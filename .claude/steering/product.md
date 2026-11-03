# Product

> Per-project file. Everything else in `.claude/steering/` is generic and can
> be copied to new projects unchanged, except where it names this project.

## Purpose
Third portfolio demo (after Clientele and Mise): shared care of an older
relative between several caregivers (siblings, a hired carer). Everyone
sees the medications, whether today's doses were given, by whom and when,
so doses are neither doubled nor forgotten. It also tracks pill stock,
medical appointments and visit notes.

What it showcases that the previous demos don't: an **offline-first,
event-sourced data model with multi-device sync and explicit conflict
handling**, behind a backend-agnostic gateway, plus accessibility for
stressful moments.

It is designed so it could grow into a real product (see "Beyond the
demo"), but the demo comes first.

## Target audience
- Users: family caregivers coordinating care, often under stress, tired or
  in a hurry, some of them older adults themselves.
- Market: Spanish first (Argentina, Rioplatense voseo in `es`), English as
  second locale. Europe later (`es_ES` and GDPR, see `docs/backend.md`).
- Demo audience: clients and agencies reviewing the repo and the live web
  demo.

## Medical disclaimer
ICare records what caregivers do; it never suggests doses, timings or
interactions. Every rule that warns (minimum interval, max per day, low
stock) uses values the user entered, and the copy says so. The disclaimer
appears on the welcome screen, in Settings and in the README. Sample data
is labeled as such and avoids combinations that read like a clinical plan.

## Competitive context (checked 2026-10-29)
Shared medication logs already exist: DoseSync, Carebind, Elderoak,
NestBoard, CircleCare, Caregiver: Elderly Care Log, Zenia Care, Caring
Village, Medisafe's Medfriend. Several are localized to Spanish
(CircleCare, Caregiver: Elderly Care Log, Elderoak), so neither
coordination nor language is a differentiator by itself. Market prices:
limited free tiers, premium at $7–15/month or a $49 lifetime deal.

Angles worth keeping, unvalidated:
- **Doses given twice are recorded, not discarded.** DoseSync resolves
  offline double confirmations with "server wins", which hides a second
  dose that really happened. ICare keeps both and raises a conflict.
- Mixed teams (family + hired carer) with handoffs and, later, shifts.
- Stress-proof UI and an emergency card.
- LatAm context: WhatsApp-first sharing, voseo, local pricing.

Nursing homes are a different (B2B, eMAR) product and out of scope; a
family portal for residents' relatives is a possible later path.

## Sync strategy
- Stage 1 (this demo): local persistence (Hive) + a **simulated remote**
  behind `SyncGateway`, with latency, an offline switch and server-assigned
  `receivedAt`. Free, no accounts, always up.
- Stage 2: a Firestore adapter (Spark plan, free) passing the same
  contract tests against the Firebase emulator. Domain and UI unchanged.
- Stage 3 (real users): Blaze plan, Cloud Functions for team alerts on
  overdue doses, final region, legal work on health data.
- Design, collections and rules: `docs/backend.md`.

## Scope
### In scope (MVP)
1. **Care circle** with sample data: one care recipient, three caregivers.
   Each phone belongs to one member (see item 15); no login.
2. **Medications**: name, strength (free text), form, instructions,
   units per dose, stock threshold in days. Schedules are versioned
   (`effectiveFrom`): fixed times on chosen weekdays, or as needed with
   minimum interval and max per day. Fixed schedules may also set a
   minimum interval. Medications are archived, never deleted.
3. **Today**: next dose highlighted; doses grouped by time of day with
   status: upcoming, due (±30 min), overdue, given (who, when), given
   twice (conflict), skipped (reason). Doses from yesterday stay in a
   "From yesterday" section while unresolved, and for the rest of the day
   once resolved, so whoever resolved them sees the result ("today at").
   As-needed medications show "Last dose: 3 h ago, by Ana". Doses
   recorded on this device but not yet synced show a "Not synced yet"
   badge.
4. **Dose sheet**: big "Given" button, "Skip" with reason, history of the
   dose. Confirmation when it is already given or the minimum interval
   has not passed; warning when the last sync is older than N minutes.
   "When was it given?": now, 30 min or 1 h ago, or a picked time (a
   time later than now means yesterday), stored as `givenAt`; warnings
   are checked against that time. Undo for a few seconds (as a
   `DoseUndone` event), and afterwards "Remove" on each record of the
   dose, with a confirmation; it appends the same event, so Activity
   shows it. A dose already given is not offered "Mark as given" again:
   when someone else recorded it, "I gave it too" opens the form, with
   warnings, for a second dose really given, which then knows every
   earlier record; whoever recorded it can only remove their record. An offline phone
   always warns, and its confirmation says the record is saved on the
   phone until the connection is back.
   **Conflicts** (doses recorded twice unseen) interrupt when they arrive
   with a sync, stay as cards at the top of Today, and open a guided
   review: "Did Elena get both doses?" → "No, only one" cancels the
   repeated records; "Yes" keeps the double dose on record with a
   pointer to the doctor or pharmacist; "I don't know yet" leaves it
   pending. Giving or skipping is hidden until it is answered.
5. **Stock** derived from events: counted, refilled, consumed by given
   doses (units stored in each event). Low-stock alert by days left.
6. **Appointments**: upcoming and past, prep notes and questions for the
   doctor, visit notes from several authors. Past appointments without
   notes ask for them while details are fresh.
7. **Activity**: the shared event log, filterable by caregiver; edits and
   conflicts appear there too.
8. **Sync status**: "Synced 2 min ago" / "Offline: others' changes may be
   missing". Concurrent edits to a medication or appointment are flagged
   for review, never silently overwritten.
9. **Two-device mode** on wide screens: two phones side by side (two
   caregivers), each with its own container, router and storage, talking
   only through the simulated remote. Offline switch per device to
   reproduce a conflict on demand.
10. **Emergency card**: allergies, conditions, doctors, emergency
    contacts and active medications on one legible screen, copyable as
    text (for an ER visit). Backed by a `RecipientProfileUpdated` event.
11. **Handoff summary** ("te dejo dicho"): pending doses, last doses
    given, low stock, next appointment and recent notes, copied as text
    to paste into WhatsApp. Clipboard only, no share dependency.
12. **Settings**: language (en/es), identity, simulation controls, medical
    disclaimer, reset demo data.

13. **Care tasks** (phase 5): things to do that are not medications
    ("Bath", "Change the bedding", "Check her skin"). A name, an optional
    note, and a schedule: times on chosen weekdays, or "during the day"
    with no set time. Marked done or skipped (with a reason) by whoever
    did it, removable like dose records, and listed with the doses on
    Today by time; "during the day" tasks get their own group. A Tasks
    tab lists them, with add, edit and archive. No stock, warnings or
    conflicts: a task done twice shows both records but is harmless.
    A task missed yesterday does not carry over. Concurrent edits are
    reviewed like medications. The handoff summary includes them.

14. **Appointment documents**: links to studies, results or reports
    (a title and an http or https address) kept with an appointment,
    shown on its detail and the list, opened outside the app, removable
    with confirmation, and listed in the handoff for the next
    appointment. ICare stores links only, never files.

15. **Roles and membership** (phases 1 to 3 of 4 built): admin, caregiver,
    helper and view-only members with their own permissions and data,
    phones joined by one-time invitation codes instead of "Who are you?",
    and the server checking every event. Design and phases:
    [`docs/roles.md`](../../docs/roles.md).

16. **Skip reasons the circle sets**: the standard reasons (translated)
    can be hidden, the circle adds its own (kept as written), and
    "Other" is always offered with room to write what happened. Events
    store reasons by id, so old records keep theirs. Managed in Settings
    by admins and caregivers.

17. **Demo without data**: on first run the welcome offers the sample
    circle or starting from scratch (demo only; also in Settings → Demo).
    From scratch, both phones and the server are cleared and the phones
    offer to create a circle (one's name, the name of the person cared
    for) or join one. The person cared for is named from the circle
    everywhere; "Sample data" shows only for the sample circle.

### Later candidates (after the MVP)
- Uploaded files (PDFs, photos) for appointment documents: with the
  stage 2 backend and file storage, and only once local data is
  encrypted. Not a medical record: no diagnoses or history beyond what
  caregivers link.
- Shift rotation: who is on duty and when (strongest differentiator
  candidate).
- Helper role with a Today-only view, or guest access by link (needs
  stage 2 auth).
- Note tags or threads by concern (sleep, swelling) to show evolution.
- Dose history export (CSV) for the doctor.
- Invites through WhatsApp links.
- Escalating overdue alerts and quiet hours (stage 3).

### Out of scope
Deliberately not built, with the reason:
- Label scanning or a drug database: regulated data that differs per
  country.
- Interaction warnings, dose suggestions, AI visit summaries: medical
  advice.
- Chat: WhatsApp already fills that role for the target users.
- Devices, vitals, fall detection: different product.
- "Grandparent mode": the target recipient depends on others for their
  medication.

Also out: real backend (stage 2), push or local notifications (web can't schedule
them reliably; server-side alerts come with stage 3), accounts and auth,
several care recipients, drug database or interactions, dose suggestions,
photos and attachments, calendar integration, PDF export, multiple time
zones (everything runs in the care recipient's local time; DST edge cases
documented), nursing-home features.

## Design
- Calm neutrals, one deep teal accent; status colors always paired with an
  icon and a label.
- Accessibility is a requirement: targets ≥ 48 dp (primary actions 56 dp),
  contrast ≥ 4.5:1, layouts that survive 200 % text, `Semantics` on custom
  controls, plain language, no time pressure except the undo window.
- Bottom navigation bar with only tabs that have real content: Today,
  Medications, Activity (Appointments joins in phase 3).
- Today: header (recipient, date, team avatars, sync and sample-data
  pills), day progress, conflict cards, a filled next-dose card with a
  one-tap "Mark as given" (opens the sheet instead when there is a
  warning), and a vertical timeline per part of the day with status
  pills.
- Rounded surfaces (20–28 px), soft shadows, stadium buttons and chips.
- Forms (inspired by DoseSync): white fields with the label above, on
  the tinted background, grouped under small uppercase section titles;
  Cupertino sliding segmented controls; "Save" as a pill in the app bar.
- Times and dates are picked with Cupertino scroll wheels in a bottom
  sheet, on Android too: always 24 h, like every time the app shows;
  dose times in 5-minute steps. Day and time are separate fields (a
  combined wheel with AM/PM does not fit a phone).
- Typography: Atkinson Hyperlegible Next, bundled (OFL), designed by the
  Braille Institute for low vision; its slashed zero is intentional.
- Light and dark themes (for night doses), following the system unless
  chosen in Settings. Both palettes keep text at 4.5:1; the next-dose
  card stays deep in dark, so it never glares.
- `test/app/accessibility_test.dart` checks every screen, sheet and
  dialog against Flutter's tap target, label and contrast guidelines in
  both themes, and at 200 % text in both languages; failures fail CI.
- Screen readers read each dose, row and card as one node, in order.

## Status
### Done
- Scaffold from Mise: core (errors, Result, guard, retry policy, logger,
  l10n, env), tokens, phone frame, verify script, CI with GitHub Pages
  deploy, skills.
- Phase 1: event-sourced care domain (schedules, dose slots, stock,
  conflicts with `knownDoseIds`, warnings); event codec, Hive event store,
  simulated server and connection, gateway contract suite; Today screen,
  dose sheet (give, skip, undo, warnings, conflict review), sync banner
  and per-dose "not synced yet" badge,
  "Who are you?"; sample circle seeded on first run; two-device demo
  shell with per-phone network switches.
- Phase 2: add and edit medications (one-page form, prescription
  note), schedule changes from now, tomorrow or a picked date with
  earlier versions listed, stock recount and refill, archive with
  confirmation, and review of concurrent edits ("keep this one" / "use
  this one"). Validation is pure domain code; every flow has widget
  tests, including 200 % text.
- Phase 3, appointments: a tab with upcoming and past appointments
  (date badges, questions to ask, "no notes yet" prompt), detail with
  questions and visit notes from several caregivers (open from the
  visit's start), add/edit form with a date-and-time wheel, cancel with
  confirmation, and concurrent edits reviewed like medications. Today
  shows the next appointment within 48 h.
- Phase 3, emergency card: full-screen card opened from a red pill on
  Today; allergies first on red, conditions, active medications from
  the log, doctors and contacts with call buttons (`url_launcher`),
  notes, and "Copy as text". Edited through a versioned
  `RecipientProfileUpdated`; sample phone numbers use the fictional 555
  range.
- Phase 3, handoff ("te dejo dicho"): a card at the end of Today opens
  the summary exactly as it will be pasted: doses given (who, when),
  skipped, still to give (yesterday's too), doses to review, low stock,
  next appointment within a week and the latest visit note; one button
  copies it. Plain text, no emoji.
- Phase 3, settings and welcome: per-phone preferences in Hive (who
  you are, language, welcome seen); a first-run welcome with the
  medical disclaimer and "Who's using this phone?"; Settings (gear on
  Today) with identity, language (System / Español / English), demo
  reset across both phones (repositories stop, stores and server are
  cleared, the sample is seeded again, syncing restarts from an empty
  cursor), disclaimer and licenses.
- Visual refresh: navigation bar, read-only Medications (schedule,
  instructions, stock) and Activity (feed by day) tabs, redesigned Today,
  bundled font.
- Phase 4: accessibility pass (guideline tests in both themes, screen
  reader order), dark theme with a System / Light / Dark setting, app
  icon and launch screens, web manifest, screenshots and README.

- Phase 5, care tasks: `TaskCreated`/`TaskUpdated`/`TaskArchived`/
  `TaskDone`/`TaskSkipped` events, projected into task slots; Today
  mixes timed tasks with doses by time and groups untimed ones under
  "During the day"; a task sheet (done, not done with a reason, remove
  a record); a Tasks tab with add, edit, archive and conflict review;
  sample tasks; Activity and handoff entries. Five tabs, so the bar uses
  short labels (Meds, Visits / Remedios, Turnos).
- Appointment documents (scope item 14): `DocumentLinked` and
  `DocumentRemoved`, a documents section and link sheet on the
  appointment, a count on the list, handoff lines and sample links on
  example.com.
- Roles, phase 1: members and roles as events, the permission rule shared
  by UI and server, the simulated server checking each event (author,
  role, last admin; former members' facts accepted and flagged), per-event
  push results, refused events kept apart and listed under "Not sent",
  phones bound to their owners instead of "Who are you?".
- Roles, phase 2: one-time invitation codes issued by admins on the
  server, a Join screen, the circle in Settings (invite, change role, new
  code, withdraw, remove), leaving a circle on a phone, and a removed
  phone that says so before clearing itself.
- Roles, phase 3: data by role (helpers never receive the team's events),
  a resync when a role change alters that, actions offered by role, the
  helper's Today-only app, read-only viewers, a day summary for admins,
  and the demo with Ana (admin) and Rosa (helper).
- Skip reasons the circle sets (scope item 16), and a note with "Other".
- Demo without data (scope item 17): creating a circle, the welcome's
  demo choice, the recipient's name from the circle.

### Known gaps
- Routers use `routerNeglect`, so the browser back button never moves
  both demo phones; on the web a deep link to a tab is not honored
  either (two apps on one page). Acceptable for the demo.

### Next steps, in order
1. Shifts (who is responsible when): roles phase 4, to design next.
2. Review design details with the user; update README screenshots.
3. Dependabot PRs #1 and #2 (very_good_analysis 11).

Each phase ends with `scripts/verify.sh` green and can be deployed.

## Success criteria
- Doubling a dose from two offline devices is reproducible in the demo
  and shows as a clear, attributed conflict.
- Domain rules (slots, status, stock, conflicts) are fully unit tested
  with an injected clock.
- The UI stays usable at 200 % text and with a screen reader.
- Swapping the simulated remote for Firestore needs no changes outside
  `data`.
