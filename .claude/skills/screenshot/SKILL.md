---
name: screenshot
description: Build the web app and capture a headless Chrome screenshot of a route to visually check UI changes. Use when comparing the UI against a design reference or after visual changes.
---

# Screenshot

```sh
.claude/skills/screenshot/screenshot.sh [route] [output.png]
# defaults: route "/" , output build/screenshots/screenshot.png
```

- Builds `flutter build web --release`, serves `build/web` on a free local
  port, captures with headless Chrome at a phone-like 500×1000 viewport
  (headless Chrome on macOS will not go narrower) and stops the server.
- Then open the PNG with the Read tool to inspect it.
- Captures run with "Reduce motion" forced (headless Chrome never runs
  entrance animations), so they show end states only.
- A static screenshot cannot verify animations: say so explicitly and ask
  the user to check motion with `flutter run`.
- Requires Google Chrome in `/Applications`. If missing, tell the user
  instead of trying alternatives.
