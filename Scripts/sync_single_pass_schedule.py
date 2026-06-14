#!/usr/bin/env python3
"""Patch SohaAli schedule files for single-pass summer + sync HTML to ScienceBowlCoach."""

from __future__ import annotations

import re
import shutil
import sys
from pathlib import Path

_SCRIPTS = Path(__file__).resolve().parent
if str(_SCRIPTS) not in sys.path:
    sys.path.insert(0, str(_SCRIPTS))

from bfn_catalog import (  # noqa: E402
    format_algebra_backup,
    format_bio_backup,
    format_chem_backup,
    format_phys_backup,
)
from fls_toc_data import FLS_PRIMARY  # noqa: E402

SOHAAli = Path.home() / "Documents/SohaAli/Schedule"
APP_RESOURCES = Path(__file__).resolve().parent.parent / "Resources/Schedule"

WEEK_META = {
    1: ("Jun 8 – 12", "Atoms · cells · motion"),
    2: ("Jun 15 – 19", "Matter · genetics · Newton's"),
    3: ("Jun 22 – 26", "Solutions · ecology · forces"),
    4: ("Jun 29 – Jul 3", "Evolution · the atom · momentum"),
    5: ("Jul 6 – 10", "Energy in life & physics"),
    6: ("Jul 13 – 17", "Ecology & solutions"),
    7: ("Jul 20 – 24", "Immunity & heat"),
    8: ("Jul 27 – 31", "Plants & electricity"),
    9: ("Aug 3 – 7", "Magnetism · waves · body systems"),
    10: ("Aug 10 – 14", "Summer capstone"),
}

# Old 4-week rotation labels → remove from schedules
OLD_WEEK_THEME_REPLACEMENTS = [
    ("Foundations", "Atoms · cells · motion"),
    ("Building depth", "Matter · genetics · Newton's"),
    ("Mid-level mastery", "Acids · ecology · forces"),
    ("Round-ready", "Evolution · the atom · momentum"),
    ("Foundations *(again · Tro/CB)*", "Energy in life & physics"),
    ("Foundations *(again)*", "Energy in life & physics"),
    ("Building depth *(again)*", "Ecology & solutions"),
    ("Mid-level mastery *(again)*", "Immunity & heat"),
    ("Round-ready *(again)*", "Plants & electricity"),
    ("Circuits & body systems", "Magnetism · waves · body systems"),
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

# Mirrors ScheduleOpenStaxCatalog.mathByWeekDay — (title, section_keys, lar_backup)
OSA_MATH: dict[int, list[tuple[str, list[str], str]]] = {
    1: [
        ("Scientific notation", ["1.1", "1.2"], "Lar Ch 1 · BFN-A U4"),
        ("Ratios", ["5.8"], "Lar Ch 2 · BFN-A U3"),
        ("Graphs & slope", ["2.1", "4.1", "3.3"], "Lar Ch 4 · BFN-A U6"),
        ("Unit conversion", ["1.1", "1.2"], "Lar Ch 1–2 · BFN-A U2"),
        ("PEMDAS & estimation", ["1.1"], "Lar Ch 2 · BFN-A U1"),
    ],
    2: [
        ("Percent", ["1.1"], "Lar Ch 2 · BFN-A U3"),
        ("Proportions", ["5.8"], "Lar Ch 3 · BFN-A U3"),
        ("F = ma", ["2.3"], "Lar Ch 3 · BFN-A U5"),
        ("Exponents", ["1.2", "6.1"], "Lar Ch 8 · BFN-A U4"),
        ("Body-scale ratios", ["5.8"], "Lar Ch 3 · BFN-A U3"),
    ],
    3: [
        ("Formula substitution", ["2.3"], "Lar Ch 3 · BFN-A U5"),
        ("Graph reading", ["2.1", "3.3"], "Lar Ch 4 · BFN-A U6"),
        ("W = Fd", ["2.3"], "Lar Ch 3 · BFN-A U5"),
        ("Concentration ratios", ["5.8"], "Lar Ch 2 · BFN-A U3"),
        ("Mixed review", ["1.2", "5.8", "2.3"], "Lar Ch 1–4 · BFN-A"),
    ],
    4: [
        ("Number review", ["1.1"], "Lar Ch 2 · BFN-A U2"),
        ("Logic & probability", ["13.7"], "Lar Ch 13 · BFN-A U7"),
        ("v = fλ", ["2.3", "1.3"], "Lar Ch 3 + Ch 11 · BFN-A U11"),
        ("Unit conversion review", ["1.1", "1.2"], "Lar Ch 1–2 · BFN-A U2"),
        ("Formula plug-in", ["2.3"], "Lar Ch 3 · BFN-A U5"),
    ],
    5: [
        ("Scientific notation", ["1.1", "1.2"], "Lar Ch 1 · BFN-A U4"),
        ("Ratios", ["5.8"], "Lar Ch 2 · BFN-A U3"),
        ("Graphs & slope", ["2.1", "4.1", "3.3"], "Lar Ch 4 · BFN-A U6"),
        ("Unit conversion", ["1.1", "1.2"], "Lar Ch 1–2 · BFN-A U2"),
        ("PEMDAS & estimation", ["1.1"], "Lar Ch 2 · BFN-A U1"),
    ],
    6: [
        ("Percent", ["1.1"], "Lar Ch 2 · BFN-A U3"),
        ("Proportions", ["5.8"], "Lar Ch 3 · BFN-A U3"),
        ("F = ma", ["2.3"], "Lar Ch 3 · BFN-A U5"),
        ("Exponents", ["1.2", "6.1"], "Lar Ch 8 · BFN-A U4"),
        ("Body-scale ratios", ["5.8"], "Lar Ch 3 · BFN-A U3"),
    ],
    7: [
        ("Formula substitution", ["2.3"], "Lar Ch 3 · BFN-A U5"),
        ("Graph reading", ["2.1", "3.3"], "Lar Ch 4 · BFN-A U6"),
        ("W = Fd", ["2.3"], "Lar Ch 3 · BFN-A U5"),
        ("Concentration ratios", ["5.8"], "Lar Ch 2 · BFN-A U3"),
        ("Mixed review", ["1.2", "5.8", "2.3"], "Lar Ch 1–4 · BFN-A"),
    ],
    8: [
        ("Number review", ["1.1"], "Lar Ch 2 · BFN-A U2"),
        ("Logic & probability", ["13.7"], "Lar Ch 13 · BFN-A U7"),
        ("v = fλ", ["2.3", "1.3"], "Lar Ch 3 + Ch 11 · BFN-A U11"),
        ("Unit conversion review", ["1.1", "1.2"], "Lar Ch 1–2 · BFN-A U2"),
        ("Formula plug-in", ["2.3"], "Lar Ch 3 · BFN-A U5"),
    ],
    9: [
        ("Scientific notation", ["1.2"], "Lar Ch 1 · BFN-A U4"),
        ("Ratios", ["5.8"], "Lar Ch 2 · BFN-A U3"),
        ("Graphs", ["2.1", "3.3"], "Lar Ch 4 · BFN-A U6"),
        ("Unit conversion", ["1.1", "1.2"], "Lar Ch 1–2 · BFN-A U2"),
        ("Flash review", ["1.2", "5.8"], "Lar Ch 1–4 · BFN-A"),
    ],
    10: [
        ("Formula substitution", ["2.3"], "Lar Ch 3 · BFN-A U5"),
        ("Graph reading", ["2.1", "3.3"], "Lar Ch 4 · BFN-A U6"),
        ("W = Fd", ["2.3"], "Lar Ch 3 · BFN-A U5"),
        ("Concentration ratios", ["5.8"], "Lar Ch 2 · BFN-A U3"),
        ("Final review", ["home"], "Lar Ch 1–13 · BFN-A"),
    ],
}


def format_osa_sections(section_keys: list[str]) -> str:
    if section_keys == ["home"]:
        return "review"
    if len(section_keys) == 1:
        return f"§{section_keys[0]}"
    if len(section_keys) == 2:
        ch0, sub0 = section_keys[0].split(".", 1)
        ch1, sub1 = section_keys[1].split(".", 1)
        if ch0 == ch1:
            return f"§{ch0}.{sub0}–{sub1}"
    return " · ".join(f"§{key}" for key in section_keys)


def osa_math_reading(week: int, day_idx: int) -> tuple[str, list[str], str]:
    return OSA_MATH[week][day_idx]


def format_osa_algebra_primary(week: int, day_idx: int) -> str:
    title, sections, _ = osa_math_reading(week, day_idx)
    return f"OSA {format_osa_sections(sections)} — {title}"


def algebra_html_cell(week: int, day_idx: int) -> str:
    primary = format_osa_algebra_primary(week, day_idx)
    title, _, lar_part = osa_math_reading(week, day_idx)
    backup = format_algebra_backup(week, day_idx, title, lar_part)
    return (
        f'<td class="alg study-cell">'
        f"<strong>{esc(primary)}</strong>"
        f'<span class="optional-book"><em>Backup:</em> {esc(backup)}</span>'
        f'<span class="focus"><em>Focus:</em> 1 hr algebra · assigned § only</span>'
        f"</td>"
    )

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
        ("chem", "Mod Ch 7", "Chemical bonding (part 1)", "electron-dot · ions · ionic/metallic bonds · NaCl",
         "Na → Na⁺ + e⁻ · ionic = metal + nonmetal", "NaCl ionic or covalent? · Metal loses e⁻ → cation?", "Is NaCl ionic or covalent?"),
        ("bio", "OSB Ch 8 §8.2–8.3 (part 2)", "Punnett squares", "genotype vs phenotype · Tt × Tt · homozygous vs heterozygous",
         "Tt × Tt → 3:1", "Dominant: capital or lowercase?", "Tt × Tt expected phenotypic ratio?"),
    ],
    3: [
        ("chem", "Mod Ch 12", "Solutions", "solvent/solute · saturation · filtration · distillation",
         "solute in solvent", "Salt water — solute?", "In salt water, which is the solute?"),
        ("bio", "OSB Ch 19 §19.1 (part 1)", "Ecology — communities", "producers · consumers · decomposers · symbiosis",
         "mutualism · commensalism · parasitism", "3 symbiosis types?", "Organism at base of food chain?"),
        ("phys", "Expl Ch 3 (part 2)", "Newton's 3rd & friction", "action-reaction · friction · net force",
         "F = ma · action-reaction pairs", "Newton's 3rd in words?", "Earth pulls you down — you pull Earth which way?"),
        ("chem", "Mod Ch 8", "Chemical reactions", "balance equations · reactants → products · exo/endothermic",
         "2H₂ + O₂ → 2H₂O", "Balance H₂ + Cl₂ → HCl", "Balance: H₂ + Cl₂ → HCl."),
        ("bio", "OSB Ch 16 §16.1–16.3", "Body systems", "levers · heart · arteries/veins · lungs O₂/CO₂",
         "fulcrum · effort · load", "3 lever parts?", "Arteries carry blood toward or away from heart?"),
    ],
    4: [
        ("chem", "Mod Ch 5 §3 + Ch 4", "The Atom", "atom · nucleus · isotopes · electron shells · valence e⁻ · first 20 symbols",
         "Z = # protons · A = p + n · avg atomic mass", "Symbol for K? · C-12 vs C-14 protons? · Protons located where?", "Chemical symbol for potassium?"),
        ("bio", "OSB Ch 11 (part 1)", "Evolution — natural selection", "natural selection · variation · adaptation · fossils",
         "Darwin · natural selection", "Scientist for natural selection?", "Who is associated with natural selection?"),
        ("phys", "Expl Ch 5", "Momentum & Collisions", "p = mv · conservation · elastic vs inelastic",
         "p = mv · conservation of momentum", "2 kg at 3 m/s momentum? · Truck vs bike at same v?", "2 kg at 3 m/s — momentum?"),
        ("chem", "Mod Ch 2", "Lab & measurement", "SI units · sig figs · graduated cylinder · safety",
         "kg, m, s, mol", "SI mass unit? · Precise volume glassware?", "SI base unit for mass?"),
        ("bio", "OSB Ch 12 (part 2)", "Classification & taxonomy", "Domain → Kingdom → Species · binomial names",
         "Homo sapiens", "Most specific taxonomic rank?", "Most specific classification level?"),
    ],
    5: [
        ("chem", "Mod Ch 7", "Covalent bonding", "covalent sharing · polar vs nonpolar · H₂O vs O₂ · electronegativity",
         "covalent · H₂O · O₂", "O₂ ionic or covalent? · Two nonmetals share → bond type?", "Is O₂ ionic or covalent?"),
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
        ("phys", "Expl Ch 9", "Heat & Temperature", "thermal energy · temperature vs heat · specific heat · conduction",
         "heat flows hot → cold · K = °C + 273", "Heat vs temperature? · 25°C to K?", "Is heat the same as temperature?"),
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
        ("phys", "Expl Ch 11–12", "Magnetism & Waves", "magnetic poles · v = fλ · reflection · refraction",
         "v = fλ · like poles repel", "Higher pitch → frequency? · Like poles?", "Do like magnetic poles attract or repel?"),
        ("chem", "Mod Ch 5 + Ch 7", "Ions & Ionic Compounds", "Na⁺ Cl⁻ Ca²⁺ O²⁻ · polyatomic ions · formulas",
         "cation · anion · NaCl", "Oxide ion charge? · Na ion?", "Charge on oxide ion?"),
        ("bio", "OSB Ch 16 §", "Digestive & Circulatory", "small intestine absorption · heart · alveoli",
         "small intestine · artery · vein", "Most absorption where? · Veins toward heart?", "Most nutrient absorption organ?"),
    ],
    10: [
        ("chem", "Mod Review", "Chemistry capstone", "pick 2 weak Hewitt chem topics · know-cold · 8 toss-ups · Mod/Tro/BFN if stuck",
         "Z · pH · balance · M = mol/L", "pH water? · Symbol K?", "pH of neutral solution?"),
        ("bio", "OSB Review", "Biology capstone", "organelles · genetics · ecology · immunity · weak areas",
         "ATP · Punnett · symbiosis", "ATP organelle? · Tt×Tt ratio?", "Organelle producing most ATP?"),
        ("phys", "Expl Ch 13", "Light & Reflection", "EM spectrum · ROYGBIV · reflection · refraction",
         "v = fλ · red lower f than violet", "Red or violet lower f? · PE converts to when falling?", "Red or violet — lower frequency in visible light?"),
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
    ("Pass 1 bio · Jun", "FLS primary · Jun–Aug"),
    ("Pass 2–3 bio · Jul–Aug", "OSB/CB backup · anytime"),
    ("Pass 1 chem · Jun", "Hewitt primary · Jun–Aug"),
    ("Pass 2–3 chem · Jul–Aug", "Mod/Tro backup · anytime"),
    ("**FLS** (Pass 1) · **CB** (Pass 2–3)", "**FLS** primary · **OSB/CB** backup"),
    ("**Mod** (Pass 1) · **Tro** (Pass 2–3)", "**Hewitt** primary · **Mod/Tro** backup"),
    ("Mod (P1) · Tro (P2–3)", "Hewitt primary · Mod/Tro backup"),
    ("FLS (P1) · CB (P2–3)", "FLS primary · OSB/CB backup"),
    ("**FLS** (P1) · **CB** (P2–3)", "**FLS** primary · **OSB/CB** backup"),
    ("**Mod** (P1) · **Tro** (P2–3)", "**Hewitt** primary · **Mod/Tro** backup"),
    ("Pass 1–3", "one summer pass"),
    ("Pass 1–2", "weeks 1–10"),
    ("Book key & pass overview", "Book key & DOE topic scope"),
    ("Focus on Life Science (FLS) — Pass 1", "Focus on Life Science (FLS) — primary"),
    ("Modern Chemistry (Mod) — Pass 1", "Modern Chemistry (Mod) — backup"),
    ("Campbell Biology (CB) — Pass 2–3", "Campbell Biology (CB) — backup"),
    ("Introductory Chemistry (Tro) — Pass 2–3", "Introductory Chemistry (Tro) — backup"),
    ("OSB/FLS primary", "FLS primary"),
    ("**OSB/FLS** primary", "**FLS** primary"),
    ("**OSB/FLS** (+ CB backup)", "**FLS** (+ OSB/CB backup)"),
    ("**OSB/FLS** primary · **CB** backup", "**FLS** primary · **OSB/CB** backup"),
    ("Mod primary · Mon &amp; Thu", "Hewitt primary · Mon/Thu chem"),
    ("OSB/FLS primary · Tue &amp; Fri", "FLS primary · Tue &amp; Fri"),
    ("OpenStax Biology (OSB) + FLS — primary", "Focus on Life Science (FLS) — primary"),
    ("Modern Chemistry (Mod) — primary", "Modern Chemistry (Mod) — backup"),
    ("**Mod** primary · **Tro** backup", "**Hewitt** primary · **Mod/Tro** backup"),
    ("**FLS/OSB** primary · **CB** backup", "**FLS** primary · **OSB/CB** backup"),
    ("**Mod** primary", "**Hewitt** primary"),
    ("| **Mod** primary |", "| **Hewitt** primary |"),
    ("Mod/Tro · Expl opt · BFN-Sci", "Hewitt · Mod/Tro backup · BFN-Sci"),
    ("**Mod + OSB/FLS + Expl**", "**Hewitt + FLS**"),
    ("pick 2 weak Mod topics", "pick 2 weak Hewitt chem topics"),
    ("**Mod (primary)** | **Tro (backup)** | **Expl opt**", "**Hewitt (primary)** | **Mod (backup)** | **Tro (backup)**"),
    ("| **Mod (primary)** | **Tro (backup)** | **Optional Expl** *(parallel)* |", "| **Hewitt (primary)** | **Mod (backup)** | **Tro (backup)** |"),
    ("| **Mod (primary)** | **Tro (backup)** |", "| **Hewitt (primary)** | **Mod (backup)** |"),
    ("**Mod** primary (+ optional Expl chem)", "**Hewitt** primary (+ **Mod** backup)"),
    ("**Expl** Ch 17–24 *(optional parallel skim)*", "—"),
    ("**Expl** Ch 17–24 *(optional 10-min skim)*", "—"),
    ("**Expl** Ch 17–24 *(optional skim)*", "—"),
    ("| **Wed** | Physics | **Expl**", "| **Wed** | Physics | **Hewitt**"),
    ("| **Wed** | Physics | **Expl** *(physics chapters + App. B)*", "| **Wed** | Physics | **Hewitt** *(Ch 1 · App. B · 2–13)*"),
    ("Chem (optional Mon/Thu):", "Chem (Hewitt primary Mon/Thu):"),
]

BOOK_PICKER_REPLACEMENTS = [
    (
        "> **Chemistry note:** **Mod** is **primary** chemistry · **Tro** is **backup**. Optional **Expl Ch 17–24** is a second explanation of the same week\u2019s topic — pick it if Mod/Tro feels dense, or skip if primary reading is enough.",
        "> **Chemistry note:** **Hewitt** (Expl Ch 17–24) is **primary** chemistry · **Mod/Tro** are **backups** — use only if a Hewitt § section feels dense.",
    ),
    (
        "**Chemistry** in Expl (Part Three, Ch 17–24) is **optional parallel reading** alongside **Mod/Tro** — same topics, Hewitt\u2019s conceptual style.",
        "**Chemistry** in Expl (Part Three, Ch 17–24) is **primary** Mon/Thu reading — assigned **§ sections** only. **Mod/Tro** cover the same topics if Hewitt feels dense.",
    ),
    (
        "**Rules:** One **primary** book per **1-hr** block — assigned **§ section** only. **Expl chem** is extra — 10-min skim after Mod/Tro if helpful, or skip. **BFN** books are for Friday review and \"stuck on a fact\" — not daily reading unless Lar/Mod/Tro runs long.",
        "**Rules:** One **primary** book per **1-hr** block — assigned **§ section** only. **Mod/Tro** are backups — use only if Hewitt/FLS feels dense. **BFN** books are for Friday review and \"stuck on a fact\" — not daily reading unless Lar runs long.",
    ),
    (
        "**Expl chem** is parallel, not required — 10 min after Mod/Tro if the primary chapter feels dense.",
        "**Mod/Tro** are backups — use only if a Hewitt § section feels dense.",
    ),
    (
        "### Three-book chemistry map *(Mod + Tro + optional Expl)*",
        "### Three-book chemistry map *(Hewitt + Mod + Tro)*",
    ),
    (
        "NSB chemistry topics rotate every 4 weeks. **Mod** teaches in June; **Tro** revisits the same topics in July with DOE questions first. **Expl** optional chapters match by **topic**, not by identical chapter numbers.",
        "NSB chemistry topics rotate every 4 weeks. **Hewitt** (Expl Ch 17–24) is primary Mon/Thu — assigned **§ sections** only. **Mod/Tro** are backups for the same topics.",
    ),
    (
        "### Expl chapters — chemistry *(optional Mon/Thu parallel)*",
        "### Expl chapters — chemistry *(Hewitt primary Mon/Thu)*",
    ),
    (
        "| Maps to rotation week |",
        "| Summer weeks |",
    ),
]

HEWITT_CHEM_INDEX_HTML = """      <h3>Conceptual Physical Science Explorations (Hewitt) — primary chem</h3>
      <table>
        <tr><th>Ch</th><th>Title</th><th>Weeks</th></tr>
        <tr><td>17</td><td>Elements of Chemistry</td><td>1, 4, 8–10</td></tr>
        <tr><td>18</td><td>How Atoms Bond and Molecules Attract</td><td>1, 4, 5, 9</td></tr>
        <tr><td>19</td><td>How Chemicals Mix</td><td>3, 6, 7</td></tr>
        <tr><td>20</td><td>How Chemicals React</td><td>2, 7</td></tr>
        <tr><td>21</td><td>Two Types of Chemical Reactions</td><td>3, 6</td></tr>
        <tr><td>22</td><td>Organic Compounds</td><td>stretch</td></tr>
      </table>
"""


def esc(s: str) -> str:
    return s.replace("&", "&amp;")


def html_cell(
    week: int,
    day_idx: int,
    kind: str,
    book: str,
    title: str,
    focus: str,
    formulas: str,
    know: str,
    tossup: str,
) -> str:
    cls = {"chem": "chem", "bio": "bio", "phys": "phys"}.get(kind, "study-cell")
    if kind == "chem":
        _, mod_book, *_ = SCIENCE_WEEKS[week][day_idx]
        mod = format_mod_reading(week, day_idx, mod_book)
        mod_display = mod[4:] if mod.startswith("Mod ") else mod
        tro = TRO_BACKUP.get((week, day_idx))
        tro_part = f" · Tro {tro}" if tro else " · Tro if stuck"
        backup_text = format_chem_backup(week, day_idx, mod_display, tro_part)
        backup = f'<span class="optional-book"><em>Backup:</em> {esc(backup_text)}</span>'
    elif kind == "bio":
        backup_text = format_bio_backup(week, day_idx, osb_backup_line(week, day_idx))
        backup = f'<span class="optional-book"><em>Backup:</em> {esc(backup_text)}</span>'
    else:
        backup = f'<span class="optional-book"><em>Backup:</em> {esc(format_phys_backup(week, day_idx))}</span>'
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


def apply_book_picker_replacements(text: str) -> str:
    for old, new in BOOK_PICKER_REPLACEMENTS:
        text = text.replace(old, new)
    text = apply_common_replacements(text)
    return text


def patch_index_sections(text: str) -> str:
    if "Hewitt) — primary chem" not in text:
        text = text.replace(
            "<h3>Modern Chemistry (Mod) — primary</h3>",
            HEWITT_CHEM_INDEX_HTML + "      <h3>Modern Chemistry (Mod) — backup</h3>",
            1,
        )
        text = text.replace(
            "<h3>Modern Chemistry (Mod) — backup</h3>",
            HEWITT_CHEM_INDEX_HTML + "      <h3>Modern Chemistry (Mod) — backup</h3>",
            1,
        )
    text = text.replace(
        "<h3>Conceptual Physical Science Explorations (Expl)</h3>",
        "<h3>Conceptual Physical Science Explorations (Hewitt) — primary physics</h3>",
    )
    return apply_common_replacements(text)


def generate_chemistry_map_rows() -> list[tuple[str, str, str, str, str]]:
    rows: list[tuple[str, str, str, str, str]] = []
    for week in range(1, 5):
        for day_idx in (0, 3):
            _, mod_book, title, *_ = SCIENCE_WEEKS[week][day_idx]
            hewitt = HEWITT_CHEM_PRIMARY[(week, day_idx)].replace("Hewitt ", "")
            mod = format_mod_reading(week, day_idx, mod_book).replace("Mod ", "")
            tro = TRO_BACKUP.get((week, day_idx), "—")
            day = "Mon" if day_idx == 0 else "Thu"
            rows.append((f"{week} {day}", title, hewitt, mod, tro))
    return rows


def generate_chemistry_map_html() -> str:
    rows = []
    for wk_day, title, hewitt, mod, tro in generate_chemistry_map_rows():
        rows.append(
            f"        <tr><td>{esc(wk_day)}</td><td>{esc(title)}</td>"
            f"<td>{esc(hewitt)}</td><td>{esc(mod)}</td><td>{esc(tro)}</td></tr>"
        )
    return (
        "      <h3>Three-book chemistry map</h3>\n"
        "      <table style=\"font-size:7pt\">\n"
        "        <tr><th>Wk</th><th>Topic</th><th>Hewitt (primary)</th>"
        "<th>Mod (backup)</th><th>Tro (backup)</th></tr>\n"
        + "\n".join(rows)
        + "\n      </table>"
    )


def generate_chemistry_map_md() -> str:
    lines = [
        "| Rotation week | NSB topic | **Hewitt (primary)** | **Mod (backup)** | **Tro (backup)** |",
        "|---------------|-----------|---------------------|------------------|------------------|",
    ]
    for wk_day, title, hewitt, mod, tro in generate_chemistry_map_rows():
        lines.append(f"| **{wk_day}** | {title} | {hewitt} | {mod} | {tro} |")
    return "\n".join(lines)


def patch_chemistry_map_html(text: str) -> str:
    return re.sub(
        r"<h3>Three-book chemistry map</h3>\s*<table style=\"font-size:7pt\">.*?</table>",
        generate_chemistry_map_html(),
        text,
        count=1,
        flags=re.DOTALL,
    )


def patch_chemistry_map_md(text: str) -> str:
    return re.sub(
        r"\| Rotation week \| NSB topic \| \*\*(?:Mod|Hewitt) \(primary\)\*\*.*?\n\n\*\*Not scheduled",
        generate_chemistry_map_md() + "\n\n**Not scheduled",
        text,
        count=1,
        flags=re.DOTALL,
    )


def coach_cell(week: int, day: str) -> str:
    key = "tue" if day == "Tue" else "thu"
    label, focus = COACH_ROWS[week][key]
    return (
        f'<td class="py study-cell"><strong>{esc(label)}</strong>'
        f'<span class="focus"><em>Focus:</em> {esc(focus)}</span></td>'
    )


HEWITT_CHEM_PRIMARY: dict[tuple[int, int], str] = {
    (1, 0): "Hewitt Ch 17 §17.1–17.3",
    (1, 3): "Hewitt Ch 17 §17.6–17.8",
    (2, 0): "Hewitt Ch 17 §17.3–17.5",
    (2, 3): "Hewitt Ch 18 §18.1–18.4",
    (3, 0): "Hewitt Ch 19 §19.1–19.4",
    (3, 3): "Hewitt Ch 20 §20.1–20.4",
    (4, 0): "Hewitt Ch 15 §15.1–15.5",
    (4, 3): "Hewitt Ch 17 §17.1–17.4",
    (5, 0): "Hewitt Ch 18 §18.5–18.8",
    (5, 3): "Hewitt Ch 19 §19.3–19.4",
    (6, 0): "Hewitt Ch 19 §19.3–19.5",
    (6, 3): "Hewitt Ch 21 §21.1–21.3",
    (7, 0): "Hewitt Ch 20 §20.1–20.4",
    (7, 3): "Hewitt Ch 17 §17.6–17.7",
    (8, 0): "Hewitt Ch 17 §17.4–17.5",
    (8, 3): "Hewitt Ch 17 §17.3–17.5",
    (9, 0): "Hewitt Ch 17 §17.2–17.3",
    (9, 3): "Hewitt Ch 18 §18.2–18.4",
    (10, 0): "Hewitt Review",
    (10, 3): "Hewitt Review",
}

HEWITT_PHYS_PRIMARY: dict[tuple[int, int], str] = {
    (1, 2): "Hewitt Ch 1 §1.2–1.5 + App. B",
    (2, 2): "Hewitt Ch 2 §2.2–2.6 + Ch 3 §3.1–3.3",
    (3, 2): "Hewitt Ch 3 §3.4–3.6 + Ch 4 §4.1–4.3",
    (4, 2): "Hewitt Ch 5 §5.1–5.5",
    (5, 2): "Hewitt Ch 6 §6.1–6.5",
    (6, 2): "Hewitt Ch 7 §7.1–7.4 + §7.7",
    (7, 2): "Hewitt Ch 9 §9.1–9.5",
    (8, 2): "Hewitt Ch 10 §10.1–10.7 + §10.11",
    (9, 2): "Hewitt Ch 11 §11.1–11.5 + Ch 12 §12.1–12.6",
    (10, 2): "Hewitt Ch 13 §13.1 + §13.3–13.4",
}


def primary_display_book(week: int, day_idx: int, kind: str, book: str) -> str:
    key = (week, day_idx)
    if kind == "chem":
        return HEWITT_CHEM_PRIMARY.get(key, book.replace("Mod", "Hewitt", 1))
    if kind == "bio":
        return FLS_PRIMARY.get(key, book.replace("OSB", "FLS", 1))
    if kind == "phys":
        return HEWITT_PHYS_PRIMARY.get(key, book.replace("Expl", "Hewitt", 1))
    return book


def generate_whiteboard_week(week: int) -> str:
    dates, theme = WEEK_META[week]
    blocks = SCIENCE_WEEKS[week]
    date_list = DATES[week]

    rows = []
    for i, day in enumerate(DAY_NAMES):
        kind, book, title, focus, formulas, know, tossup = blocks[i]
        display_book = primary_display_book(week, i, kind, book)
        cell = html_cell(week, i, kind, display_book, title, focus, formulas, know, tossup)
        alg_cell = algebra_html_cell(week, i)

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
    <div class="week-meta"><span class="pass-tag">SUMMER · ONE PASS</span><br>Hewitt + FLS + assigned §</div>
  </div>
{note}  <table>
    <tr><th>Date</th><th>Day</th><th>Chemistry · Hewitt (+ Mod backup)</th><th>Biology · FLS</th><th>Physics · Hewitt</th><th>Algebra · OSA (+ Lar backup)</th><th>Python · Coach<br><span style="font-weight:normal;text-transform:none">Tue/Thu 4:45–5:15</span></th><th>Fri review</th></tr>
{chr(10).join(rows)}
  </table>{footer}
</section>
"""


def generate_calendar_week_md(week: int) -> str:
    dates, theme = WEEK_META[week]
    blocks = SCIENCE_WEEKS[week]
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
        math_title, _, lar_part = osa_math_reading(week, idx)
        alg_backup = format_algebra_backup(week, idx, math_title, lar_part)
        lines.append(
            f"| **Algebra · OSA** | *{format_osa_algebra_primary(week, idx)}* · "
            f"backup {alg_backup} | 1 hr algebra block | — | — | — |"
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
    <tr><td><strong>FLS</strong></td><td>Focus on Life Science — Prentice Hall CA ed. (ISBN 9780130443465)</td><td>Primary biology · Tue &amp; Fri</td></tr>
    <tr><td><strong>OSB</strong></td><td>OpenStax Biology 2e — free online (openstax.org)</td><td>Biology backup · same DOE topics</td></tr>
    <tr><td><strong>CB</strong></td><td>Campbell Biology: Concepts &amp; Connections — 7th ed. (ISBN 9780321696816)</td><td>Biology backup · deeper TAG level</td></tr>
    <tr><td><strong>Mod</strong></td><td>Modern Chemistry 2012 — Sarquis (ISBN 9780547586632)</td><td>Chemistry backup · Mon &amp; Thu</td></tr>
    <tr><td><strong>Tro</strong></td><td>Introductory Chemistry — Tro 4th ed. (ISBN 9780321687937)</td><td>Chemistry backup</td></tr>
    <tr><td><strong>Hewitt</strong></td><td>Conceptual Physical Science Explorations — Hewitt student text (ISBN 9780321567918)</td><td>Primary chem (Ch 17–24) · Wed physics</td></tr>
    <tr><td><strong>OSA</strong></td><td>OpenStax Algebra &amp; Trigonometry 2e — free online (openstax.org)</td><td>Primary algebra · Mon–Fri · assigned §</td></tr>
    <tr><td><strong>Lar</strong></td><td>Holt McDougal Larson Algebra 1 2011 (ISBN 9780547315157)</td><td>Algebra backup · Ch 1–13</td></tr>
    <tr><td><strong>BFN-A/Bio/Sci</strong></td><td>Big Fat Notebooks — Algebra · Biology · Science</td><td>Backup quizzes · Fri review</td></tr>
    <tr><td><strong>Coach</strong></td><td>Soha Python Coach — Mac app (Outschool L1–4 + portfolio)</td><td>Tue/Thu 4:45–5:15 PM · Journey tab</td></tr>
  </table>"""
    text = re.sub(
        r"<section class=\"week legend-page\">.*?<!-- WEEK 1 -->",
        f"<section class=\"week legend-page\">\n  <div class=\"week-header\">\n    <h2>Book key &amp; DOE topic scope</h2>\n    <div class=\"week-meta\">Summer 2026 · Soha<br>Jun 8 – Aug 19</div>\n  </div>\n{legend_table}\n  <h3 style=\"font-size:9pt;margin:0.15in 0 0.08in\">DOE study topics (not whole textbooks)</h3>\n  <p style=\"font-size:8pt;margin:0 0 0.1in\">Life: cell biology, genetics, anatomy &amp; physiology, plant biology, ecology, animal behavior · Physical: chem reactions/periodic table/states of matter + physics forces/motion/waves/electromagnetism/thermo · Math: algebra, geometry, probability, statistics (OSA § block).</p>\n  <h3 style=\"font-size:9pt;margin:0.15in 0 0.08in\">Pick your book *(Soha)*</h3>\n  <table style=\"font-size:8pt\">\n    <tr><th>When</th><th>Primary</th><th>Also OK</th><th>Backup</th></tr>\n    <tr><td>Mon/Thu Chem</td><td><strong>Hewitt</strong> Ch 17–24</td><td>—</td><td><strong>Mod</strong> · <strong>Tro</strong> · <strong>BFN-Sci</strong></td></tr>\n    <tr><td>Tue/Fri Bio</td><td><strong>FLS</strong></td><td>—</td><td><strong>OSB</strong> · <strong>CB</strong> · <strong>BFN-Bio</strong></td></tr>\n    <tr><td>Wed Phys</td><td><strong>Hewitt</strong></td><td>—</td><td><strong>BFN-Sci</strong></td></tr>\n    <tr><td>Mon–Fri Algebra</td><td><strong>OSA</strong> assigned §</td><td>—</td><td><strong>Lar</strong> · <strong>BFN-A</strong></td></tr>\n    <tr><td>Tue/Thu Python</td><td><strong>Coach</strong> Journey week</td><td>—</td><td>Playground + live notes</td></tr>\n  </table>\n  <table style=\"margin-top:0.2in\">\n    <tr><th>Plan</th><th>Dates</th><th>Chemistry</th><th>Biology</th><th>Physics</th><th>Python</th></tr>\n    <tr><td><strong>One summer pass</strong></td><td>Jun 8 – Aug 14</td><td><strong>Hewitt</strong> chem</td><td><strong>FLS</strong> (+ OSB/CB backup)</td><td><strong>Hewitt</strong></td><td><strong>Coach</strong> wk 1–10</td></tr>\n    <tr><td><strong>Backups</strong></td><td>anytime</td><td><strong>Mod</strong> · <strong>Tro</strong> · BFN-Sci</td><td><strong>OSB</strong> · <strong>CB</strong> · BFN-Bio</td><td>BFN-Sci</td><td>Quiz → DOE in app</td></tr>\n    <tr><td><strong>Bridge</strong></td><td>Aug 15 – 18</td><td colspan=\"4\">Optional flash cards · school meetings in fall · Aug 19 = first day of school</td></tr>\n  </table>\n  <p class=\"footer\">Each cell: read assigned <strong>§ section</strong> only · <strong>Formulas</strong> · <strong>Focus</strong> · <strong>Know</strong> · <strong>Toss-up</strong> · Full detail + answers in summer-2026-calendar.md · Daily times → weekly-timetable.md</p>\n</section>\n\n<!-- WEEK 1 -->",
        text,
        count=1,
        flags=re.DOTALL,
    )
    return apply_common_replacements(text)


def patch_whiteboard_master_index(text: str) -> str:
    text = text.replace("(Pass 2)", "(wk 6–7)")
    return patch_index_sections(text)


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
| **FLS** | *Focus on Life Science* — Prentice Hall California ed. (2001) | 9780130443465 | Primary bio · Tue & Fri |
| **OSB** | *OpenStax Biology 2e* — free online | openstax.org | Biology backup · same DOE topics |
| **CB** | *Campbell Biology: Concepts & Connections* — **7th ed.** | 9780321696816 | Biology backup · anytime |
| **Hewitt** | *Conceptual Physical Science Explorations* — Hewitt **student text** | 9780321567918 | Primary chem (Ch 17–24) · Wed **physics** |
| **Mod** | *Modern Chemistry* — Sarquis **Student Edition 2012** | 9780547586632 | Chemistry backup · Mon & Thu |
| **Tro** | *Introductory Chemistry* — Tro **4th ed.** | 9780321687937 | Chemistry backup · anytime |
| **ExplLab** | *Explorations: Laboratory Manual* *(optional hands-on)* | 9780321051837 | Wed labs when you want |
| **OSA** | *OpenStax Algebra & Trigonometry 2e* — free online | openstax.org | **Primary** algebra · Mon–Fri · assigned § |
| **Lar** | *Holt McDougal Larson Algebra 1* — **2011** | 9780547315157 | Algebra **backup** · Ch 1–13 |
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
         "| **FLS** | *Focus on Life Science* — Prentice Hall California ed. (2001) | 9780130443465 | Primary bio · Tue & Fri |"),
        ("| **CB** | *Campbell Biology: Concepts & Connections* — **7th ed.** | 9780321696816 | CB backup · anytime |",
         "| **CB** | *Campbell Biology: Concepts & Connections* — **7th ed.** | 9780321696816 | Biology backup · anytime |"),
        ("| **Mod** | *Modern Chemistry* — Sarquis **Student Edition 2012** | 9780547586632 | Pass 1 chem · Jun |",
         "| **Mod** | *Modern Chemistry* — Sarquis **Student Edition 2012** | 9780547586632 | Chemistry backup · Mon & Thu |"),
        ("| **Tro** | *Introductory Chemistry* — Tro **4th ed.** | 9780321687937 | Tro backup · anytime |",
         "| **Tro** | *Introductory Chemistry* — Tro **4th ed.** | 9780321687937 | Chemistry backup · anytime |"),
        ("| **Mon** | Chemistry | **Mod** (P1) · **Tro** (P2–3) | **Expl** Ch 17–24 *(optional skim)* | **BFN-Sci** |",
         "| **Mon** | Chemistry | **Hewitt** primary | — | **Mod** · **Tro** · **BFN-Sci** |"),
        ("| **Tue** | Biology | **FLS** (P1) · **CB** (P2–3) | — | **BFN-Bio** |",
         "| **Tue** | Biology | **FLS** primary | — | **OSB** · **CB** · **BFN-Bio** |"),
        ("| **Thu** | Chemistry | **Mod** (P1) · **Tro** (P2–3) | **Expl** Ch 17–24 *(optional skim)* | **BFN-Sci** |",
         "| **Thu** | Chemistry | **Hewitt** primary | — | **Mod** · **Tro** · **BFN-Sci** |"),
        ("| **Fri** | Biology | **FLS** (P1) · **CB** (P2–3) | — | **BFN-Bio** |",
         "| **Fri** | Biology | **FLS** primary | — | **OSB** · **CB** · **BFN-Bio** |"),
        ("| **Mon–Thu** | Algebra | **Lar** | — | **BFN-A** |",
         "| **Mon–Fri** | Algebra | **OSA** assigned § | — | **Lar** · **BFN-A** |"),
    ]:
        text = text.replace(old, new)
    text = re.sub(
        r"### Which book each pass\n\n\| Pass \| Dates.*?\n\n---",
        """### One summer pass — books by block

| Block | Chemistry | Biology | Physics | Python |
|-------|-----------|---------|---------|--------|
| **Mon/Thu** | **Hewitt** chem (Ch 17–24) | — | — | — |
| **Tue/Fri** | — | **FLS** (+ OSB/CB backup) | — | — |
| **Wed** | — | — | **Hewitt** physics | — |
| **Mon–Fri** | — | — | — | **OSA** algebra (+ Lar backup) |
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

*One careful read through **Hewitt + FLS** (50 × 1-hr science blocks). Read assigned **§ sections** for each DOE topic — stop when Focus is covered. **Mod/OSB/Tro/CB/BFN** = backups. Extra DOE practice → Science Bowl Coach **Quiz** tab. Flash-card review → **school meetings** in fall.*

"""
        new_section += "\n".join(generate_calendar_week_md(w) for w in range(1, 11))
        text = text[:start] + new_section + text[end:]

    text = patch_calendar_books_section(text)
    text = text.replace("*(Pass 2)*", "*(wk 6–7)*")
    text = text.replace("*(stretch Pass 1 wk 4)*", "*(wk 4, 8)*")
    text = text.replace("— Pass 1 biology", "— primary biology")
    text = apply_book_picker_replacements(text)
    path.write_text(text)


def patch_weekly_timetable(path: Path) -> None:
    text = path.read_text()
    if "DOE study topics" not in text:
        insert_at = text.find("---\n\n## Every day includes")
        if insert_at != -1:
            text = text[:insert_at] + "\n" + DOE_TOPIC_SCOPE + text[insert_at:]
    reps = [
        ("same **10-week Pass 1–3 schedule**", "same **10-week summer schedule**"),
        ("**Mod** (Pass 1) · **Tro** (Pass 2–3)", "**Hewitt** primary · **Mod/Tro** backup"),
        ("**FLS** (Pass 1) · **CB** (Pass 2–3)", "**FLS** primary · **OSB/CB** backup"),
        ("Pass 1–3", "one summer pass"),
        ("| **Mon–Thu** | Algebra | **Lar** | — | **BFN-A** |",
         "| **Mon–Fri** | Algebra | **OSA** assigned § | — | **Lar** · **BFN-A** |"),
        ("**All books on shelf:** FLS · CB · Mod",
         "**All books on shelf:** OSB · FLS · CB · Mod"),
    ]
    for old, new in reps:
        text = text.replace(old, new)
    text = apply_book_picker_replacements(text)
    path.write_text(text)


def patch_weekly_html(path: Path) -> None:
    if not path.exists():
        return
    text = path.read_text()
    reps = [
        ("Pass 1–3", "one summer pass"),
        ("Pass 1 · Pass 2 · Pass 3", "one summer pass"),
        ("Weeks 1–4 = Pass 1", "Weeks 1–10 = one summer pass"),
        ("FLS (P1) · CB (P2–3)", "FLS primary · OSB/CB backup"),
        ("Mod (P1) · Tro (P2–3)", "Hewitt primary · Mod/Tro backup"),
        ("Mod/Tro · Expl opt · BFN-Sci", "Hewitt · Mod/Tro backup · BFN-Sci"),
        ("FLS/CB/Expl/Lar", "Hewitt/FLS/Mod/OSB/CB/Lar"),
        ("calendar says primary (Mod/Tro/FLS/CB/Expl/Lar)", "calendar says primary (Hewitt/FLS) — backups on picker table"),
        ("Chemistry — 30 min<br><span style=\"font-size:7.5pt\">Mod/Tro · Expl opt · BFN-Sci</span>",
         "Chemistry — 1 hr<br><span style=\"font-size:7.5pt\">Hewitt · Mod/Tro backup · BFN-Sci</span>"),
        ("Book key & pass overview", "Book key & DOE topic scope"),
        ("one chapter in one day", "assigned § section per block"),
        ("whole chapter", "assigned § section"),
    ]
    for old, new in reps:
        text = text.replace(old, new)
    text = apply_book_picker_replacements(text)
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


MOD_SECTION_APPEND: dict[tuple[int, int], str] = {
    (1, 0): "§3.1–3.3",
    (1, 3): "§5.1–5.2",
    (2, 0): "§10.1–10.2",
    (2, 3): "§7.1–7.2",
    (3, 0): "§12.1–12.2",
    (3, 3): "§8.1–8.3",
    (4, 3): "§2.1–2.3",
    (5, 0): "§7.1–7.2",
    (5, 3): "§6.1–6.2",
    (6, 0): "§12.2–12.3",
    (6, 3): "§14.3–14.4",
    (7, 0): "§8.2–8.4",
    (7, 3): "§12.1–12.2",
    (8, 0): "§5.3–5.4",
    (8, 3): "§2.3–2.4",
    (9, 0): "§3.2–3.3",
    (9, 3): "§5.1 + §7.1",
}

TRO_BACKUP: dict[tuple[int, int], str] = {
    (1, 0): "Ch 4 §4.3–4.6",
    (1, 3): "Ch 4 §4.7–4.8 + Ch 5",
    (2, 0): "Ch 3",
    (2, 3): "Ch 5",
    (3, 0): "Ch 13",
    (3, 3): "Ch 7 §7.1–7.4",
    (4, 0): "Ch 9 §9.7 · §9.9",
    (4, 3): "Ch 2",
    (5, 0): "Ch 5",
    (5, 3): "Ch 6",
    (6, 0): "Ch 13",
    (6, 3): "Ch 14",
    (7, 0): "Ch 7",
    (7, 3): "Ch 9",
    (8, 0): "Ch 2",
    (8, 3): "Ch 3",
    (9, 0): "Ch 4",
    (9, 3): "Ch 4–5",
}

BIO_BACKUP: dict[tuple[int, int], str] = {
    (1, 1): "FLS Ch 1 · CB Ch 4",
    (1, 4): "FLS Ch 2 · CB Ch 6–7",
    (2, 1): "FLS Ch 4 · CB Ch 9",
    (2, 4): "FLS Ch 4 · CB Ch 9",
    (3, 1): "FLS Ch 7 · CB Ch 36–37",
    (3, 4): "FLS Ch 16–20 · CB Ch 21–23",
    (4, 1): "FLS Ch 5–6 · CB Ch 13–14",
    (4, 4): "FLS Ch 5–6 · CB Ch 13–14",
    (5, 1): "FLS Ch 3 · CB Ch 8",
    (5, 4): "FLS Ch 3 · CB Ch 9",
    (6, 1): "FLS Ch 7 · CB Ch 36",
    (6, 4): "FLS Ch 8 · CB Ch 16",
    (7, 1): "FLS Ch 21 · CB Ch 24",
    (7, 4): "FLS Ch 10 · CB Ch 31",
    (8, 1): "FLS Ch 11 · CB Ch 31",
    (8, 4): "FLS Ch 16 · CB Ch 20",
    (9, 1): "FLS Ch 4 · CB Ch 8",
    (9, 4): "FLS Ch 16–20 · CB Ch 21–23",
    (10, 1): "FLS · CB · BFN-Bio",
    (10, 4): "BFN-Bio",
}

EXPL_CHEM_OPT: dict[tuple[int, int], str] = {
    (1, 0): "Ch 17",
    (1, 3): "Ch 17–18",
    (2, 0): "Ch 17–19",
    (2, 3): "Ch 18",
    (3, 0): "Ch 19",
    (3, 3): "Ch 20",
    (4, 0): "Ch 17–18",
    (4, 3): "Ch 17",
}

PREP_BLOCK_ROWS = [
    (0, "Mon Chem", "chem"),
    (1, "Tue Bio", "bio"),
    (2, "Wed Phys", "phys"),
    (3, "Thu Chem", "chem"),
    (4, "Fri Bio", "bio"),
]


def format_mod_reading(week: int, day_idx: int, book: str) -> str:
    if "§" in book or "+" in book or "review" in book.lower():
        return book
    extra = MOD_SECTION_APPEND.get((week, day_idx), "")
    return f"{book} {extra}".strip() if extra else book


def osb_backup_line(week: int, day_idx: int) -> str:
    kind, osb_book, *_ = SCIENCE_WEEKS[week][day_idx]
    if kind != "bio":
        return "—"
    fls_cb = BIO_BACKUP.get((week, day_idx), "CB backup")
    if " · CB" in fls_cb:
        cb_part = fls_cb.split(" · CB", 1)[1].strip()
        return f"{osb_book} · CB {cb_part}"
    return f"{osb_book} · {fls_cb}"


def format_primary_md(week: int, day_idx: int, kind: str, book: str, title: str) -> str:
    display = primary_display_book(week, day_idx, kind, book)
    label = display.split()[0]
    rest = display[len(label) :].strip()
    return f"**{label}** {rest} — *{title}*"


def format_backup_md(week: int, day_idx: int, kind: str) -> str:
    if kind == "chem":
        _, mod_book, *_ = SCIENCE_WEEKS[week][day_idx]
        mod = format_mod_reading(week, day_idx, mod_book)
        mod_display = mod[4:] if mod.startswith("Mod ") else mod
        tro = TRO_BACKUP.get((week, day_idx))
        tro_part = f" · Tro {tro}" if tro else " · Tro if stuck"
        return format_chem_backup(week, day_idx, mod_display, tro_part)
    if kind == "bio":
        return format_bio_backup(week, day_idx, osb_backup_line(week, day_idx))
    if kind == "phys":
        return format_phys_backup(week, day_idx)
    return "—"


def format_mod_backup(week: int, day_idx: int, kind: str) -> str:
    if kind != "chem":
        return "—"
    _, mod_book, *_ = SCIENCE_WEEKS[week][day_idx]
    mod = format_mod_reading(week, day_idx, mod_book)
    return mod.replace("Mod ", "Mod ", 1)


def format_primary_html(week: int, day_idx: int, kind: str, book: str) -> str:
    display = primary_display_book(week, day_idx, kind, book)
    label, _, rest = display.partition(" ")
    return f"<strong>{esc(label)}</strong> {esc(rest)}"


def format_backup_html(week: int, day_idx: int, kind: str) -> str:
    if kind == "chem":
        _, mod_book, *_ = SCIENCE_WEEKS[week][day_idx]
        mod = format_mod_reading(week, day_idx, mod_book)
        mod_display = mod[4:] if mod.startswith("Mod ") else mod
        tro = TRO_BACKUP.get((week, day_idx))
        tro_part = f" · Tro {esc(tro)}" if tro else " · Tro if stuck"
        return esc(format_chem_backup(week, day_idx, mod_display, tro_part))
    if kind == "bio":
        return esc(format_bio_backup(week, day_idx, osb_backup_line(week, day_idx)))
    if kind == "phys":
        return esc(format_phys_backup(week, day_idx))
    return "—"


def generate_prep_week_table_md(week: int) -> str:
    _, theme = WEEK_META[week]
    blocks = SCIENCE_WEEKS[week]
    lines = [
        f"### Week {week} — {theme}",
        "",
        "| Block | Topic | Primary (§ sections) | Backup | Mod backup |",
        "|-------|-------|----------------------|--------|------------|",
    ]
    for day_idx, label, kind in PREP_BLOCK_ROWS:
        _, book, title, *_ = blocks[day_idx]
        lines.append(
            f"| **{label}** | {title} | {format_primary_md(week, day_idx, kind, book, title)} "
            f"| {format_backup_md(week, day_idx, kind)} | {format_mod_backup(week, day_idx, kind)} |"
        )
    for day_idx, day_name in enumerate(["Mon", "Tue", "Wed", "Thu", "Fri"]):
        title, _, lar_part = osa_math_reading(week, day_idx)
        alg_backup = format_algebra_backup(week, day_idx, title, lar_part)
        lines.append(
            f"| **{day_name} Algebra** | {title} | **{format_osa_algebra_primary(week, day_idx)}** "
            f"| {alg_backup} | — |"
        )
    lines.extend(["", f"**Fri review:** {REVIEW_ROWS[week]}", "", "---", ""])
    return "\n".join(lines)


def generate_prep_week_table_html(week: int) -> str:
    _, theme = WEEK_META[week]
    blocks = SCIENCE_WEEKS[week]
    rows = []
    for day_idx, label, kind in PREP_BLOCK_ROWS:
        _, book, title, *_ = blocks[day_idx]
        rows.append(
            f'        <tr class="{kind}"><td>{label}</td><td>{esc(title)}</td>'
            f"<td>{format_primary_html(week, day_idx, kind, book)}</td>"
            f"<td>{format_backup_html(week, day_idx, kind)}</td>"
            f"<td>{esc(format_mod_backup(week, day_idx, kind))}</td></tr>"
        )
    for day_idx, day_name in enumerate(["Mon", "Tue", "Wed", "Thu", "Fri"]):
        title, _, lar_part = osa_math_reading(week, day_idx)
        alg_backup = format_algebra_backup(week, day_idx, title, lar_part)
        rows.append(
            f'        <tr class="alg"><td>{day_name} Alg</td><td>{esc(title)}</td>'
            f"<td>{esc(format_osa_algebra_primary(week, day_idx))}</td>"
            f"<td>{esc(alg_backup)}</td><td>—</td></tr>"
        )
    return f"""      <h4 id="week-{week}"><span class="week-tag">Week {week}</span> {theme}</h4>
      <table>
        <tr><th>Block</th><th>Topic</th><th>Primary (§ sections)</th><th>Backup</th><th>Mod backup</th></tr>
{chr(10).join(rows)}
      </table>
      <p style="font-size:8pt"><strong>Fri review:</strong> {esc(REVIEW_ROWS[week])}</p>
"""


def generate_prep_reading_guide_html() -> str:
    pages = []
    week_pairs = [(1, 2), (3, 4), (5, 6), (7, 8), (9, 10)]
    for i, (w_left, w_right) in enumerate(week_pairs):
        label = "PAGE 3" if i == 0 else f"PAGE 3{chr(ord('a') + i - 1)}"
        pages.append(
            f"""<!-- {label} — READING GUIDE WEEKS {w_left}–{w_right} -->
<section class="page page-guide">
  <div class="page-header">
    <h2>Textbook reading guide — weeks {w_left}–{w_right}</h2>
    <div class="page-meta">One summer pass · assigned § sections only · Full detail → summer-2026-calendar.md</div>
  </div>

  <div class="two-col">
    <div>
{generate_prep_week_table_html(w_left)}
    </div>
    <div>
{generate_prep_week_table_html(w_right)}
    </div>
  </div>

  <p class="footer">Read assigned § sections only (stop at Focus) · Mod/OSB/CB = backup · DOE topics not whole books · Daily detail in summer-2026-calendar.md</p>
</section>
"""
        )
    return "\n".join(pages)


def patch_prep_reading_guide_md(text: str) -> str:
    start = text.find("## Textbook reading guide")
    end = text.find("## Topic deep-dives")
    if start == -1 or end == -1:
        return text
    new_section = (
        "## Textbook reading guide — weeks 1–10\n\n"
        "*One summer pass · read **assigned § sections** for each DOE topic — not whole chapters. "
        "Stop when Focus is covered.*\n\n"
    )
    new_section += "\n".join(generate_prep_week_table_md(w) for w in range(1, 11))
    return text[:start] + new_section + text[end:]


def patch_prep_md(path: Path) -> None:
    text = path.read_text()
    if "### DOE study topics" not in text:
        marker = "## How this fits your schedule"
        if marker in text:
            text = text.replace(marker, DOE_TOPIC_SCOPE + marker, 1)

    text = text.replace(
        "**Weeks 1–4** = Pass 1 *(Mod + FLS · learn from textbook)* · **Weeks 5–8** = Pass 2 *(Tro + CB · DOE questions first)* · **Weeks 9–10** = Pass 3 *(flash cards → book only if stuck)*",
        "**Weeks 1–10** = **one summer pass** *(Hewitt + FLS · assigned § section per 1-hr block)* · **Mod/OSB/Tro/CB/BFN** = backups · **DOE drill** = app Quiz tab · **Flash cards** = school meetings in fall",
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
| **FLS** | *Focus on Life Science* — Prentice Hall **California ed. (2001)** | 9780130443465 | **Primary** biology · Tue & Fri |
| **OSB** | *OpenStax Biology 2e* — free online | openstax.org | Biology **backup** · same DOE topics |
| **CB** | *Campbell Biology: Concepts & Connections* — **7th ed.** | 9780321696816 | Biology **backup** · deeper TAG level |
| **Hewitt** | *Conceptual Physical Science Explorations* — Hewitt **student text** | 9780321567918 | **Primary** chem (Ch 17–24) · Wed **physics** |
| **Mod** | *Modern Chemistry* — Sarquis **Student Edition 2012** | 9780547586632 | Chemistry **backup** · Mon & Thu |
| **Tro** | *Introductory Chemistry* — Nivaldo Tro **4th ed.** | 9780321687937 | Chemistry **backup** |
| **ExplLab** | *Explorations: Laboratory Manual* | 9780321051837 | Optional Wed labs |
| **OSA** | *OpenStax Algebra & Trigonometry 2e* — free online | openstax.org | **Primary** algebra · Mon–Fri · assigned § |
| **Lar** | *Holt McDougal Larson Algebra 1* — **2011** | 9780547315157 | Algebra **backup** · Ch 1–13 |
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
| **Mon/Thu** | — | **Hewitt** primary (Ch 17–24) | — |
| **Tue/Fri** | **FLS** primary (+ OSB/CB backup) | — | — |
| **Wed** | — | — | **Hewitt** |

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
         "**Hewitt** is **primary** chemistry · **Mod/Tro** are **backups**"),
        ("| **Mon** | Chemistry | **Mod** (Pass 1) · **Tro** (Pass 2–3) |",
         "| **Mon** | Chemistry | **Hewitt** primary |"),
        ("| **Tue** | Biology | **FLS** (Pass 1) · **CB** (Pass 2–3) |",
         "| **Tue** | Biology | **FLS** primary |"),
        ("| **Thu** | Chemistry | **Mod** (Pass 1) · **Tro** (Pass 2–3) |",
         "| **Thu** | Chemistry | **Hewitt** primary |"),
        ("| **Fri** | Biology | **FLS** (Pass 1) · **CB** (Pass 2–3) |",
         "| **Fri** | Biology | **FLS** primary |"),
        ("pick **2 weak subtopics** for Pass 2", "log **2 weak subtopics** in app Progress"),
        ("for Pass 3", "for school meetings"),
        ("Pass 2: re-read only the Tro/CB/Expl section you missed on DOE",
         "Backup: re-read Tro/CB/Expl section only if stuck on a topic"),
        ("**Pass 2 level-up on Expl:**", "**Expl physics stretch topics:**"),
        ("| **Pass 1 — Mod** | **Pass 2 — Tro** |",
         "| **Hewitt (primary)** | **Mod (backup)** |"),
        ("*Expl chapters *(all passes — your student text)*",
         "*Expl chapters *(summer pass — your student text)*"),
        ("One **primary** book per 30-min block.",
         "One **primary** book per **1-hr** block — assigned **§ section** only."),
        ("Pass 3: if you open the book more than twice in one block, that topic stays on flash cards through fall",
         "Flash cards: if you need the book more than twice on one topic, keep it on cards through fall school meetings"),
    ]
    for old, new in prep_reps:
        text = text.replace(old, new)

    text = patch_chemistry_map_md(text)
    text = apply_book_picker_replacements(text)
    text = patch_prep_reading_guide_md(text)
    text = patch_all_week_titles(text)
    path.write_text(text)


def patch_prep_html(path: Path) -> None:
    text = path.read_text()
    start = text.find("<!-- PAGE 3 — READING GUIDE")
    end = text.find("<!-- PAGE 4 — TOPIC DEEP-DIVES")
    if start != -1 and end != -1:
        text = text[:start] + generate_prep_reading_guide_html() + "\n" + text[end:]

    text = re.sub(
        r"<div class=\"page-meta\">Pass 2 · Jul 6 – Jul 17 · Tro \+ CB \+ Expl<br>15 min DOE first → 15 min re-read if missed</div>",
        '<div class="page-meta">Weeks 5–6 · one summer pass · § sections · Full detail → summer-2026-calendar.md</div>',
        text,
    )
    text = re.sub(
        r"<div class=\"page-meta\">Pass 2 · Jul 20 – Jul 31 · regional difficulty<br>Pick 2 weak subtopics for Pass 3 after Week 8 mock</div>",
        '<div class="page-meta">Weeks 7–8 · one summer pass · § sections</div>',
        text,
    )
    text = re.sub(
        r"<div class=\"page-meta\">Pass 3 · Aug 3 – 14 · flash cards first<br>Bonus = 10 pts · 2–4 parts after toss-up</div>",
        '<div class="page-meta">Weeks 9–10 · capstone · flash cards at school meetings</div>',
        text,
    )
    text = text.replace(
        "<!-- PAGE 6 — TOPIC DEEP-DIVES WEEKS 5–6 (PASS 2) -->",
        "<!-- PAGE 6 — TOPIC DEEP-DIVES WEEKS 5–6 -->",
    )
    text = text.replace(
        "<!-- PAGE 7 — TOPIC DEEP-DIVES WEEKS 7–8 (PASS 2) -->",
        "<!-- PAGE 7 — TOPIC DEEP-DIVES WEEKS 7–8 -->",
    )
    text = text.replace(
        "<!-- PAGE 8 — WEEKS 9–10 + BONUS (PASS 3) -->",
        "<!-- PAGE 8 — WEEKS 9–10 + BONUS -->",
    )
    text = text.replace(
        "Weeks 1–4 = Pass 1 · Weeks 5–8 = Pass 2 · Weeks 9–10 = Pass 3",
        "Weeks 1–10 = one summer pass · Tro/CB backup · flash cards at school",
    )
    text = text.replace(
        "Weeks 1–4 Pass 1 · Weeks 5–8 Pass 2 (DOE first) · Weeks 9–10 Pass 3 (flash cards)",
        "Weeks 1–10 one summer pass · § sections · Tro/CB/FLS backup",
    )
    text = text.replace(
        "4-week rotation · Pass 1 (Jun) vs Pass 2 (Jul)",
        "10-week summer plan · one pass · § sections",
    )
    text = text.replace(
        "Pass 1 Jun · Pass 2 Jul · Pass 3 Aug",
        "One summer pass · Jun 8 – Aug 14",
    )
    text = text.replace(
        "Pass 1 bio · Tue &amp; Fri",
        "FLS primary · Tue &amp; Fri",
    )
    text = text.replace(
        "Pass 2–3 bio",
        "OSB/CB backup · bio",
    )
    text = text.replace(
        "Pass 2–3 chem",
        "Mod/Tro backup · chem",
    )
    text = text.replace(
        "Physics all passes · Wed",
        "Physics · Wed",
    )
    text = text.replace(
        "<tr><th>Pass</th><th>Dates</th><th>Biology</th><th>Chemistry</th></tr>\n        <tr><td><strong>1 Learn</strong></td><td>Jun 8 – Jul 3</td><td class=\"bio\"><strong>FLS</strong></td><td class=\"chem\"><strong>Mod</strong> + opt <strong>Expl</strong> chem</td></tr>\n        <tr><td><strong>2 Practice</strong></td><td>Jul 6 – Jul 31</td><td class=\"bio\"><strong>CB</strong> + DOE</td><td class=\"chem\"><strong>Tro</strong> + DOE + opt <strong>Expl</strong> chem</td></tr>\n        <tr><td><strong>3 Review</strong></td><td>Aug 3 – 14</td><td class=\"bio\"><strong>CB</strong> + <strong>FLS</strong> cards</td><td class=\"chem\"><strong>Tro</strong> + <strong>Mod</strong> cards</td></tr>",
        "<tr><th>Block</th><th>Biology</th><th>Chemistry</th><th>Physics</th></tr>\n        <tr><td><strong>Mon/Thu</strong></td><td>—</td><td class=\"chem\"><strong>Hewitt</strong> primary (Ch 17–24)</td><td>—</td></tr>\n        <tr><td><strong>Tue/Fri</strong></td><td class=\"bio\"><strong>FLS</strong> primary</td><td>—</td><td>—</td></tr>\n        <tr><td><strong>Wed</strong></td><td>—</td><td>—</td><td class=\"phys\"><strong>Hewitt</strong></td></tr>\n        <tr><td><strong>Backup</strong></td><td class=\"bio\"><strong>OSB</strong> · <strong>CB</strong> · <strong>BFN-Bio</strong></td><td class=\"chem\"><strong>Mod</strong> · <strong>Tro</strong> · <strong>BFN-Sci</strong></td><td class=\"phys\"><strong>BFN-Sci</strong></td></tr>",
    )
    text = text.replace(
        "<tr><th>Physics stage</th><th>Book</th><th>Pass 2 change</th></tr>\n        <tr><td>Primary (§)</td><td class=\"phys\"><strong>Expl</strong> Ch 1 · App. B · 2–4 · 6 · 10–13</td><td>Learn concepts</td></tr>\n        <tr><td>Backup</td><td class=\"phys\">Same + Ch 5 · 7 · 14</td><td>DOE first, re-read</td></tr>\n        <tr><td>Pass 3 (Aug)</td><td class=\"phys\">Flash cards → book if stuck</td><td>Review only</td></tr>",
        "<tr><th>Stage</th><th>Book</th><th>Notes</th></tr>\n        <tr><td>Primary (§)</td><td class=\"phys\"><strong>Hewitt</strong> Ch 1 · App. B · 2–4 · 6 · 10–13</td><td>Section splits · stop at Focus</td></tr>\n        <tr><td>Backup</td><td class=\"phys\"><strong>BFN-Sci</strong> · flash cards</td><td>If Hewitt section feels dense</td></tr>\n        <tr><td>School meetings</td><td class=\"phys\">Flash cards → book if stuck</td><td>Fall review</td></tr>",
    )
    text = patch_chemistry_map_html(text)
    text = text.replace(
        "Pass 1 chem · Mon &amp; Thu",
        "Hewitt primary · Mon/Thu chem",
    )
    html_reps = [
        ("30-min science block", "1-hr science block"),
        ("30 min science", "1 hr science"),
        ("Pass 1 = learn", "One summer pass — DOE topics"),
        ("Pass 2 = DOE", "Extra DOE → Quiz tab"),
        ("Pass 3 = flash", "Flash cards at school"),
        ("Pass 1 = textbook", "Primary = § sections"),
        ("whole chapter", "assigned § section"),
        ("one chapter in one day", "assigned § section per block"),
        ("FLS (Pass 1)", "FLS primary"),
        ("CB (Pass 2–3)", "OSB/CB backup"),
        ("Mod (Pass 1)", "Hewitt primary"),
        ("Tro (Pass 2–3)", "Mod/Tro backup"),
        ("Pass 1 (Jun)", "Primary (§)"),
        ("Pass 2 (Jul)", "Backup"),
        ("Weeks 1–4 = Pass 1 (Mod+FLS)", "Weeks 1–10 = one pass (Hewitt+FLS)"),
        ("Weeks 5–8 = Pass 2 (Tro+CB, DOE first)", "Mod/OSB/Tro/CB backup · DOE in Quiz tab"),
        ("Weeks 9–10 = Pass 3 (flash cards)", "Weeks 9–10 capstone · flash cards at school"),
        ("review Pass 1 gaps", "review weak § sections"),
        ("OSB/FLS primary", "FLS primary"),
        ("Mod primary · Mon &amp; Thu", "Hewitt primary · Mon/Thu chem"),
        ("Mod primary · Mon & Thu", "Hewitt primary · Mon/Thu chem"),
        ("Mod/Tro primary · optional <strong>Expl Ch 17–24</strong> parallel",
         "<strong>Hewitt</strong> Ch 17–24 primary · <strong>Mod/Tro</strong> backup"),
        ("<strong>OSB/FLS</strong> primary", "<strong>FLS</strong> primary"),
        ("<strong>Mod</strong> primary (+ opt <strong>Expl</strong> chem)",
         "<strong>Hewitt</strong> primary (+ <strong>Mod</strong> backup)"),
        ("class=\"phys\"><strong>Expl</strong></td>", "class=\"phys\"><strong>Hewitt</strong></td>"),
        ("Mod/Tro · Expl opt · BFN-Sci", "Hewitt · Mod/Tro backup · BFN-Sci"),
        ("Chemistry — 30 min<br><span style=\"font-size:7.5pt\">Mod/Tro · Expl opt · BFN-Sci</span>",
         "Chemistry — 1 hr<br><span style=\"font-size:7.5pt\">Hewitt · Mod/Tro backup · BFN-Sci</span>"),
        ("calendar says primary (Mod/Tro/FLS/CB/Expl/Lar)",
         "calendar says primary (Hewitt/FLS) — backups on picker table"),
    ]
    for old, new in html_reps:
        text = text.replace(old, new)
    text = text.replace(
        "<tr><td>Primary (§)</td><td class=\"phys\"><strong>Expl</strong> Ch 1 · App. B · 2–4 · 6 · 10–13</td>",
        "<tr><td>Primary (§)</td><td class=\"phys\"><strong>Hewitt</strong> Ch 1 · App. B · 2–4 · 6 · 10–13</td>",
    )
    text = text.replace(
        "<tr><td><strong>Backup</strong></td><td class=\"bio\"><strong>CB</strong> · <strong>BFN-Bio</strong></td>",
        "<tr><td><strong>Backup</strong></td><td class=\"bio\"><strong>OSB</strong> · <strong>CB</strong> · <strong>BFN-Bio</strong></td>",
    )
    text = text.replace(
        "<h3>Expl chapters — what you learn</h3>",
        "<h3>Hewitt chapters — what you learn</h3>",
    )
    # Fix prep book table rows after broad pass/replace substitutions.
    text = text.replace(
        '<tr class="chem"><td><strong>Mod</strong></td><td><em>Modern Chemistry</em> — 2012</td>'
        '<td>9780547586632</td><td>Hewitt primary · Mon/Thu chem</td></tr>',
        '<tr class="chem"><td><strong>Mod</strong></td><td><em>Modern Chemistry</em> — 2012</td>'
        '<td>9780547586632</td><td>Chemistry backup · Mon &amp; Thu</td></tr>',
    )
    text = text.replace(
        '<tr class="chem"><td><strong>Mod</strong></td><td><em>Modern Chemistry</em> — 2012</td>'
        '<td>9780547586632</td><td>Hewitt primary · Mon &amp; Thu</td></tr>',
        '<tr class="chem"><td><strong>Mod</strong></td><td><em>Modern Chemistry</em> — 2012</td>'
        '<td>9780547586632</td><td>Chemistry backup · Mon &amp; Thu</td></tr>',
    )
    text = text.replace(
        '<tr class="phys"><td><strong>Expl</strong></td><td><em>Conceptual Physical Science Explorations</em> — student text</td>'
        '<td>9780321567918</td><td>Physics · Wed</td></tr>',
        '<tr class="phys"><td><strong>Hewitt</strong></td><td><em>Conceptual Physical Science Explorations</em> — Hewitt student text</td>'
        '<td>9780321567918</td><td>Primary chem (Ch 17–24) · Wed physics</td></tr>',
    )
    text = text.replace(
        '<tr class="bio"><td><strong>CB</strong></td><td><em>Campbell Biology: C&amp;C</em> — 7th ed.</td>'
        '<td>9780321696816</td><td>CB backup · bio</td></tr>',
        '<tr class="bio"><td><strong>OSB</strong></td><td><em>OpenStax Biology 2e</em> — free online</td>'
        '<td>openstax.org</td><td>Biology backup · Tue &amp; Fri</td></tr>\n'
        '    <tr class="bio"><td><strong>CB</strong></td><td><em>Campbell Biology: C&amp;C</em> — 7th ed.</td>'
        '<td>9780321696816</td><td>Biology backup · deeper TAG</td></tr>',
    )
    for w, (_dates, theme) in WEEK_META.items():
        text = re.sub(
            rf'(<span class="week-tag">Week {w}</span>)[^<\n]*',
            rf'\1 {theme}',
            text,
        )
    text = apply_book_picker_replacements(text)
    text = patch_index_sections(text)
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

**Plan:** One careful read through **Hewitt + FLS** (50 science blocks). Mod/OSB/Tro/CB/BFN = backups. DOE practice in the app. Flash-card review at school Science Bowl meetings.

Regenerate bundled HTML in the Mac app:

```bash
python3 /Users/farah/Documents/FarahRasheed/ScienceBowlCoach/Scripts/sync_single_pass_schedule.py
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
