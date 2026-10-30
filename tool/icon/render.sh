#!/usr/bin/env bash
# Renders the launcher icon and launch screen images from icare.svg with
# headless Chrome, then regenerates every platform's icons:
#   tool/icon/render.sh
set -euo pipefail
cd "$(dirname "$0")"
chrome="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

# render <svg> <png>: 1024×1024, transparent where the SVG draws nothing.
render() {
  {
    printf '<!doctype html><style>html,body{margin:0;background:transparent}</style>'
    cat "$1"
  } >"$tmp/page.html"
  "$chrome" --headless=new --hide-scrollbars --window-size=1024,1024 \
    --default-background-color=00000000 --user-data-dir="$tmp/profile" \
    --screenshot="$PWD/$2" "file://$tmp/page.html" >/dev/null 2>&1
}

mark='translate(512 459) scale(1)'

render icare.svg full.png

# Android adaptive icons crop the foreground to a shape, keeping only the
# middle 66%: drop the background and shrink the mark to fit.
sed -e '/id="bg"/d' -e "s/$mark/translate(512 480) scale(0.6)/" \
  icare.svg >"$tmp/fg.svg"
render "$tmp/fg.svg" fg.png

# Launch screens: the mark alone, on the teal launch background.
sed -e '/id="bg"/d' -e "s/$mark/translate(512 464) scale(0.9)/" \
  icare.svg >"$tmp/launch.svg"
render "$tmp/launch.svg" launch.png
images=../../ios/Runner/Assets.xcassets/LaunchImage.imageset
sips -z 200 200 launch.png --out "$images/LaunchImage.png" >/dev/null
sips -z 400 400 launch.png --out "$images/LaunchImage@2x.png" >/dev/null
sips -z 600 600 launch.png --out "$images/LaunchImage@3x.png" >/dev/null
android=../../android/app/src/main/res/drawable-xxhdpi
mkdir -p "$android"
sips -z 600 600 launch.png --out "$android/launch_image.png" >/dev/null
rm launch.png

cd ../..
dart run flutter_launcher_icons
