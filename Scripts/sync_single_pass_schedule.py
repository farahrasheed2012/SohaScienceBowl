#!/usr/bin/env python3
"""Patch SohaAli schedule files for single-pass summer + sync HTML to ScienceBowlCoach."""

from __future__ import annotations

import re
import shutil
from pathlib import Path

SOHAAli = Path.home() / "Documents/SohaAli/Schedule"
APP_RESOURCES = Path(__file__).resolve().parent.parent / "Resources/Schedule"

WEEK_META = {
    1: ("Jun 8 – 12", "Atoms · cells · motion"),
    2: ("Jun 15 – 19", "Matter · genetics · Newton's"),
    3: ("Jun 22 – 26", "Acids · ecology · forces"),
    4: ("Jun 29 – Jul 3", "Evolution · waves · periodic trends"),
    5: ("Jul 6 – 10", "Energy in life & physics"),
    6: ("Jul 13 – 17", "Ecology & solutions"),
    7: ("Jul 20 – 24", "Immunity & momentum"),
    8: ("Jul 27 – 31", "Plants & electricity"),
    9: ("Aug 3 – 7", "Circuits & body systems"),
    10: ("Aug 10 – 14", "Summer capstone"),
}

# Old 4-week rotation labels → remove from schedules
OLD_WEEK_THEME_REPLACEMENTS = [
    ("Foundations", "Atoms · cells · motion"),
    ("Building depth", "Matter · genetics · Newton's"),
    ("Mid-level mastery", "Acids · ecology · forces"),
    ("Round-ready", "Evolution · waves · periodic trends"),
    ("Foundations *(again · Tro/CB)*", "Energy in life & physics"),
    ("Foundations *(again)*", "Energy in life & physics"),
    ("Building depth *(again)*", "Ecology & solutions"),
    ("Mid-level mastery *(again)*", "Immunity & momentum"),
    ("Round-ready *(again)*", "Plants & electricity"),
    ("Final review (1 of 2)", "Circuits & body systems"),
    ("Final review (2 of 2)", "Summer capstone"),
]

DOE_TOPIC_SCOPE = """### DOE study topics ([Tips & Resources](https://science.osti.gov/wdts/nsb/Regional-Competitions/Resources/Tips-and-Resources))

| Area | Topics to study *(not whole textbooks)* |
|------|----------------------------------------|
| **Life Science** | Cell biology, genetics, anatomy & physiology, plant biology, ecology, animal behavior |
| **Physical Science** | **Chemistry:** reactions, periodic table, states of matter · **Physics:** forces, motion, waves, electromagnetism, thermodynamics |
| **Mathematics** | Algebra I & II, geometry, probability, statistics, number sense *(1-hr algebra block Mon–Fri)* |

Earth & Space and Energy are also official Rule 3-1 categories — use DOE sample questions when you specialize in those. Summer science blocks focus on **Life + Physical Science** above.

"""

BLOCK_WORKFLOW_NOTE = (
    "1-hr block: ~10 min recall → ~30 min read **assigned § section** (stop when Focus is covered) "
    "→ ~10 min know cold → ~10 min toss-ups."
)

DATES = {
    1: ["Jun 8", "Jun 9", "Jun 10", "Jun 11", "Jun 12"],
    2: ["Jun 15", "Jun 16", "Jun 17", "Jun 18", "Jun 19"],
    3: ["Jun 22", "Jun 23", "Jun 24", "Jun 25", "Jun 26"],
    4: ["Jun 29", "Jun 30", "Jul 1", "Jul 2", "Jul 3"],
    5: ["Jul 6", "Jul 7", "Jul 8", "Jul 9", "Jul 10"],
    6: ["Jul 13", "Jul 14", "Jul 15", "Jul 16", "Jul 17"],
    7: ["Jul 20", "Jul 21", "Jul 22", "Jul 23", "Jul 24"],
    8: ["Jul 27", "Jul 28", "Jul 29", "Jul 30", "Jul 31"],
    9: ["Aug 3", "Aug 4", "Aug 5", "Aug 6", "Aug 7"],
    10: ["Aug 10", "Aug 11", "Aug 12", "Aug 13", "Aug 14"],
}

REVIEW_ROWS = {
    1: "Plan next week — skim Week 2 · list 2 weak topics",
    2: "Timed drill · 20 toss-ups (Bio + Chem + Phys) · log misses",
    3: "Timed drill · 20 toss-ups · log misses by subject",
    4: "Mock round · 25 toss-ups · log weak subtopics",
    5: "Photosynthesis + respiration · 10 toss-ups on cell energy",
    6: "Ecology + microbes drill · 15 toss-ups",
    7: "Plant structure · draw xylem/phloem path",
    8: "Electricity + waves · V = IR and v = fλ toss-ups",
    9: "Mixed drill · 20 toss-ups all categories",
    10: "Final summer mock · 25 toss-ups · list 3 topics for school meetings",
}

ALGEBRA_ROWS = {
    1: ["Lar Ch 1", "Lar Ch 2", "Lar Ch 4", "Lar Ch 1–2", "Lar Ch 2"],
    2: ["Lar Ch 2", "Lar Ch 3", "Lar Ch 3", "Lar Ch 8 §", "Lar Ch 3"],
    3: ["Lar Ch 3", "Lar Ch 4", "Lar Ch 3", "Lar Ch 2", "Lar Ch 4"],
    4: ["Lar Ch 2", "Lar Ch 13", "Lar Ch 3", "Lar Ch 1–2", "Lar Ch 4"],
    5: ["Lar Ch 5", "Lar Ch 6", "Lar Ch 6", "Lar Ch 5 §", "Lar Ch 6"],
    6: ["Lar Ch 12 §", "Lar Ch 4", "Lar Ch 7", "Lar Ch 14 §", "Lar Ch 2"],
    7: ["Lar Ch 8 §", "Lar Ch 9", "Lar Ch 4–5", "Lar Ch 9 §", "Lar Ch 10"],
    8: ["Lar Ch 2 §", "Lar Ch 11", "Lar Ch 10", "Lar Ch 10 §", "Lar Ch 20"],
    9: ["Lar Ch 3 §", "Lar Ch 8", "Lar Ch 11–12", "Lar Ch 5 + 7", "Lar Ch 16 §"],
    10: ["Lar Review", "Lar Review", "Lar Ch 13", "Lar Review", "Lar Review"],
}

# Science blocks Mon–Fri per week (kind, book, title, focus, formulas, know, tossup)
# Weeks 1–4 aligned with ScienceBowlCoach SeedDataWeeks1_4.swift (OSB biology + section splits)
SCIENCE_WEEKS: dict[int, list[tuple]] = {
    1: [
        ("chem", "Mod Ch 3", "Atoms", "proton · neutron · electron · Z = # protons · A = p+n · isotopes",
         "Z = # protons · A = p + n", "17 protons → element? · C-12 electrons?", "Atomic number of atom with 15 protons?"),
        ("bio", "OSB Ch 3 §3.2–3.4", "Cell organelles & membrane", "nucleus · mitochondria → ATP · ribosomes · chloroplast · cell wall · pro/eukaryote",
         "ATP = energy currency", "ATP organelle? · 2 plant-only parts?", "Which organelle produces most ATP in eukaryotes?"),
        ("phys", "Expl Ch 1 + App. B", "About Science + motion", "hypothesis · SI units · v = d/t · d-t graphs",
         "v = d/t · slope = rise/run", "Theory vs law? · 120 km/2 h → speed?", "Car goes 150 km in 3 h — average speed?"),
        ("chem", "Mod Ch 5", "Periodic Law", "periods · groups · metals/nonmetals · H₂O, CO₂, NaCl · ions intro",
         "Na → Na⁺ + e⁻ · Group 18 noble gases", "Noble gas group? · CO₂ formula?", "Which group contains the noble gases?"),
        ("bio", "OSB Ch 1 §1.1", "Levels of organization", "cell → tissue → organ → system · specialization",
         "Levels of organization", "Order: organ, cell, tissue, organism?", "Simplest → most complex: organ, cell, tissue, organism."),
    ],
    2: [
        ("chem", "Mod Ch 10", "States of matter", "solid/liquid/gas · particle model · phase changes · heating curve",
         "Solid ↔ liquid ↔ gas", "Gas vs solid particle motion?", "Which state has fastest-moving particles?"),
        ("bio", "OSB Ch 8 §8.1–8.2 (part 1)", "DNA & genes", "DNA · gene · chromosome · allele · dominant/recessive",
         "Tt × Tt → 3:1", "Tt × Tt phenotype ratio?", "What molecule carries genetic information?"),
        ("phys", "Expl Ch 2 (part 1)", "Newton's 1st & 2nd", "inertia · F = ma · friction intro",
         "F = ma · a = F/m", "F=20 N, m=4 kg → a?", "4 kg object at 5 m/s² — net force?"),
        ("chem", "Mod Ch 8", "Chemical reactions", "balance equations · reactants → products · exo/endothermic",
         "2H₂ + O₂ → 2H₂O", "Balance H₂ + Cl₂ → HCl", "Balance: H₂ + Cl₂ → HCl."),
        ("bio", "OSB Ch 8 §8.2–8.3 (part 2)", "Punnett squares", "genotype vs phenotype · Tt × Tt · homozygous vs heterozygous",
         "Tt × Tt → 3:1", "Dominant: capital or lowercase?", "Tt × Tt expected phenotypic ratio?"),
    ],
    3: [
        ("chem", "Mod Ch 14", "Acids & bases", "pH 0–14 · neutral = 7 · H⁺/OH⁻ · common acids/bases",
         "pH < 7 acid · pH > 7 base", "pH of pure water? · pH 3 acid or base?", "pH of neutral solution at 25°C?"),
        ("bio", "OSB Ch 19 §19.1 (part 1)", "Ecology — communities", "producers · consumers · decomposers · symbiosis",
         "mutualism · commensalism · parasitism", "3 symbiosis types?", "Organism at base of food chain?"),
        ("phys", "Expl Ch 3 (part 2)", "Newton's 3rd & friction", "action-reaction · friction · net force",
         "F = ma · action-reaction pairs", "Newton's 3rd in words?", "Earth pulls you down — you pull Earth which way?"),
        ("chem", "Mod Ch 12", "Solutions", "solvent/solute · saturation · filtration · distillation",
         "solute in solvent", "Salt water — solute?", "In salt water, which is the solute?"),
        ("bio", "OSB Ch 16 §16.1–16.3", "Body systems", "levers · heart · arteries/veins · lungs O₂/CO₂",
         "fulcrum · effort · load", "3 lever parts?", "Arteries carry blood toward or away from heart?"),
    ],
    4: [
        ("chem", "Mod Ch 5 §3 + Ch 4", "Periodic trends + electrons", "valence e⁻ · atomic radius · first 20 symbols",
         "radius ↓ across period", "Symbol for K? · Na vs Cl larger?", "Chemical symbol for potassium?"),
        ("bio", "OSB Ch 11 (part 1)", "Evolution — natural selection", "natural selection · variation · adaptation · fossils",
         "Darwin · natural selection", "Scientist for natural selection?", "Who is associated with natural selection?"),
        ("phys", "Expl Ch 12 (part 1)", "Waves & sound", "λ · f · amplitude · v = fλ · reflection/refraction",
         "v = fλ", "Higher pitch → frequency?", "Higher pitch — higher or lower frequency?"),
        ("chem", "Mod Ch 2", "Lab & measurement", "SI units · sig figs · graduated cylinder · safety",
         "kg, m, s, mol", "SI mass unit? · Precise volume glassware?", "SI base unit for mass?"),
        ("bio", "OSB Ch 12 (part 2)", "Classification & taxonomy", "Domain → Kingdom → Species · binomial names",
         "Homo sapiens", "Most specific taxonomic rank?", "Most specific classification level?"),
    ],
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

DAY_NAMES = ["Mon", "Tue", "Wed", "Thu", "Fri"]
EMPTY_TD = "<td>—</td>"

# Tue/Thu Coach sessions differ in weeks 1–4; weeks 5–10 reuse the same label both days.
COACH_ROWS = {
    1: {
        "tue": ("Journey wk 1 · L1 (1–2)", "Hello Python · variables · if/else"),
        "thu": ("Journey wk 1 · L1 (3–5)", "loops · functions · first games"),
    },
    2: {
        "tue": ("Journey wk 2 · L1 (6–7)", "lists · Science Quiz · pygame"),
        "thu": ("Journey wk 2 · L1 (8–10)", "Final Boss · Flask · grad prep"),
    },
    3: {
        "tue": ("Journey wk 3 · L2 (1–2)", "try/except · Caesar cipher"),
        "thu": ("Journey wk 3 · L2 (3–5)", "OOP · APIs · weather app"),
    },
    4: {
        "tue": ("Journey wk 4 · L2 (6–7)", "Pandas · Matplotlib"),
        "thu": ("Journey wk 4 · L2 (8–10)", "lambda · sklearn · L2 grad"),
    },
    5: {
        "tue": ("Journey wk 5 · L3 (1–5)", "Tkinter · cipher · APIs"),
        "thu": ("Journey wk 5 · L3 (1–5)", "Tkinter · cipher · APIs"),
    },
    6: {
        "tue": ("Journey wk 6 · L3 (6–10)", "JSON · pygame · L3 capstone"),
        "thu": ("Journey wk 6 · L3 (6–10)", "JSON · pygame · L3 capstone"),
    },
    7: {
        "tue": ("Journey wk 7 · L4 (1–5)", "OOP adventure · algorithms · pathfinding"),
        "thu": ("Journey wk 7 · L4 (1–5)", "OOP adventure · algorithms · pathfinding"),
    },
    8: {
        "tue": ("Journey wk 8 · L4 (6–10)", "ML · weather API · L4 grad"),
        "thu": ("Journey wk 8 · L4 (6–10)", "ML · weather API · L4 grad"),
    },
    9: {
        "tue": ("Journey wk 9 · Portfolio (1–5)", "calculator · adventure · algo viz"),
        "thu": ("Journey wk 9 · Portfolio (1–5)", "calculator · adventure · algo viz"),
    },
    10: {
        "tue": ("Journey wk 10 · Portfolio (6–10)", "GUI lab · sprint · graduation"),
        "thu": ("Journey wk 10 · Portfolio (6–10)", "GUI lab · sprint · graduation"),
    },
}

COMMON_PASS_REPLACEMENTS = [
    ("Pass 1 bio · Jun", "OSB/FLS primary · Jun–Aug"),
    ("Pass 2–3 bio · Jul–Aug", "CB backup · anytime"),
    ("Pass 1 chem · Jun", "Mod primary · Jun–Aug"),
    ("Pass 2–3 chem · Jul–Aug", "Tro backup · anytime"),
    ("**FLS** (Pass 1) · **CB** (Pass 2–3)", "**OSB/FLS** primary · **CB** backup"),
    ("**Mod** (Pass 1) · **Tro** (Pass 2–3)", "**Mod** primary · **Tro** backup"),
    ("Mod (P1) · Tro (P2–3)", "Mod primary · Tro backup"),
    ("FLS (P1) · CB (P2–3)", "OSB/FLS primary · CB backup"),
    ("**FLS** (P1) · **CB** (P2–3)", "**OSB/FLS** primary · **CB** backup"),
    ("**Mod** (P1) · **Tro** (P2–3)", "**Mod** primary · **Tro** backup"),
    ("Pass 1–3", "one summer pass"),
    ("Pass 1–2", "weeks 1–10"),
    ("Book key & pass overview", "Book key & DOE topic scope"),
    ("Focus on Life Science (FLS) — Pass 1", "OpenStax Biology (OSB) + FLS — primary"),
    ("Modern Chemistry (Mod) — Pass 1", "Modern Chemistry (Mod) — primary"),
    ("Campbell Biology (CB) — Pass 2–3", "Campbell Biology (CB) — backup"),
    ("Introductory Chemistry (Tro) — Pass 2–3", "Introductory Chemistry (Tro) — backup"),
]


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


def apply_common_replacements(text: str) -> str:
    for old, new in COMMON_PASS_REPLACEMENTS:
        text = text.replace(old, new)
    return text


def coach_cell(week: int, day: str) -> str:
    key = "tue" if day == "Tue" else "thu"
    label, focus = COACH_ROWS[week][key]
    return (
        f'<td class="py study-cell"><strong>{esc(label)}</strong>'
        f'<span class="focus"><em>Focus:</em> {esc(focus)}</span></td>'
    )


def generate_whiteboard_week(week: int) -> str:
    dates, theme = WEEK_META[week]
    blocks = SCIENCE_WEEKS[week]
    alg = ALGEBRA_ROWS[week]
    date_list = DATES[week]

    rows = []
    for i, day in enumerate(DAY_NAMES):
        kind, book, title, focus, formulas, know, tossup = blocks[i]
        cell = html_cell(kind, book, title, focus, formulas, know, tossup)
        alg_cell = (
            f'<td class="alg study-cell"><strong>{esc(alg[i])}</strong>'
            f'<span class="focus"><em>Focus:</em> 1 hr algebra · Larson · BFN-A backup</span></td>'
        )

        if day == "Mon":
            rows.append(
                f'    <tr><td class="date-col">{date_list[i]}</td><td class="day-col">{day}</td>'
                f"{cell}{EMPTY_TD}{EMPTY_TD}{alg_cell}{EMPTY_TD}{EMPTY_TD}</tr>"
            )
        elif day == "Tue":
            rows.append(
                f'    <tr><td class="date-col">{date_list[i]}</td><td class="day-col">{day}</td>'
                f"{EMPTY_TD}{cell}{EMPTY_TD}{alg_cell}{coach_cell(week, day)}{EMPTY_TD}</tr>"
            )
        elif day == "Wed":
            rows.append(
                f'    <tr><td class="date-col">{date_list[i]}</td><td class="day-col">{day}</td>'
                f"{EMPTY_TD}{EMPTY_TD}{cell}{alg_cell}{EMPTY_TD}{EMPTY_TD}</tr>"
            )
        elif day == "Thu":
            rows.append(
                f'    <tr><td class="date-col">{date_list[i]}</td><td class="day-col">{day}</td>'
                f"{cell}{EMPTY_TD}{EMPTY_TD}{alg_cell}{coach_cell(week, day)}{EMPTY_TD}</tr>"
            )
        else:
            rows.append(
                f'    <tr><td class="date-col">{date_list[i]}</td><td class="day-col">{day}</td>'
                f"{EMPTY_TD}{cell}{EMPTY_TD}"
                f'<td class="free">Free block</td>{EMPTY_TD}'
                f'<td class="review">{esc(REVIEW_ROWS[week])}</td></tr>'
            )

    note = ""
    if week == 10:
        note = f'  <p class="pass-note">{BLOCK_WORKFLOW_NOTE} Light capstone — review weak topics · flash-card drill at school meetings in fall.</p>\n'
    else:
        note = f'  <p class="pass-note">{BLOCK_WORKFLOW_NOTE}</p>\n'

    footer = ""
    if week == 4:
        footer = '\n  <p class="footer">Jul 4 weekend — Off.</p>'

    return f"""<!-- WEEK {week} -->
<section class="week" id="week-{week}">
  <div class="week-header">
    <h2>Week {week} · {dates} · {theme}</h2>
    <div class="week-meta"><span class="pass-tag">SUMMER · ONE PASS</span><br>Mod + OSB/FLS + Expl</div>
  </div>
{note}  <table>
    <tr><th>Date</th><th>Day</th><th>Chemistry · Mod (+ Tro backup)</th><th>Biology · OSB/FLS</th><th>Physics · Expl</th><th>Algebra · Lar</th><th>Python · Coach<br><span style="font-weight:normal;text-transform:none">Tue/Thu 4:45–5:15</span></th><th>Fri review</th></tr>
{chr(10).join(rows)}
  </table>{footer}
</section>
"""


def generate_calendar_week_md(week: int) -> str:
    dates, theme = WEEK_META[week]
    blocks = SCIENCE_WEEKS[week]
    alg = ALGEBRA_ROWS[week]
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
        "*Each science block: **1 hour** — recall → read assigned **§ section** (stop at Focus) → know cold → toss-ups. Tro/CB/BFN = backup only.*",
        "",
    ]
    for idx in range(5):
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
        if idx == 1:
            label, focus_txt = COACH_ROWS[week]["tue"]
            lines.append(f"| **Python · Coach** | {label} | {focus_txt} | — | — | — |")
        elif idx == 3:
            label, focus_txt = COACH_ROWS[week]["thu"]
            lines.append(f"| **Python · Coach** | {label} | {focus_txt} | — | — | — |")
        if idx == 4:
            lines.append("| **Free block** | 3:00 – 4:00 PM Fri bio done · algebra 4:00–5:00 | Rest or BFN catch-up | — | — | — |")
            lines.append(f"| **Review 4:40–5:40** | — | **{REVIEW_ROWS[week]}** | — | — | — |")
        lines.append("")
    lines.append("---")
    lines.append("")
    return "\n".join(lines)


def patch_whiteboard_legend(text: str) -> str:
    text = re.sub(
        r"<h2>Book key &amp; pass overview</h2>",
        "<h2>Book key &amp; DOE topic scope</h2>",
        text,
        count=1,
    )
    legend_table = """  <table>
    <tr><th>Code</th><th>Book</th><th>When</th></tr>
    <tr><td><strong>OSB</strong></td><td>OpenStax Biology 2e — free online (openstax.org)</td><td>Primary biology · Tue &amp; Fri</td></tr>
    <tr><td><strong>FLS</strong></td><td>Focus on Life Science — Prentice Hall CA ed. (ISBN 9780130443465)</td><td>Biology backup · same DOE topics</td></tr>
    <tr><td><strong>CB</strong></td><td>Campbell Biology: Concepts &amp; Connections — 7th ed. (ISBN 9780321696816)</td><td>Biology backup · deeper TAG level</td></tr>
    <tr><td><strong>Mod</strong></td><td>Modern Chemistry 2012 — Sarquis (ISBN 9780547586632)</td><td>Primary chemistry · Mon &amp; Thu</td></tr>
    <tr><td><strong>Tro</strong></td><td>Introductory Chemistry — Tro 4th ed. (ISBN 9780321687937)</td><td>Chemistry backup</td></tr>
    <tr><td><strong>Expl</strong></td><td>Conceptual Physical Science Explorations — student text (ISBN 9780321567918)</td><td>Wed physics · optional chem Expl Ch 17–24</td></tr>
    <tr><td><strong>Lar</strong></td><td>Holt McDougal Larson Algebra 1 2011 (ISBN 9780547315157)</td><td>Algebra Mon–Fri · Ch 1–13</td></tr>
    <tr><td><strong>BFN-A/Bio/Sci</strong></td><td>Big Fat Notebooks — Algebra · Biology · Science</td><td>Backup quizzes · Fri review</td></tr>
    <tr><td><strong>Coach</strong></td><td>Soha Python Coach — Mac app (Outschool L1–4 + portfolio)</td><td>Tue/Thu 4:45–5:15 PM · Journey tab</td></tr>
  </table>"""
    text = re.sub(
        r"<section class=\"week legend-page\">.*?<!-- WEEK 1 -->",
        f"<section class=\"week legend-page\">\n  <div class=\"week-header\">\n    <h2>Book key &amp; DOE topic scope</h2>\n    <div class=\"week-meta\">Summer 2026 · Soha<br>Jun 8 – Aug 19</div>\n  </div>\n{legend_table}\n  <h3 style=\"font-size:9pt;margin:0.15in 0 0.08in\">DOE study topics (not whole textbooks)</h3>\n  <p style=\"font-size:8pt;margin:0 0 0.1in\">Life: cell biology, genetics, anatomy &amp; physiology, plant biology, ecology, animal behavior · Physical: chem reactions/periodic table/states of matter + physics forces/motion/waves/electromagnetism/thermo · Math: algebra, geometry, probability, statistics (Lar block).</p>\n  <h3 style=\"font-size:9pt;margin:0.15in 0 0.08in\">Pick your book *(Soha)*</h3>\n  <table style=\"font-size:8pt\">\n    <tr><th>When</th><th>Primary</th><th>Also OK</th><th>Backup</th></tr>\n    <tr><td>Mon/Thu Chem</td><td><strong>Mod</strong></td><td><strong>Expl</strong> Ch 17–24 optional</td><td><strong>Tro</strong> · <strong>BFN-Sci</strong></td></tr>\n    <tr><td>Tue/Fri Bio</td><td><strong>OSB/FLS</strong></td><td>—</td><td><strong>CB</strong> · <strong>BFN-Bio</strong></td></tr>\n    <tr><td>Wed Phys</td><td><strong>Expl</strong></td><td>—</td><td><strong>BFN-Sci</strong></td></tr>\n    <tr><td>Mon–Fri Algebra</td><td><strong>Lar</strong></td><td>—</td><td><strong>BFN-A</strong></td></tr>\n    <tr><td>Tue/Thu Python</td><td><strong>Coach</strong> Journey week</td><td>—</td><td>Playground + live notes</td></tr>\n  </table>\n  <table style=\"margin-top:0.2in\">\n    <tr><th>Plan</th><th>Dates</th><th>Chemistry</th><th>Biology</th><th>Physics</th><th>Python</th></tr>\n    <tr><td><strong>One summer pass</strong></td><td>Jun 8 – Aug 14</td><td><strong>Mod</strong> + opt <strong>Expl</strong> chem</td><td><strong>OSB/FLS</strong> (+ CB backup)</td><td><strong>Expl</strong></td><td><strong>Coach</strong> wk 1–10</td></tr>\n    <tr><td><strong>Backups</strong></td><td>anytime</td><td><strong>Tro</strong> · BFN-Sci</td><td><strong>CB</strong> · BFN-Bio</td><td>BFN-Sci</td><td>Quiz → DOE in app</td></tr>\n    <tr><td><strong>Bridge</strong></td><td>Aug 15 – 18</td><td colspan=\"4\">Optional flash cards · school meetings in fall · Aug 19 = first day of school</td></tr>\n  </table>\n  <p class=\"footer\">Each cell: read assigned <strong>§ section</strong> only · <strong>Formulas</strong> · <strong>Focus</strong> · <strong>Know</strong> · <strong>Toss-up</strong> · Full detail + answers in summer-2026-calendar.md · Daily times → weekly-timetable.md</p>\n</section>\n\n<!-- WEEK 1 -->",
        text,
        count=1,
        flags=re.DOTALL,
    )
    return apply_common_replacements(text)


def patch_whiteboard_master_index(text: str) -> str:
    return text.replace("(Pass 2)", "(wk 6–7)")


def patch_whiteboard(path: Path) -> None:
    text = path.read_text()
    start = text.find("<!-- WEEK 1 -->")
    end = text.find("<!-- MASTER INDEX 1 -->")
    if start == -1 or end == -1:
        raise SystemExit(f"Could not find week 1 / index markers in {path}")
    new_weeks = "\n".join(generate_whiteboard_week(w) for w in range(1, 11))
    text = text[:start] + new_weeks + "\n\n" + text[end:]
    text = patch_whiteboard_legend(text)
    text = patch_whiteboard_master_index(text)
    text = apply_common_replacements(text)
    path.write_text(text)


def patch_calendar_books_section(text: str) -> str:
    text = re.sub(
        r"## Your books \*\*\(editions you own\)\*\*\n\n\| Code \| Book \| ISBN \| When \|\n\|[-| ]+\|\n(?:\| \*\*[^|]+\*\* \|[^\n]+\n)+",
        """## Your books *(editions you own)*

| Code | Book | ISBN | When |
|------|------|------|------|
| **OSB** | *OpenStax Biology 2e* — free online | openstax.org | Primary bio · Tue & Fri |
| **FLS** | *Focus on Life Science* — Prentice Hall California ed. (2001) | 9780130443465 | Biology backup · same DOE topics |
| **CB** | *Campbell Biology: Concepts & Connections* — **7th ed.** | 9780321696816 | Biology backup · anytime |
| **Mod** | *Modern Chemistry* — Sarquis **Student Edition 2012** | 9780547586632 | Primary chem · Mon & Thu |
| **Tro** | *Introductory Chemistry* — Tro **4th ed.** | 9780321687937 | Chemistry backup · anytime |
| **Expl** | *Conceptual Physical Science Explorations* — Hewitt **student text** | 9780321567918 | Wed **physics** · optional **chem** Expl Ch 17–24 Mon/Thu |
| **ExplLab** | *Explorations: Laboratory Manual* *(optional hands-on)* | 9780321051837 | Wed labs when you want |
| **Lar** | *Holt McDougal Larson Algebra 1* — **2011** | 9780547315157 | Algebra Mon–Fri |
| **BFN-A** | *Big Fat Notebook: Pre-Algebra & Algebra* | 9781523504382 | Algebra backup · CYK quizzes |
| **BFN-Bio** | *Big Fat Notebook: Biology* (HS) | 9781523504367 | Fri review · quick bio recall |
| **BFN-Sci** | *Big Fat Notebook: Science* (MS) | 9780761160957 | Fri review · chem/phys recall |
| **Coach** | *Soha Python Coach* — Mac app (Outschool L1–4 + portfolio) | — | **Tue/Thu 4:45–5:15 PM** · Journey tab · 50 sessions in 10 cal weeks |
""",
        text,
        count=1,
    )
    for old, new in [
        ("| **FLS** | *Focus on Life Science* — Prentice Hall California ed. (2001) | 9780130443465 | Pass 1 bio · Jun |",
         "| **FLS** | *Focus on Life Science* — Prentice Hall California ed. (2001) | 9780130443465 | Biology backup · same DOE topics |"),
        ("| **CB** | *Campbell Biology: Concepts & Connections* — **7th ed.** | 9780321696816 | CB backup · anytime |",
         "| **CB** | *Campbell Biology: Concepts & Connections* — **7th ed.** | 9780321696816 | Biology backup · anytime |"),
        ("| **Mod** | *Modern Chemistry* — Sarquis **Student Edition 2012** | 9780547586632 | Pass 1 chem · Jun |",
         "| **Mod** | *Modern Chemistry* — Sarquis **Student Edition 2012** | 9780547586632 | Primary chem · Mon & Thu |"),
        ("| **Tro** | *Introductory Chemistry* — Tro **4th ed.** | 9780321687937 | Tro backup · anytime |",
         "| **Tro** | *Introductory Chemistry* — Tro **4th ed.** | 9780321687937 | Chemistry backup · anytime |"),
        ("| **Mon** | Chemistry | **Mod** (P1) · **Tro** (P2–3) | **Expl** Ch 17–24 *(optional skim)* | **BFN-Sci** |",
         "| **Mon** | Chemistry | **Mod** primary | **Expl** Ch 17–24 *(optional skim)* | **Tro** · **BFN-Sci** |"),
        ("| **Tue** | Biology | **FLS** (P1) · **CB** (P2–3) | — | **BFN-Bio** |",
         "| **Tue** | Biology | **OSB/FLS** primary | — | **CB** · **BFN-Bio** |"),
        ("| **Thu** | Chemistry | **Mod** (P1) · **Tro** (P2–3) | **Expl** Ch 17–24 *(optional skim)* | **BFN-Sci** |",
         "| **Thu** | Chemistry | **Mod** primary | **Expl** Ch 17–24 *(optional skim)* | **Tro** · **BFN-Sci** |"),
        ("| **Fri** | Biology | **FLS** (P1) · **CB** (P2–3) | — | **BFN-Bio** |",
         "| **Fri** | Biology | **OSB/FLS** primary | — | **CB** · **BFN-Bio** |"),
        ("| **Mon–Thu** | Algebra | **Lar** | — | **BFN-A** |",
         "| **Mon–Fri** | Algebra | **Lar** | — | **BFN-A** |"),
    ]:
        text = text.replace(old, new)
    text = re.sub(
        r"### Which book each pass\n\n\| Pass \| Dates.*?\n\n---",
        """### One summer pass — books by block

| Block | Chemistry | Biology | Physics | Python |
|-------|-----------|---------|---------|--------|
| **Mon/Thu** | **Mod** (+ optional Expl chem) | — | — | — |
| **Tue/Fri** | — | **OSB/FLS** (+ CB backup) | — | — |
| **Wed** | — | — | **Expl** | — |
| **Mon–Fri** | — | — | — | **Lar** algebra |
| **Tue/Thu PM** | — | — | — | **Coach** Journey wk 1–10 |

Study **DOE Tips & Resources topics** only — assigned **§ sections**, not whole textbooks. Tro/CB/BFN = backups. Extra DOE → Science Bowl Coach **Quiz** tab. Flash cards → school meetings in fall.

---""",
        text,
        count=1,
        flags=re.DOTALL,
    )
    return apply_common_replacements(text)


def patch_calendar_md(path: Path) -> None:
    text = path.read_text()
    start = text.find("## PASS 1 —")
    end = text.find("## BRIDGE ·")
    if start != -1 and end != -1:
        new_section = """## WEEKS 1–10 — *Single summer pass* *(June 8 – August 14)*

*One careful read through **Mod + OSB/FLS + Expl** (50 × 1-hr science blocks). Read assigned **§ sections** for each DOE topic — stop when Focus is covered. **Tro/CB/BFN** = backups. Extra DOE practice → Science Bowl Coach **Quiz** tab. Flash-card review → **school meetings** in fall.*

"""
        new_section += "\n".join(generate_calendar_week_md(w) for w in range(1, 11))
        text = text[:start] + new_section + text[end:]

    text = patch_calendar_books_section(text)
    text = text.replace("*(Pass 2)*", "*(wk 6–7)*")
    text = text.replace("*(stretch Pass 1 wk 4)*", "*(wk 4, 8)*")
    text = text.replace("— Pass 1 biology", "— primary biology")
    text = apply_common_replacements(text)
    path.write_text(text)


def patch_weekly_timetable(path: Path) -> None:
    text = path.read_text()
    if "DOE study topics" not in text:
        insert_at = text.find("---\n\n## Every day includes")
        if insert_at != -1:
            text = text[:insert_at] + "\n" + DOE_TOPIC_SCOPE + text[insert_at:]
    reps = [
        ("same **10-week Pass 1–3 schedule**", "same **10-week summer schedule**"),
        ("**Mod** (Pass 1) · **Tro** (Pass 2–3)", "**Mod** primary · **Tro** backup"),
        ("**FLS** (Pass 1) · **CB** (Pass 2–3)", "**OSB/FLS** primary · **CB** backup"),
        ("Pass 1–3", "one summer pass"),
        ("| **Mon–Thu** | Algebra | **Lar** | — | **BFN-A** |",
         "| **Mon–Fri** | Algebra | **Lar** | — | **BFN-A** |"),
        ("**All books on shelf:** FLS · CB · Mod",
         "**All books on shelf:** OSB · FLS · CB · Mod"),
    ]
    for old, new in reps:
        text = text.replace(old, new)
    text = apply_common_replacements(text)
    path.write_text(text)


def patch_weekly_html(path: Path) -> None:
    if not path.exists():
        return
    text = path.read_text()
    reps = [
        ("Pass 1–3", "one summer pass"),
        ("Pass 1 · Pass 2 · Pass 3", "one summer pass"),
        ("Weeks 1–4 = Pass 1", "Weeks 1–10 = one summer pass"),
        ("FLS (P1) · CB (P2–3)", "OSB/FLS primary · CB backup"),
        ("Mod (P1) · Tro (P2–3)", "Mod primary · Tro backup"),
        ("Book key & pass overview", "Book key & DOE topic scope"),
        ("one chapter in one day", "assigned § section per block"),
        ("whole chapter", "assigned § section"),
    ]
    for old, new in reps:
        text = text.replace(old, new)
    text = apply_common_replacements(text)
    path.write_text(text)


def patch_all_week_titles(text: str, *, html_h2: bool = False) -> str:
    """Replace old rotation labels (Foundations, Building depth, …) with topic-based week names."""
    for w, (dates, theme) in WEEK_META.items():
        if html_h2:
            # Full h2 replacement avoids duplicate partial rewrites
            short_dates = dates  # e.g. Jun 8 – 12
            text = re.sub(
                rf"<h2>Week {w} · [^<]+</h2>",
                f"<h2>Week {w} · {short_dates} · {theme}</h2>",
                text,
                count=1,
            )
        else:
            text = re.sub(
                rf"(### Week {w} · .+? · )[^\n]+",
                rf"\1{theme}",
                text,
                count=1,
            )
            text = re.sub(
                rf"(### Week {w} — )[^\n]+",
                rf"\1{theme}",
                text,
                count=1,
            )
    for old, new in OLD_WEEK_THEME_REPLACEMENTS:
        text = text.replace(old, new)
    return text


def patch_whiteboard_week_titles(path: Path) -> None:
    text = patch_all_week_titles(path.read_text(), html_h2=True)
    path.write_text(text)


def patch_calendar_week_titles(path: Path) -> None:
    text = patch_all_week_titles(path.read_text())
    path.write_text(text)


def patch_prep_md(path: Path) -> None:
    text = path.read_text()
    if "### DOE study topics" not in text:
        marker = "## How this fits your schedule"
        if marker in text:
            text = text.replace(marker, DOE_TOPIC_SCOPE + marker, 1)

    text = text.replace(
        "**Weeks 1–4** = Pass 1 *(Mod + FLS · learn from textbook)* · **Weeks 5–8** = Pass 2 *(Tro + CB · DOE questions first)* · **Weeks 9–10** = Pass 3 *(flash cards → book only if stuck)*",
        "**Weeks 1–10** = **one summer pass** *(Mod + OSB/FLS + Expl · assigned § section per 1-hr block)* · **Tro/CB/BFN** = backups · **DOE drill** = app Quiz tab · **Flash cards** = school meetings in fall",
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
    text = re.sub(
        r"## Pass 2 deep-dives — Weeks 5–8.*?(?=## Pass 3|$)",
        "",
        text,
        flags=re.DOTALL,
    )
    text = re.sub(
        r"## Pass 3 deep-dives — Weeks 9–10.*?(?=## |$)",
        "",
        text,
        flags=re.DOTALL,
    )
    text = re.sub(
        r"\| Code \| Book \| ISBN \| When to use \|\n\|[-| ]+\|\n(?:\| \*\*[^|]+\*\* \|[^\n]+\n)+",
        """| Code | Book | ISBN | When to use |
|------|------|------|-------------|
| **OSB** | *OpenStax Biology 2e* — free online | openstax.org | **Primary** biology · Tue & Fri |
| **FLS** | *Focus on Life Science* — Prentice Hall **California ed. (2001)** | 9780130443465 | Biology **backup** · same DOE topics |
| **CB** | *Campbell Biology: Concepts & Connections* — **7th ed.** | 9780321696816 | Biology **backup** · deeper TAG level |
| **Mod** | *Modern Chemistry* — Sarquis **Student Edition 2012** | 9780547586632 | **Primary** chemistry · Mon & Thu |
| **Tro** | *Introductory Chemistry* — Nivaldo Tro **4th ed.** | 9780321687937 | Chemistry **backup** |
| **Expl** | *Conceptual Physical Science Explorations* — Hewitt **student text** | 9780321567918 | Wed **physics** · optional **chem** parallel Mon/Thu *(Ch 17–24)* |
| **ExplLab** | *Explorations: Laboratory Manual* | 9780321051837 | Optional Wed labs |
| **Lar** | *Holt McDougal Larson Algebra 1* — **2011** | 9780547315157 | Mon–Fri Algebra · 1 hr |
| **BFN-A** | *Big Fat Notebook: Pre-Algebra & Algebra* | 9781523504382 | Algebra backup · CYK |
| **BFN-Bio** | *Big Fat Notebook: Biology* (HS) | 9781523504367 | Fri review · bio recall |
| **BFN-Sci** | *Big Fat Notebook: Science* (MS) | 9780761160957 | Fri review · chem/phys recall |
""",
        text,
        count=1,
    )

    text = re.sub(
        r"### How the science books work together\n\n\| Pass \| Dates.*?\n\n\*\*30-min block:\*\*.*?\n\n\*\*Best workflow:\*\*.*?\n\n### Physics — one book, two passes\n\n\| Stage \| Book \| What changes in Pass 2 \|\n\|[-| ]+\|\n(?:\| \*\*Pass [^\n]+\n){3}",
        """### How the science books work together

| Block | Biology | Chemistry | Physics |
|-------|---------|-----------|---------|
| **Mon/Thu** | — | **Mod** primary (+ optional Expl chem) | — |
| **Tue/Fri** | **OSB/FLS** primary (+ CB backup) | — | — |
| **Wed** | — | — | **Expl** |

**1-hr block:** read assigned **§ section** for the DOE topic → know cold → toss-ups. Tro/CB/BFN = backups only.

**Best workflow:** [DOE past questions](https://science.osti.gov/wdts/nsb/Regional-Competitions) → miss one → read that section → retry · extra drill in Science Bowl Coach **Quiz** tab.

### Physics — one book, one summer pass

| Stage | Book | Notes |
|-------|------|-------|
| **Weeks 1–10** | **Expl** Ch 1 · App. B · 2–4 · 6–7 · 10–13 | Section splits when chapters run long · stop at Focus |
| **Backups** | **BFN-Sci** · flash cards | Use if Expl section feels dense · school meetings in fall |
""",
        text,
        count=1,
        flags=re.DOTALL,
    )

    text = text.replace("*(Pass 2)*", "*(wk 6–7)*")
    text = text.replace("*(stretch Pass 1 wk 4)*", "*(wk 4, 8)*")
    text = text.replace("*(Pass 2)*", "*(wk 7)*")

    prep_reps = [
        ("| **Science** | 30 min · Mon–Fri | Life + Physical sciences | **150 min** |",
         "| **Science** | **1 hr** · Mon–Fri | Life + Physical sciences (DOE topics · § sections) | **250 min** |"),
        ("| **Algebra 1** | 30 min · daily | *School curriculum* — not a separate NSB category for you | 150 min |",
         "| **Algebra 1** | **1 hr** · Mon–Fri | Algebra I/II · geometry · probability · statistics (DOE math topics) | **250 min** |"),
        ("| **Physical sciences** | Physics | Wednesday | 30 min |",
         "| **Physical sciences** | Physics | Wednesday | **60 min** |"),
        ("| **Mon** | Chemistry | 10:00 – 10:30 AM | Physical sciences |",
         "| **Mon** | Chemistry | 10:00 – 11:00 AM | Physical sciences |"),
        ("| **Tue** | Biology | 10:00 – 10:30 AM | Life sciences |",
         "| **Tue** | Biology | 10:00 – 11:00 AM | Life sciences |"),
        ("| **Wed** | Physics | 3:00 – 3:30 PM | Physical sciences |",
         "| **Wed** | Physics | 3:00 – 4:00 PM | Physical sciences |"),
        ("| **Thu** | Chemistry *(deeper / new unit)* | 11:00 – 11:30 AM | Physical sciences |",
         "| **Thu** | Chemistry *(deeper / new unit)* | 11:00 – 12:00 PM | Physical sciences |"),
        ("| **Fri** | Biology *(deeper / new unit)* | 3:00 – 3:30 PM | Life sciences |",
         "| **Fri** | Biology *(deeper / new unit)* | 3:00 – 4:00 PM | Life sciences |"),
        ("## What to do in each 30-min science block",
         "## What to do in each 1-hr science block"),
        ("**Pass difficulty:** Pass 1 = learn from textbook · Pass 2 = DOE regional-style questions first · Pass 3 = flash cards only unless stuck.",
         "**Summer plan:** One pass through DOE **Tips & Resources** topics — read assigned **§ sections** only (not whole textbooks). Tro/CB/BFN = backups. Extra DOE → app Quiz tab. Flash cards at school meetings."),
        ("**Mod** (Pass 1) and **Tro** (Pass 2) stay **primary**",
         "**Mod** is **primary** chemistry · **Tro** is **backup**"),
        ("| **Mon** | Chemistry | **Mod** (Pass 1) · **Tro** (Pass 2–3) |",
         "| **Mon** | Chemistry | **Mod** primary |"),
        ("| **Tue** | Biology | **FLS** (Pass 1) · **CB** (Pass 2–3) |",
         "| **Tue** | Biology | **OSB/FLS** primary |"),
        ("| **Thu** | Chemistry | **Mod** (Pass 1) · **Tro** (Pass 2–3) |",
         "| **Thu** | Chemistry | **Mod** primary |"),
        ("| **Fri** | Biology | **FLS** (Pass 1) · **CB** (Pass 2–3) |",
         "| **Fri** | Biology | **OSB/FLS** primary |"),
        ("pick **2 weak subtopics** for Pass 2", "log **2 weak subtopics** in app Progress"),
        ("for Pass 3", "for school meetings"),
        ("Pass 2: re-read only the Tro/CB/Expl section you missed on DOE",
         "Backup: re-read Tro/CB/Expl section only if stuck on a topic"),
        ("**Pass 2 level-up on Expl:**", "**Expl physics stretch topics:**"),
        ("| **Pass 1 — Mod** | **Pass 2 — Tro** |",
         "| **Mod (primary)** | **Tro (backup)** |"),
        ("*Expl chapters *(all passes — your student text)*",
         "*Expl chapters *(summer pass — your student text)*"),
        ("One **primary** book per 30-min block.",
         "One **primary** book per **1-hr** block — assigned **§ section** only."),
        ("Pass 3: if you open the book more than twice in one block, that topic stays on flash cards through fall",
         "Flash cards: if you need the book more than twice on one topic, keep it on cards through fall school meetings"),
    ]
    for old, new in prep_reps:
        text = text.replace(old, new)

    text = apply_common_replacements(text)
    text = patch_all_week_titles(text)
    path.write_text(text)


def patch_prep_html(path: Path) -> None:
    text = path.read_text()
    text = text.replace(
        "Weeks 1–4 = Pass 1 · Weeks 5–8 = Pass 2 · Weeks 9–10 = Pass 3",
        "Weeks 1–10 = one summer pass · Tro/CB backup · flash cards at school",
    )
    html_reps = [
        ("30-min science block", "1-hr science block"),
        ("30 min science", "1 hr science"),
        ("Pass 1 = learn", "One summer pass — DOE topics"),
        ("Pass 2 = DOE", "Extra DOE → Quiz tab"),
        ("Pass 3 = flash", "Flash cards at school"),
        ("whole chapter", "assigned § section"),
        ("one chapter in one day", "assigned § section per block"),
        ("FLS (Pass 1)", "OSB/FLS primary"),
        ("CB (Pass 2–3)", "CB backup"),
        ("Mod (Pass 1)", "Mod primary"),
        ("Tro (Pass 2–3)", "Tro backup"),
    ]
    for old, new in html_reps:
        text = text.replace(old, new)
    for w, (_dates, theme) in WEEK_META.items():
        text = re.sub(
            rf'(<span class="week-tag">Week {w}</span>)[^<\n]*',
            rf'\1 {theme}',
            text,
        )
    text = apply_common_replacements(text)
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
    patch_whiteboard_week_titles(SOHAAli / "summer-2026-whiteboard.html")
    patch_calendar_md(SOHAAli / "summer-2026-calendar.md")
    patch_calendar_week_titles(SOHAAli / "summer-2026-calendar.md")
    patch_weekly_timetable(SOHAAli / "weekly-timetable.md")
    patch_weekly_html(SOHAAli / "weekly-timetable.html")
    patch_prep_md(SOHAAli / "science-bowl-prep.md")
    patch_prep_html(SOHAAli / "science-bowl-prep.html")
    patch_readme(SOHAAli / "README.md")
    print("Syncing HTML to ScienceBowlCoach…")
    sync_to_app()
    print("Done.")


if __name__ == "__main__":
    main()
