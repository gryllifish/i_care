---
name: new-feature
description: Scaffold a new feature end to end (DTO → entity → repository → controller → screen + tests) following this project's architecture. Use when the user asks to create a new feature, screen with data, or module.
argument-hint: <feature_name> [entity_name]
---

# New feature

Scaffold `lib/features/<feature>/` using the templates below. Replace
`<feature>` (snake_case), `<Feature>` (PascalCase), `<entity>` / `<Entity>`.
Sibling project `../mise` (`recipes` feature) is the reference
implementation; open it only if a template does not cover a case.

Most ICare features are UI on top of `features/care/` (the event log):
they need only a controller, a screen and tests, reading and writing
through `care`'s repository providers. Scaffold data/domain layers only
for a genuinely new data source.

## 1. Plan first
Tell the user (in Spanish) which files you will create and which entity
fields you assume. Ask only if the entity's fields are unknown.

## 2. Files

```
lib/features/<feature>/
  domain/entities/<entity>.dart
  domain/repositories/<feature>_repository.dart
  data/models/<entity>_dto.dart
  data/mappers/<entity>_mapper.dart
  data/datasources/<feature>_<local|remote>_data_source.dart
  data/repositories/<feature>_repository_impl.dart
  controllers/<feature>_controller.dart
  presentation/screens/<feature>_screen.dart
  presentation/widgets/
test/features/<feature>/   (mirror: datasource, repository, controller tests)
```

### Entity (pure Dart)
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '<entity>.freezed.dart';

@freezed
abstract class <Entity> with _$<Entity> {
  const factory <Entity>({required String id}) = _<Entity>;
}
```

### Repository interface
```dart
abstract interface class <Feature>Repository {
  Future<Result<List<<Entity>>>> get<Entity>s();
}
```

### DTO + mapper
```dart
@freezed
abstract class <Entity>Dto with _$<Entity>Dto {
  const factory <Entity>Dto({required String id}) = _<Entity>Dto;
  factory <Entity>Dto.fromJson(Map<String, dynamic> json) =>
      _$<Entity>DtoFromJson(json);
}

extension <Entity>DtoMapper on <Entity>Dto {
  <Entity> toEntity() => <Entity>(id: id);
}
```
JSON keys are snake_case automatically (`build.yaml`); no `@JsonKey` needed
for renaming.

### Data source
- Throws only `AppException` subclasses (`StorageException`,
  `ParsingException`, `NoConnectionException`, ...).
- Local sources take a Hive `Box<String>` from a provider (opened in
  `bootstrap`, overridden in tests). Remote access goes only through
  `SyncGateway` (`docs/backend.md`).
- Expose with `@riverpod <Feature>XDataSource <feature>XDataSource(Ref ref)`.

### Repository implementation
```dart
class <Feature>RepositoryImpl implements <Feature>Repository {
  const <Feature>RepositoryImpl(this._dataSource);
  final <Feature>XDataSource _dataSource;

  @override
  Future<Result<List<<Entity>>>> get<Entity>s() => guard(() async {
    final dtos = await _dataSource.fetch<Entity>s();
    return List.unmodifiable(dtos.map((dto) => dto.toEntity()));
  });
}

@riverpod
<Feature>Repository <feature>Repository(Ref ref) =>
    <Feature>RepositoryImpl(ref.watch(<feature>XDataSourceProvider));
```

### Controller
```dart
@riverpod
class <Feature>Controller extends _$<Feature>Controller {
  @override
  Future<List<<Entity>>> build() async =>
      (await ref.watch(<feature>RepositoryProvider).get<Entity>s())
          .getOrThrow();

  void retry() => ref.invalidateSelf();
}
```
Mutations: set `state = const AsyncLoading()`, call the repository, then set
`AsyncData`/`AsyncError` from the `Result` with a `switch`.

### Screen
`ConsumerWidget` that `switch`es on the `AsyncValue` (`AsyncData`,
`AsyncError` → `ErrorView` with `failure.message(context.l10n)`, loading).
No logic, no hardcoded strings: add keys to **both** `app_en.arb` and
`app_es.arb`. Register the route in `AppRoutes` + `lib/app/app_router.dart`.

### Tests (required)
- Data source: fake input → DTOs; error paths → right `AppException`.
- Repository: mock data source with `mocktail`; `Ok` mapping and `Err`
  on exception.
- Controller: `ProviderContainer.test(overrides: [...], retry: (_, _) => null)`
  overriding the repository provider.

## 3. Finish
Run the `verify` skill. Report the created files briefly.
