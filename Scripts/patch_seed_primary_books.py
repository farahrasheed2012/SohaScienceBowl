#!/usr/bin/env python3
"""Patch SeedData book fields for Hewitt/FLS primaries."""

from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent / "Data"

PATCHES = [
    (
        'book: "Mod", chapter: "Ch 3", title: "Atoms: The Building Blocks of Matter",\n'
        '              pass2Book: "Tro", pass2Chapter: "Ch 4 §4.3–4.6", pass2Title: "Atoms & Elements",',
        'book: "Expl", chapter: "Ch 17 §17.1–17.3", title: "Atoms: The Building Blocks of Matter",\n'
        '              pass2Book: "Mod", pass2Chapter: "Ch 3", pass2Title: "Atoms & Elements (backup)",\n'
        '              backupBookLine: "Tro Ch 4 §4.3–4.6",',
    ),
    (
        'book: "OSB", chapter: "Ch 3", title: "Cell Structure and Function",\n'
        '                      backupBookLine: "FLS Ch 1 · CB Ch 4",',
        'book: "FLS", chapter: "Ch 1 §1.3–1.4", title: "Cell Structure and Function",\n'
        '                      backupBookLine: "OSB Ch 3 §3.2–3.4 · CB Ch 4",',
    ),
    (
        'focus: "~1 hr: Expl Ch 1 (hypothesis, SI units, precision).',
        'focus: "~1 hr: Hewitt Ch 1 (hypothesis, SI units, precision).',
    ),
    (
        'book: "Mod", chapter: "Ch 5", title: "Periodic Law",\n'
        '              pass2Book: "Tro", pass2Chapter: "Ch 4 §4.7–4.8 + Ch 5", pass2Title: "Ions · Molecules & Compounds",',
        'book: "Expl", chapter: "Ch 17 §17.6–17.8", title: "Periodic Law",\n'
        '              pass2Book: "Mod", pass2Chapter: "Ch 5", pass2Title: "Ions · Molecules & Compounds (backup)",\n'
        '              backupBookLine: "Tro Ch 4 §4.7–4.8 + Ch 5",',
    ),
    (
        'book: "OSB", chapter: "Ch 1", title: "Levels of Organization",\n'
        '                      backupBookLine: "FLS Ch 2 · CB Ch 6–7",',
        'book: "FLS", chapter: "Ch 2 §2.1–2.2", title: "Levels of Organization",\n'
        '                      backupBookLine: "OSB Ch 1 §1.1 · CB Ch 6–7",',
    ),
    (
        'book: "Mod", chapter: "Ch 10", title: "States of Matter",\n'
        '              pass2Book: "Tro", pass2Chapter: "Ch 3", pass2Title: "Matter and Energy",',
        'book: "Expl", chapter: "Ch 17 §17.3–17.5", title: "States of Matter",\n'
        '              pass2Book: "Mod", pass2Chapter: "Ch 10", pass2Title: "Matter and Energy (backup)",\n'
        '              backupBookLine: "Tro Ch 3",',
    ),
    (
        'book: "OSB", chapter: "Ch 7", title: "Genetics — DNA & genes (part 1)",\n'
        '                      backupBookLine: "FLS Ch 4 · CB Ch 9",',
        'book: "FLS", chapter: "Ch 4 §4.1–4.2", title: "Genetics — DNA & genes (part 1)",\n'
        '                      backupBookLine: "OSB Ch 8 §8.1–8.2 · CB Ch 9",',
    ),
    (
        'book: "Mod", chapter: "Ch 8", title: "Chemical Equations and Reactions",\n'
        '              pass2Book: "Tro", pass2Chapter: "Ch 7 §7.1–7.4", pass2Title: "Chemical Reactions",',
        'book: "Expl", chapter: "Ch 20 §20.1–20.4", title: "Chemical Equations and Reactions",\n'
        '              pass2Book: "Mod", pass2Chapter: "Ch 8", pass2Title: "Chemical Reactions (backup)",\n'
        '              backupBookLine: "Tro Ch 7 §7.1–7.4",',
    ),
    (
        'book: "OSB", chapter: "Ch 8", title: "Genetics — Punnett squares (part 2)",\n'
        '                      backupBookLine: "FLS Ch 4 · CB Ch 9",',
        'book: "FLS", chapter: "Ch 4 §4.3", title: "Genetics — Punnett squares (part 2)",\n'
        '                      backupBookLine: "OSB Ch 8 §8.2–8.3 · CB Ch 9",',
    ),
    (
        'book: "Mod", chapter: "Ch 14", title: "Acids and Bases",\n'
        '              pass2Book: "Tro", pass2Chapter: "Ch 14", pass2Title: "Acids and Bases",',
        'book: "Expl", chapter: "Ch 21 §21.1–21.3", title: "Acids and Bases",\n'
        '              pass2Book: "Mod", pass2Chapter: "Ch 14", pass2Title: "Acids and Bases (backup)",\n'
        '              backupBookLine: "Tro Ch 14",',
    ),
    (
        'book: "OSB", chapter: "Ch 19", title: "Ecology — communities (part 1)",\n'
        '                      backupBookLine: "FLS Ch 7 · CB Ch 36–37",',
        'book: "FLS", chapter: "Ch 7 §7.2–7.3", title: "Ecology — communities (part 1)",\n'
        '                      backupBookLine: "OSB Ch 19 §19.1 · CB Ch 36–37",',
    ),
    (
        'book: "Mod", chapter: "Ch 12", title: "Solutions",\n'
        '              pass2Book: "Tro", pass2Chapter: "Ch 13", pass2Title: "Solutions",',
        'book: "Expl", chapter: "Ch 19 §19.1–19.4", title: "Solutions",\n'
        '              pass2Book: "Mod", pass2Chapter: "Ch 12", pass2Title: "Solutions (backup)",\n'
        '              backupBookLine: "Tro Ch 13",',
    ),
    (
        'book: "OSB", chapter: "Ch 16", title: "Body systems — musculoskeletal & cardiopulmonary",\n'
        '                      backupBookLine: "FLS Ch 16–20 · CB Ch 21–23",',
        'book: "FLS", chapter: "Ch 17 §17.1–18.1", title: "Body systems — musculoskeletal & cardiopulmonary",\n'
        '                      backupBookLine: "OSB Ch 16 §16.1–16.3 · CB Ch 21–23",',
    ),
    (
        'book: "Mod", chapter: "Ch 5 §3 + Ch 4", title: "Periodic Properties + Electrons",\n'
        '              pass2Book: "Tro", pass2Chapter: "Ch 9 §9.7 · §9.9", pass2Title: "Periodic trends",',
        'book: "Expl", chapter: "Ch 17–18 §17.6 + §18.1–18.2", title: "Periodic Properties + Electrons",\n'
        '              pass2Book: "Mod", pass2Chapter: "Ch 5 §3 + Ch 4", pass2Title: "Periodic trends (backup)",\n'
        '              backupBookLine: "Tro Ch 9 §9.7 · §9.9",',
    ),
    (
        'book: "OSB", chapter: "Ch 11", title: "Evolution — natural selection (part 1)",\n'
        '                      backupBookLine: "FLS Ch 5–6 · CB Ch 13–14",',
        'book: "FLS", chapter: "Ch 5 §5.1–5.2", title: "Evolution — natural selection (part 1)",\n'
        '                      backupBookLine: "OSB Ch 11 · CB Ch 13–14",',
    ),
    (
        'book: "Mod", chapter: "Ch 2", title: "Measurements and Calculations",\n'
        '              pass2Book: "Tro", pass2Chapter: "Ch 2", pass2Title: "Measurement and Problem Solving",',
        'book: "Expl", chapter: "Ch 17 §17.1–17.4", title: "Measurements and Calculations",\n'
        '              pass2Book: "Mod", pass2Chapter: "Ch 2", pass2Title: "Measurement and Problem Solving (backup)",\n'
        '              backupBookLine: "Tro Ch 2",',
    ),
    (
        'book: "OSB", chapter: "Ch 12", title: "Classification & taxonomy (part 2)",\n'
        '                      backupBookLine: "FLS Ch 5–6 · CB Ch 13–14",',
        'book: "FLS", chapter: "Ch 6 §6.1", title: "Classification & taxonomy (part 2)",\n'
        '                      backupBookLine: "OSB Ch 12 · CB Ch 14",',
    ),
]

PATCHES_5_10 = [
    (
        'book: "Mod", chapter: "Ch 7", title: "Chemical Bonding",\n'
        '              pass2Book: "Tro", pass2Chapter: "Ch 5", pass2Title: "Molecules & Compounds (backup)",',
        'book: "Expl", chapter: "Ch 18 §18.1–18.6", title: "Chemical Bonding",\n'
        '              pass2Book: "Mod", pass2Chapter: "Ch 7", pass2Title: "Molecules & Compounds (backup)",\n'
        '              backupBookLine: "Tro Ch 5",',
    ),
    (
        'book: "OSB", chapter: "Ch 4", title: "Photosynthesis (part 1)",\n'
        '              backupBookLine: "FLS Ch 3 · CB Ch 8",',
        'book: "FLS", chapter: "Ch 3 §2.4", title: "Photosynthesis (part 1)",\n'
        '              backupBookLine: "OSB Ch 4 · CB Ch 8",',
    ),
    (
        'book: "Mod", chapter: "Ch 6", title: "Chemical Quantities",\n'
        '              pass2Book: "Tro", pass2Chapter: "Ch 6", pass2Title: "Quantities in Chemistry (backup)",',
        'book: "Expl", chapter: "Ch 19 §19.3–19.4", title: "Chemical Quantities",\n'
        '              pass2Book: "Mod", pass2Chapter: "Ch 6", pass2Title: "Quantities in Chemistry (backup)",\n'
        '              backupBookLine: "Tro Ch 6",',
    ),
    (
        'book: "OSB", chapter: "Ch 5", title: "Cellular Respiration (part 2)",\n'
        '              backupBookLine: "FLS Ch 3 · CB Ch 9",',
        'book: "FLS", chapter: "Ch 3 §2.5", title: "Cellular Respiration (part 2)",\n'
        '              backupBookLine: "OSB Ch 5 · CB Ch 9",',
    ),
    (
        'book: "Mod", chapter: "Ch 12 §", title: "Molarity & Dilution",\n'
        '              pass2Book: "Tro", pass2Chapter: "Ch 13", pass2Title: "Solutions (backup)",',
        'book: "Expl", chapter: "Ch 19 §19.3–19.5", title: "Molarity & Dilution",\n'
        '              pass2Book: "Mod", pass2Chapter: "Ch 12 §", pass2Title: "Solutions (backup)",\n'
        '              backupBookLine: "Tro Ch 13",',
    ),
    (
        'book: "OSB", chapter: "Ch 20", title: "Population Ecology (part 2)",\n'
        '              backupBookLine: "FLS Ch 7 · CB Ch 36",',
        'book: "FLS", chapter: "Ch 7 §7.3", title: "Population Ecology (part 2)",\n'
        '              backupBookLine: "OSB Ch 20 · CB Ch 36",',
    ),
    (
        'book: "Mod", chapter: "Ch 14 §", title: "Neutralization & Titration",\n'
        '              pass2Book: "Tro", pass2Chapter: "Ch 14", pass2Title: "Acids and Bases (backup)",',
        'book: "Expl", chapter: "Ch 21 §21.1–21.3", title: "Neutralization & Titration",\n'
        '              pass2Book: "Mod", pass2Chapter: "Ch 14 §", pass2Title: "Acids and Bases (backup)",\n'
        '              backupBookLine: "Tro Ch 14",',
    ),
    (
        'book: "OSB", chapter: "Ch 13", title: "Bacteria & Viruses",\n'
        '              backupBookLine: "FLS Ch 8 · CB Ch 16",',
        'book: "FLS", chapter: "Ch 8 §8.1–8.2", title: "Bacteria & Viruses",\n'
        '              backupBookLine: "OSB Ch 13 · CB Ch 16",',
    ),
    (
        'book: "Mod", chapter: "Ch 8 §", title: "Reaction Types (deeper)",\n'
        '              pass2Book: "Tro", pass2Chapter: "Ch 7", pass2Title: "Chemical Reactions (backup)",',
        'book: "Expl", chapter: "Ch 20 §20.1–20.4", title: "Reaction Types (deeper)",\n'
        '              pass2Book: "Mod", pass2Chapter: "Ch 8 §", pass2Title: "Chemical Reactions (backup)",\n'
        '              backupBookLine: "Tro Ch 7",',
    ),
    (
        'book: "OSB", chapter: "Ch 17", title: "Immune System",\n'
        '              backupBookLine: "FLS Ch 21 · CB Ch 24",',
        'book: "FLS", chapter: "Ch 21 §21.1", title: "Immune System",\n'
        '              backupBookLine: "OSB Ch 17 · CB Ch 24",',
    ),
    (
        'book: "Mod", chapter: "Ch 5 §", title: "Periodic Trends (deeper)",\n'
        '              pass2Book: "Tro", pass2Chapter: "Ch 9", pass2Title: "Periodic Trends (backup)",',
        'book: "Expl", chapter: "Ch 17 §17.6–17.7", title: "Periodic Trends (deeper)",\n'
        '              pass2Book: "Mod", pass2Chapter: "Ch 5 §", pass2Title: "Periodic Trends (backup)",\n'
        '              backupBookLine: "Tro Ch 9",',
    ),
    (
        'book: "OSB", chapter: "Ch 14", title: "Plant Structure (part 1)",\n'
        '              backupBookLine: "FLS Ch 10 · CB Ch 31",',
        'book: "FLS", chapter: "Ch 10 §10.1–10.2", title: "Plant Structure (part 1)",\n'
        '              backupBookLine: "OSB Ch 14 · CB Ch 31",',
    ),
    (
        'book: "Mod", chapter: "Ch 2 §", title: "Density & Unit Analysis",\n'
        '              pass2Book: "Tro", pass2Chapter: "Ch 2", pass2Title: "Measurement (backup)",',
        'book: "Expl", chapter: "Ch 17 §17.4–17.5", title: "Density & Unit Analysis",\n'
        '              pass2Book: "Mod", pass2Chapter: "Ch 2 §", pass2Title: "Measurement (backup)",\n'
        '              backupBookLine: "Tro Ch 2",',
    ),
    (
        'book: "OSB", chapter: "Ch 15", title: "Plant Transport & Tissues (part 2)",\n'
        '              backupBookLine: "FLS Ch 11 · CB Ch 31",',
        'book: "FLS", chapter: "Ch 11 §11.1", title: "Plant Transport & Tissues (part 2)",\n'
        '              backupBookLine: "OSB Ch 15 · CB Ch 31",',
    ),
    (
        'book: "Mod", chapter: "Ch 10 §", title: "Heating Curves & Phase Diagrams",\n'
        '              pass2Book: "Tro", pass2Chapter: "Ch 3", pass2Title: "Matter and Energy (backup)",',
        'book: "Expl", chapter: "Ch 17 §17.3–17.5", title: "Heating Curves & Phase Diagrams",\n'
        '              pass2Book: "Mod", pass2Chapter: "Ch 10 §", pass2Title: "Matter and Energy (backup)",\n'
        '              backupBookLine: "Tro Ch 3",',
    ),
    (
        'book: "OSB", chapter: "Ch 18", title: "Animal Structure & Tissues",\n'
        '              backupBookLine: "FLS Ch 16 · CB Ch 20",',
        'book: "FLS", chapter: "Ch 16 §16.1", title: "Animal Structure & Tissues",\n'
        '              backupBookLine: "OSB Ch 18 · CB Ch 20",',
    ),
    (
        'book: "Mod", chapter: "Ch 3 §", title: "Isotopes & Average Atomic Mass",\n'
        '              pass2Book: "Tro", pass2Chapter: "Ch 4", pass2Title: "Atoms (backup)",',
        'book: "Expl", chapter: "Ch 17 §17.2–17.3", title: "Isotopes & Average Atomic Mass",\n'
        '              pass2Book: "Mod", pass2Chapter: "Ch 3 §", pass2Title: "Atoms (backup)",\n'
        '              backupBookLine: "Tro Ch 4",',
    ),
    (
        'book: "OSB", chapter: "Ch 6", title: "Cell Reproduction (intro)",\n'
        '              backupBookLine: "FLS Ch 4 · CB Ch 8",',
        'book: "FLS", chapter: "Ch 3 §3.1–3.2", title: "Cell Reproduction (intro)",\n'
        '              backupBookLine: "OSB Ch 6 · CB Ch 8",',
    ),
    (
        'book: "Mod", chapter: "Ch 5 + Ch 7", title: "Ions & Ionic Compounds",\n'
        '              pass2Book: "Tro", pass2Chapter: "Ch 4–5", pass2Title: "Ions & Compounds (backup)",',
        'book: "Expl", chapter: "Ch 18 §18.2–18.4", title: "Ions & Ionic Compounds",\n'
        '              pass2Book: "Mod", pass2Chapter: "Ch 5 + Ch 7", pass2Title: "Ions & Compounds (backup)",\n'
        '              backupBookLine: "Tro Ch 4–5",',
    ),
    (
        'book: "OSB", chapter: "Ch 16 §", title: "Digestive & Circulatory (deeper)",\n'
        '              backupBookLine: "FLS Ch 16–20 · CB Ch 21–23",',
        'book: "FLS", chapter: "Ch 18 §18.1–19.1", title: "Digestive & Circulatory (deeper)",\n'
        '              backupBookLine: "OSB Ch 16 § · CB Ch 21–23",',
    ),
    (
        'book: "Mod", chapter: "Review", title: "Chemistry capstone — atoms to reactions",\n'
        '              focus:',
        'book: "Expl", chapter: "Review", title: "Chemistry capstone — atoms to reactions",\n'
        '              pass2Book: "Mod", pass2Chapter: "Review", pass2Title: "Mod/Tro if stuck",\n'
        '              backupBookLine: "Tro / BFN-Sci if stuck",\n'
        '              focus:',
    ),
    (
        'book: "OSB", chapter: "Review", title: "Biology capstone — cells to ecology",\n'
        '              backupBookLine: "FLS · CB · BFN-Bio",',
        'book: "FLS", chapter: "Review", title: "Biology capstone — cells to ecology",\n'
        '              backupBookLine: "OSB · CB · BFN-Bio",',
    ),
    (
        'book: "Mod", chapter: "Review", title: "Lab skills & periodic table",\n'
        '              focus:',
        'book: "Expl", chapter: "Review", title: "Lab skills & periodic table",\n'
        '              pass2Book: "Mod", pass2Chapter: "Review", pass2Title: "Mod/Tro if stuck",\n'
        '              backupBookLine: "Tro / BFN-Sci if stuck",\n'
        '              focus:',
    ),
    (
        'book: "OSB", chapter: "Review", title: "Final summer bio check",\n'
        '              backupBookLine: "BFN-Bio",',
        'book: "FLS", chapter: "Review", title: "Final summer bio check",\n'
        '              backupBookLine: "OSB · BFN-Bio",',
    ),
]


def apply(path: Path, patches: list) -> None:
    text = path.read_text()
    for old, new in patches:
        if old not in text:
            raise SystemExit(f"Missing patch anchor in {path.name}:\n{old[:80]}...")
        text = text.replace(old, new, 1)
    path.write_text(text)
    print(f"OK {path.name}")


if __name__ == "__main__":
    apply(ROOT / "SeedDataWeeks1_4.swift", PATCHES)
    apply(ROOT / "SeedDataWeeks5_10.swift", PATCHES_5_10)
