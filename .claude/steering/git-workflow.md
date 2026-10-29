# Git workflow

## Conventional Commits (always)
```
<type>(<scope>): <description>

[optional body: why, not what]

[optional footer: BREAKING CHANGE: ..., Refs #123]
```
- Description: imperative mood, lowercase, no trailing period, ≤ 72 chars
  for the whole header.
- Scope: feature or area (`clients`, `core`, `l10n`, `theme`, `deps`,
  `router`). Optional for repo-wide changes.
- Breaking changes: `feat(api)!: ...` and/or a `BREAKING CHANGE:` footer.
- Small, atomic commits: one purpose each. Generated files go with the
  source change that produced them.

| Type | Use for |
|---|---|
| `feat` | New user-facing behavior |
| `fix` | Bug fix |
| `docs` | Documentation only (README, steering) |
| `style` | Formatting, no code meaning change |
| `refactor` | Code change without behavior change |
| `perf` | Performance improvement |
| `test` | Adding or fixing tests |
| `build` | Dependencies, build config, codegen config |
| `ci` | CI configuration |
| `chore` | Tooling and maintenance |
| `revert` | Reverting a previous commit |

Examples:
```
feat(clients): animate grid between filter results
fix(clients): keep card colors stable after sorting
refactor(clients): move filtering into domain enum
build(deps): add go_router
test(clients): cover repository failure mapping
docs: add steering files
chore: add verify script
```

## Branches
- `main` is always releasable.
- `<type>/<short-kebab-description>`: `feat/client-detail-hero`,
  `fix/grid-overflow`, `chore/upgrade-flutter`.

## Pull requests
- Title follows Conventional Commits (used as squash message).
- Description: what and why, screenshots/GIF for UI changes, how to test.
- `scripts/verify.sh` passes before opening.
- Prefer squash merge for small PRs; keep atomic commits for larger ones.

## Claude-specific
- Never commit or push without explicit approval. Propose messages first
  (use the `commit` skill).
