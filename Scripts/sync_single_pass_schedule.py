#!/usr/bin/env python3
"""Patch SohaAli schedule files for single-pass summer + sync HTML to ScienceBowlCoach."""

from __future__ import annotations

import re
import shutil
from pathlib import Path

SOHAAli = Path.home() / "Documents/SohaAli/Schedule"
APP_RESOURCES = Path(__file__).resolve().parent.parent / "Resources/Schedule"

WEEK_META = {
    5: ("Jul 6 – 10", "Energy in life & physics"),
    6: ("Jul 13 – 17", "Ecology & solutions"),
    7: ("Jul 20 – 24", "Immunity & momentum"),
    8: ("Jul 27 – 31", "Plants & electricity"),
    9: ("Aug 3 – 7", "Circuits & body systems"),
    10: ("Aug 10 – 14", "Summer capstone"),
}

# Science blocks Mon–Fri per week (book, chapter, title, focus snippet, formulas, know, tossup)
SCIENCE_WEEKS: dict[int, list[tuple]] = {
    5: [
        ("chem", "Mod Ch 7", "Chemical Bonding", "ionic vs covalent · NaCl vs H₂O · electronegativity intro",
         "ionic · covalent · NaCl · H₂O", "NaCl ionic or covalent? · O₂ bond type?", "Is NaCl ionic or covalent?"),
        ("bio", "OSB Ch 4", "Photosynthesis (part 1)", "chloroplast · light reactions · CO₂ + H₂O + light · finish Fri Ch 5",
         "6CO₂ + 6H₂O + light → glucose + O₂", "Photosynthesis organelle? · Gas released?", "Which organelle carries out photosynthesis?"),
        ("phys", "Expl Ch 6", "Work & Energy (part 1)", "W = Fd · KE = ½mv² · energy conservation intro",
         "W = Fd · KE = ½mv²", "10 N × 4 m → work? · Double speed → KE factor?", "10 N for 4 m — work done?"),
        ("chem", "Mod Ch 6", "Chemical Quantities", "mole · molar mass · Avogadro concept · percent composition intro",
         "mol · molar mass g/mol · n = m/M", "SI unit for amount? · H₂O molar mass ≈?", "SI unit for amount of substance?"),
        ("bio", "OSB Ch 5", "Cellular Respiration (part 2)", "mitochondria · aerobic respiration · compare to photosynthesis",
         "C₆H₁₂O₆ + 6O₂ → CO₂ + H₂O + ATP", "Respiration organelle? · Gas consumed?", "Main site of aerobic respiration?"),
    ],
    6: [
        ("chem", "Mod Ch 12 §", "Molarity & Dilution", "M = mol/L · M₁V₁ = M₂V₂ · saturated · electrolytes",
         "M = mol/L · M₁V₁ = M₂V₂", "Add solvent — concentration? · Molarity unit?", "Adding solvent — concentration up or down?"),
        ("bio", "OSB Ch 20", "Population Ecology (part 2)", "carrying capacity · logistic growth · succession",
         "carrying capacity · biotic vs abiotic", "Max population term? · Sunlight biotic or abiotic?", "Term for max population environment supports?"),
        ("phys", "Expl Ch 7", "Gravity & Projectiles", "W = mg · mass vs weight · PE = mgh · projectiles qualitatively",
         "W = mg · PE = mgh", "Moon — mass or weight changes? · Ball rises — PE?", "On Moon, mass, weight, or both different?"),
        ("chem", "Mod Ch 14 §", "Neutralization", "acid + base → salt + water · HCl + NaOH · titration concept",
         "HCl + NaOH → NaCl + H₂O", "HCl + NaOH products? · pH 11 acid or base?", "Products of HCl + NaOH?"),
        ("bio", "OSB Ch 13", "Bacteria & Viruses", "prokaryote · antibiotic vs antiviral · vaccines intro",
         "bacteria = prokaryote · antibiotic ≠ virus", "Antibiotic for virus? · Bacteria have nucleus?", "Can antibiotics treat viral infections?"),
    ],
    7: [
        ("chem", "Mod Ch 8 §", "Reaction Types (deeper)", "synthesis · decomposition · combustion · balance harder",
         "A + B → AB · AB → A + B", "2H₂O → 2H₂ + O₂ type? · Combustion needs?", "Classify 2H₂O → 2H₂ + O₂"),
        ("bio", "OSB Ch 17", "Immune System", "innate vs adaptive · B/T cells · memory · vaccines",
         "innate vs adaptive · memory cells", "Second infection milder why? · Innate barrier?", "Why is second infection often milder?"),
        ("phys", "Expl Ch 4–5", "Momentum & Collisions", "p = mv · conservation · elastic vs inelastic",
         "p = mv · conservation of momentum", "2 kg at 3 m/s momentum? · Truck vs bike at same v?", "2 kg at 3 m/s — momentum?"),
        ("chem", "Mod Ch 5 §", "Periodic Trends (deeper)", "ionization energy · electronegativity · halogen reactivity",
         "radius ↓ across period · F most reactive halogen", "Radius across period? · F or I more reactive?", "Atomic radius across period — increase or decrease?"),
        ("bio", "OSB Ch 14", "Plant Structure (part 1)", "root · stem · leaf · meristem · Fri = Ch 15 transport",
         "xylem · phloem · meristem", "Water-up tissue? · Meristem function?", "Vascular tissue transporting water upward?"),
    ],
    8: [
        ("chem", "Mod Ch 2 §", "Density & Unit Analysis", "d = m/V · sig figs · K = °C + 273 · percent error",
         "d = m/V · K = °C + 273", "Sig figs in 0.00450? · 25°C to K?", "Sig figs in 0.00450?"),
        ("bio", "OSB Ch 15", "Plant Transport (part 2)", "xylem up · phloem sugars · stomata · transpiration",
         "xylem · phloem · stomata", "Phloem transports? · Xylem direction?", "Vascular tissue for sugars in plants?"),
        ("phys", "Expl Ch 10", "Electricity — Current", "charge · V = IR · series vs parallel intro",
         "V = IR · A · V · Ω", "SI unit of current? · More resistors in series?", "SI unit of electric current?"),
        ("chem", "Mod Ch 10 §", "Heating Curves", "phase diagrams · plateau = phase change · physical vs chemical",
         "heating curve plateau", "Plateau meaning? · Melting ice physical or chemical?", "Flat plateau on heating curve?"),
        ("bio", "OSB Ch 18", "Animal Tissues", "epithelial · muscle · nervous · connective",
         "tissue types", "Contracting tissue? · Signal tissue?", "Tissue specialized for contraction?"),
    ],
    9: [
        ("chem", "Mod Ch 3 §", "Isotopes & Avg Atomic Mass", "isotopes · average atomic mass · nuclear notation",
         "Z · A · isotopes", "Isotopes differ in? · C-12 electrons?", "Isotopes differ in which particle?"),
        ("bio", "OSB Ch 6", "Cell Reproduction (intro)", "mitosis overview · diploid vs haploid intro",
         "mitosis → 2 cells", "Mitosis produces how many? · Used for growth?", "Daughter cells from one mitosis?"),
        ("phys", "Expl Ch 11–12", "Circuits & Waves (part 2)", "series/parallel · v = fλ · EM spectrum",
         "V = IR · v = fλ · ROYGBIV", "Higher pitch → frequency? · v = fλ relates?", "Higher pitch — higher or lower frequency?"),
        ("chem", "Mod Ch 5 + Ch 7", "Ions & Ionic Compounds", "Na⁺ Cl⁻ Ca²⁺ O²⁻ · polyatomic ions · formulas",
         "cation · anion · NaCl", "Oxide ion charge? · Na ion?", "Charge on oxide ion?"),
        ("bio", "OSB Ch 16 §", "Digestive & Circulatory", "small intestine absorption · heart · alveoli",
         "small intestine · artery · vein", "Most absorption where? · Veins toward heart?", "Most nutrient absorption organ?"),
    ],
    10: [
        ("chem", "Mod Review", "Chemistry capstone", "pick 2 weak Mod topics · know-cold · 8 toss-ups · Tro/BFN if stuck",
         "Z · pH · balance · M = mol/L", "pH water? · Symbol K?", "pH of neutral solution?"),
        ("bio", "OSB Review", "Biology capstone", "organelles · genetics · ecology · immunity · weak areas",
         "ATP · Punnett · symbiosis", "ATP organelle? · Tt×Tt ratio?", "Organelle producing most ATP?"),
        ("phys", "Expl Ch 13", "Electricity wrap-up", "magnetism intro · review V = IR · energy forms",
         "V = IR · PE · KE · v = fλ", "Unit of resistance? · PE converts to when falling?", "SI unit of resistance?"),
        ("chem", "Mod Review", "Lab & periodic table", "SI · sig figs · first 20 elements · safety",
         "kg · m · s · meniscus", "SI mass unit? · Precise volume glassware?", "SI base unit for mass?"),
        ("bio", "OSB Review", "Final bio check", "mock toss-ups · list 3 topics for school meetings",
         "producer · xylem · antibody", "Three symbiosis types? · Photosynthesis gas?", "Three types of symbiosis?"),
    ],
}

ALGEBRA_ROWS = {
    5: ["Lar Ch 5", "Lar Ch 6", "Lar Ch 6", "Lar Ch 5 §", "Lar Ch 6"],
    6: ["Lar Ch 12 §", "Lar Ch 4", "Lar Ch 7", "Lar Ch 14 §", "Lar Ch 2"],
    7: ["Lar Ch 8 §", "Lar Ch 9", "Lar Ch 4–5", "Lar Ch 9 §", "Lar Ch 10"],
    8: ["Lar Ch 2 §", "Lar Ch 11", "Lar Ch 10", "Lar Ch 10 §", "Lar Ch 20"],
    9: ["Lar Ch 3 §", "Lar Ch 8", "Lar Ch 11–12", "Lar Ch 5 + 7", "Lar Ch 16 §"],
    10: ["Lar Review", "Lar Review", "Lar Ch 13", "Lar Review", "Lar Review"],
}

COACH_ROWS = {
    5: ("Journey wk 5 · L3 (1–5)", "Tkinter · cipher · APIs"),
    6: ("Journey wk 6 · L3 (6–10)", "JSON · pygame · L3 capstone"),
    7: ("Journey wk 7 · L4 (1–5)", "OOP adventure · algorithms · pathfinding"),
    8: ("Journey wk 8 · L4 (6–10)", "ML · weather API · L4 grad"),
    9: ("Journey wk 9 · Portfolio (1–5)", "calculator · adventure · algo viz"),
    10: ("Journey wk 10 · Portfolio (6–10)", "GUI lab · sprint · graduation"),
}

REVIEW_ROWS = {
    5: "Photosynthesis + respiration · 10 toss-ups on cell energy",
    6: "Ecology + microbes drill · 15 toss-ups",
    7: "Plant structure · draw xylem/phloem path",
    8: "Electricity + waves · V = IR and v = fλ toss-ups",
    9: "Mixed drill · 20 toss-ups all categories",
    10: "Final summer mock · 25 toss-ups · list 3 topics for school meetings",
}

DATES = {
    5: ["Jul 6", "Jul 7", "Jul 8", "Jul 9", "Jul 10"],
    6: ["Jul 13", "Jul 14", "Jul 15", "Jul 16", "Jul 17"],
    7: ["Jul 20", "Jul 21", "Jul 22", "Jul 23", "Jul 24"],
    8: ["Jul 27", "Jul 28", "Jul 29", "Jul 30", "Jul 31"],
    9: ["Aug 3", "Aug 4", "Aug 5", "Aug 6", "Aug 7"],
    10: ["Aug 10", "Aug 11", "Aug 12", "Aug 13", "Aug 14"],
}

DAY_NAMES = ["Mon", "Tue", "Wed", "Thu", "Fri"]


def esc(s: str) -> str:
    return s.replace("&", "&amp;")


def html_cell(kind: str, book: str, title: str, focus: str, formulas: str, know: str, tossup: str) -> str:
    cls = {"chem": "chem", "bio": "bio", "phys": "phys"}.get(kind, "study-cell")
    backup = '<span class="optional-book"><em>Backup:</em> Tro · CB · BFN</span>' if kind != "phys" else ""
    return (
        f'<td class="{cls} study-cell">'
        f"<strong>{esc(book)}</strong> — {esc(title)}{backup}"
        f'<span class="formulas"><em>Formulas:</em> {esc(formulas)}</span>'
        f'<span class="focus"><em>Focus:</em> {esc(focus)}</span>'
        f'<span class="know"><em>Know:</em> {esc(know)}</span>'
        f'<span class="tossup"><em>Toss-up:</em> {esc(tossup)}</span>'
        f"</td>"
    )


def generate_whiteboard_week(week: int) -> str:
    dates, theme = WEEK_META[week]
    blocks = SCIENCE_WEEKS[week]
    alg = ALGEBRA_ROWS[week]
    coach_label, coach_focus = COACH_ROWS[week]
    date_list = DATES[week]

    rows = []
    for i, day in enumerate(DAY_NAMES):
        kind, book, title, focus, formulas, know, tossup = blocks[i]
        cell = html_cell(kind, book, title, focus, formulas, know, tossup)

        if day == "Mon":
            science = cell + "—" + "—"
            alg_cell = (
                f'<td class="alg study-cell"><strong>{alg[i]}</strong>'
                f'<span class="focus"><em>Focus:</em> 1 hr algebra · Larson · BFN-A backup</span></td>'
            )
            rows.append(
                f'    <tr><td class="date-col">{date_list[i]}</td><td class="day-col">{day}</td>'
                f"{science}{alg_cell}—</tr>"
            )
        elif day == "Tue":
            science = "—" + cell + "—"
            alg_cell = f'<td class="alg study-cell"><strong>{alg[i]}</strong></td>'
            py = (
                f'<td class="py study-cell"><strong>{coach_label}</strong>'
                f'<span class="focus"><em>Focus:</em> {coach_focus}</span></td>'
            )
            rows.append(
                f'    <tr><td class="date-col">{date_list[i]}</td><td class="day-col">{day}</td>'
                f"{science}{alg_cell}{py}—</tr>"
            )
        elif day == "Wed":
            science = "—" + "—" + cell
            alg_cell = f'<td class="alg study-cell"><strong>{alg[i]}</strong></td>'
            rows.append(
                f'    <tr><td class="date-col">{date_list[i]}</td><td class="day-col">{day}</td>'
                f"{science}{alg_cell}—</tr>"
            )
        elif day == "Thu":
            science = cell + "—" + "—"
            alg_cell = f'<td class="alg study-cell"><strong>{alg[i]}</strong></td>'
            py = (
                f'<td class="py study-cell"><strong>{coach_label}</strong>'
                f'<span class="focus"><em>Focus:</em> {coach_focus}</span></td>'
            )
            rows.append(
                f'    <tr><td class="date-col">{date_list[i]}</td><td class="day-col">{day}</td>'
                f"{science}{alg_cell}{py}—</tr>"
            )
        else:
            science = "—" + cell + "—"
            rows.append(
                f'    <tr><td class="date-col">{date_list[i]}</td><td class="day-col">{day}</td>'
                f'{science}<td class="free">Free block</td>—'
                f'<td class="review">{REVIEW_ROWS[week]}</td></tr>'
            )

    note = ""
    if week == 10:
        note = '  <p class="pass-note">Light capstone — review weak topics · flash-card drill at school meetings in fall.</p>\n'

    return f"""<!-- WEEK {week} -->
<section class="week" id="week-{week}">
  <div class="week-header">
    <h2>Week {week} · {dates} · {theme}</h2>
    <div class="week-meta"><span class="pass-tag">SUMMER · ONE PASS</span><br>Mod + OSB/FLS + Expl</div>
  </div>
{note}  <p class="pass-note">1-hr block: ~10 min recall → ~30 min read (one chapter/section) → ~10 min know cold → ~10 min toss-ups.</p>
  <table>
    <tr><th>Date</th><th>Day</th><th>Chemistry · Mod (+ Tro backup)</th><th>Biology · OSB/FLS</th><th>Physics · Expl</th><th>Algebra · Lar</th><th>Python · Coach<br><span style="font-weight:normal;text-transform:none">Tue/Thu 4:45–5:15</span></th><th>Fri review</th></tr>
{chr(10).join(rows)}
  </table>
</section>
"""


def generate_calendar_week_md(week: int) -> str:
    dates, theme = WEEK_META[week]
    blocks = SCIENCE_WEEKS[week]
    alg = ALGEBRA_ROWS[week]
    coach_label, coach_focus = COACH_ROWS[week]
    date_list = DATES[week]
    full_days = [
        f"Monday, {date_list[0]}",
        f"Tuesday, {date_list[1]}",
        f"Wednesday, {date_list[2]}",
        f"Thursday, {date_list[3]}",
        f"Friday, {date_list[4]}",
    ]
    lines = [
        f"### Week {week} · {dates} · {theme}",
        "",
        "*Each science block: **1 hour** — recall → read one chapter/section → know cold → toss-ups. Tro/CB/BFN = backup only.*",
        "",
    ]
    day_map = [(0, "Mon"), (1, "Tue"), (2, "Wed"), (3, "Thu"), (4, "Fri")]
    for idx, _ in day_map:
        lines.append(f"#### {full_days[idx]}")
        lines.append("")
        lines.append("| Block | Reading | Focus | Formulas & key terms | Know cold | Sample toss-ups |")
        lines.append("|-------|---------|-------|----------------------|-----------|-------------------|")
        kind, book, title, focus, formulas, know, tossup = blocks[idx]
        subj = {"chem": "Chem", "bio": "Bio", "phys": "Phys"}[kind]
        lines.append(
            f"| **{subj} · {book}** | *{title}* · backup Tro/CB/BFN | {focus} | {formulas} | {know} | 1. {tossup} |"
        )
        lines.append(
            f"| **Algebra · {alg[idx]}** | *Larson* · BFN-A backup | 1 hr algebra block | — | — | — |"
        )
        if idx in (1, 3):
            lines.append(
                f"| **Python · Coach** | {coach_label} | {coach_focus} | — | — | — |"
            )
        if idx == 4:
            lines.append("| **Free block** | 3:00 – 4:00 PM Fri bio done · algebra 4:00–5:00 | Rest or BFN catch-up | — | — | — |")
            lines.append(f"| **Review 4:40–5:40** | — | **{REVIEW_ROWS[week]}** | — | — | — |")
        lines.append("")
    lines.append("---")
    lines.append("")
    return "\n".join(lines)


def patch_whiteboard(path: Path) -> None:
    text = path.read_text()
    start = text.find("<!-- WEEK 5 -->")
    end = text.find("<!-- MASTER INDEX 1 -->")
    if start == -1 or end == -1:
        raise SystemExit(f"Could not find week 5 / index markers in {path}")
    new_weeks = "\n".join(generate_whiteboard_week(w) for w in range(5, 11))
    text = text[:start] + new_weeks + "\n\n" + text[end:]

    # Intro table — single pass
    text = re.sub(
        r"<tr><th>Pass</th>.*?</table>",
        """<tr><th>Plan</th><th>Dates</th><th>Chemistry</th><th>Biology</th><th>Physics</th><th>Python</th></tr>
    <tr><td><strong>One summer pass</strong></td><td>Jun 8 – Aug 14</td><td><strong>Mod</strong> + opt <strong>Expl</strong> chem</td><td><strong>FLS/OSB</strong> (+ CB backup)</td><td><strong>Expl</strong></td><td><strong>Coach</strong> wk 1–10</td></tr>
    <tr><td><strong>Backups</strong></td><td>anytime</td><td><strong>Tro</strong> · BFN-Sci</td><td><strong>CB</strong> · BFN-Bio</td><td>BFN-Sci</td><td>Quiz → DOE in app</td></tr>
    <tr><td><strong>Bridge</strong></td><td>Aug 15 – 18</td><td colspan="4">Optional flash cards · school meetings in fall · Aug 19 = first day of school</td></tr>
  </table>""",
        text,
        count=1,
        flags=re.DOTALL,
    )
    text = text.replace("Mod (P1) · Tro (P2–3)", "Mod primary · Tro backup")
    text = text.replace("FLS (P1) · CB (P2–3)", "FLS/OSB primary · CB backup")
    text = text.replace("Mon–Thu Algebra", "Mon–Fri Algebra")
    for w in range(1, 5):
        text = text.replace(f'<span class="pass-tag">PASS 1 · LEARN</span>', '<span class="pass-tag">SUMMER · ONE PASS</span>', 1)
        text = text.replace(f'<span class="pass-tag">PASS 1</span>', '<span class="pass-tag">SUMMER · ONE PASS</span>', 1)
    path.write_text(text)


def patch_calendar_md(path: Path) -> None:
    text = path.read_text()
    start = text.find("## PASS 2 —")
    end = text.find("## BRIDGE ·")
    if start == -1 or end == -1:
        raise SystemExit(f"Could not find PASS 2 / BRIDGE in {path}")

    new_section = """## WEEKS 5–10 — *Single summer pass continues* *(July 6 – August 14)*

*Same books as weeks 1–4: **Mod** + **OSB/FLS** + **Expl**. One careful read — section splits when chapters run long. **Tro/CB** and **BFN** are backups. Extra DOE practice → Science Bowl Coach **Quiz** tab. Flash-card review → **school meetings** in fall.*

"""
    new_section += "\n".join(generate_calendar_week_md(w) for w in range(5, 11))
    text = text[:start] + new_section + text[end:]

    replacements = [
        ("*(Pass 3 ends)*", "*(summer science ends)*"),
        ("Pass 3 is **2 weeks** instead of 3 — same topics, one less mid-review cycle. All foundation chapters still covered in Pass 1–2.",
         "**One summer pass** — 50 science blocks × 1 hr each. Each topic read once carefully; Tro/CB for backup; flash cards at school meetings."),
        ("Pass 2–3 bio · Jul–Aug", "CB backup · anytime"),
        ("Pass 2–3 chem · Jul–Aug", "Tro backup · anytime"),
        ("**Mod** (Pass 1) · **Tro** (Pass 2–3)", "**Mod** primary · **Tro** backup"),
        ("**FLS** (Pass 1) · **CB** (Pass 2–3)", "**FLS/OSB** primary · **CB** backup"),
        ("for Pass 2", "for extra practice"),
        ("Pick **2 weak subtopics** for Pass 2", "Log **2 weak subtopics** in app Progress"),
        ("for Pass 3", "for school meetings"),
        ("Pass 1–3 dates", "same 10-week calendar"),
        ("Pass 1–3", "one summer pass"),
    ]
    for old, new in replacements:
        text = text.replace(old, new)
    path.write_text(text)


def patch_weekly_timetable(path: Path) -> None:
    text = path.read_text()
    reps = [
        ("same **10-week Pass 1–3 schedule**", "same **10-week summer schedule**"),
        ("**Mod** (Pass 1) · **Tro** (Pass 2–3)", "**Mod** primary · **Tro** backup"),
        ("**FLS** (Pass 1) · **CB** (Pass 2–3)", "**FLS/OSB** primary · **CB** backup"),
        ("Pass 1–3", "one summer pass"),
    ]
    for old, new in reps:
        text = text.replace(old, new)
    path.write_text(text)


def patch_prep_md(path: Path) -> None:
    text = path.read_text()
    text = text.replace(
        "**Weeks 1–4** = Pass 1 *(Mod + FLS · learn from textbook)* · **Weeks 5–8** = Pass 2 *(Tro + CB · DOE questions first)* · **Weeks 9–10** = Pass 3 *(flash cards → book only if stuck)*",
        "**Weeks 1–10** = **one summer pass** *(Mod + FLS/OSB + Expl · one chapter/section per 1-hr block)* · **Tro/CB/BFN** = backups · **DOE drill** = app Quiz tab · **Flash cards** = school meetings in fall",
    )
    text = re.sub(
        r"## Pass 2 — Weeks 5–8.*?(?=## Pass 3|$)",
        "",
        text,
        flags=re.DOTALL,
    )
    text = re.sub(
        r"## Pass 3 — Weeks 9–10.*?(?=## |$)",
        "",
        text,
        flags=re.DOTALL,
    )
    for old, new in [
        ("Pass 2 *(Jul)*", "Tro backup"),
        ("Pass 1 *(Jun)*", "Mod primary"),
        ("| **Pass 2** |", "| **Backup** |"),
    ]:
        text = text.replace(old, new)
    path.write_text(text)


def patch_prep_html(path: Path) -> None:
    text = path.read_text()
    text = text.replace(
        "Weeks 1–4 = Pass 1 · Weeks 5–8 = Pass 2 · Weeks 9–10 = Pass 3",
        "Weeks 1–10 = one summer pass · Tro/CB backup · flash cards at school",
    )
    for w, (dates, theme) in WEEK_META.items():
        text = re.sub(
            rf"<span class=\"week-tag\">Week {w}</span>[^<]*",
            f'<span class="week-tag">Week {w}</span> {theme}',
            text,
            count=2,
        )
    path.write_text(text)


def patch_readme(path: Path) -> None:
    path.write_text("""# Soha — Schedule folder

## Summer 2026 — one pass (Jun 8 – Aug 14)

| File | Purpose |
|------|---------|
| **[weekly-timetable.md](weekly-timetable.md)** | **When** — 1 hr science + 1 hr algebra Mon–Fri |
| **[summer-2026-calendar.md](summer-2026-calendar.md)** | **What** — full daily reading, focus, toss-ups |
| **[summer-2026-whiteboard.html](summer-2026-whiteboard.html)** | Print grid · week jump in Science Bowl Coach Calendar tab |
| **[science-bowl-prep.md](science-bowl-prep.md)** | Books · study method · chapter maps |

**Plan:** One careful read through Mod + FLS/OSB + Expl (50 science blocks). Tro/CB/BFN = backups. DOE practice in the app. Flash-card review at school Science Bowl meetings.

Regenerate bundled HTML in the Mac app:

```bash
python3 /Users/farah/Documents/FarahRasheed/ScienceBowlCoach/Scripts/sync_schedule_html.py
```
""")


def sync_to_app() -> None:
    APP_RESOURCES.mkdir(parents=True, exist_ok=True)
    for name in [
        "weekly-timetable.html",
        "summer-2026-whiteboard.html",
        "science-bowl-prep.html",
        "periodic-table-study.html",
        "periodic-table-print.html",
    ]:
        src = SOHAAli / name
        if src.exists():
            shutil.copy2(src, APP_RESOURCES / name)
            print(f"  → app: {name}")


def main() -> None:
    print("Patching SohaAli schedule…")
    patch_whiteboard(SOHAAli / "summer-2026-whiteboard.html")
    patch_calendar_md(SOHAAli / "summer-2026-calendar.md")
    patch_weekly_timetable(SOHAAli / "weekly-timetable.md")
    patch_prep_md(SOHAAli / "science-bowl-prep.md")
    patch_prep_html(SOHAAli / "science-bowl-prep.html")
    patch_readme(SOHAAli / "README.md")
    print("Syncing HTML to ScienceBowlCoach…")
    sync_to_app()
    print("Done.")


if __name__ == "__main__":
    main()
