#!/usr/bin/env bash
# PostToolUse hook: formats the Dart file Claude just edited, so formatting
# never costs an extra turn. Generated files are skipped.
file="$(jq -r '.tool_input.file_path // empty')"
case "$file" in
  *.g.dart | *.freezed.dart) ;;
  *.dart) dart format "$file" >/dev/null 2>&1 ;;
esac
exit 0
