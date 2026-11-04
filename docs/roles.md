# Roles and membership

Design for who belongs to a care circle, what each person can do and see,
and how a phone becomes someone's. Agreed with the product owner on
2026-11-02; phases 1 to 3 are built, shifts (4) are set aside (see
[Phases](#phases)). Sync and backend
basics: [`backend.md`](backend.md).

## Goals
- A primary caregiver can hand daily care to others (relatives, nurses,
  occasional helpers) without recording everything themselves, and trust
  what others record.
- Each person sees and changes only what their role needs.
- Joining a circle feels like a real app: by invitation, not by picking a
  name from a list.
- The data model, flow and rules are the ones a real backend would use.
  The demo's server is simulated, so the demo is not secure, but nothing
  here changes when stage 2 replaces it.

Not goals: passwords (stage 2 uses anonymous device sign-in; an
optional Google sign-in makes it recoverable, see
[Recoverable access](#recoverable-access-proposed)), a PIN to open the
app (a possible later circle policy), the person cared for as a user.

## Roles

| Role | Label (en) | Label (es) | For |
|---|---|---|---|
| `admin` | Admin | Admin | Whoever organizes the care; one or more |
| `caregiver` | Caregiver | Cuida a diario | Family or nurses who care every day |
| `helper` | Helper | Ayuda a veces | Occasional help: today's care only |
| `viewer` | View only | Solo lectura | Relatives who follow along |

Labels describe what a person does and carry no grammatical gender.

## Permissions

| Action | admin | caregiver | helper | viewer |
|---|---|---|---|---|
| Record a dose or task as given/done or skipped | ✓ | ✓ | ✓ | |
| Remove one's own record | ✓ | ✓ | ✓ | |
| Leave a note for the circle | ✓ | ✓ | ✓ | |
| Remove someone else's record | ✓ | | | |
| Review a dose conflict (see below) | ✓ | ✓ | | |
| Medications, schedules, stock | ✓ | ✓ | | |
| Care tasks: add, edit, archive | ✓ | ✓ | | |
| Appointments, visit notes, documents | ✓ | ✓ | | |
| Edit the emergency card | ✓ | ✓ | | |
| Reasons for not giving or doing | ✓ | ✓ | | |
| Members, roles, invitations, devices | ✓ | | | |
| Reset the demo | ✓ | | | |

- Reviewing a dose conflict includes cancelling the repeated records of
  that conflict ("No, only one"), whoever made them. It is a permission of
  its own, not "remove someone else's record".
- A circle always has at least one admin. The server rejects a change
  that would leave none (two admins demoting each other offline: the one
  that arrives second is rejected), and the UI does not offer it.
- One rule decides all of this, a pure function `can(role, action)` in
  the domain. The UI uses it to show or hide actions; the server uses it
  to accept or reject events. Where the role comes from differs (see
  [Server](#server)).

## What each role sees

- **admin, caregiver**: the whole app, with the large "Mark as given"
  card at the top of Today.
- **helper**: Today (doses and tasks, without the next appointment), the
  emergency card, the handoff and Settings. No tab bar, no Activity,
  medications, appointments, notes or documents.
- **viewer**: the whole app, read-only: no action buttons anywhere. A
  summary at the top of Today (done, pending, late, last record) instead
  of the "Mark as given" card.

What tops Today follows a permission, not a role: whoever can record a
dose is offered the next one; whoever cannot gets the day's summary.
Admins first got the summary too, as coordinators. Changed on
2026-11-04: in a family the admin is usually the primary caregiver, who
also gives doses, and whoever creates a circle is its admin, so someone
using the app alone never saw its main action. The day's list, "To
review" and Activity already show admins how the day goes.

### Data by role
Hiding screens is not privacy: the app keeps the log on every phone to
work offline. So the server sends each role only the events it may see.
Every event has an **audience**, derived from its type when it is written:

| Audience | Event types | Synced to |
|---|---|---|
| `care` | medications, schedules, stock, doses, undos, care tasks and their records, notes left for the circle, emergency card, conflict reviews, members and invitations (names and roles only) | everyone |
| `team` | appointments, visit notes, documents | admin, caregiver, viewer |

When a helper's role goes up, their phone syncs again from the start.
When it goes down to helper, their phone first sends what it has not
sent yet, then clears its synced events and syncs again, so `team` events
leave it. Unsent records are never cleared.

A helper sees a dose conflict on Today ("Needs review by an admin or a
caregiver") without the review actions.

## Identity: invitations and devices

A phone belongs to one member of one circle. There is no "Who are you?".

0. **Create.** On a phone that belongs to nobody, "Create a circle" asks
   for one's name and the name of the person cared for. The server writes
   `CircleCreated` and makes that person the first admin, joined on that
   phone (all `system` events). The demo has room for one circle.

1. **Invite.** An admin adds a person (name and role) in Settings →
   Members. The server creates the member and a one-time code (for
   example `K7P-4QM`) that expires 48 hours later by the server's clock.
   The admin sends it however they like.
2. **Join.** On a new phone, the welcome screen asks for the code. The
   server checks it (unused, not expired, not revoked), binds the phone
   to that member and marks the code used. Joining needs a connection.
3. **Use.** Settings shows "This phone: Rosa · Helper". Every event the
   phone sends is checked against that binding.
4. **Another device.** An admin can create a code for an existing member
   (Ana's tablet), which binds a second device to the same person.
5. **Leave.** "Leave the circle on this phone" sends what is still
   unsent (it needs a connection, and says how many records are pending
   when there is none), then unbinds the phone and clears its local data.
   Joining again takes a new code.
6. **Removed.** When an admin removes a member, their device bindings
   end. On its next sync, a removed device first sends its pending
   records (accepted as facts from a former member, below), is then told
   it is no longer a member, clears its local data and returns to the
   welcome screen. A device that never connects again keeps its data: a
   real limit, until local data is encrypted.

Bindings end; they are never deleted. The server keeps which member each
device belonged to, so it can still check who wrote a late record.

Admins can revoke an unused code.

## Recoverable access (proposed)

Proposed on 2026-11-04, not built. Phase 5 below.

**The problem.** A phone is an anonymous Supabase user: its `uid` is
the device. Uninstalling the app, clearing the browser's data or
changing phones loses that session, and with it the phone's binding.
What was synced stays on the server; what was unsent is lost
(`backend.md`, open issue 1). For most members this costs a new code
from an admin. For **the only admin** it orphans the circle: nobody else
can issue them a code, so nobody can invite, change roles or recover a
phone again.

**The goal.** An admin who uninstalls the app or changes phones gets
back into the circle, with its whole log. Three layers, so that no
single one is a point of failure:
1. **Sign in with Google**, optional and asked of admins.
2. **A second admin**, suggested while there is only one. It already
   works today: another admin issues a code.
3. **Recovery by the operator** as the last resort.

### Options considered
| Option | Verdict |
|---|---|
| Google sign-in | **Chosen.** Nothing to remember; Google's own second factor and account recovery; Google is already a processor (push). Android and the web, where the testers are |
| Email code | Later. Supabase's built-in sender is limited to a couple of emails an hour and to the project's team, so it needs a provider (Resend) and a domain with SPF and DKIM |
| Password | No. It needs an email reset anyway, so it never raises security above the email's, and adds weak and reused passwords. Used once a year, it is forgotten |
| Recovery key to keep | Kept in reserve. The simplest to build (a permanent invitation code for oneself), but tired people lose it |
| SMS code | No: a paid provider and a new processor |
| Android Block Store | No: Android backups are off on purpose, and the web has nothing like it |

### Decisions
- **Optional, asked of admins.** Admins see "Protect your access" once
  after creating a circle, and in Settings until they do it. Other
  members find it in Settings. Nobody needs it to use the app. Not
  offered on iOS: an App Store app offering Google sign-in must also
  offer Sign in with Apple.
- **The same `uid`.** Protecting links a Google identity to the phone's
  anonymous user (manual identity linking), so its binding and push
  token stay as they are.
- **One phone per account.** Recovering moves the account to the new
  phone and ends its sessions everywhere else, so a lost or stolen
  phone is locked out by the recovery itself. A second device of the
  same member keeps joining with a code, as its own anonymous user.
- **The circle hears of it.** The first call from a new session of a
  protected account writes a system event, so the circle sees "Ana is
  using a new phone" and other admins get a push. The server writes it
  from the JWT's `session_id`, so it does not depend on the new phone
  asking for it: whoever took over a Google account cannot skip it.
- **Native or browser sign-in, decided when building.** The native
  account sheet is the better experience and needs a new dependency
  (`google_sign_in`); the browser flow needs none, but leaves the app
  for a tab and needs a deep link back.
- **The demo does not offer it.** The demo has no Google project and
  resets anyway. The simulated gateway implements it for tests and the
  contract suite.

### Flows
1. **Protect.** Settings → "Protect your access" → Google's account
   picker → "Protected with a•••@gmail.com".
2. **Recover.** On a phone that belongs to nobody, the welcome screen
   offers "I already have access" next to joining with a code → Google.
   The phone loads the member and downloads the log from the start, like
   a phone that has just joined, and registers its push token. A Google
   account linked to no one gets "No access with this account", and the
   phone signs out of it.
3. **Second admin.** While a circle has a single admin, Settings →
   Members suggests making someone else admin.
4. **Operator.** The member calls the operator, who confirms who they
   are by a channel of their own (a phone call, not a message from an
   unknown number) and runs `private.operator_issue_code` in Supabase's
   SQL editor. It issues a normal code for that member, which works as
   any other. Clients cannot call it; `backend.md` documents the steps
   once it is built.
5. **Removed or left.** A recovered account whose binding has ended gets
   the removed device's screen and clears itself, as today.

### On the server
Built in `supabase/migrations/*_recoverable_access.sql`.
- `public.check_request` runs before every API request (PostgREST's
  `db_pre_request`), so no function can forget it:
  - a JWT whose session no longer exists gets `session_ended` at once,
    not when its access token expires. The phone signs out locally and
    signs in again as a new anonymous device; if that device belongs to
    no one, the next call says `not_member` and it clears itself, as a
    removed device does.
  - a protected account's session other than the one its binding last
    saw gets `session_unconfirmed`, and may only call
    `confirm_session`. That records the session and, when it started
    more than a minute after the account was protected (so it comes from
    signing in on another phone, not from protecting this one), writes
    `access_recovered` (system, `member_id`, audience `care`). A new
    phone cannot read anything before the circle is told.
- After recovering, the phone calls `signOut` with scope `others`.
- `discard_unbound_user` deletes the caller's user when it is not
  anonymous and was never bound: a Google account linked to no one.
- `delete_circle` also deletes the circle's protected accounts, so their
  Google identities go with it. Anonymous phones keep their users, which
  hold nothing, so installed apps behave as before.
- `private.discard_stray_users` and `private.operator_issue_code` are
  the operator's (`backend.md`, "Operator").
- Still to do: `config.toml` with the Google provider and manual
  linking, once the client side is built.

### Errors
Typed `Failure`s, rendered through l10n: sign-in cancelled (not an
error, nothing shown), Google account already protecting another access,
no access with that account, and no connection (transient, retried).
`session_ended` and `session_unconfirmed` never reach the UI: the
connection handles them and retries once.

### Verified
On 2026-11-04, against the local stack (GoTrue v2.197.0) and
`gotrue` 2.27.3, the Dart client the app already uses:
- **Linking keeps the `uid`.** Both ways send the current session's JWT,
  so Google is added to the same user: `linkIdentityWithIdToken`
  (native, with the ID token from Google's sheet) and `linkIdentity`
  (browser). With manual linking on, the server accepts both for an
  anonymous user; the browser way asks Google only for `email` and
  `profile`. The last step needs real Google credentials, so the first
  real link is checked on the beta project.
- **`session_id`** is in every JWT and survives refreshes.
- **`signOut(scope: others)`** removes the other sessions from
  `auth.sessions` and their refresh tokens stop working. Their access
  tokens do not: the API keeps accepting them until they expire, up to
  an hour (`jwt_expiry`). So every RPC also checks that the JWT's
  session still exists in `auth.sessions`, and a lost phone is locked
  out at once.
- **A Google account linked to no one** creates a user when it signs in
  (signups stay on: anonymous phones need them). The app then calls
  `discard_unbound_user`, which deletes the caller's user if it is not
  anonymous and was never bound. Functions owned by `postgres` may
  delete from `auth.users` and read `auth.sessions`.

### Setup (the maintainer, once)
A Google Cloud project with an OAuth consent screen asking only for the
email and basic profile (no Google review needed), a web client whose ID
and secret go to Supabase, and an Android client per signing key
(package name and SHA-1).

### Later
- **Email code**, once there is a domain or the beta opens to more
  families.
- **Stage 3:** passkeys (`[auth.passkey]` in `config.toml`), a second
  factor for admins, Sign in with Apple if there is an iOS app.

### What it does not solve
- An unlocked, stolen phone is still open (no app PIN).
- Records not yet sent when the app was uninstalled are lost.
- Taking over someone's Google account takes over their access here.
  The event to the circle is how it shows.

## Server
- `public.current_circle` and the other RPCs compare the JWT's
  `session_id` with the one last seen for the binding. A new one on a
  protected account writes the system event (`AccessRecovered`,
  `memberId`, audience `care`) and records it.
- After recovering, the phone calls `signOut` with scope `others`, and
  every RPC refuses a JWT whose session no longer exists.
- `delete_circle` also deletes its members' auth users, so their emails
  go with the circle.
- Anonymous users left behind (the throwaway one a phone signs in with
  before recovering) are deleted periodically.
- Settings: the email code expires after 10 minutes (`otp_expiry = 600`),
  6 digits, and the existing per-IP limits on verifications.

### Errors
Typed `Failure`s, rendered through l10n: wrong code, expired code, too
many attempts, email already protecting another access, no access with
that email, and email not sent (transient, retried).

### To verify against Supabase before building
- Converting an anonymous user with an email code (not a link) keeps
  its `uid`, and the code arrives with the email change template.
- The JWT carries `session_id`, and `signOut(scope: others)` ends the
  other sessions at once.
- The built-in email sender's hourly limit is enough to try this, and
  which provider to use for the beta instead (a new processor).
- Whether Supabase passkeys (`[auth.passkey]` in `config.toml`) are
  mature enough for stage 3.

### Later
- **Phase 5b, Google as an option** on Android and the web, next to the
  email. A native sign-in needs a new dependency, decided then; the
  browser flow needs none but leaves the app. Supabase's manual
  identity linking keeps the `uid`. Apple's rule to also offer Sign in
  with Apple applies only to an App Store app.
- **Stage 3:** passkeys, a second factor for admins, Sign in with Apple
  if there is an iOS app.

### What it does not solve
- An unlocked, stolen phone is still open (no app PIN).
- Records not yet sent when the app was uninstalled are lost.
- Taking over someone's email takes over their access here. The event
  to the circle is how it shows.

## Server

What the server does, simulated now and in Supabase later. In the demo,
`SimulatedServer` holds this state next to the log; in stage 2 it is
Postgres tables plus `SECURITY DEFINER` functions (see
[Stage 2](#stage-2)).

**State, not events.** Members, roles, device bindings and invitation
codes are server state. Rules can check state; they cannot replay a log.
Changes to members also go to the log as events, for Activity and the
member list on every phone.

**Secrets stay on the server.** Codes (or their hashes) never enter the
log: six characters can be brute-forced by anyone holding a hash.

**System events.** Some events have no member as author: the server
writes `MemberJoined` when a code is used (the person is not a member
yet). Their author is `system`.

**Checking each event**, in the order received:
1. The author in the event must be the member the sending device is (or
   was last) bound to. Otherwise the event is rejected.
2. Configuration (everything except the facts below) needs a current
   member whose role allows it. Otherwise it is rejected.
3. **Facts**: `DoseGiven`, `DoseSkipped`, `TaskDone`, `TaskSkipped`, and
   undos of the author's own facts. Rosa may give a pill offline at 10:00,
   lose access at 11:00 and sync at 12:00; the device clock cannot prove
   which came first, and rejecting the record could lead to a second
   dose. So a fact from a device whose binding has ended is **accepted
   and flagged** and shown to admins. A fact about the person cared for
   is never lost. The flag is set by the server, like `receivedAt`, as an
   optional field of the event's metadata (`fromFormerMember`); readers
   treat a missing one as false, so the stored format stays compatible.

**Results per event.** `push` answers with the events stored and, apart,
the ones rejected and why. One rejected event never blocks the others
(today a failed push retries the whole batch, so one bad event would
block everything behind it forever).

**Watch by audience.** `watch` takes the device's role into account and
sends only its audiences.

## Client

- **Rejected events** move to a separate store: never retried, left out
  of projections (so the phone does not show a dose others will never
  see) and listed in Settings and on the sync banner ("Not sent: you no
  longer have access…"). Nothing disappears silently.
- **Role changes** arrive as events; the UI follows the current role at
  once. The phone resyncs when its audience changes (see above).
- **Legacy demo data.** A stored log with no member events comes from
  before roles: the demo reseeds it. "Reset demo" also restores which
  phone belongs to whom.

## Events

| Event | Payload | Audience |
|---|---|---|
| `MemberInvited` | `memberId`, name, role, `colorIndex` | care |
| `InvitationRevoked` | `memberId` | care |
| `MemberJoined` (system) | `memberId` (a device was bound) | care |
| `RoleChanged` | `memberId`, role, `baseVersion` | care |
| `MemberRemoved` | `memberId`, `baseVersion` | care |
| `MemberLeft` | `memberId` (one device unbound itself) | care |

- `MemberInvited` creates the member in the projection; until
  `MemberJoined` the member shows as "Invited". Events from `system` are
  shown as ICare's in Activity.
- Concurrent role changes or removals are flagged for review like other
  edits (`baseVersion`), after the server has applied them in order.
- `Caregiver` in the domain becomes `Member` (id, name, color, role,
  status). Sample ids (`ana`, `martin`, `rosa`) stay.

## Demo

- The two phones are **Ana (admin)** and **Rosa (helper)**, already joined.
  Martín (caregiver) is a member without a phone in the demo.
- Rosa's phone shows the helper's app; a double dose made across the two
  phones is reviewed on Ana's.
- To show joining: on Rosa's phone, "Leave the circle on this phone"; on
  Ana's, Members → Rosa → "New code for a device"; type it on Rosa's.

## Stage 2

Supabase, as designed in [`backend.md`](backend.md#supabase-stage-2):
- Each device signs in anonymously; its auth `uid` is the device, and
  `device_bindings` holds which member it is, including ended bindings.
- `members` and `invite_codes` are written only by RPCs (`create_circle`,
  `issue_code`, `join`, and member events such as role changes,
  removals, revoked invitations and leaving through `push_events`),
  which enforce the last-admin rule while holding the circle's row lock.
- `invite_codes` stores hashes and has no client grant; `join` redeems a
  code and locks a device out after repeated failures.
- `events` has an `audience` column. Row Level Security returns only the
  audiences of the caller's role, so a helper's queries and Realtime
  channel never see the rest.
- `push_events` checks each event against the same matrix as
  `can(role, action)`, written once more in SQL and covered by the
  gateway contract tests and pgTAP.
- Facts from former members: `push_events` accepts and flags them, as
  the simulated server does.

## Limitations

- The simulated server is not security: it runs in the same app as the
  phones. It shows the design, not a guarantee.
- A removed member's phone that never reconnects keeps its data.
- The demo's local data is not encrypted: it is sample data. The beta's
  is (`privacy.md`).

## Phases

1. **Members, roles and authorization** (done): `Member` and member
   events, the permission matrix (`domain/permissions.dart`), author
   checks, per-event push results, rejected events on the client ("Not
   sent" in Settings), facts from former members, legacy reseed. "Who are
   you?" went away here: each demo phone is bound to its owner, and
   Settings shows the circle read-only. Two UI rules came early because
   the server now enforces them: "Remove" shows only on records the
   member may take back, and "No, only one" sends the conflict's key.
2. **Invitations and devices** (done): codes on the server (one live
   code per member: a new one replaces an unused one; codes are typed
   without the dash or in lower case just as well), a
   `MembershipGateway` for issuing codes and joining, apart from the
   sync gateway; the Join screen; the circle in Settings, where admins
   invite, change roles, make codes, withdraw invitations and remove;
   leaving a circle, which needs a connection and sends everything first;
   a removed device showing why, then clearing itself. The phone's member
   lives in its preferences (`member_id`).
3. **UI by role and filtered sync** (done): `audienceOf` and
   `audiencesFor` in the domain; the server's watch sends each device its
   role's audiences; a role change that changes them starts the phone's
   copy over (`audienceSync`), keeping anything unsent; actions offered
   through `canDo`; the helper's app without tabs (other tabs' routes lead
   to Today); viewers without action buttons; a day summary on Today for
   viewers instead of the next dose card (admins too until 2026-11-04);
   the demo with Ana (admin) and Rosa (helper). Demo phones the server
   has never seen join as their owners on start, so older installs keep
   working.
4. **Shifts**: who is responsible when. Set aside on 2026-11-03: keeping
   a schedule up adds work to a family's day, and notes for the circle
   already carry the handoff (`product.md`, later candidates).
5. **Recoverable access** (proposed): optional Google sign-in for any
   member, asked of admins; the suggestion of a second admin; recovery
   by the operator ([above](#recoverable-access-proposed)).

Each phase ends with `scripts/verify.sh` green and the gateway contract
tests covering what changed.
