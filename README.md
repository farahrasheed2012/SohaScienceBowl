# Science Bowl Coach — Soha

Native SwiftUI app for National Science Bowl (Middle School) prep in **Biology**, **Chemistry**, and **Physics**.

## Project location

```
/Users/farah/Documents/FarahRasheed/ScienceBowlCoach/
```

## Requirements

- Xcode 15+ (iOS 17+ · macOS 14+)
- **Mac** (native sidebar app, large window) or **iPhone/iPad**

## Setup

1. Open `ScienceBowlCoach.xcodeproj` in Xcode.
2. *(Optional but recommended)* Download official DOE question PDFs:

```bash
python3 Scripts/download_doe_pdfs.py
```

3. Build and run:
   - **Mac (recommended):** choose **My Mac** as the run destination → **Run** (⌘R). Opens a native Mac app with sidebar navigation (~1280×840), not an iPhone window.
   - **iPhone/iPad:** choose a simulator or device → **Run**

### Run from Terminal (Mac)

```bash
cd /Users/farah/Documents/FarahRasheed/ScienceBowlCoach
python3 Scripts/generate_xcode_project.py
xcodebuild -scheme ScienceBowlCoach -destination 'platform=macOS' -configuration Debug build
open ~/Library/Developer/Xcode/DerivedData/ScienceBowlCoach-*/Build/Products/Debug/ScienceBowlCoach.app
```

**Important:** If the app still looks like an iPhone in a small window, you are running the iOS build. Select run destination **My Mac** (not an iPhone simulator). Clean build folder (⇧⌘K) and rebuild.

## Features

- **Today** — daily study blocks, 4-stage study session (Recall → Read → Know Cold → Toss-ups), **1 hr science + 1 hr algebra**, buzzer drill schedule, Friday review
- **Calendar** — weekly timetable, 10-week whiteboard, prep guide, and periodic table (bundled HTML; sync with `python3 Scripts/sync_single_pass_schedule.py`)
- **Learn** — 124 NSB encyclopedia topics (6 categories) with full articles, related topics, MC/Toss-up/Free-response practice; badges show topics missing drills; `make verify` checks reading + question coverage
- **Quiz** — toss-up drill, topic quiz, mock rounds, DOE browse/drill (toss-up + bonus mock), encyclopedia practice, **Texas Regional Sprint** (11 packs), search, weak-area practice
- **Progress** — weekly/lifetime accuracy, checklist, flash cards with spaced repetition, spaced-review pace setting
- **Settings** — week picker, **read-aloud TTS** (auto-read, voice, student name, MC choices), parent-reads-aloud mode, session timer, DOE PDF download

### Speech (Settings → Speech & review)

Turn on **Read questions aloud** for TTS across toss-up drill, plan/buzzer drill, DOE mock (toss-up + bonus), study session, MathCounts, encyclopedia, mental math, flash cards, and regional sprint previews. Set **Student name** for personalized praise, pick a **Voice**, and choose **Flash card review pace** (normal / quick / long retention). Mac: **Space** replays; iPhone/iPad: **Replay** button.

## Data

- **One summer plan** — 50 science blocks; **DOE Tips & Resources topics** (Life Science · Physical Science) — not whole textbooks; algebra block covers DOE Math topics
- Encyclopedia: 124 topics + 182 practice questions (includes 11 Regional Sprint articles)
- DOE PDFs parsed at first launch via PDFKit → cached in Documents as `doe_questions_cache.json`
- All progress stored locally in UserDefaults (no network, no accounts)

## Books referenced

FLS · Hewitt (Expl) · Mod · Tro · OSB · CB — summer schedule books; **reading checkboxes** track **NSB-scheduled FLS + Hewitt sections only** (not entire books).
