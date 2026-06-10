#!/usr/bin/env python3
"""Generate topic_readings.json for NSB encyclopedia topics.

Sources (no invented chapter numbers):
- Soha science-bowl-prep.md summer rotation (Mod/Tro/FLS/CB/Expl/Lar/BFN)
- summer-2026-trial OpenStax OSB mappings
- ScheduleBFNCatalog unit/chapter citations
- DOE Tips & Resources textbook names where chapters are not specified
"""

import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from expl_chapters_data import expl  # noqa: E402

OUT = Path(__file__).resolve().parents[1] / "Resources/StudyContent/topic_readings.json"

# Campbell Biology: Concepts & Connections, 7th Edition
CB_CH: dict[int, tuple[str, str]] = {
    1: ("Intro", "Biology: Exploring Life"),
    2: ("Unit I — The Life of the Cell", "The Chemical Basis of Life"),
    3: ("Unit I — The Life of the Cell", "The Molecules of Cells"),
    4: ("Unit I — The Life of the Cell", "A Tour of the Cell"),
    5: ("Unit I — The Life of the Cell", "The Working Cell"),
    6: ("Unit I — The Life of the Cell", "How Cells Harvest Chemical Energy"),
    7: ("Unit I — The Life of the Cell", "Photosynthesis: Using Light to Make Food"),
    8: ("Unit II — Cellular Reproduction and Genetics", "The Cellular Basis of Reproduction and Inheritance"),
    9: ("Unit II — Cellular Reproduction and Genetics", "Patterns of Inheritance"),
    10: ("Unit II — Cellular Reproduction and Genetics", "Molecular Biology of the Gene"),
    11: ("Unit II — Cellular Reproduction and Genetics", "How Genes Are Controlled"),
    12: ("Unit II — Cellular Reproduction and Genetics", "DNA Technology and Genomics"),
    13: ("Unit III — Concepts of Evolution", "How Populations Evolve"),
    14: ("Unit III — Concepts of Evolution", "The Origin of Species"),
    15: ("Unit III — Concepts of Evolution", "Tracing Evolutionary History"),
    16: ("Unit IV — The Evolution of Biological Diversity", "Microbial Life: Prokaryotes and Protists"),
    17: ("Unit IV — The Evolution of Biological Diversity", "The Evolution of Plant and Fungal Diversity"),
    18: ("Unit IV — The Evolution of Biological Diversity", "The Evolution of Invertebrate Diversity"),
    19: ("Unit IV — The Evolution of Biological Diversity", "The Evolution of Vertebrate Diversity"),
    20: ("Unit V — Animals: Form and Function", "Unifying Concepts of Animal Structure and Function"),
    21: ("Unit V — Animals: Form and Function", "Nutrition and Digestion"),
    22: ("Unit V — Animals: Form and Function", "Gas Exchange"),
    23: ("Unit V — Animals: Form and Function", "Circulation"),
    24: ("Unit V — Animals: Form and Function", "The Immune System"),
    25: ("Unit V — Animals: Form and Function", "Control of Body Temperature and Water Balance"),
    26: ("Unit V — Animals: Form and Function", "Hormones and the Endocrine System"),
    27: ("Unit V — Animals: Form and Function", "Reproduction and Embryonic Development"),
    28: ("Unit V — Animals: Form and Function", "Nervous Systems"),
    29: ("Unit V — Animals: Form and Function", "The Senses"),
    30: ("Unit V — Animals: Form and Function", "How Animals Move"),
    31: ("Unit VI — Plants: Form and Function", "Plant Structure, Growth, and Reproduction"),
    32: ("Unit VI — Plants: Form and Function", "Plant Nutrition and Transport"),
    33: ("Unit VI — Plants: Form and Function", "Control Systems in Plants"),
    34: ("Unit VII — Ecology", "The Biosphere: An Introduction to Earth's Diverse Environments"),
    35: ("Unit VII — Ecology", "Behavioral Adaptations to the Environment"),
    36: ("Unit VII — Ecology", "Population Ecology"),
    37: ("Unit VII — Ecology", "Communities and Ecosystems"),
    38: ("Unit VII — Ecology", "Conservation Biology"),
}


def cb(*parts: str) -> str:
    """Format Campbell 7e refs: cb('4'), cb('6', '7'), cb('16', '24')."""
    numbers: list[int] = []
    for part in parts:
        normalized = part.replace("Ch ", "").strip()
        if "–" in normalized or "-" in normalized:
            sep = "–" if "–" in normalized else "-"
            start, end = normalized.split(sep, 1)
            numbers.extend(range(int(start), int(end) + 1))
        else:
            numbers.append(int(normalized))
    labels = []
    for n in numbers:
        unit, title = CB_CH[n]
        labels.append(f"{unit} · Ch {n} — {title}")
    return " · ".join(labels)


# Prentice Hall Science Explorer: Focus on Life Science (California Edition)
FLS_CH: dict[int, tuple[str, str]] = {
    1: ("Unit 1 — Cell Biology and Genetics", "Cell Structure and Function"),
    2: ("Unit 1 — Cell Biology and Genetics", "Cell Processes and Energy"),
    3: ("Unit 1 — Cell Biology and Genetics", "Genetics: The Science of Heredity"),
    4: ("Unit 1 — Cell Biology and Genetics", "Modern Genetics"),
    5: ("Unit 2 — Evolution and Earth's History", "Evolution"),
    6: ("Unit 2 — Evolution and Earth's History", "Earth's History"),
    7: ("Unit 3 — Structure and Function in Living Things", "Living Things"),
    8: ("Unit 3 — Structure and Function in Living Things", "Viruses and Bacteria"),
    9: ("Unit 3 — Structure and Function in Living Things", "Protists and Fungi"),
    10: ("Unit 3 — Structure and Function in Living Things", "Introduction to Plants"),
    11: ("Unit 3 — Structure and Function in Living Things", "Seed Plants"),
    12: ("Unit 3 — Structure and Function in Living Things", "Sponges, Cnidarians, and Worms"),
    13: ("Unit 3 — Structure and Function in Living Things", "Mollusks, Arthropods, and Echinoderms"),
    14: ("Unit 3 — Structure and Function in Living Things", "Fishes, Amphibians, and Reptiles"),
    15: ("Unit 3 — Structure and Function in Living Things", "Birds and Mammals"),
    16: ("Unit 4 — Human Body Systems", "Healthy Body Systems"),
    17: ("Unit 4 — Human Body Systems", "Bones, Muscles, and Skin"),
    18: ("Unit 4 — Human Body Systems", "Food and Digestion"),
    19: ("Unit 4 — Human Body Systems", "Circulation"),
    20: ("Unit 4 — Human Body Systems", "Respiration and Excretion"),
    21: ("Unit 4 — Human Body Systems", "Fighting Disease"),
    22: ("Unit 4 — Human Body Systems", "The Nervous System"),
    23: ("Unit 4 — Human Body Systems", "The Endocrine System and Reproduction"),
}


def fls(*parts: str) -> str:
    numbers: list[int] = []
    for part in parts:
        normalized = part.replace("Ch ", "").strip()
        if "–" in normalized or "-" in normalized:
            sep = "–" if "–" in normalized else "-"
            start, end = normalized.split(sep, 1)
            numbers.extend(range(int(start), int(end) + 1))
        else:
            numbers.append(int(normalized))
    labels = []
    for n in numbers:
        unit, title = FLS_CH[n]
        labels.append(f"{unit} · Ch {n} — {title}")
    return " · ".join(labels)

# bookCode, label, role: primary | pass1 | pass2 | alsoOK | backup | doe

def R(book, label, role="primary"):
    return {"bookCode": book, "label": label, "role": role}

READINGS: dict[str, list] = {}

def set_topic(tid, *lines):
    READINGS[tid] = list(lines)

# --- Life Science (OSB primary from trial + FLS/CB from prep) ---
set_topic("ls-photosynthesis",
    R("FLS", fls("2"), "primary"),
    R("OSB", "Ch 5 — Photosynthesis", "pass2"),
    R("CB", cb("6", "7"), "pass2"),
    R("BFN-Bio", "U3 · Ch 11 Photosynthesis · p103", "backup"),
)
set_topic("ls-cell-organelles",
    R("FLS", fls("1"), "primary"),
    R("OSB", "Ch 3 — Cell Structure and Function", "pass2"),
    R("CB", cb("4"), "pass2"),
    R("BFN-Bio", "U3 · Ch 9 Cell Structure · p84", "backup"),
)
set_topic("ls-cell-processes",
    R("FLS", fls("1"), "primary"),
    R("OSB", "Ch 3 — Cell membrane · transport", "pass2"),
    R("CB", cb("5"), "pass2"),
    R("BFN-Bio", "U3 · Ch 9–10 Cell structure · ATP · p84", "backup"),
)
set_topic("ls-cell-division",
    R("FLS", fls("2"), "primary"),
    R("OSB", "Ch 10 — Cell division (mitosis/meiosis intro)", "pass2"),
    R("CB", cb("8"), "pass2"),
    R("BFN-Bio", "U3 · Ch 13–14 Mitosis · Meiosis · p115", "backup"),
)
set_topic("ls-cellular-respiration",
    R("FLS", fls("2"), "primary"),
    R("OSB", "Ch 4–5 — Cellular respiration", "pass2"),
    R("CB", cb("6"), "pass2"),
    R("BFN-Bio", "U3 · Ch 12 Cellular Respiration · p103", "backup"),
)
set_topic("ls-dna-rna",
    R("FLS", fls("3"), "primary"),
    R("OSB", "Ch 8 — DNA structure and replication", "pass2"),
    R("CB", cb("10"), "pass2"),
    R("BFN-Bio", "U10 · Ch 45 DNA and RNA · p413", "backup"),
)
set_topic("ls-genetics",
    R("FLS", fls("3", "4"), "primary"),
    R("OSB", "Ch 7–8 — Genetics · inheritance", "alsoOK"),
    R("CB", cb("9"), "alsoOK"),
    R("BFN-Bio", "U10 · Ch 44 Introduction to Genetics · p413", "backup"),
)
set_topic("ls-mutations",
    R("FLS", fls("4"), "primary"),
    R("CB", cb("10"), "pass2"),
    R("BFN-Bio", "U10 · Ch 46 Genetic engineering · p413", "backup"),
)
set_topic("ls-evolution",
    R("FLS", fls("5", "6"), "primary"),
    R("OSB", "Ch 11–12 — Evolution", "alsoOK"),
    R("CB", cb("13", "14"), "alsoOK"),
    R("BFN-Bio", "U11 · Ch 47 Evolution · p451", "backup"),
)
set_topic("ls-classification",
    R("FLS", fls("7"), "primary"),
    R("OSB", "Ch 11 — Classification", "pass2"),
    R("CB", cb("15", "18"), "pass2"),
    R("BFN-Bio", "U11 · Ch 47–48 History of Life · p451", "backup"),
)
set_topic("ls-bacteria-viruses",
    R("FLS", fls("8"), "primary"),
    R("OSB", "Ch 13 — Microorganisms", "pass2"),
    R("CB", cb("16"), "pass2"),
    R("BFN-Bio", "U4 · Ch 15 Bacteria · Ch 16 Viruses · p141", "backup"),
)
set_topic("ls-fungi-protists",
    R("FLS", fls("9"), "primary"),
    R("CB", cb("16", "17"), "pass2"),
    R("BFN-Bio", "U4–6 · Protists · Fungi · p141", "backup"),
)
set_topic("ls-plant-biology",
    R("FLS", fls("10", "11"), "primary"),
    R("OSB", "Ch 14–15 — Plants", "alsoOK"),
    R("CB", cb("31"), "alsoOK"),
    R("BFN-Bio", "U7 · Ch 26–28 Plant kingdom · p229", "backup"),
)
for tid, fls_label, cb_label, bfn in [
    ("ls-circulatory", fls("19"), cb("23"), "U9 · Ch 40 Respiratory/Circulatory · p325"),
    ("ls-respiratory", fls("20"), cb("22"), "U9 · Ch 40 Respiratory · p325"),
    ("ls-digestive", fls("18"), cb("21"), "U9 · Ch 41 Digestive · p325"),
    ("ls-nervous", fls("22"), cb("28"), "U9 · Ch 36 Body Systems · p325"),
    ("ls-endocrine", fls("23"), cb("26"), "U9 · Ch 36–43 Body systems · p325"),
    ("ls-immune", fls("21"), cb("24"), "U4 · Ch 18 Disease · p141"),
    ("ls-skeletal-muscular", fls("17"), cb("20", "30"), "U9 · Ch 36 Body Systems · p325"),
    ("ls-reproductive", fls("23"), cb("27"), "U9 · Ch 43 Reproductive · p325"),
]:
    set_topic(tid,
        R("FLS", fls_label, "primary"),
        R("CB", cb_label, "pass2"),
        R("BFN-Bio", bfn, "backup"),
    )
set_topic("ls-ecology",
    R("FLS", fls("7"), "primary"),
    R("OSB", "Ch 19–20 — Ecology · ecosystems", "pass2"),
    R("CB", cb("36", "37"), "pass2"),
    R("BFN-Bio", "U12 · Ch 49 The Ecosystem · p483", "backup"),
)
set_topic("ls-biomes",
    R("FLS", fls("7"), "primary"),
    R("CB", cb("34"), "pass2"),
    R("BFN-Bio", "U12 · Ch 49–50 Ecosystems · p483", "backup"),
)
set_topic("ls-population-ecology",
    R("FLS", fls("7"), "primary"),
    R("CB", cb("36"), "pass2"),
    R("BFN-Bio", "U12 · Ch 50 Populations · p483", "backup"),
)
set_topic("ls-symbiosis",
    R("FLS", fls("7"), "primary"),
    R("CB", cb("37"), "pass2"),
    R("BFN-Bio", "U12 · Ch 49 Ecosystem interactions · p483", "backup"),
)
set_topic("ls-biodiversity",
    R("FLS", fls("7"), "primary"),
    R("CB", cb("38"), "pass2"),
    R("BFN-Bio", "U12 · Ch 49–50 · p483", "backup"),
)

# --- Chemistry (Mod/Tro/Expl from prep rotation) ---
set_topic("ch-atomic-structure",
    R("Mod", "Ch 3 — Atoms: The Building Blocks of Matter", "pass2"),
    R("Tro", "Ch 4 §4.3–4.6 — Atoms · atomic structure", "pass2"),
    R("Expl", expl("17"), "primary"),
    R("BFN-Sci", "U2 · Ch 7 Periodic Table · p59", "backup"),
)
set_topic("ch-periodic-table",
    R("Mod", "Ch 5 — The Periodic Law", "pass2"),
    R("Tro", "Ch 4 · Ch 9 §9.7 · §9.9 — Periodic table · trends", "pass2"),
    R("Expl", expl("17"), "primary"),
    R("BFN-Sci", "U2 · Ch 7 · p59", "backup"),
)
set_topic("ch-elements-compounds",
    R("Mod", "Ch 5 + Ch 7 intro — Periodic law · formulas", "pass2"),
    R("Tro", "Ch 4 §4.7–4.8 + Ch 5 — Ions · compounds", "pass2"),
    R("Expl", expl("17–18"), "primary"),
)
set_topic("ch-chemical-bonds",
    R("Mod", "Ch 7 — Chemical formulas · bonding intro", "pass2"),
    R("Tro", "Ch 5 — Chemical bonding", "pass2"),
    R("Expl", expl("18"), "primary"),
)
set_topic("ch-chemical-reactions",
    R("Mod", "Ch 8 — Chemical Equations and Reactions", "pass2"),
    R("Tro", "Ch 7 §7.1–7.4 — Chemical reactions", "pass2"),
    R("Expl", expl("20–21"), "primary"),
)
set_topic("ch-reaction-types",
    R("Mod", "Ch 8 — Reaction types", "pass2"),
    R("Tro", "Ch 7 — Reaction types", "pass2"),
    R("Expl", expl("21"), "primary"),
)
set_topic("ch-acids-bases",
    R("Mod", "Ch 14 — Acids and Bases", "pass2"),
    R("Tro", "Ch 14 — Acids and bases", "pass2"),
    R("Expl", expl("21"), "primary"),
    R("BFN-Sci", "U2 · Ch 6–8 Matter · Solutions · p59", "backup"),
)
set_topic("ch-solutions",
    R("Mod", "Ch 12 — Solutions", "pass2"),
    R("Tro", "Ch 13 — Solutions", "pass2"),
    R("Expl", expl("19"), "primary"),
    R("BFN-Sci", "U2 · Ch 8 Solutions · p59", "backup"),
)
set_topic("ch-states-matter",
    R("Mod", "Ch 10 — States of Matter", "pass2"),
    R("Tro", "Ch 3 — Matter and Energy", "pass2"),
    R("Expl", expl("17–19"), "primary"),
    R("BFN-Sci", "U2 · Ch 6 Matter · Phases · p59", "backup"),
)
set_topic("ch-mole",
    R("Tro", "Ch 9 · Ch 13 — Moles · molarity", "pass2"),
    R("Mod", "Ch 12 — Solutions (concentration)", "pass2"),
)
set_topic("ch-redox",
    R("Tro", "Ch 7 — Oxidation-reduction (intro)", "pass2"),
    R("Mod", "Ch 8 — Redox (if in edition)", "pass2"),
)
set_topic("ch-organic",
    R("Expl", expl("22"), "primary"),
    R("Tro", "Ch 22 — Organic (stretch)", "pass2"),
)
set_topic("ch-nuclear-chem",
    R("Tro", "Ch 3 — Nuclear (intro if covered)", "pass2"),
    R("BFN-Sci", "U2 · Ch 6–7 · p59", "backup"),
)

# --- Physical Science (Expl primary) ---
set_topic("ps-scientific-method",
    R("Expl", expl("1"), "primary"),
    R("Mod", "Ch 2 — Measurements (lab skills)", "alsoOK"),
    R("BFN-Sci", "U1 · Ch 1–5 Scientific thinking · lab tools · p1", "backup"),
)
set_topic("ps-motion",
    R("Expl", expl("1 + App. B"), "primary"),
    R("BFN-Sci", "U3 · Ch 9 Motion · p91", "backup"),
)
set_topic("ps-newtons-laws",
    R("Expl", expl("2–4"), "primary"),
    R("BFN-Sci", "U3 · Ch 10–11 Forces · p91", "backup"),
)
set_topic("ps-forces",
    R("Expl", expl("2–4"), "primary"),
    R("BFN-Sci", "U3 · Ch 10 Force · p91", "backup"),
)
set_topic("ps-momentum",
    R("Expl", expl("5"), "primary"),
    R("BFN-Sci", "U3 · Ch 10–11 · p91", "backup"),
)
set_topic("ps-work-energy-power",
    R("Expl", expl("6"), "primary"),
    R("BFN-Sci", "U3–4 · Ch 12 Work · Ch 13 Energy · p91", "backup"),
)
set_topic("ps-kinetic-potential",
    R("Expl", expl("6"), "primary"),
    R("BFN-Sci", "U4 · Ch 13 Forms of Energy · p129", "backup"),
)
set_topic("ps-simple-machines",
    R("Expl", expl("6"), "primary"),
    R("BFN-Sci", "U3 · Ch 12 Work and Machines · p91", "backup"),
)
set_topic("ps-waves",
    R("Expl", expl("12"), "primary"),
    R("BFN-Sci", "U4 · Ch 15 Light and Sound · p129", "backup"),
)
set_topic("ps-sound",
    R("Expl", expl("12"), "primary"),
    R("BFN-Sci", "U4 · Ch 15 · p129", "backup"),
)
set_topic("ps-light",
    R("Expl", expl("13"), "primary"),
    R("BFN-Sci", "U4 · Ch 15 · p129", "backup"),
)
set_topic("ps-reflection-refraction",
    R("Expl", expl("13"), "primary"),
)
set_topic("ps-optics",
    R("Expl", expl("14"), "primary"),
)
set_topic("ps-electricity",
    R("Expl", expl("10"), "primary"),
    R("BFN-Sci", "U4 · Ch 16 Electricity · p129", "backup"),
)
set_topic("ps-circuits",
    R("Expl", expl("10"), "primary"),
    R("BFN-Sci", "U4 · Ch 16 · p129", "backup"),
)
set_topic("ps-magnetism",
    R("Expl", expl("11"), "primary"),
    R("BFN-Sci", "U4 · Ch 16 Electricity and Magnetism · p129", "backup"),
)
set_topic("ps-thermodynamics",
    R("Expl", expl("9"), "primary"),
    R("BFN-Sci", "U4 · Ch 14 Heat · p129", "backup"),
)
set_topic("ps-states-of-matter",
    R("Mod", "Ch 10 — States of Matter", "alsoOK"),
    R("Expl", expl("17"), "alsoOK"),
    R("BFN-Sci", "U2 · Ch 6 · p59", "backup"),
)
set_topic("ps-pressure-fluids",
    R("Expl", expl("8"), "primary"),
    R("BFN-Sci", "U2 · Ch 8 Solutions and Fluids · p59", "backup"),
)
set_topic("ps-nuclear",
    R("Expl", expl("16"), "alsoOK"),
    R("Tro", "Ch 3 — Nuclear (stretch)", "alsoOK"),
)

# --- Math (OSA primary trial + Lar/BFN from prep) ---
MATH = {
    "math-pemdas": [R("OSA", "§1.1 — Real numbers · order of operations", "primary"), R("Lar", "Ch 2 — Estimation · PEMDAS", "alsoOK"), R("BFN-A", "U1 · Ch 1–3 Order of Operations · p1", "backup")],
    "math-fractions": [R("OSA", "§1.1 — Fractions · decimals · percent", "primary"), R("Lar", "Ch 2 — Percent · decimals", "alsoOK"), R("BFN-A", "U2–U3 · p23", "backup")],
    "math-ratios": [R("OSA", "§5.8 — Ratios · proportions", "primary"), R("Lar", "Ch 2–3 — Ratios · proportions", "alsoOK"), R("BFN-A", "U3 · Ch 11–18 · p75", "backup")],
    "math-exponents": [R("OSA", "§1.2 · §6.1 — Exponents · scientific notation", "primary"), R("Lar", "Ch 8 §8.1–8.4", "alsoOK"), R("BFN-A", "U4 · Ch 19–20 · p141", "backup")],
    "math-word-problems": [R("OSA", "§2.3 — Models and applications", "primary"), R("Lar", "Ch 1–2 — Unit conversion", "alsoOK"), R("BFN-A", "U2–U3 · p23", "backup")],
    "math-linear-eq": [R("OSA", "§2.3 · §4.1 — Linear equations", "primary"), R("Lar", "Ch 3 — Solving linear equations", "alsoOK"), R("BFN-A", "U5 · Ch 24–30 · p175", "backup")],
    "math-functions": [R("OSA", "§4.1 — Linear functions", "primary"), R("Lar", "Ch 4 — Graphing functions", "alsoOK"), R("BFN-A", "U8 · Ch 45–47 · p395", "backup")],
    "math-data-graphs": [R("OSA", "§2.1 · §3.3 — Graphs · slope", "primary"), R("Lar", "Ch 4 — Graph reading", "alsoOK"), R("BFN-A", "U6 · Ch 31–38 · p247", "backup")],
    "math-coordinate": [R("OSA", "§2.1 — Coordinate systems", "primary"), R("Lar", "Ch 4", "alsoOK"), R("BFN-A", "U6 · p247", "backup")],
    "math-probability": [R("OSA", "§13.7 — Probability", "primary"), R("Lar", "Ch 13 — Probability · logic", "alsoOK"), R("BFN-A", "U7 · Ch 39–44 · p325", "backup")],
    "math-statistics": [R("OSA", "§13.7 — Statistics intro", "primary"), R("Lar", "Ch 13", "alsoOK"), R("BFN-A", "U7 · p325", "backup")],
    "math-geom-angles": [R("OSA", "§7.1 — Angles · triangles (intro)", "primary"), R("Lar", "Ch 11 — Geometry connections", "alsoOK")],
    "math-pythagorean": [R("OSA", "§7.3 — Pythagorean theorem", "primary"), R("Lar", "Ch 11", "alsoOK")],
    "math-roots": [R("OSA", "§1.3 — Radicals", "primary"), R("Lar", "Ch 11 §11.1 — Square roots", "alsoOK"), R("BFN-A", "U11 · Ch 57–60 · p505", "backup")],
    "math-systems": [R("OSA", "§7.1 — Systems (intro)", "primary"), R("BFN-A", "U5 · systems · p175", "backup")],
    "math-algebra-expressions": [R("OSA", "§1.1 — Expressions", "primary"), R("BFN-A", "U4 · Ch 21–23 · p141", "backup")],
    "math-number-theory": [R("OSA", "§1.1 — Integers · real numbers", "primary"), R("Lar", "Ch 2", "alsoOK"), R("BFN-A", "U2 · p23", "backup")],
    "math-geom-polygons": [R("OSA", "§7.1 — Area · polygons", "primary")],
    "math-geom-circles": [R("OSA", "§7.1 — Circles", "primary")],
    "math-geom-3d": [R("OSA", "§7.1 — 3D shapes · volume", "primary")],
    "math-sequences": [R("OSA", "§9.1 — Sequences (intro)", "primary")],
}
for tid, lines in MATH.items():
    set_topic(tid, *lines)

# --- Earth & Space (DOE textbooks — index lookup; BFN-Sci where mapped) ---
EARTH_DOE = "Heath Earth Science · Glencoe Earth Science · Tarbuck & Lutgens Foundations of Earth Science"
SPACE_DOE = "Seeds Foundations of Astronomy · Glencoe Earth Science"
earth_topics = {
    "es-earths-layers": ("Earth's interior · layers", expl("26"), "U6 · Ch 21–24 Earth structure · p219"),
    "es-plate-tectonics": ("Plate tectonics", expl("27"), "U6 · geology · p219"),
    "es-earthquakes": ("Earthquakes · seismic waves", expl("26"), "U6 · p219"),
    "es-volcanoes": ("Volcanoes", expl("27"), "U6 · p219"),
    "es-rock-cycle": ("Rocks · rock cycle", expl("25"), "U6 · p219"),
    "es-minerals": ("Minerals", expl("25"), "U6 · p219"),
    "es-weathering": ("Weathering · erosion", expl("28"), "U6 · p219"),
    "es-soil": ("Soil formation", expl("28"), "U6 · p219"),
    "es-water-cycle": ("Water cycle", expl("28", "30"), "U6 · Ch 25–27 Weather · p259"),
    "es-oceans": ("Oceans", expl("30"), "U6 · p219"),
    "es-weather": ("Weather · atmosphere", expl("30", "31"), "U6 · Ch 25–27 · p259"),
    "es-weather-systems": ("Weather systems", expl("31"), "U6 · Ch 25–27 · p259"),
    "es-climate": ("Climate · climate change", expl("30"), "U6 · Ch 27 Climate · p259"),
    "es-solar-system": ("Solar system", expl("32"), "U5 · Ch 17–20 · p179"),
    "es-sun": ("The Sun", expl("32"), "U5 · Ch 18 The Sun · p179"),
    "es-stars": ("Stars · life cycles", expl("33"), "U5 · Ch 19 Stars · p179"),
    "es-galaxies": ("Galaxies · universe", expl("34"), "U5 · Ch 20 Galaxies · p179"),
    "es-moon": ("Earth's Moon", expl("32"), "U5 · Ch 17 Solar system · p179"),
    "es-space-exploration": ("Space exploration", expl("32"), "U5 · space units · p179"),
    "es-time-seasons": ("Earth rotation · seasons", expl("32"), "U5–U6 · Earth in space · p179"),
}
for tid, (index_hint, expl_label, bfn) in earth_topics.items():
    set_topic(tid,
        R("DOE-ESS", f"{EARTH_DOE} — index: {index_hint}", "primary"),
        R("Expl", expl_label, "alsoOK"),
        R("BFN-Sci", bfn, "backup"),
    )

# --- Energy (DOE labs + Expl/BFN) ---
energy_topics = {
    "en-forms": ("Forms of energy", expl("6"), "U4 · Ch 13 · p129"),
    "en-conservation": ("Conservation of energy", expl("6"), "U4 · Ch 13 · p129"),
    "en-fossil": ("Fossil fuels", expl("6"), "U4 · energy sources · p129"),
    "en-nuclear": ("Nuclear energy", expl("16"), "U4 · p129"),
    "en-solar": ("Solar energy", expl("6"), "U4 · p129"),
    "en-wind": ("Wind energy", expl("6"), "U4 · p129"),
    "en-hydro": ("Hydroelectric power", expl("6"), "U4 · p129"),
    "en-geothermal": ("Geothermal energy", expl("6"), "U4 · p129"),
    "en-biomass": ("Biomass · biofuels", expl("6"), "U7 · metabolism tie-in · p291"),
    "en-efficiency": ("Energy efficiency", expl("6"), "U4 · p129"),
    "en-grid": ("Electric grid", expl("10"), "U4 · Ch 16 · p129"),
    "en-doe-policy": ("DOE · U.S. energy policy", None, None),
    "en-climate-energy": ("Climate change · energy", expl("30"), "U6 · climate · p259"),
}
for tid, (hint, expl_label, bfn) in energy_topics.items():
    lines = [R("DOE-Energy", "DOE National Laboratory websites (Tips & Resources)", "primary")]
    if expl_label:
        lines.append(R("Expl", expl_label, "alsoOK"))
    if bfn:
        lines.append(R("BFN-Sci", bfn, "backup"))
    if tid == "en-doe-policy":
        lines = [R("DOE-Energy", "energy.gov · DOE National Laboratory websites", "primary")]
    set_topic(tid, *lines)

# --- Texas Regional Sprint (Quiz tab packs) ---
set_topic("ls-reg-resp-photosyn",
    R("FLS", fls("2"), "primary"),
    R("OSB", "Ch 5 — Photosynthesis", "alsoOK"),
    R("CB", cb("6", "7"), "alsoOK"),
)
set_topic("ls-reg-genetics",
    R("FLS", fls("3", "4"), "primary"),
    R("CB", cb("10", "11"), "alsoOK"),
)
set_topic("ls-reg-anatomy",
    R("FLS", fls("16", "17", "18", "19", "20"), "primary"),
    R("CB", cb("20", "28"), "alsoOK"),
)
set_topic("ls-reg-phyla",
    R("FLS", fls("12", "13", "14", "15"), "primary"),
    R("CB", cb("18", "19"), "alsoOK"),
)
set_topic("ch-reg-nomenclature",
    R("Expl", expl("17–18"), "primary"),
    R("Mod", "Ch 7 — Chemical formulas", "alsoOK"),
    R("Tro", "Ch 5 — Nomenclature · ions", "alsoOK"),
)
set_topic("ch-reg-trends",
    R("Expl", expl("17"), "primary"),
    R("Mod", "Ch 5 — Periodic law & trends", "alsoOK"),
    R("Tro", "Ch 4 — Periodic properties", "alsoOK"),
)
set_topic("ch-reg-gas-laws",
    R("Expl", expl("17–19"), "primary"),
    R("Tro", "Ch 9 — Gases", "alsoOK"),
    R("Mod", "Ch 10 — States of matter", "alsoOK"),
)
set_topic("ch-reg-acids",
    R("Expl", expl("21"), "primary"),
    R("Tro", "Ch 14 — Acids & bases", "alsoOK"),
    R("Mod", "Ch 14 — Acids & bases", "alsoOK"),
)
set_topic("ps-reg-kinematics",
    R("Expl", expl("1 + App. B"), "primary"),
    R("Expl", expl("2"), "alsoOK"),
)
set_topic("ps-reg-forces",
    R("Expl", expl("2–4"), "primary"),
    R("Expl", expl("5"), "alsoOK"),
)
set_topic("ps-reg-waves",
    R("Expl", expl("12", "13"), "primary"),
)

def main():
    import json
    from pathlib import Path
    all_ids = []
    with open(Path(__file__).resolve().parents[1] / "Resources/StudyContent/topics.json") as f:
        all_ids = [t["id"] for t in json.load(f)]
    missing = [i for i in all_ids if i not in READINGS]
    if missing:
        raise SystemExit(f"Missing readings for {len(missing)} topics: {missing[:5]}...")
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(READINGS, indent=2, ensure_ascii=False) + "\n")
    print(f"Wrote {len(READINGS)} topics to {OUT}")

if __name__ == "__main__":
    main()
