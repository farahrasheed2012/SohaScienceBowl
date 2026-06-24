"""BFN-C full book catalog + summer schedule — mirrors Data/BFNChemistrySchedule.swift."""

from __future__ import annotations

from dataclasses import dataclass

UNITS: list[tuple[int, str, int]] = [
    (1, "Basics of Chemistry", 1),
    (2, "All About Matter", 73),
    (3, "Atomic Theory and Electron Configuration", 113),
    (4, "Elements and the Periodic Table", 135),
    (5, "Bonding and VSEPR Theory", 179),
    (6, "Chemical Compounds", 231),
    (7, "Chemical Reactions and Calculations", 273),
    (8, "Gases", 311),
    (9, "Solutions and Solubility", 347),
    (10, "Acids and Bases", 383),
    (11, "Chemical Equilibrium", 423),
    (12, "Thermodynamics", 451),
]

CHAPTERS: list[tuple[int, str, int]] = [
    (1, "Introduction to Chemistry", 1),
    (2, "Conducting Experiments", 1),
    (3, "Lab Reports and Evaluating Results", 1),
    (4, "Measurement", 1),
    (5, "Lab Safety and Scientific Tools", 1),
    (6, "Properties of Matter and Changes in Form", 2),
    (7, "States of Matter", 2),
    (8, "Atoms, Elements, Compounds, and Mixtures", 2),
    (9, "Atomic Theory", 3),
    (10, "Waves, Quantum Theory, and Photons", 3),
    (11, "The Periodic Table", 4),
    (12, "Periodic Trends", 4),
    (13, "Electrons", 4),
    (14, "Bonding", 5),
    (15, "Valence Shell Electron Pair Repulsion (VSEPR) Theory", 5),
    (16, "Metallic Bonds and Intramolecular Forces", 5),
    (17, "Naming Substances", 6),
    (18, "The Mole", 6),
    (19, "Finding Compositions in Compounds", 6),
    (20, "Chemical Reactions", 7),
    (21, "Chemical Calculations", 7),
    (22, "Common Gases", 8),
    (23, "Kinetic Molecular Theory", 8),
    (24, "Gas Laws", 8),
    (25, "Solubility", 9),
    (26, "Solubility Rules and Conditions", 9),
    (27, "Concentrations of Solutions", 9),
    (28, "Properties of Acids and Bases", 10),
    (29, "pH Scale and Calculations", 10),
    (30, "Conjugate Acids and Bases", 10),
    (31, "Titrations", 10),
    (32, "Chemical Equilibrium", 11),
    (33, "Le Châtelier's Principle", 11),
    (34, "The First Law of Thermodynamics", 12),
    (35, "The Second Law of Thermodynamics", 12),
    (36, "Reaction Rates", 12),
]

CHAPTER_BY_NUMBER: dict[int, tuple[str, int]] = {
    number: (title, unit) for number, title, unit in CHAPTERS
}

UNIT_BY_NUMBER: dict[int, tuple[str, int]] = {
    number: (name, start_page) for number, name, start_page in UNITS
}

BOOK_CODE = "BFN-C"
EDITION_TITLE = "Big Fat Notebook: High School Chemistry"


@dataclass(frozen=True)
class DayAssignment:
    chapter_numbers: tuple[int, ...] = ()
    review_label: str | None = None

    @property
    def is_review_day(self) -> bool:
        return self.review_label is not None


def _chapter_range_label(numbers: tuple[int, ...]) -> str:
    if not numbers:
        return ""
    first, last = numbers[0], numbers[-1]
    return str(first) if first == last else f"{first}–{last}"


def _page_label(chapter_number: int) -> str:
    unit_number = CHAPTER_BY_NUMBER[chapter_number][1]
    return f"p{UNIT_BY_NUMBER[unit_number][1]}"


def citation_line(chapter_numbers: tuple[int, ...], review_label: str | None) -> str:
    if review_label:
        return review_label
    if not chapter_numbers:
        return "See index · Match today's chemistry topic"
    first = chapter_numbers[0]
    unit_number = CHAPTER_BY_NUMBER[first][1]
    if len(chapter_numbers) == 1:
        ch_label = f"Ch {first} {CHAPTER_BY_NUMBER[first][0]}"
    else:
        ch_label = f"Ch {_chapter_range_label(chapter_numbers)}"
    return f"Unit {unit_number} · {ch_label} · {_page_label(first)}"


def option_text(chapter_numbers: tuple[int, ...], review_label: str | None = None) -> str:
    return f"{BOOK_CODE} — {EDITION_TITLE} · {citation_line(chapter_numbers, review_label)}"


def _day(chapters: tuple[int, ...] = (), review: str | None = None) -> DayAssignment:
    return DayAssignment(chapter_numbers=chapters, review_label=review)


PLAN: dict[tuple[int, int], DayAssignment] = {
    (1, 0): _day(chapters=(8, 9)),
    (1, 3): _day(chapters=(11, 12)),
    (2, 0): _day(chapters=(9, 10)),
    (2, 3): _day(chapters=(14,)),
    (3, 0): _day(chapters=(25, 26)),
    (3, 3): _day(chapters=(20,)),
    (4, 0): _day(chapters=(6, 7)),
    (4, 3): _day(chapters=(4, 5)),
    (5, 0): _day(chapters=(14, 15)),
    (5, 3): _day(chapters=(18, 19)),
    (6, 0): _day(chapters=(27,)),
    (6, 3): _day(chapters=(28, 29, 31)),
    (7, 0): _day(chapters=(20, 21)),
    (7, 3): _day(chapters=(12, 13)),
    (8, 0): _day(chapters=(4, 19)),
    (8, 3): _day(chapters=(6, 7)),
    (9, 0): _day(chapters=(9, 10)),
    (9, 3): _day(chapters=(16, 17)),
    (10, 0): _day(review="Units 1–6 · Check Your Knowledge"),
    (10, 3): _day(review="Units 7–10 · Check Your Knowledge"),
}


def day_assignment(week: int, day_idx: int) -> DayAssignment | None:
    return PLAN.get((week, day_idx))


def primary_display(week: int, day_idx: int) -> str:
    assignment = day_assignment(week, day_idx)
    if assignment is None:
        return "BFN-C"
    return option_text(assignment.chapter_numbers, assignment.review_label)


def compact_primary_display(week: int, day_idx: int) -> str:
    """Short line for HTML cells: BFN-C — Ch 8–9 — Atoms…"""
    assignment = day_assignment(week, day_idx)
    if assignment is None:
        return "BFN-C"
    if assignment.review_label:
        return f"BFN-C — {assignment.review_label}"
    numbers = assignment.chapter_numbers
    if not numbers:
        return "BFN-C"
    titles = [CHAPTER_BY_NUMBER[n][0] for n in numbers]
    if len(numbers) == 1:
        return f"BFN-C — Ch {numbers[0]} — {titles[0]}"
    joined = " · ".join(titles[:2])
    suffix = " · …" if len(titles) > 2 else ""
    return f"BFN-C — Ch {_chapter_range_label(numbers)} — {joined}{suffix}"


# Hewitt (Expl) § backup — same mapping as BlockAssignedReadingCatalog explChemByKey
HEWITT_CHEM_BACKUP: dict[tuple[int, int], str] = {
    (1, 0): "Ch 17 §17.1–17.3",
    (1, 3): "Ch 17 §17.6–17.8",
    (2, 0): "Ch 15 §15.1–15.5",
    (2, 3): "Ch 18 §18.1–18.4",
    (3, 0): "Ch 19 §19.1–19.4",
    (3, 3): "Ch 20 §20.1–20.4",
    (4, 0): "Ch 17 §17.3–17.5",
    (4, 3): "Ch 17 §17.1–17.4",
    (5, 0): "Ch 18 §18.5–18.8",
    (5, 3): "Ch 19 §19.3–19.4",
    (6, 0): "Ch 19 §19.3–19.5",
    (6, 3): "Ch 21 §21.1–21.3",
    (7, 0): "Ch 20 §20.1–20.4",
    (7, 3): "Ch 17 §17.6–17.7",
    (8, 0): "Ch 17 §17.4–17.5",
    (8, 3): "Ch 17 §17.3–17.5",
    (9, 0): "Ch 17 §17.2–17.3",
    (9, 3): "Ch 18 §18.2–18.4",
    (10, 0): "Review",
    (10, 3): "Review",
}
