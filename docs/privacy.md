# Privacy and health data

What the stage 2 beta (one family using ICare for real) needs under
Argentina's data protection law, and what is left for stage 3. Written on
2026-11-03 as design guidance, not legal advice; check with a lawyer
before opening ICare to people outside the beta. Backend details:
[`backend.md`](backend.md).

## The law
**Ley 25.326** (Protección de Datos Personales, 2000) is in force. Bills
to replace it with a GDPR-like regime (such as 3397-D-2026) had not
passed when this was written. The authority is the AAIP (Agencia de
Acceso a la Información Pública).

What applies to ICare:

| Article | Rule | For ICare |
|---|---|---|
| 2, 7 | Health data is sensitive; nobody can be required to provide it | Medications, doses, allergies, conditions and appointments are all sensitive |
| 5 | Processing needs free, express and informed consent, in writing or equivalent | Consent is the legal basis: ICare is not a health provider (art. 8) |
| 9, 10 | Security measures and confidentiality | Access per circle and role, TLS, encrypted local storage, no data in the repo or CI |
| 12 | No transfers to countries without adequate protection, unless consented or under contract clauses | Server in the EU, which is on the adequate list (Disposición 60/2016, Resolución AAIP 34/2019); Brazil and the US are not |
| 14 | Free access to one's data; answer within 10 days | Export the circle's log on request |
| 16 | Rectification and deletion; answer within 5 working days | `delete_circle` removes everything (`backend.md`, Deletion) |
| 21 | Databases are registered with the AAIP | Unclear for a private beta; settle before stage 3 |

## Whose data it is
- **The person cared for** owns the health data. They consent, or their
  legal representative does if they cannot.
- **Each caregiver** consents for their own data: name, role, what they
  recorded and when.

## Beta checklist
Before the family enters real data:
1. **Written consent** from the person cared for (or representative) and
   from every member: what is stored, where (Supabase, Ireland), who
   sees it (circle members by role, and the maintainer as operator), that
   it is a beta, and how to ask for a copy or deletion. For members who
   protect their access with Google, also what is kept of that account
   (item 3).
2. **Encrypted local storage** on every device (done): the beta's Hive
   boxes use AES-256 with a key kept in the platform's secure storage
   (`StorageKey`), and the Supabase session lives there too
   (`SecureSessionStorage`), not in plain preferences. Without a key the
   app keeps data in memory only. Android backups are off, so encrypted
   files are never restored without their key. On the web, secure
   storage is the browser's own: it keeps the key out of plain sight,
   not away from code running on the page.
3. **Minimal data**: only what the features use; no ID numbers, no
   diagnoses beyond what caregivers choose to note. The optional Google
   sign-in to recover access (`roles.md`) keeps, in Supabase Auth only
   and never in the log, what Google hands over for that account: its
   email, name, picture address and Google's id for it. They are deleted
   when the member leaves on that phone, is removed, or the circle is
   deleted, without anyone asking. The app shows the email masked.
4. **Deletion and export** work end to end. Deletion is done: an admin
   deletes the circle for everyone from Settings (beta only), after a
   confirmation that says it cannot be undone. Still to do: a log export
   the maintainer can send.
5. **Backups** encrypted and kept off the repository (`backend.md`).
6. The app keeps saying what it is: a record of what caregivers did,
   never medical advice (`product.md`, medical disclaimer).

## Processors
- **Supabase** (database, Ireland) stores the circle's log.
- **Google (Firebase Cloud Messaging)** delivers push notifications. It
  sees a device token and the kind of news ("a new note"), never names,
  medications or other health data. Each phone's person allows it in
  the system's dialog, and can withdraw it in the system's settings.
- **Google sign-in** (`roles.md`): for members who protect their
  access, Google learns they use ICare. It sees nothing of the circle.

## Stage 3, before strangers use it
- Privacy policy and terms in the app and on the site.
- Processor agreement with Supabase (and Google for FCM and sign-in).
- Whether the database must be registered with the AAIP.
- GDPR if EU users arrive (a separate region and project).
