# Code style

## Clean code
- SOLID, DRY, KISS, YAGNI. One responsibility per class/function.
- Short functions with intention-revealing names. Full English words; no
  cryptic abbreviations.
- No magic numbers or strings: design tokens, `static const` named
  constants, or enums. Component-specific dimensions are private
  `static const` fields in the widget (`_iconSize`).
- No dead code, no commented-out code. Comments explain **why**, never
  what. Doc comments (`///`) are required on public APIs in `core/` and
  `domain/`.
- Composition over inheritance. Immutability by default: `final`, `const`,
  freezed classes, unmodifiable lists.
- Avoid `dynamic`, avoid `!` (use pattern matching / local promotion), avoid
  `late` unless the value is guaranteed before first read (e.g. initialized
  in `initState`).
- Never `print`: use `AppLogger`.
- Prefer `switch` expressions and sealed classes over `if` chains and type
  checks.

## Flutter
- Extract widgets into classes, never `_buildX()` methods. Private
  `_Widget` classes when only one file uses them.
- `const` constructors and instances wherever possible.
- Lists: `ListView.builder` / slivers for unbounded or long content.
- Never use a `BuildContext` after an `await` without `if (!context.mounted)
  return;`.
- Theme: Material 3, colors from `context.colors` (the `AppColors` theme
  extension, light and dark palettes), text from `AppTextStyles`,
  spacing from `AppSpacing`, radii from `AppRadius`, motion from
  `AppDurations`. Nothing hardcoded in widgets.
- Text styles carry no color: main text inherits `ink` from the theme;
  muted styles add `.copyWith(color: context.colors.inkMuted)`. Styles
  the theme applies directly (app bar title, chips, wheels) set it there.
- i18n: every user-visible string comes from `context.l10n`. Add each key
  to **both** `app_en.arb` and `app_es.arb`.
- Accessibility: `Semantics` on custom tappables (button, selected, label),
  tap targets ≥ 48×48, text contrast ≥ 4.5:1, test with large text scale.
- Performance: avoid rebuilding large subtrees (split widgets, `select`),
  dispose controllers, prefer implicit/`AnimatedX` widgets for simple
  motion and `AnimationController` for orchestrated motion.

## Linting and formatting
- `very_good_analysis` + explicit extras in `analysis_options.yaml`. Zero
  issues allowed (infos included).
- `dart format` (tall style, 80 columns). The formatter manages trailing
  commas, so `require_trailing_commas` is disabled.
- Generated files are excluded from analysis.

## Testing
- Pyramid: many unit tests (domain, data, controllers), some widget tests,
  goldens only for visually critical components.
- New logic must have tests. Test files mirror `lib/`.
- Mock with `mocktail`; providers with
  `ProviderContainer.test(overrides: [...], retry: (_, _) => null)`.
- Inject time through `clockProvider`; never call `DateTime.now()` in logic
  (domain functions take `now` as a parameter).
- Arrange–act–assert, one behavior per test, names describe behavior
  (`'returns a ParsingFailure instead of throwing'`).
- Sync behavior is tested through the `SyncGateway` contract suite and
  with `fake_async` for latency; never with real delays.

## Definition of Done
- [ ] `scripts/verify.sh` passes (pub get, codegen, l10n, format, analyze
      with zero issues, tests).
- [ ] No business logic in widgets; no hardcoded strings, colors or sizes.
- [ ] New strings in both ARB files.
- [ ] Tests for new logic.
- [ ] Generated code regenerated and included.
- [ ] Conventional Commit message(s) proposed.
