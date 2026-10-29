# Architecture

## Data flow
```
Widget ──event──▶ Controller ──▶ Repository (interface) ──▶ RepositoryImpl ──▶ DataSource
  ▲                   │                                         │                  │
  └── AsyncValue ◀────┘◀──────────── Result<T> ◀────── guard() ◀┘◀── DTO / AppException
```
1. The **data source** reads raw data and returns DTOs, or throws an
   `AppException` (`StorageException`, `ParsingException`, ...).
2. The **repository impl** wraps the work in `guard()`, maps DTOs to
   entities and returns `Result<T>`: `Ok(value)` or `Err(failure)`. Raw
   exceptions never leave the data layer.
3. The **controller** turns the `Result` into state. In `build()`,
   `result.getOrThrow()` makes a `Failure` become `AsyncError`.
4. The **widget** watches the controller and renders `AsyncValue` with
   pattern matching. User events call controller methods.

## Events and sync
Shared data follows the event model in `docs/backend.md`:
- Writes append an immutable `CareEvent` to the local log (and outbox);
  they never mutate shared state. Edits carry the `baseVersion` they
  started from.
- Reads are projections of the log, computed in `domain` as pure
  functions that take `now` (no clock access inside). Controllers watch
  the log and derive.
- Conflicts (two doses for one slot, two edits from one version) are part
  of the projected state and rendered as such; nothing resolves them
  silently.
- Only `data` knows the `SyncGateway` implementation. Device clocks never
  order or resolve anything; `receivedAt` from the server does.

## Error handling
- `Failure` (sealed, `core/error/failure.dart`) is the only error type above
  the data layer. Add a subclass when the UI must react differently
  (`NetworkFailure`, `NotFoundFailure`, ...).
- `guard()` catches `AppException` → mapped failure, and other `Exception`s →
  `UnexpectedFailure`. `Error`s (bugs) are **not** caught.
- The UI shows `failure.message(context.l10n)` (`core/l10n/failure_messages.dart`)
  and offers retry. Never show `toString()` of an error.
- Never `catch (e) {}`. Every catch has an `on` type and logs or rethrows.

## Riverpod rules
- Always codegen: `@riverpod` / `@Riverpod(keepAlive: true)`. No manual
  `Provider(...)` declarations.
- `ref.watch` in `build` (widgets and providers); `ref.read` only inside
  callbacks/event handlers; `ref.listen` for side effects (snackbars,
  navigation).
- DI is through providers: data sources, repositories, clients, clock
  (`clockProvider`), session. Override them in tests.
- Repository providers return the **interface** type.
- Derive instead of duplicating state: a functional provider combining
  others (e.g. `visibleClients` = clients + filter). Derive synchronously
  with `whenData` when a `.future` rebuild would flash a loading state.
- Use `ref.watch(provider.select((s) => s.field))` when a widget needs a
  small part of a large state.
- Release resources with `ref.onDispose`.
- Riverpod retries failed providers automatically; disable with
  `retry: (_, _) => null` in tests.

## Widgets have no business logic
Widgets only: render state, capture events and delegate them, hold
**ephemeral UI state** (selected tab, animation controllers, text field
focus). Pure display formatting via `core/utils/formatters.dart` is allowed.

❌ Wrong: logic, data access and hardcoded copy in the widget
```dart
class ClientsList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ClientsRepositoryImpl(ClientsLocalDataSource(...)); // data access
    return FutureBuilder(
      future: repo.getClients(),
      builder: (context, snapshot) {
        final hot = snapshot.data!.where((c) => c.isHot).toList(); // business rule, `!`
        if (hot.isEmpty) return const Text('No clients');           // hardcoded copy
        ...
      },
    );
  }
}
```

✅ Right: the controller owns the logic; the widget renders and delegates
```dart
@riverpod
AsyncValue<List<Client>> visibleClients(Ref ref) {
  final filter = ref.watch(clientFilterControllerProvider);
  return ref.watch(clientsControllerProvider).whenData(filter.apply);
}

class ClientsSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(visibleClientsProvider)) {
      AsyncData(:final value) => AnimatedClientGrid(clients: value),
      AsyncError(:final error) => ErrorView(
        message: ...,
        onRetry: ref.read(clientsControllerProvider.notifier).retry,
      ),
      _ => const LoadingView(),
    };
  }
}
```

## Where does this code go?
| Code | Place |
|---|---|
| Business rule about one entity (`isOverdue`, sorting rules) | Entity method / domain enum |
| Orchestration, validation, combining sources, user actions | Controller |
| Parsing, HTTP, storage, exception mapping | Data source / repository impl |
| Layout math, animations, display formatting | Widget |
| Translated copy | ARB files |
