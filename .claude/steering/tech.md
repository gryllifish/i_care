# Tech stack

## Versions
- Flutter 3.47 (stable) / Dart 3.13. Material 3.
- Platforms: iOS, Android, Web.

## Packages
| Package | Why |
|---|---|
| `flutter_riverpod` + `riverpod_annotation` / `riverpod_generator` | State management and DI. Codegen (`@riverpod`) for less boilerplate and compile-time safety. |
| `freezed` + `freezed_annotation` | Immutable entities, DTOs and states with `copyWith`/`==`/unions. |
| `json_serializable` + `json_annotation` | DTO serialization. `build.yaml` sets `field_rename: snake`. |
| `go_router` | Declarative routing, exposed through a keep-alive provider. |
| `flutter_localizations` + `intl` | i18n via ARB files (`en`, `es`) and locale-aware formatting. |
| `hive_ce` + `hive_ce_flutter` | Local event log, outbox and the simulated remote (IndexedDB on web). Boxes of JSON strings; no type adapters. |
| `uuid` | Event ids generated on the device, unique across devices without a server (`docs/backend.md`). |
| `flutter_secure_storage` | The beta's storage key and Supabase session in Keychain / Android Keystore (`docs/privacy.md`). |
| `supabase_flutter` | Stage 2 beta backend: anonymous sign-in, calls to the backend's functions, Realtime pings, session kept across restarts. Used only in `data/sync/supabase_connection.dart` and `bootstrap`. |
| `mocktail` (dev) | Mocks without codegen. |
| `fake_async` (dev) | Deterministic time for sync latency and undo windows. |
| `very_good_analysis` (dev) | Strict lint set. |
| `build_runner` (dev) | Runs the generators. |
| `flutter_launcher_icons` (dev) | Platform icons from `tool/icon/icare.svg`, drawn by `tool/icon/render.sh`. |

### Deliberately not added yet (YAGNI)
- **FCM** (`firebase_core`, `firebase_messaging`): stage 2 push
  notifications by event; Firebase is used for messaging only.
- **`google_fonts`**: Atkinson Hyperlegible Next is bundled in
  `assets/fonts/` instead, so text never waits on a font server.
- **Notifications**: out of the demo; push by event comes with the stage
  2 beta, overdue alerts later.
- **Native flavors**: `--dart-define-from-file` covers dev/staging/prod
  until per-flavor app ids or icons are needed.
- **Logger package**: `AppLogger` wraps `dart:developer`.
- **`fpdart`**: `Result` is a small sealed class in `core/error/`.

### Version pins
- `freezed`, `riverpod_generator` and `json_serializable` share the
  `analyzer`: upgrade them together, never one alone.

## Commands
```sh
scripts/verify.sh                       # Definition of Done gate (prefer this)
flutter run --dart-define-from-file=env/dev.json
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch --delete-conflicting-outputs
flutter gen-l10n                        # also runs on pub get / run
flutter analyze
flutter test
dart format lib test
```

### Backend (stage 2)
Needs the Supabase CLI and a container runtime (OrbStack on the
maintainer's Mac; its `docker` lives in `~/.orbstack/bin`).
```sh
# Only what the app uses: database, auth, REST and Realtime.
supabase start -x studio,imgproxy,mailpit,storage-api,edge-runtime,logflare,vector,supavisor,postgres-meta
supabase test db                        # pgTAP suite in supabase/tests/
flutter test test/features/care/data/sync/supabase_connection_test.dart
flutter run --dart-define-from-file=env/beta.json   # the beta, one phone
supabase db reset                       # reapply migrations from scratch
supabase stop
```
Local keys printed by `supabase start` are the CLI's fixed demo keys,
not secrets; real project keys go only in git-ignored `env/*.json`
(`env/beta.json.example`). An Android emulator reaches the host's stack
at `10.0.2.2`, not `127.0.0.1`.

## Environments
- `env/<env>.json` (git-ignored) holds `APP_ENV`, and for the beta
  `SYNC_BACKEND` and the Supabase project; copy from
  `env/*.json.example`. Read them only through `core/config/env.dart`.
- Never commit secrets. Anything shipped in the binary is not secret anyway.

## Generated code
`*.g.dart`, `*.freezed.dart` and `lib/core/l10n/generated/` **are
committed** so the repo runs right after cloning. `.gitattributes` marks
them `linguist-generated` (collapsed in GitHub diffs). They are excluded
from analysis and must never be edited by hand: change the source and
re-run codegen.
