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
   "Who are you?" picks the identity; no login.
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
   Undo for a few seconds (as a `DoseUndone` event). An offline phone
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

### Later candidates (after the MVP)
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
- Light theme first; dark theme (night doses) is a phase 4 candidate.
- Typography: platform font for now; a legibility-focused font (e.g.
  Atkinson Hyperlegible, bundled) is a phase 4 candidate.

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

### Known gaps
- Both phones' GoRouters share the browser URL on the web; harmless with
  one route, to revisit when phase 2 adds routes.
- The chosen identity ("Who are you?") resets on reload.

### Next steps, in order
1. **Phase 2**: medications CRUD with schedule versions and stock events.
2. **Phase 3**: appointments and visit notes (questions, post-visit
   prompt); emergency card; handoff summary; Activity; Settings.
3. **Phase 4**: accessibility pass (large text, screen readers), dark
   theme, app icon, screenshots, README.

Each phase ends with `scripts/verify.sh` green and can be deployed.

## Success criteria
- Doubling a dose from two offline devices is reproducible in the demo
  and shows as a clear, attributed conflict.
- Domain rules (slots, status, stock, conflicts) are fully unit tested
  with an injected clock.
- The UI stays usable at 200 % text and with a screen reader.
- Swapping the simulated remote for Firestore needs no changes outside
  `data`.
