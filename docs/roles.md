# Roles and membership

Design for who belongs to a care circle, what each person can do and see,
and how a phone becomes someone's. Agreed with the product owner on
2026-11-02; phase 1 is built, phases 2 to 4 are not (see
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

Not goals: accounts and passwords (stage 2), a PIN to open the app (a
possible later circle policy), the person cared for as a user.

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
| Remove someone else's record | ✓ | | | |
| Review a dose conflict (see below) | ✓ | ✓ | | |
| Medications, schedules, stock | ✓ | ✓ | | |
| Care tasks: add, edit, archive | ✓ | ✓ | | |
| Appointments, visit notes, documents | ✓ | ✓ | | |
| Edit the emergency card | ✓ | ✓ | | |
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

- **admin, caregiver**: the whole app. Admins also get a summary at the
  top of Today (done, pending, late, last record) instead of the large
  "Mark as given" card; who is responsible comes with shifts.
- **helper**: Today (doses and tasks, without the next appointment), the
  emergency card, the handoff and Settings. No tab bar, no Activity,
  medications, appointments, notes or documents.
- **viewer**: the whole app, read-only: no action buttons anywhere.

### Data by role
Hiding screens is not privacy: the app keeps the log on every phone to
work offline. So the server sends each role only the events it may see.
Every event has an **audience**, derived from its type when it is written:

| Audience | Event types | Synced to |
|---|---|---|
| `care` | medications, schedules, stock, doses, undos, care tasks and their records, emergency card, conflict reviews, members and invitations (names and roles only) | everyone |
| `team` | appointments, visit notes, documents | admin, caregiver, viewer |

When a helper's role goes up, their phone syncs again from the start.
When it goes down to helper, their phone first sends what it has not
sent yet, then clears its synced events and syncs again, so `team` events
leave it. Unsent records are never cleared.

A helper sees a dose conflict on Today ("Needs review by an admin or a
caregiver") without the review actions.

## Identity: invitations and devices

A phone belongs to one member of one circle. There is no "Who are you?".

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

## Server

What the server does, simulated now and in Firebase later. In the demo,
`SimulatedServer` holds this state next to the log; in stage 2 it is
Firestore collections plus Cloud Functions (see [Stage 2](#stage-2)).

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

- `circles/{id}/members/{uid}`: role, memberId, status. Written only by
  Cloud Functions (invite, join, change role, remove), which enforce the
  last-admin rule in a transaction.
- `invitations/{code}` outside the circle, readable by no client; a
  callable function redeems it.
- `events/{id}` gains `audience`. Rules allow reading an event if the
  caller's role includes its audience; a helper's listener queries
  `where('audience', '==', 'care')`, since rules do not filter results.
- Event rules call the same matrix as `can(role, action)`, written once
  more in the rules language and covered by the gateway contract tests.
- Facts from former members: a Cloud Function accepts and flags them, as
  the simulated server does.

## Limitations

- The simulated server is not security: it runs in the same app as the
  phones. It shows the design, not a guarantee.
- A removed member's phone that never reconnects keeps its data.
- Local data is not encrypted yet; needed before real health data.

## Phases

1. **Members, roles and authorization** (done): `Member` and member
   events, the permission matrix (`domain/permissions.dart`), author
   checks, per-event push results, rejected events on the client ("Not
   sent" in Settings), facts from former members, legacy reseed. "Who are
   you?" went away here: each demo phone is bound to its owner, and
   Settings shows the circle read-only. Two UI rules came early because
   the server now enforces them: "Remove" shows only on records the
   member may take back, and "No, only one" sends the conflict's key.
2. **Invitations and devices**: codes on the server, the join screen,
   Members in Settings (invite, change role, remove, new code, revoke),
   leaving a circle, a removed device clearing itself.
3. **UI by role and filtered sync**: audiences, watch by role, resync on
   role change, the helper's app, read-only viewer, admin summary on
   Today, demo with Ana and Rosa.
4. **Shifts**: who is responsible when (separate design).

Each phase ends with `scripts/verify.sh` green and the gateway contract
tests covering what changed.
