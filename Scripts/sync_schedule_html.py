#!/usr/bin/env python3
"""Copy schedule HTML from SohaAli/Schedule into Resources/Schedule for the app bundle.

After editing markdown or regenerating HTML, run:
  python3 Scripts/sync_single_pass_schedule.py   # patch SohaAli + copy HTML
  python3 Scripts/generate_xcode_project.py
"""

from pathlib import Path
import shutil

ROOT = Path(__file__).resolve().parent.parent
SOURCE = Path.home() / "Documents/SohaAli/Schedule"
DEST = ROOT / "Resources/Schedule"

FILES = [
    "weekly-timetable.html",
    "summer-2026-whiteboard.html",
    "science-bowl-prep.html",
    "periodic-table-study.html",
    "periodic-table-print.html",
]

def main() -> None:
    DEST.mkdir(parents=True, exist_ok=True)
    copied = 0
    for name in FILES:
        src = SOURCE / name
        if not src.exists():
            print(f"skip (missing): {src}")
            continue
        shutil.copy2(src, DEST / name)
        print(f"copied: {name}")
        copied += 1
    print(f"Done — {copied}/{len(FILES)} files in {DEST}")
    print("Run: python3 Scripts/generate_xcode_project.py && xcodebuild …")

if __name__ == "__main__":
    main()
