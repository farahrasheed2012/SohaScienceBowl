#!/bin/bash
# Force macOS to pick up a rebuilt app icon (Launch Services cache).
set -euo pipefail

APP=$(find "$HOME/Library/Developer/Xcode/DerivedData"/ScienceBowlCoach-*/Build/Products/Debug/ScienceBowlCoach.app -maxdepth 0 2>/dev/null | head -1)

if [[ -z "$APP" || ! -d "$APP" ]]; then
  echo "Build the app in Xcode first (My Mac destination), then run this script."
  exit 1
fi

echo "Refreshing icon for: $APP"
touch "$APP"
/System/Library/Frameworks/CoreServices.framework/Versions/Current/Frameworks/LaunchServices.framework/Versions/Current/Support/lsregister -f -R -trusted "$APP"
killall Dock 2>/dev/null || true
open "$APP"
echo "Done. If the Dock icon is still old, quit Science Bowl Coach, drag the app out of Dock, and Run again from Xcode."
