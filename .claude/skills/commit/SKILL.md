---
name: commit
description: Propose Conventional Commits for the current changes and create them only after the user approves. Use when the user asks to commit or to prepare commit messages.
---

# Commit

1. Run `git status --short` and `git diff --stat` (add `git diff` on specific
   files only if the stat is not enough to understand them).
2. Group the changes into small, atomic commits with one purpose each.
   Generated files (`*.g.dart`, `*.freezed.dart`, l10n output) go in the same
   commit as the source change that produced them.
3. Propose the plan to the user, in Spanish, as a list:
   `<type>(<scope>): <description>` + the files in each commit.
   Rules: see `.claude/steering/git-workflow.md` (types, imperative lowercase,
   no trailing period, ≤ 72 chars, `!`/`BREAKING CHANGE:` for breaking
   changes).
4. **Wait for explicit approval.** Never commit or push without it.
5. Run `scripts/verify.sh --skip-codegen` before the first commit; stop if it
   fails.
6. Create the commits with `git add <files>` + `git commit -m` (use a body
   when the *why* is not obvious). Append the attribution trailer required
   by the session, if any.
7. Show `git log --oneline -n <count>` as confirmation. Do not push unless
   asked.
