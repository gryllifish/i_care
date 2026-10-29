---
name: verify
description: Run the Definition of Done gate (pub get, codegen, l10n, format, analyze, test) with token-cheap output. Use after any code change and before proposing a commit.
---

# Verify

Run from the project root:

```sh
scripts/verify.sh                 # full gate
scripts/verify.sh --skip-codegen  # faster, when no @riverpod/@freezed/@JsonSerializable/ARB changed
```

Output is one `✓`/`✗` line per step; failing steps print only the last 40
lines of their output. Do not re-run the underlying commands individually to
"see more" unless the tail is truly insufficient.

## On failure
1. Fix the root cause. Never edit `*.g.dart`, `*.freezed.dart` or
   `lib/core/l10n/generated/**` by hand.
2. Re-run `scripts/verify.sh` (use `--skip-codegen` if codegen already passed
   and no annotated files changed).
3. Report to the user only the final status, plus any failure you could not
   fix.

## Manual checks the script cannot do
Before declaring the change done, also confirm the remaining Definition of
Done items in `.claude/steering/code-style.md` (no logic in widgets, no
hardcoded strings/colors/sizes, tests for new logic).
