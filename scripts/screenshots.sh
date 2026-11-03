#!/usr/bin/env bash
# Regenerates the README screenshots in docs/screenshots from the real app
# on the sample circle (tool/screenshots). Not part of verify or CI.
set -euo pipefail
cd "$(dirname "$0")/.."

# The Material icons font ships with the Flutter SDK.
flutter_bin="$(command -v flutter)"
flutter_root="$(cd "$(dirname "$(readlink -f "$flutter_bin")")/.." && pwd)"

FLUTTER_ROOT="$flutter_root" flutter test tool/screenshots \
  --update-goldens --reporter failures-only
echo "Screenshots written to docs/screenshots/"
