# Backend design

ICare ships with a simulated remote. This document describes the sync
model both implementations share and the Supabase design the real one
will follow, so the simulated remote is built against real constraints.

## Sync model

### Everything is an event
Caregivers never edit shared state in place. Each action appends an
immutable `CareEvent`; current state (today's doses, stock, the activity
feed, the latest version of a medication) is a projection of the log.

| Event | Payload |
|---|---|
| `MedicationCreated` / `MedicationUpdated` | full medication snapshot, `baseVersion` |
| `MedicationArchived` | `medicationId`, `baseVersion` |
| `ScheduleChanged` | `medicationId`, new schedule, `effectiveFrom` |
| `DoseGiven` | `medicationId`, `slotAt` (null when as needed), `givenAt` (stated by the caregiver), `units`, `knownDoseIds`, note |
| `DoseSkipped` | `medicationId`, `slotAt`, reason id, note |
| `DoseUndone` | `targetEventId` (a dose or task record; the name predates tasks) |
| `StockCounted` / `StockRefilled` | `medicationId`, units |
| `AppointmentCreated` / `AppointmentUpdated` | snapshot (title, `startsAt`, doctor, place, questions), `baseVersion` on updates |
| `AppointmentCancelled` | `appointmentId`, `baseVersion` |
| `VisitNoteAdded` | `appointmentId`, text |
| `CareNoteAdded` | text: a note left for the circle ("te dejo dicho"); never edited, a later note says what changed |
| `DocumentLinked` | `appointmentId`, title, http(s) URL; the event id is the document's |
| `DocumentRemoved` | `appointmentId`, `documentId` |
| `TaskCreated` / `TaskUpdated` | details (name, note) and schedule (times, or none for "during the day"; weekdays), `baseVersion` on updates |
| `TaskArchived` | `taskId`, `baseVersion` |
| `TaskDone` / `TaskSkipped` | `taskId`, `slotAt` (start of the day when untimed); reason id and note when skipped |
| `CircleCreated` | recipient name, whether it is the demo's sample; written by the server when someone creates the circle |
| `SkipReasonAdded` | reason id, label: one of the circle's own reasons |
| `SkipReasonHidden` / `SkipReasonShown` | reason id: stops or resumes offering a reason, standard or the circle's ("Other" is always offered) |
| `RecipientProfileUpdated` | profile snapshot (allergies, conditions, doctors, contacts), `baseVersion` |

Every event carries `id` (UUID v4 generated on the device; events the
server writes and sample data use other unique strings),
`caregiverId` (the author: a member, or `system`; see `roles.md`),
`occurredAt` (device clock, shown to users) and
`receivedAt` (assigned by the server, null until synced). Events carry
no circle id: a device belongs to one circle, and the server files each
event under its device's circle.

### Why events
- **Merging is a set union by `id`**: commutative and idempotent, so
  devices converge whatever the order or number of retries.
- Conflicts become **visible facts** instead of lost writes:
  - two `DoseGiven` for the same `medicationId` + `slotAt`, or closer than
    the minimum interval → "given twice", unless the later one lists the
    earlier in `knownDoseIds` (a warning showed it and the caregiver
    confirmed anyway);
  - a change made on an older `baseVersion` that overlaps a change applied
    since (details with details, schedule with schedule, archiving with
    anything) → "conflicting changes, review".
  Nothing is resolved silently; a caregiver resolves it with a new event.
- A "given twice" record is a fact about the patient, not a sync error.
  Resolving it as "server wins" (one confirmation per dose) would drop
  the evidence that a second dose was actually given; keeping both and
  alerting is the safer behavior.
- Schedule changes never rewrite history: past slots use the schedule
  version that was effective then, and dose events store their own
  `slotAt` and `units`.
- Stock never conflicts: it is counted + refilled − consumed.

### Ordering and clocks
Device clocks drift, so they never decide anything. The log is ordered by
`serverSeq`, the place the server gave each event (then `occurredAt` for
unsynced local events); conflicts are detected by slot or `baseVersion`,
not by time. Events received together (one push) keep their arrival
order instead of falling back to their random ids: an invitation and a
role change pushed together must apply in that order.

`receivedAt` is for display only. Timestamps cannot order the log: on
the web Dart's `DateTime` keeps milliseconds only, so events of one push
can share one. Copies synced before events carried `serverSeq` sort
first, by `receivedAt`; the simulated server numbers its old records
when it loads them.

### App versions
Devices update at different times (web, APK), so a device may receive
events from a newer app version: a type it does not know, or a newer
`formatVersion`. It keeps them as received, leaves them out of the log
and reads them after updating (`CareEventCodec.tryDecodeString`,
`EventStore.keepUnreadable`); one updated device never stops sync for
the others. A newer event the old app cannot see may make its view
incomplete until it updates. The server is updated before any client
that writes a new type.

### Offline
Each device keeps its log and an outbox locally. The UI shows the last
successful sync; before a "Given" it warns when that is older than a
threshold, because an offline device cannot know what others did.
Preventing a double dose offline is impossible; detecting and surfacing
it is the goal.

## The gateway

```dart
abstract interface class SyncGateway {
  /// Uploads events; returns the ones stored (`receivedAt` set) and the
  /// ones rejected with why. Idempotent by id.
  Future<PushResult> push(List<CareEvent> events);

  /// Events received after [cursor], then new ones, in server order.
  Stream<SyncBatch> watch({String? cursor});
}
```

Implementations live in `data`; nothing above `data` knows which one runs.

### Simulated remote (stage 1)
- In-process server shared by the device containers, persisted in Hive so
  it survives reloads; "Reset demo" clears it with the devices' stores.
- Assigns `receivedAt` from its own clock (injected, so tests control it).
- Configurable latency and a per-device offline switch.
- Talks to devices only through serialized JSON, like a network would.

### Contract tests
One suite describes gateway behavior (idempotent push, ordering, cursor
resume, offline errors) and runs against the simulated remote today and
against a local Supabase stack (`supabase start`) in stage 2.

### Which gateway runs
The public web demo keeps the simulated remote: free, always up, and no
visitor ever sees real data. The beta build selects Supabase through
`--dart-define-from-file=env/beta.json` (`SYNC_BACKEND=supabase`, the
project URL and its publishable key; see `env/beta.json.example`).
`bootstrap` then runs one phone, without the demo's frame, sample data
or demo actions (`isDemoProvider` is false), and `SupabaseConnection`
implements both gateways. Nothing else above `data` changes.

## Supabase (stage 2)

Chosen on 2026-11-03 over Firebase, Azure and Neon + Render. The beta
(one family testing for real, see `privacy.md`) needs server-side logic
for membership and event checks; Supabase runs it as Postgres functions
on the free plan, without a card. Firebase needs the Blaze plan for Cloud
Functions; Azure and Neon + Render mean writing and hosting an API,
realtime and auth ourselves.

| | Supabase | Firebase |
|---|---|---|
| Server logic on the free plan | SQL functions, Edge Functions, `pg_cron` | none (Functions need Blaze) |
| Authorization | Row Level Security, testable SQL | security rules |
| Offline cache | none (ICare has its own log and outbox) | built in (redundant here) |
| Lock-in | standard Postgres | proprietary model and rules |
| Free-plan catch | pauses after 7 idle days; no backups | quotas stop the app when hit |

A paused project degrades to offline mode, not an outage: devices keep
working on their local log and the outbox uploads everything once the
project is resumed. A family using it daily never triggers the pause.

### Region
`eu-west-1` (Ireland): project `icare_test`, created 2026-11-03, with
the migration applied. Latency barely matters to an offline-first app,
and the EU is on Argentina's list of countries with adequate protection,
so storing there is not a restricted international transfer under Ley
25.326 (`privacy.md`). Fixed at project creation.

### Schema
```
circles         id, recipient_name, is_sample, next_seq, last_received_at
members         circle_id, member_id, name, role, status, color_index
device_bindings uid (auth user), circle_id, member_id, ended_at
invite_codes    code_hash, circle_id, member_id, expires_at   -- no client access
events          circle_id, id text, seq, received_at, author, audience,
                type, payload jsonb, from_former_member
                -- PK (circle_id, id); unique (circle_id, seq)
device_tokens   uid, fcm_token, platform, updated_at
join_attempts   uid, failed_count, locked_until             -- no client access
```
- `events.id` is text, not uuid: server-written events and sample data
  use readable ids. The key includes the circle, so sample ids can
  repeat across circles.
- `payload` is the event exactly as `CareEventCodec` encodes it; the
  server reads only what it checks (type, author, targets) and writes
  `received_at`, `server_seq` and `from_former_member` into it, in the
  codec's formats. `received_at` uses the codec's wall-clock format in
  the circle's time zone (open issue 3 below).
- Every device signs in anonymously; its auth `uid` is the device, and
  `device_bindings` says which member it is (`roles.md`).
- Members, roles, bindings and codes are server state, as in the
  simulated server; member changes also go to the log as events.
- Projections stay client-side; the log per circle is small (hundreds of
  events a month).

### Writes go through functions
Clients have no `insert`, `update` or `delete` grant on any table. They
call RPCs, `SECURITY DEFINER` functions that check the caller:
- `push_events(events jsonb)`: for each event, in order, applies the
  checks in `roles.md` (author bound to the calling device, permission
  matrix, last-admin rule, facts from former members accepted and
  flagged) and returns `{stored, rejected}`. An event id already stored
  comes back as stored, unchanged. Member tables change in the same
  transaction as the events that change them (`MemberInvited`,
  `RoleChanged`, `MemberRemoved`, `InvitationRevoked`, `MemberLeft`, the
  last one ending only the calling device's binding), so log and state
  never disagree. The client sends large outboxes in batches.
- `create_circle`, `issue_code`, `join_circle`: the
  `MembershipGateway`. Leaving and revoking are events, not calls.
  `join_circle` answers a bad code with `{error}` rather than raising,
  so the failure is counted instead of rolled back: after five, the
  device waits 15 minutes (`locked`; the app needs a `CodeProblem` for
  it).
- `events_after(cursor, page_size)`: what `watch` reads (below).
- `delete_circle`: admins only; see "Deletion" below.

The permission matrix (`can(role, action)` in the domain) is written once
more in SQL. The contract tests cover both copies.

### Ordering
A Postgres sequence alone is not enough: two concurrent transactions can
commit out of sequence order, and a reader resuming after cursor 41 could
miss event 40 committed a moment later. `push_events` instead locks the
circle's row (`select … for update`), takes `next_seq`, and sets
`received_at = greatest(now(), last_received_at + 1 µs)`. The lock is held
until commit, so `seq` order is commit order within a circle, and
`received_at` keeps strictly increasing even within one push. One family
never contends for the lock.

### Watch
Realtime is the doorbell, the cursor is the truth:
1. On start and on every reconnect, call `events_after(cursor)` until a
   page comes back short. It returns the events with `seq > cursor` the
   caller's role may read, ordered by `seq`, and the new cursor. It
   raises `not_member` for a device whose binding ended or whose member
   was removed, which the gateway maps to `NotMemberException`: a plain
   `select` under RLS would just return nothing, and the device would
   never learn it was removed.
2. Subscribe to a private Realtime broadcast channel for the circle;
   `push_events` sends a ping after commit, which triggers step 1 again.

Realtime may drop messages while a device is offline; re-reading from the
cursor makes that harmless, and merging by id makes duplicates harmless.

### Errors
The gateway maps Supabase errors to `AppException` and nothing of
Supabase leaves `data`: socket and client errors to
`NoConnectionException`, timeouts to `RequestTimeoutException`, 5xx and paused
projects to `ServerException` (all transient, retried by
`retryPolicy`), `not_member` to `NotMemberException`, and
membership errors to the exceptions `MembershipGateway` documents.

### Access
- Tables live in a `private` schema the API does not expose, with RLS on
  and no policies: clients cannot read or write any table. Every read
  and write is a function in `public`, granted to `authenticated` only
  (anonymous devices included), never to `anon`.
- Audiences are applied inside `events_after`, from the caller's role.
- `public.current_circle()` gives the device its circle for the Realtime
  channel; a policy on `realtime.messages` lets only current members
  hear `circle:<id>`.
- `device_tokens` (push phase) will be written through a function too.
- `public.check_request` runs before every request (`db_pre_request`)
  and refuses sessions that ended or are not yet confirmed
  ([`roles.md`](roles.md#on-the-server), recoverable access).

### Operator
What the maintainer runs in the SQL editor, never a client:
- **A member lost every way back in** (no Google linked, or no access to
  it, and no other admin). Confirm who is asking by a channel of your
  own: call them on the number you know, never trust a message from a
  new one. Then find the circle and member:
  `select circle_id, member_id, name, role from private.members where name ilike '%ana%';`
  and issue a code: `select private.operator_issue_code('<circle_id>', '<member_id>');`
  It works as an admin's code, once, for 48 hours. Tell it to them on
  that same call.
- **Monthly:** `select private.discard_stray_users();` deletes users
  that belong to no circle.

### Push notifications
Sent by FCM (free without Firebase's Blaze plan); Supabase only decides
when. The Firebase project is used for messaging only, no data.
- **Phase 1, by event** (server built, `*_push_notifications.sql` and
  `functions/push`): a trigger on `events` decides whether an event is
  news (`push_kind`: a note for the circle, an appointment created,
  changed or cancelled, a medication added, changed or stopped (added
  on 2026-11-04: whoever gives the next dose must know), or a dose for
  a slot that already has one standing that the caregiver did not
  knowingly confirm; doses given, stock and tasks stay quiet, since
  they happen many times a day) and who is
  told (`push_targets`: current members' devices whose role reads the
  event's audience, never its author's). A recovered access
  (`roles.md`, added on 2026-11-13) is news for admins, who can remove
  the member, and for the member's other phones; the token the account
  had is forgotten first, since it is the phone left behind's. It queues {kind, targets}
  through pg_net to the `push` Edge Function, which checks a shared
  secret in constant time and sends through FCM. A failed send never
  fails the event's insert.
  - Devices register their token with `register_push_token(token,
    platform, language)`; `unregister_push_token()` stops them.
  - Nothing is sent until Vault holds `push_function_url` and
    `push_hook_secret`; the function needs `PUSH_HOOK_SECRET` and
    `FCM_SERVICE_ACCOUNT`. Local stacks and tests never call out.
  - Messages carry only the kind of news, in the device's language
    ("There is a new note for the circle"): no names, medications or
    other health data travel through Google's or Apple's servers.
  - In the app (beta builds with `FIREBASE_*` values, Android and web)
    the system's permission is the only switch. The welcome, shown after
    joining or creating a circle, says it will ask, and its button asks
    (a tap, which browsers require). Once allowed, the phone keeps its
    token on the server by itself on every start and language change;
    once refused in the system's settings, it has the server forget it
    (`PushRepositoryImpl.sync`, `pushNotificationsProvider`). Settings
    only shows the state, with a button while never asked. An in-app
    switch on top was tried and dropped on 2026-11-04: testers enabled
    notifications in the system and never found it. The web
    needs `web/firebase-messaging-sw.js`, whose values are the Firebase
    project's public identifiers. Foreground messages are not shown: the
    open app already syncs.
  - Open: firebase_messaging 17 deprecates registration tokens for
    installation IDs and direct send. The app keeps tokens until the
    function moves to the new API.
  - Deployed to `icare_test` on 2026-11-03; sending starts once the
    secrets below exist. Function secrets (`supabase secrets set`):
    `PUSH_HOOK_SECRET`, `FCM_SERVICE_ACCOUNT`. Vault (SQL editor):
    `push_function_url`, `push_hook_secret` (the same value).
- **Phase 2, overdue doses** (only if the family needs it): `pg_cron`
  runs an Edge Function every few minutes. It needs the slot logic
  (schedules, `effectiveFrom`, skips, undos) a second time in
  TypeScript, so it waits until shared test vectors keep both copies
  equal.
- iOS needs APNs, so an Apple Developer account; web push on iPhone works
  only for a PWA added to the home screen. Android and desktop web work
  for free.
- Copy says what kind of news there is, never who or what medication,
  and never gives advice.

### Deletion
The log is append-only for caregivers, but the person cared for can ask
to delete their data (Ley 25.326, art. 16). `delete_circle` removes the
circle with everything in it (cascade) and unbinds its devices, which
then clear themselves as a removed device does today. Members' protected
accounts (recoverable access, `roles.md`) are deleted with it. A member
who leaves or is removed does not wait for that: their Google identity
and email are deleted when their binding ends. It is the one
operation that deletes shared data, and it is not an event. In the app,
an admin finds it in Settings (beta only); the phone that deletes also
erases its own copy, unsent records included (`CareRepositoryImpl.erase`).

### Backups
The free plan has none. A script runs `pg_dump` to the maintainer's
machine, encrypted, never to the repository or CI artifacts. Every device
also holds its circle's full log, and `push` is idempotent, so devices
could repopulate an empty server.

### Tests
- SQL tests (`supabase/tests/`, pgTAP) cover each function, every cell
  of the permission matrix, audiences, paging, former members, the last
  admin, code lockout, table access and deletion.
- `test/features/care/data/sync/supabase_connection_test.dart` runs the
  gateway contract suite, plus membership checks, against the local
  stack. A TCP proxy cuts one phone's network, so going offline fails
  requests and the Realtime socket as a real outage would. Skipped when
  no stack is running (CI today).
- `SupabaseConnection.watch` reads on start, on each Realtime ping and
  every 30 s: the poll catches up when Realtime drops a ping, and is how
  an idle phone learns it is offline.
- Schema: `supabase/migrations/`. Malformed events are refused alone as
  `not_allowed`; events of a newer `formatVersion` too, until the server
  is updated.

### Open issues before the beta
Found reviewing the code against this design on 2026-11-03. Three more
were fixed then: ordering ties on the web ("Ordering and clocks"),
events from newer app versions stopping sync ("App versions"), and
demo-only paths in a beta build ("Which gateway runs").
1. **Device identity.** Local stores are keyed by `deviceId`; on Supabase
   it becomes the auth `uid`. Losing the anonymous session (reinstall,
   cleared browser data) unbinds the device: it needs a new code, and
   anything unsent on it is lost. An only admin cannot get one. Answered
   by optional Google sign-in, a second admin, and recovery by the
   operator ([`roles.md`](roles.md#recoverable-access)); what was unsent
   is still lost.
2. **Browser storage on iPhone.** Safari may delete a website's storage
   after 7 days without a visit, including the unsent outbox. Testers on
   iPhone should install the PWA to the home screen, or use Android.
3. **Time zone for server-side alerts.** Dates are encoded without an
   offset (local time). Phase 2 alerts need the circle's time zone
   stored on the server.

## Stage 3 notes
- Pro plan once more families use it: daily backups and no pausing.
- Escalating overdue alerts and quiet hours.
- A second region (and project) if EU users arrive: GDPR treats health
  data as a special category.
- Privacy policy, processor agreements and the AAIP database registry
  question settled before opening to strangers (`privacy.md`).
