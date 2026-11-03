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
   from every member: what is stored, where (Supabase, Frankfurt), who
   sees it (circle members by role, and the maintainer as operator), that
   it is a beta, and how to ask for a copy or deletion.
2. **Encrypted local storage** on every device (Hive with a key kept in
   the platform's secure storage). Already a stated prerequisite in
   `roles.md`.
3. **Minimal data**: only what the features use; no ID numbers, no
   diagnoses beyond what caregivers choose to note.
4. **Deletion and export** work end to end: `delete_circle`, and a log
   export the maintainer can send.
5. **Backups** encrypted and kept off the repository (`backend.md`).
6. The app keeps saying what it is: a record of what caregivers did,
   never medical advice (`product.md`, medical disclaimer).

## Stage 3, before strangers use it
- Privacy policy and terms in the app and on the site.
- Processor agreement with Supabase (and Google for FCM).
- Whether the database must be registered with the AAIP.
- GDPR if EU users arrive (a separate region and project).
