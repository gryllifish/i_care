# Backend design

ICare ships with a simulated remote. This document describes the sync
model both implementations share and the Firestore design the real one
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
| `DoseSkipped` | `medicationId`, `slotAt`, reason |
| `DoseUndone` | `targetEventId` |
| `StockCounted` / `StockRefilled` | `medicationId`, units |
| `AppointmentCreated` / `AppointmentUpdated` | snapshot (title, `startsAt`, doctor, place, questions), `baseVersion` on updates |
| `AppointmentCancelled` | `appointmentId`, `baseVersion` |
| `VisitNoteAdded` | `appointmentId`, text |
| `RecipientProfileUpdated` | profile snapshot (allergies, conditions, doctors, contacts), `baseVersion` |

Every event carries `id` (UUID v4, generated on the device), `circleId`,
`caregiverId`, `occurredAt` (device clock, shown to users) and
`receivedAt` (assigned by the server, null until synced).

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
Device clocks drift, so they never decide anything. The feed is ordered by
`receivedAt` (then `occurredAt` for unsynced local events); conflicts are
detected by slot or `baseVersion`, not by time.

### Offline
Each device keeps its log and an outbox locally. The UI shows the last
successful sync; before a "Given" it warns when that is older than a
threshold, because an offline device cannot know what others did.
Preventing a double dose offline is impossible; detecting and surfacing
it is the goal.

## The gateway

```dart
abstract interface class SyncGateway {
  /// Uploads events; returns them with `receivedAt` set. Idempotent by id.
  Future<Result<List<CareEvent>>> push(List<CareEvent> events);

  /// Events received by the server after [cursor], as they arrive.
  Stream<List<CareEvent>> watch({required String circleId, Cursor? cursor});
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
against the Firestore emulator in stage 2.

## Firestore (stage 2)

### Collections
```
circles/{circleId}
  name, recipientName, createdAt
  members/{uid}          role (family | carer | viewer), caregiverId, joinedAt
  events/{eventId}       the CareEvent as JSON, receivedAt = serverTimestamp()
```
- Event ids are the client UUIDs, so a retried write is the same document
  (`set` without merge, rejected by rules if it already exists).
- `watch` is a snapshot listener on `events` ordered by `receivedAt`,
  starting after the cursor. Firestore's offline cache replaces the local
  outbox on mobile and web.
- Projections stay client-side; the log per circle is small (hundreds of
  events a month). Snapshots are an optimization for later.

### Security rules (draft)
```
match /circles/{circleId} {
  function isMember() {
    return exists(/databases/$(database)/documents/circles/$(circleId)/members/$(request.auth.uid));
  }
  allow read: if isMember();

  match /members/{uid} {
    allow read: if isMember();
    // Invitations are created by a Cloud Function, not by clients.
    allow write: if false;
  }

  match /events/{eventId} {
    allow read: if isMember();
    allow create: if isMember()
      && request.resource.data.circleId == circleId
      && request.resource.data.receivedAt == request.time
      && request.resource.data.id == eventId;
    // The log is append-only.
    allow update, delete: if false;
  }
}
```

### Public demo on Firebase
Anonymous auth; "Try the demo" seeds a private circle per visitor; App
Check limits abuse; old demo circles are deleted after 7 days.

## Stage 3 notes
- **Region** is fixed at database creation: `europe-west*` for EU users
  (GDPR treats health data as a special category), `southamerica-east1`
  for Argentina first (Ley 25.326 treats it as sensitive). Possibly one
  project per region.
- **Team alerts**: a scheduled Cloud Function finds overdue slots and
  notifies every member through FCM. Requires the Blaze plan.
- Data processing agreements, privacy policy and data export/deletion
  before any real user.
