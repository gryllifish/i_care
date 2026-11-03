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
| `mocktail` (dev) | Mocks without codegen. |
| `fake_async` (dev) | Deterministic time for sync latency and undo windows. |
| `very_good_analysis` (dev) | Strict lint set. |
| `build_runner` (dev) | Runs the generators. |
| `flutter_launcher_icons` (dev) | Platform icons from `tool/icon/icare.svg`, drawn by `tool/icon/render.sh`. |

### Deliberately not added yet (YAGNI)
- **Firebase** (`firebase_core`, `firebase_auth`, `cloud_firestore`):
  stage 2, as a second `SyncGateway` implementation (`docs/backend.md`).
- **`google_fonts`**: Atkinson Hyperlegible Next is bundled in
  `assets/fonts/` instead, so text never waits on a font server.
- **Notifications**: out of the MVP; server-side alerts come with stage 3.
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

## Environments
- `env/<env>.json` (git-ignored) holds `APP_ENV`; copy
  from `env/dev.json.example`. Read them only through `core/config/env.dart`.
- Never commit secrets. Anything shipped in the binary is not secret anyway.

## Generated code
`*.g.dart`, `*.freezed.dart` and `lib/core/l10n/generated/` **are
committed** so the repo runs right after cloning. `.gitattributes` marks
them `linguist-generated` (collapsed in GitHub diffs). They are excluded
from analysis and must never be edited by hand: change the source and
re-run codegen.
