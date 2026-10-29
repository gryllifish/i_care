# ICare (`i_care`, working name)

Flutter portfolio demo: shared care of an older relative between several
caregivers (medications, who gave each dose and when, stock,
appointments). Offline-first event log with multi-device sync behind a
backend-agnostic `SyncGateway` (simulated remote now, Firestore later),
on the Mise architecture (Riverpod codegen, repository pattern, freezed,
go_router, l10n). Product scope and current status:
`.claude/steering/product.md`. Sync and backend design: `docs/backend.md`.

## Language
Always reply to the user in Spanish. Write code, identifiers, comments,
documentation files (including everything in `.claude/`) and commit
messages in English.

## Non-negotiable rules
1. **Layers:** `presentation → controllers → domain ← data`. `domain` is pure
   Dart. `core` never imports `features` or `app`.
2. **Widgets have no business logic.** They render state, hold ephemeral UI
   state and delegate events to controllers. Logic lives in `@riverpod`
   controllers or domain entities.
3. **Riverpod with codegen only** (`@riverpod`). `ref.watch` in build,
   `ref.read` in callbacks. All dependencies come from providers.
4. **Errors are typed.** Data sources throw `AppException`; repositories
   return `Result<T>` via `guard()`; the UI renders `Failure` messages
   through l10n. Network failures (`NoConnection`, `Timeout`, `Server`)
   are `isTransient` and retried by `retryPolicy`. No empty catches, no
   raw exceptions above `data`. Hive and gateway types never leave `data`.
5. **No hardcoded values in widgets:** strings from `context.l10n` (en + es),
   colors/text/spacing/radius/durations from `core/theme` and
   `core/constants`.
6. **Immutability and safety:** freezed models, `final`/`const`, no
   `dynamic`, no unjustified `!` or `late`, no `print` (use `AppLogger`).
7. **Never edit generated files** (`*.g.dart`, `*.freezed.dart`,
   `lib/core/l10n/generated/`). They are committed; regenerate instead.
8. **Ask before adding a dependency**, with a justification.
9. **Conventional Commits.** Never commit or push without explicit approval.
10. **Shared data is an append-only event log.** Never mutate shared
    state; append a `CareEvent`. Never resolve conflicts silently. Never
    order or decide anything by device clock. Never give medical advice in
    copy (warnings cite values the user entered).
11. **Done means `scripts/verify.sh` passes (full run, with codegen)** and
    new logic has tests. CI fails if generated files are stale.

## Read on demand (do not load everything up front)
| When you are... | Read |
|---|---|
| Clarifying what to build, checking status | `.claude/steering/product.md` |
| Adding a package, running/building, env config | `.claude/steering/tech.md` |
| Creating files or folders, naming things | `.claude/steering/structure.md` |
| Writing controllers, repositories, error handling | `.claude/steering/architecture.md` |
| Touching events, projections, sync or the backend | `docs/backend.md` |
| Unsure about a style rule, writing tests, finishing a task | `.claude/steering/code-style.md` |
| Committing, branching, PRs | `.claude/steering/git-workflow.md` |

## Skills
- `/verify`: Definition of Done gate with compact output. Run after changes.
- `/new-feature <name>`: scaffold a feature end to end from templates.
- `/commit`: propose Conventional Commits, commit after approval.
- `/screenshot [route]`: web build + headless screenshot for visual checks.

## Environment notes
- The user works in the VS Code extension: `!` shell commands don't run
  there and the `claude` CLI is not on PATH. Give commands for the VS Code
  integrated terminal instead.
- iOS simulators run in Device Hub (there is no Simulator.app); use
  `xcrun simctl` for scripted actions such as recordings.
- Sibling projects `../mise` (Mise) and `../clients_app` (Clientele) are
  the finished previous demos and the source of this template; reuse
  their patterns when in doubt.

## Token hygiene
- Prefer `scripts/verify.sh` over running analyze/test/build_runner
  separately; it prints only failures.
- Once `features/care` exists, use it as the reference implementation
  instead of re-reading steering files for patterns already shown there.
