#!/usr/bin/env bash
# Builds the web app and captures a headless Chrome screenshot at phone size.
# Usage: screenshot.sh [route] [output.png] [width] [height]
#
# Headless Chrome on macOS won't make windows narrower than ~500px, so the
# app is rendered inside an iframe of the requested size.
set -euo pipefail
cd "$(dirname "$0")/../../.."

route="${1:-/}"
output="${2:-build/screenshots/screenshot.png}"
width="${3:-393}"
height="${4:-852}"
chrome="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
port=8765

flutter build web --release --no-wasm-dry-run >/dev/null
mkdir -p "$(dirname "$output")"
# Chrome needs an absolute path.
case "$output" in /*) output_path="$output" ;; *) output_path="$PWD/$output" ;; esac
cat >build/web/_frame.html <<EOF
<!doctype html>
<style>html,body{margin:0;background:#888}iframe{border:0;display:block}</style>
<iframe src="/#$route" width="$width" height="$height"></iframe>
EOF

python3 -m http.server "$port" --directory build/web >/dev/null 2>&1 &
server_pid=$!
trap 'kill "$server_pid" 2>/dev/null' EXIT
sleep 1

window_width=$((width > 500 ? width : 500))
# Headless Chrome has no display link, so entrance animations never run;
# reduced motion makes the app render their end state instead.
"$chrome" --headless=new --hide-scrollbars --force-device-scale-factor=2 \
  --force-prefers-reduced-motion \
  --window-size="$window_width,$height" --virtual-time-budget=40000 \
  --user-data-dir="$(mktemp -d)" \
  --screenshot="$output_path" "http://localhost:$port/_frame.html" \
  >/dev/null 2>&1

echo "$output (${width}x${height} inside a ${window_width}px window)"
