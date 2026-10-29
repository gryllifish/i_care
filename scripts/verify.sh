#!/usr/bin/env bash
# Definition of Done gate: pub get, codegen, l10n, format, analyze, test.
# Prints one line per passing step and only the tail of failing output, so
# running it costs few tokens. Exit code is non-zero if any step fails.
#
# Usage: scripts/verify.sh [--skip-codegen]
set -uo pipefail
cd "$(dirname "$0")/.."

failed=0
run() {
  local name="$1"
  shift
  local output
  if output="$("$@" 2>&1)"; then
    echo "✓ $name"
  else
    echo "✗ $name"
    echo "$output" | grep -v '^\s*$' | tail -n 40
    failed=1
  fi
}

run "pub get" flutter pub get
if [[ "${1:-}" != "--skip-codegen" ]]; then
  run "codegen" dart run build_runner build --delete-conflicting-outputs
fi
run "l10n" flutter gen-l10n
run "format" dart format lib test
run "analyze" flutter analyze --no-pub
run "test" flutter test --no-pub --reporter failures-only

exit $failed
