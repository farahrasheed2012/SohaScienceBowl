# Science Bowl Coach — Soha

Native SwiftUI iOS app for National Science Bowl (Middle School) prep in **Biology**, **Chemistry**, and **Physics**.

## Project location

```
/Users/farah/Documents/FarahRasheed/ScienceBowlCoach/
```

## Requirements

- Xcode 15+ (iOS 17+ deployment target)
- iPhone only (v1)

## Setup

1. Open `ScienceBowlCoach.xcodeproj` in Xcode.
2. *(Optional but recommended)* Download official DOE question PDFs:

```bash
python3 Scripts/download_doe_pdfs.py
```

3. Build and run on a simulator or device.

## Features

- **Today** — daily study blocks, 4-stage study session (Recall → Read → Know Cold → Toss-ups), buzzer drill schedule, Friday review
- **Quiz** — toss-up drill, topic quiz, mock rounds, DOE browse/drill, search, weak-area practice
- **Progress** — weekly/lifetime accuracy, checklist, flash cards, spaced repetition
- **Settings** — pass/week picker, parent-reads-aloud mode, session timer

## Data

- Curriculum seed data: Weeks 1–4 full, Weeks 5–8 Pass 2, Weeks 9–10 flash-card mode
- DOE PDFs parsed at first launch via PDFKit → cached in Documents as `doe_questions_cache.json`
- All progress stored locally in UserDefaults (no network, no accounts)

## Books referenced

FLS · CB · Mod · Tro · Expl — aligned with Soha's summer 2026 schedule.
