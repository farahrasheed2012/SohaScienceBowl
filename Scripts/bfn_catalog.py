"""Big Fat Notebook citations — mirrors Data/ScheduleBFNCatalog.swift."""

from __future__ import annotations

from typing import NamedTuple


class BfnCitation(NamedTuple):
    unit: str
    chapters: str
    pages: str

    @property
    def short_line(self) -> str:
        return f"{self.unit} · {self.chapters} · {self.pages}"


BFN_FALLBACK_SCI = BfnCitation("See index", "Match today's topic in BFN-Sci", "p1")
BFN_FALLBACK_BIO = BfnCitation("See index", "Match today's topic in BFN-Bio", "p483")
BFN_FALLBACK_ALG = BfnCitation("See index", "Match today's math topic in BFN-A", "p1")

# NSB topic key per science block (week, day_idx) — matches SeedData sampleTossups.topic
SCIENCE_BFN_TOPIC: dict[tuple[int, int], str] = {
    (1, 0): "Atoms & periodic table",
    (1, 1): "Cell structure",
    (1, 2): "About Science + Motion",
    (1, 3): "Elements & ions",
    (1, 4): "Cell energy & organization",
    (2, 0): "States of matter",
    (2, 1): "Genetics",
    (2, 2): "Forces & Newton's laws",
    (2, 3): "Chemical reactions",
    (2, 4): "Genetics",
    (3, 0): "Acids, bases & pH",
    (3, 1): "Ecology",
    (3, 2): "Forces & Newton's laws",
    (3, 3): "Solutions",
    (3, 4): "Human body systems",
    (4, 0): "Periodic trends & elements",
    (4, 1): "Evolution & classification",
    (4, 2): "Waves",
    (4, 3): "Lab & equipment",
    (4, 4): "Evolution & classification",
    (5, 0): "Chemical bonding",
    (5, 1): "Photosynthesis & respiration",
    (5, 2): "Work & energy",
    (5, 3): "Stoichiometry",
    (5, 4): "Photosynthesis & respiration",
    (6, 0): "Solutions",
    (6, 1): "Ecology",
    (6, 2): "Work & energy",
    (6, 3): "Acids, bases & pH",
    (6, 4): "Microorganisms & disease",
    (7, 0): "Chemical reactions",
    (7, 1): "Microorganisms & disease",
    (7, 2): "Forces & momentum",
    (7, 3): "Periodic trends & elements",
    (7, 4): "Plants & animals",
    (8, 0): "Lab & equipment",
    (8, 1): "Plants & animals",
    (8, 2): "Electricity",
    (8, 3): "States of matter",
    (8, 4): "Plants & animals",
    (9, 0): "Atoms & periodic table",
    (9, 1): "Cell structure",
    (9, 2): "Waves & electricity",
    (9, 3): "Ions & compounds",
    (9, 4): "Human body systems",
    (10, 0): "Atoms & periodic table",
    (10, 1): "Cell structure",
    (10, 2): "Electricity",
    (10, 3): "Lab & equipment",
    (10, 4): "Ecology",
}

BFN_SCI_BY_TOPIC: dict[str, BfnCitation] = {
    "Atoms & periodic table": BfnCitation("Unit 2", "Ch 7 Periodic Table, Atomic Structure, and Compounds", "p59"),
    "Atoms review": BfnCitation("Unit 2", "Ch 6–7 Matter · Atoms · Periodic table", "p59"),
    "Elements & ions": BfnCitation("Unit 2", "Ch 7 Periodic Table and Compounds", "p59"),
    "Ions & compounds": BfnCitation("Unit 2", "Ch 7 Atomic Structure and Compounds", "p59"),
    "Compounds review": BfnCitation("Unit 2", "Ch 7 Compounds · Ch 8 Solutions", "p59"),
    "Chemical bonding": BfnCitation("Unit 2", "Ch 7 Atomic Structure and Compounds", "p59"),
    "States of matter": BfnCitation("Unit 2", "Ch 6 Matter, Properties, and Phases", "p59"),
    "Chemical reactions": BfnCitation("Unit 2", "Ch 6–8 Matter · Solutions · Chemical change", "p59"),
    "Stoichiometry": BfnCitation("Unit 2", "Ch 8 Solutions and Fluids · Molarity intro", "p59"),
    "Acids, bases & pH": BfnCitation("Unit 2", "Ch 6–8 Matter and Solutions", "p59"),
    "Acids review": BfnCitation("Unit 2", "Ch 6–8 Matter · Solutions", "p59"),
    "Solutions": BfnCitation("Unit 2", "Ch 8 Solutions and Fluids", "p59"),
    "Solutions review": BfnCitation("Unit 2", "Ch 8 Solutions and Fluids", "p59"),
    "Periodic trends & elements": BfnCitation("Unit 2", "Ch 7 Periodic Table and Atomic Structure", "p59"),
    "Periodic trends & lab": BfnCitation("Unit 1", "Ch 3–5 Lab reports · SI units · Lab tools", "p1"),
    "Lab & equipment": BfnCitation("Unit 1", "Ch 4–5 SI Units · Lab Safety and Scientific Tools", "p1"),
    "About Science + Motion": BfnCitation("Unit 3", "Ch 1–2 Scientific thinking · Ch 9 Motion", "p1 · p91"),
    "Motion": BfnCitation("Unit 3", "Ch 9 Motion", "p91"),
    "Motion review": BfnCitation("Unit 3", "Ch 9 Motion · Ch 10 Force", "p91"),
    "Forces & Newton's laws": BfnCitation("Unit 3", "Ch 10 Force and Newton's Laws · Ch 11 Gravity and Friction", "p91"),
    "Forces & momentum": BfnCitation("Unit 3", "Ch 10–11 Forces · Newton's laws", "p91"),
    "Work & energy": BfnCitation("Unit 3–4", "Ch 12 Work and Machines · Ch 13 Forms of Energy", "p91 · p129"),
    "Waves": BfnCitation("Unit 4", "Ch 15 Light and Sound", "p129"),
    "Waves & electricity": BfnCitation("Unit 4", "Ch 15 Light and Sound · Ch 16 Electricity and Magnetism", "p129"),
    "Electricity": BfnCitation("Unit 4", "Ch 16 Electricity and Magnetism", "p129"),
    "Cell structure": BfnCitation("Unit 7", "Ch 29 Cell Theory and Cell Structure", "p291"),
    "Cell review": BfnCitation("Unit 7", "Ch 29 Cell Theory and Cell Structure", "p291"),
    "Photosynthesis & respiration": BfnCitation("Unit 7", "Ch 30 Cellular Transport and Metabolism", "p291"),
    "Cell energy & organization": BfnCitation("Unit 7", "Ch 29–30 Cells · Metabolism", "p291"),
    "Energy review": BfnCitation("Unit 7", "Ch 30 Cellular Transport and Metabolism", "p291"),
    "Genetics": BfnCitation("Unit 10", "Ch 42 Heredity and Genetics", "p433"),
    "Genetics review": BfnCitation("Unit 10", "Ch 42 Heredity and Genetics · Ch 43 Evolution", "p433"),
    "Ecology": BfnCitation("Unit 11", "Ch 46 Ecology and Ecosystems · Ch 47 Interdependence", "p475"),
    "Ecology review": BfnCitation("Unit 11", "Ch 46–48 Ecology · Biomes", "p475"),
    "Human body systems": BfnCitation("Unit 9", "Ch 36–41 Body systems (skeletal through immune)", "p373"),
    "Evolution & classification": BfnCitation("Unit 10", "Ch 43 Evolution · Ch 44 Fossils", "p433"),
    "Evolution & plants": BfnCitation("Unit 10", "Ch 43 Evolution · Ch 45 History of Life", "p433"),
    "Microorganisms & disease": BfnCitation("Unit 7", "Ch 28 Organisms and Biological Classification", "p291"),
    "Plants & animals": BfnCitation("Unit 8", "Ch 32–35 Plant structure · Invertebrates · Vertebrates", "p333"),
}

BFN_BIO_BY_TOPIC: dict[str, BfnCitation] = {
    "Cell structure": BfnCitation("Unit 3", "Ch 9 Cell Structure and Function", "p84"),
    "Cell review": BfnCitation("Unit 3", "Ch 9 Cell Structure and Function", "p84"),
    "Photosynthesis & respiration": BfnCitation("Unit 3", "Ch 11 Photosynthesis · Ch 12 Cellular Respiration", "p103"),
    "Cell energy & organization": BfnCitation("Unit 3", "Ch 10 Chemical Energy and ATP · Ch 11–12 Energy in cells", "p97"),
    "Energy review": BfnCitation("Unit 3", "Ch 10–12 ATP · Photosynthesis · Respiration", "p97"),
    "Genetics": BfnCitation("Unit 10", "Ch 44 Introduction to Genetics · Ch 45 DNA and RNA", "p413"),
    "Genetics review": BfnCitation("Unit 10", "Ch 44–46 Genetics · Genetic engineering", "p413"),
    "Ecology": BfnCitation("Unit 12", "Ch 49 The Ecosystem · Ch 50 Populations", "p483"),
    "Ecology review": BfnCitation("Unit 12", "Ch 49–50 Ecosystems · Populations", "p483"),
    "Human body systems": BfnCitation("Unit 9", "Ch 36 Body Systems · Ch 40 Respiratory/Circulatory · Ch 41 Digestive", "p325"),
    "Evolution & classification": BfnCitation("Unit 11", "Ch 47 Evolution · Ch 48 History of Life", "p451"),
    "Evolution & plants": BfnCitation("Unit 7", "Ch 26–28 Plant kingdom · Structure · Reproduction", "p229"),
    "Microorganisms & disease": BfnCitation("Unit 4", "Ch 15 Bacteria · Ch 16 Viruses · Ch 18 Disease", "p141"),
    "Plants & animals": BfnCitation("Unit 7–8", "Ch 26–29 Plants · Ch 30–35 Animals", "p229"),
}

BFN_ALG_BY_TITLE: dict[str, BfnCitation] = {
    "Scientific notation": BfnCitation("Unit 4", "Ch 19 Exponents · Ch 20 Scientific Notation", "p141"),
    "Ratios": BfnCitation("Unit 3", "Ch 11–18 Ratios · Unit Rates · Proportions", "p75"),
    "Graphs & slope": BfnCitation("Unit 6", "Ch 31–38 Slope · Slope-Intercept · Read Graphs", "p247"),
    "Graphs": BfnCitation("Unit 6", "Ch 31–38 Graphing Linear Equations", "p247"),
    "Graph reading": BfnCitation("Unit 6", "Ch 31–38 Read Graphs · Slope as Rate", "p247"),
    "Unit conversion": BfnCitation("Unit 2", "Ch 4–10 The Number System · Decimals", "p23"),
    "Unit conversion review": BfnCitation("Unit 2", "Ch 4–10 Fractions · Decimals · Metric", "p23"),
    "PEMDAS & estimation": BfnCitation("Unit 1", "Ch 1–3 Types of Numbers · Order of Operations", "p1"),
    "Percent": BfnCitation("Unit 3", "Ch 11–18 Percent · Proportions", "p75"),
    "Proportions": BfnCitation("Unit 3", "Ch 11–18 Proportions · Cross-Multiply", "p75"),
    "F = ma": BfnCitation("Unit 5", "Ch 24–30 Linear Equations · Plug-In", "p175"),
    "Exponents": BfnCitation("Unit 4", "Ch 19 Exponents · Ch 20 Scientific Notation", "p141"),
    "Body-scale ratios": BfnCitation("Unit 3", "Ch 11–18 Ratios · Unit Rates", "p75"),
    "Formula substitution": BfnCitation("Unit 5", "Ch 24–30 Solve Equations · Rearrange Formulas", "p175"),
    "Formula plug-in": BfnCitation("Unit 5", "Ch 24–30 Linear Equations · Substitution", "p175"),
    "W = Fd": BfnCitation("Unit 5", "Ch 24–30 Equations · Formula Rearranging", "p175"),
    "Concentration ratios": BfnCitation("Unit 3", "Ch 11–18 Proportions · Percent", "p75"),
    "Mixed review": BfnCitation("Units 1–7", "Pick weakest unit · Check Your Knowledge", "p1"),
    "Number review": BfnCitation("Unit 2", "Ch 4–10 Negatives · Fractions · Decimals", "p23"),
    "Logic & probability": BfnCitation("Unit 7", "Ch 39–44 Data · Probability · Logic", "p325"),
    "v = fλ": BfnCitation("Unit 11", "Ch 57–60 Square Roots · Simplify Radicals", "p505"),
    "Flash review": BfnCitation("Units 1–6", "Mixed CYK · sci notation · ratios · graphs", "p1"),
    "Final review": BfnCitation("Units 1–7", "All summer units · Check Your Knowledge", "p1"),
}


def science_bfn_topic(week: int, day_idx: int) -> str:
    return SCIENCE_BFN_TOPIC[(week, day_idx)]


def format_bfn_sci(topic: str) -> str:
    c = BFN_SCI_BY_TOPIC.get(topic, BFN_FALLBACK_SCI)
    return f"BFN-Sci · {c.short_line}"


def format_bfn_bio(topic: str) -> str:
    c = BFN_BIO_BY_TOPIC.get(topic, BFN_FALLBACK_BIO)
    return f"BFN-Bio · {c.short_line}"


def format_bfn_algebra(math_title: str) -> str:
    c = BFN_ALG_BY_TITLE.get(math_title, BFN_FALLBACK_ALG)
    return f"BFN-A · {c.short_line}"


def format_algebra_backup(week: int, day_idx: int, math_title: str, lar_part: str) -> str:
    lar = lar_part.split(" · BFN")[0].strip()
    return f"{lar} · {format_bfn_algebra(math_title)}"


def format_chem_backup(week: int, day_idx: int, mod_display: str, tro_part: str) -> str:
    topic = science_bfn_topic(week, day_idx)
    return f"Mod {mod_display}{tro_part} · {format_bfn_sci(topic)}"


def format_bio_backup(week: int, day_idx: int, osb_line: str) -> str:
    topic = science_bfn_topic(week, day_idx)
    return f"{osb_line} · {format_bfn_bio(topic)}"


def format_phys_backup(week: int, day_idx: int) -> str:
    topic = science_bfn_topic(week, day_idx)
    return format_bfn_sci(topic)
