# Soha Apps — Mini-Games Roadmap (Science Bowl Coach + TossUp)

Saved plan for future implementation. **Middle-school NSB prep** — not InayaStudyApp (see `../InayaStudyApp/docs/GAMES_ROADMAP_TIER_2_3.md` for elementary games).

**Apps:**
- **Science Bowl Coach** — `/Users/farah/Documents/FarahRasheed/ScienceBowlCoach/`
- **TossUp** — `/Users/farah/Documents/FarahRasheed/TossUp/`

Shared visual DNA: dark game theme, subject colors, XP/streak (`DesignSystem.swift` in each repo). Implement each game in **both** codebases unless noted.

---

## Design principles

- Native **SwiftUI only** — no external dependencies.
- Some pure fun, some sneaky science — all replayable in 1–5 minutes.
- Reuse existing drill / flash-card / buzzer infrastructure where possible.
- Fastest path: tap a chip → you're playing.

---

## Tier A — Build first (highest fun-to-effort) ✅ Shipped

All five mini-games are live in **Science Bowl Coach** (Quiz → Mini-Games hub) and **TossUp** (Drill tab).

### 1. Science Wordle ⭐ Top pick

**Why:** Pure SwiftUI grid, NSB vocab word bank, no custom assets, completely replayable, familiar format. Every guess drills terminology.

| | |
|---|---|
| **Science** | Vocabulary from encyclopedia topics, glossary terms, element names |
| **UI** | 5–6 letter grid, color feedback (correct spot / wrong spot / absent) |
| **Data** | Word bank from `EncyclopediaStore` / `NSBTopic` glossary; curated list per subject |
| **Reuse** | New view; optional tie-in to weak topics |
| **Effort** | Medium — grid + validation logic; no drag assets |

**Science Bowl Coach hooks:** `Views/Encyclopedia/`, `Services/EncyclopediaStore.swift`, `Models/NSBTopic.swift`  
**TossUp hooks:** `Data/TopicCatalog.swift`, `Services/QuestionBank.swift` (term extraction)

---

### 2. True or False Blitz

**Why:** Fastest to build — ~80% reuse of buzzer drill. Swipe or tap true/false instead of typed/buzzer answer.

| | |
|---|---|
| **Science** | Quick fact checks from MC questions stripped to T/F statements |
| **UI** | One statement, swipe right = true / left = false (or two big buttons) |
| **Reuse** | `BuzzerDrillComponents.swift`, `TossupDrillView` / `QuizSessionView` feedback flow |
| **Effort** | Low |

**Science Bowl Coach:** `Views/Shared/BuzzerDrillComponents.swift`, `Views/Quiz/TossupDrillView.swift`, `Views/Shared/DrillFeedbackViews.swift`  
**TossUp:** `Helpers/BuzzerDrillComponents.swift`, `Views/QuizSessionView.swift`

---

### 3. Element Blitz

**Why:** 90-second chemistry reset on hard days. Flash-card mechanics exist — swap to countdown + rapid-fire mode.

| | |
|---|---|
| **Science** | Symbol ↔ name ↔ atomic number |
| **UI** | Timer bar, card flip or prompt/answer, streak counter |
| **Reuse** | `FlashCardItem`, element flash cards route, `ElementProgressStore`, periodic table data |
| **Effort** | Low–medium |

**Science Bowl Coach:** `Models/FlashCardItem.swift`, `Models/ElementData.swift`, `Services/ElementProgressStore.swift`, `Views/PeriodicTable/`, Today → element flash cards  
**TossUp:** Add element subset or link to shared JSON if extracted later

---

### 4. Molecule Match (memory / flip)

**Why:** Pure fun, zero science pressure — mental reset after a hard session. Pairs: formula ↔ name, or structure emoji ↔ compound.

| | |
|---|---|
| **Science** | Light — optional “learn” sheet after match |
| **UI** | Classic memory grid, flip animation |
| **Reuse** | Grid layout patterns from flash cards; `DesignSystem` cards |
| **Effort** | Low |

**Content examples:** H₂O / Water, CO₂ / Carbon dioxide, NaCl / Salt, O₂ / Oxygen

---

## Tier B — Build second (higher payoff, more work)

### 5. Cell Builder ✅

**Why:** iReady-style drag-and-drop; feels like a “real” learning game. Worth the investment.

| | |
|---|---|
| **Science** | Organelles → correct region of cell diagram (plant vs animal) |
| **UI** | `DragGesture` + drop zones on cell diagram asset |
| **Reuse** | Custom drag-drop; encyclopedia life-science topics |
| **Effort** | High — diagram asset, hit testing, validation rules |

**Needs:** Cell diagram asset (SF Symbols collage or simple vector); organelle label bank for MS level.

---

### 6. Science Wordle — ongoing content

Same as Tier A #1 — listed again in original notes as “most replayable.” Prioritize **daily word** + **subject-themed weeks** (Bio week, Chem week) after MVP ships.

---

## Recommended implementation order

1. **True or False Blitz** — ship in a day; validates “Games” entry in nav  
2. **Element Blitz** — chemistry days; reuses flash cards  
3. **Science Wordle** — highest long-term replay value  
4. **Molecule Match** — fun break between study blocks  
5. **Cell Builder** — when drag-drop pattern is proven  

---

## Where games live in the app (proposed)

### Science Bowl Coach

Add **Games** section under Quiz tab or new sidebar item:

```
Quiz
  ├── Toss-up drill (existing)
  ├── …
  └── Mini-Games
        ├── Science Wordle
        ├── True or False Blitz
        ├── Element Blitz
        ├── Molecule Match
        └── Cell Builder (later)
```

Entry from **Today** as “90-second reset” chips on heavy days.

### TossUp

Add **Games** sub-section under **Drill** tab (or 5th tab if it grows):

- Same five games, leaner nav (4-tab structure preserved).
- Question/term source: bundled `topics.json` + parsed PDF metadata.

---

## Per-game implementation checklist

- [x] Game view (`Views/Games/<Name>GameView.swift`)
- [x] Content catalog / word bank (`Data/` or extract from encyclopedia)
- [x] Navigation route (`StudyNavigationRoute` / TossUp equivalent)
- [x] XP + streak hook (`XPManager.swift`) — optional points per session
- [x] Register in `project.pbxproj` / `generate_xcode_project.py` (Coach)
- [x] macOS + iOS layout (`PlatformCompatibility.swift`)
- [ ] TTS optional for Wordle hints (Settings parity)

---

## Explicitly not in scope here

- InayaStudyApp elementary games (map, Sparky, Tier 1–3)
- Narrative / town-builder / collection meta-games
- Network multiplayer

---

## Existing code to reuse (quick reference)

| Feature | Science Bowl Coach | TossUp |
|---------|-------------------|--------|
| Buzzer UI | `Views/Shared/BuzzerDrillComponents.swift` | `Helpers/BuzzerDrillComponents.swift` |
| Drill session | `Views/Quiz/TossupDrillView.swift` | `Views/QuizSessionView.swift` |
| Flash cards | `Models/FlashCardItem.swift`, Progress dashboard | — (add or share) |
| Elements | `Models/ElementData.swift`, `ElementProgressStore` | Periodic table TBD |
| XP / streak | `Services/XPManager.swift` | `Services/XPManager.swift` |
| Design tokens | `Views/Shared/DesignSystem.swift` | `Helpers/DesignSystem.swift` |
| UX spec | `../TossUp/CURSOR_PROMPT_ScienceBowlCoach_UX_Redesign.md` | `CURSOR_PROMPT_TossUp_UX_Redesign.md` |

---

## Next step when implementing

**Option A:** Full Cursor prompt per game (copy-paste implementation spec).  
**Option B:** Fully spec **top 3–4** first (Wordle, T/F Blitz, Element Blitz, Molecule Match), then Cursor prompts.

Recommended: **Option B** — spec top 4, implement in Coach first, port to TossUp.

---

## Original game menu (brainstorm)

| Game | Tier | Notes |
|------|------|-------|
| Science Wordle | A | Top pick |
| True or False Blitz | A | Fastest build |
| Element Blitz | A | Chemistry reset |
| Molecule Match | A | Pure fun memory |
| Cell Builder | B | Drag-drop, highest learning-game feel |

---

*Last updated: June 2026 — all five mini-games shipped in Coach + TossUp.*
