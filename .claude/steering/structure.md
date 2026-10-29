# Structure

Feature-first, with layers inside each feature.

```
lib/
├── main.dart                 # Only calls bootstrap(App.new)
├── app/                      # App widget, bootstrap, GoRouter (imports features)
├── core/                     # Feature-agnostic; never imports features/ or app/
│   ├── config/               # Env (dart-defines)
│   ├── constants/            # AppDurations and other app-wide constants
│   ├── error/                # Failure, AppException, Result, guard
│   ├── l10n/                 # ARB files, generated code, context.l10n, failure messages
│   ├── router/               # Route path constants (AppRoutes)
│   ├── theme/                # Design tokens + ThemeData
│   └── utils/                # Logger, formatters, pure helpers
├── shared/
│   ├── providers/            # Cross-feature providers (clock, session)
│   └── widgets/              # Reusable widgets without business logic
└── features/
    ├── care/                 # Shared care domain: events, entities, projections, sync
    └── <feature>/            # today, medications, appointments, activity, settings
    ├── data/
    │   ├── datasources/      # Talk to assets/APIs/storage; throw AppException
    │   ├── mappers/          # DTO -> entity extensions
    │   ├── models/           # DTOs (freezed + json_serializable)
    │   └── repositories/     # Implementations + their @riverpod providers
    ├── domain/
    │   ├── entities/         # Pure Dart business objects and rules
    │   ├── projections/      # Pure functions from events to state (care only)
    │   └── repositories/     # Abstract interfaces
    ├── controllers/          # @riverpod Notifiers/AsyncNotifiers + state classes
    └── presentation/
        ├── screens/          # One per route
        └── widgets/          # Feature-specific widgets
test/                         # Mirrors lib/; shared fixtures in test/helpers/
```

Deviations from a textbook layout, on purpose:
- `data/mappers/` keeps DTO→entity mapping explicit and out of both models.
- `features/care/` owns the event log (domain + data, including
  `SyncGateway` and its implementations). UI features (`today`,
  `medications`, ...) usually have only `controllers/` and
  `presentation/`, and read and write through `care`'s repository
  providers. `care` is the one feature others may import; it never imports
  them. See `docs/backend.md`.
- The `GoRouter` lives in `app/` because it imports screens; `core/router/`
  only holds path constants, so `core` never depends on features.
- `core/config/` holds build-time environment config.

## Dependency rules
```
presentation → controllers → domain ← data
```
- `domain` imports only Dart, `freezed_annotation` and `core/error` +
  `core/utils` pure helpers. Never Flutter, Riverpod, Hive or `data`.
- `data` implements `domain` interfaces. It may use Flutter services
  (`AssetBundle`) and Riverpod (for its own providers).
- `controllers` depend on repository **providers** typed as the domain
  interface, never on data sources or implementations directly.
- `presentation` talks only to controllers/providers. Never to repositories
  or data sources.
- Features don't import each other's internals. Share through `shared/` or
  expose a provider.

## Naming
| Kind | File | Class |
|---|---|---|
| Entity | `client.dart` | `Client` |
| DTO | `client_dto.dart` | `ClientDto` |
| Mapper | `client_mapper.dart` | `extension ClientDtoMapper` |
| Repository interface | `clients_repository.dart` | `ClientsRepository` |
| Repository impl | `clients_repository_impl.dart` | `ClientsRepositoryImpl` |
| Data source | `clients_local_data_source.dart` | `ClientsLocalDataSource` |
| Controller | `clients_controller.dart` | `ClientsController` → `clientsControllerProvider` |
| Screen | `home_screen.dart` | `HomeScreen` |
| Test | `<file>_test.dart` mirroring the path in `lib/` | |

- Files: `snake_case.dart`. Classes/enums: `PascalCase`. Members:
  `lowerCamelCase`. Private widgets in the same file: `_PascalCase`.
- Use full words (`client`, not `cli`); booleans read as questions
  (`isHot`, `hasValue`).
