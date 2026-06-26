"""BFN-A full book catalog + summer schedule — mirrors Data/BFNAlgebraSchedule.swift."""

from __future__ import annotations

from dataclasses import dataclass

UNITS: list[tuple[int, str, int]] = [
    (1, "Arithmetic Properties", 1),
    (2, "The Number System", 23),
    (3, "Ratios, Proportions, and Percent", 75),
    (4, "Exponents and Algebraic Expressions", 141),
    (5, "Linear Equations and Inequalities", 175),
    (6, "Graphing Linear Equations and Inequalities", 247),
    (7, "Statistics and Probability", 325),
    (8, "Functions", 395),
    (9, "Polynomial Operations", 427),
    (10, "Factoring Polynomials", 461),
    (11, "Radicals", 505),
    (12, "Quadratic Equations", 533),
    (13, "Quadratic Functions", 587),
]

CHAPTERS: list[tuple[int, str, int]] = [
    (1, "Types of Numbers", 1),
    (2, "Algebraic Properties", 1),
    (3, "Order of Operations", 1),
    (4, "Adding Positive and Negative Whole Numbers", 2),
    (5, "Subtracting Positive and Negative Whole Numbers", 2),
    (6, "Multiplying and Dividing Positive and Negative Whole Numbers", 2),
    (7, "Multiplying and Dividing Positive and Negative Fractions", 2),
    (8, "Adding and Subtracting Positive and Negative Fractions", 2),
    (9, "Adding and Subtracting Decimals", 2),
    (10, "Multiplying and Dividing Decimals", 2),
    (11, "Ratio", 3),
    (12, "Unit Rate", 3),
    (13, "Proportion", 3),
    (14, "Percent", 3),
    (15, "Percent Applications", 3),
    (16, "Simple Interest", 3),
    (17, "Percent Rate of Change", 3),
    (18, "Tables and Ratios", 3),
    (19, "Exponents", 4),
    (20, "Scientific Notation", 4),
    (21, "Expressions", 4),
    (22, "Evaluating Algebraic Expressions", 4),
    (23, "Combining Like Terms", 4),
    (24, "Introduction to Equations", 5),
    (25, "Solving One-Variable Equations", 5),
    (26, "Solving One-Variable Inequalities", 5),
    (27, "Solving Compound Inequalities", 5),
    (28, "Rewriting Formulas", 5),
    (29, "Solving Systems of Linear Equations by Substitution", 5),
    (30, "Solving Systems of Linear Equations by Elimination", 5),
    (31, "Points and Lines", 6),
    (32, "Graphing a Line from a Table of Values", 6),
    (33, "Slope of a Line", 6),
    (34, "Slope-Intercept Form", 6),
    (35, "Point-Slope Form", 6),
    (36, "Solving Systems of Linear Equations by Graphing", 6),
    (37, "Graphing Linear Inequalities", 6),
    (38, "Solving Systems of Linear Inequalities by Graphing", 6),
    (39, "Introduction to Statistics", 7),
    (40, "Measures of Central Tendency and Variation", 7),
    (41, "Displaying Data", 7),
    (42, "Probability", 7),
    (43, "Compound Events", 7),
    (44, "Permutations and Combinations", 7),
    (45, "Relations and Functions", 8),
    (46, "Function Notation", 8),
    (47, "Application of Functions", 8),
    (48, "Adding and Subtracting Polynomials", 9),
    (49, "Multiplying and Dividing Exponents", 9),
    (50, "Multiplying and Dividing Monomials", 9),
    (51, "Multiplying and Dividing Polynomials", 9),
    (52, "Factoring Polynomials Using GCF", 10),
    (53, "Factoring Polynomials Using Grouping", 10),
    (54, "Factoring Trinomials When a = 1", 10),
    (55, "Factoring Trinomials When a ≠ 1", 10),
    (56, "Factoring Using Special Formulas", 10),
    (57, "Square Roots and Cube Roots", 11),
    (58, "Simplifying Radicals", 11),
    (59, "Adding and Subtracting Radicals", 11),
    (60, "Multiplying and Dividing Radicals", 11),
    (61, "Introduction to Quadratic Equations", 12),
    (62, "Solving Quadratic Equations by Factoring", 12),
    (63, "Solving Quadratic Equations by Taking Square Roots", 12),
    (64, "Solving Quadratic Equations by Completing the Square", 12),
    (65, "Solving Quadratic Equations with the Quadratic Formula", 12),
    (66, "The Discriminant and the Number of Solutions", 12),
    (67, "Graphing Quadratic Functions", 13),
    (68, "Solving Quadratic Equations by Graphing", 13),
]

CHAPTER_BY_NUM = {n: (title, unit) for n, title, unit in CHAPTERS}
UNIT_PAGE = {u: page for u, _, page in UNITS}

REVIEW_FRIDAYS = {3, 7, 9, 10}
REVIEW_LABELS = {
    3: "Units 1–3 · Check Your Knowledge",
    7: "Units 4–7 · Check Your Knowledge",
    9: "Units 8–11 · Check Your Knowledge",
    10: "Full book · Check Your Knowledge",
}

OSA_BY_LEGACY = {
    "Scientific notation": ["1.1", "1.2"],
    "Ratios": ["5.8"],
    "Graphs & slope": ["2.1", "4.1", "3.3"],
    "Unit conversion": ["1.1", "1.2"],
    "PEMDAS & estimation": ["1.1"],
    "Percent": ["1.1"],
    "Proportions": ["5.8"],
    "F = ma": ["2.3"],
    "Exponents": ["1.2", "6.1"],
    "Body-scale ratios": ["5.8"],
    "Formula substitution": ["2.3"],
    "Graph reading": ["2.1", "3.3"],
    "W = Fd": ["2.3"],
    "Concentration ratios": ["5.8"],
    "Mixed review": ["1.2", "5.8", "2.3"],
    "Number review": ["1.1"],
    "Logic & probability": ["13.7"],
    "v = fλ": ["2.3", "1.3"],
    "Unit conversion review": ["1.1", "1.2"],
    "Formula plug-in": ["2.3"],
    "Graphs": ["2.1", "3.3"],
    "Flash review": ["1.2", "5.8"],
    "Final review": ["home"],
}

LAR_BY_WEEK = {
    1: ["Lar Ch 1", "Lar Ch 2", "Lar Ch 4", "Lar Ch 1–2", "Lar Ch 2"],
    2: ["Lar Ch 2", "Lar Ch 3", "Lar Ch 3", "Lar Ch 8", "Lar Ch 3"],
    3: ["Lar Ch 7", "Lar Ch 1", "Lar Ch 3", "Lar Ch 3", "Lar Ch 1–4"],
    4: ["Lar Ch 6", "Lar Ch 9", "Lar Ch 9", "Lar Ch 9", "Lar Ch 9"],
    5: ["Lar Ch 9", "Lar Ch 4", "Lar Ch 4–5", "Lar Ch 4", "Lar Ch 6–7"],
    6: ["Lar Ch 6", "Lar Ch 11", "Lar Ch 10", "Lar Ch 10", "Lar Ch 1"],
    7: ["Lar Ch 1", "Lar Ch 7", "Lar Ch 10", "Lar Ch 1", "Lar Ch 1–4"],
    8: ["Lar Ch 4", "Lar Ch 13", "Lar Ch 13", "Lar Ch 1–13", "Lar Ch 9"],
    9: ["Lar Ch 8", "Lar Ch 8", "Lar Ch 8", "Lar Ch 8", "Lar Ch 1–4"],
    10: ["Lar Ch 8", "Lar Ch 1–13", "Lar Ch 9", "Lar Ch 1–13", "Lar Ch 1–13"],
    11: ["Lar Ch 11", "Lar Ch 11", "Lar Ch 11", "Lar Ch 11", "Lar Ch 11"],
    12: ["Lar Ch 11", "Lar Ch 11", "Lar Ch 1–13", "Lar Ch 1–13", "Lar Ch 1–13"],
}

LEGACY_TITLES = {
    1: ["Scientific notation", "Ratios", "Graphs & slope", "Unit conversion", "PEMDAS & estimation"],
    2: ["Percent", "Proportions", "F = ma", "Exponents", "Body-scale ratios"],
    3: ["Formula substitution", "Graph reading", "W = Fd", "Concentration ratios", "Mixed review"],
    4: ["Number review", "Logic & probability", "v = fλ", "Unit conversion review", "Formula plug-in"],
    5: ["Scientific notation", "Ratios", "Graphs & slope", "Unit conversion", "PEMDAS & estimation"],
    6: ["Percent", "Proportions", "F = ma", "Exponents", "Body-scale ratios"],
    7: ["Formula substitution", "Graph reading", "W = Fd", "Concentration ratios", "Mixed review"],
    8: ["Number review", "Logic & probability", "v = fλ", "Unit conversion review", "Formula plug-in"],
    9: ["Scientific notation", "Ratios", "Graphs", "Unit conversion", "Flash review"],
    10: ["Formula substitution", "Graph reading", "W = Fd", "Concentration ratios", "Final review"],
}


@dataclass(frozen=True)
class DayAssignment:
    chapter_numbers: tuple[int, ...]
    review_label: str | None
    pot_codes: tuple[str, ...]
    topic_label: str | None
    osa_section_keys: tuple[str, ...]
    lar_backup: str

    @property
    def display_title(self) -> str:
        if self.review_label:
            return self.review_label
        if self.topic_label:
            return self.topic_label
        bfn = _bfn_title(self.chapter_numbers)
        if not self.pot_codes:
            return bfn
        pot = ", ".join(self.pot_codes)
        if not self.chapter_numbers:
            return f"POT 6 — {pot}"
        return f"POT 6 — {pot} · {bfn}"

    @property
    def bfn_line(self) -> str:
        if self.review_label:
            return f"BFN-A · {self.review_label}"
        if not self.chapter_numbers:
            return "BFN-A · See index"
        first = self.chapter_numbers[0]
        _, unit = CHAPTER_BY_NUM[first]
        page = f"p{UNIT_PAGE[unit]}"
        if len(self.chapter_numbers) == 1:
            title, _ = CHAPTER_BY_NUM[first]
            return f"BFN-A · Unit {unit} · Ch {first} {title} · {page}"
        last = self.chapter_numbers[-1]
        return f"BFN-A · Unit {unit} · Ch {first}–{last} · {page}"


def _bfn_title(chapter_numbers: tuple[int, ...]) -> str:
    if not chapter_numbers:
        return "BFN-A reading"
    if len(chapter_numbers) == 1:
        n = chapter_numbers[0]
        title, _ = CHAPTER_BY_NUM[n]
        return f"Ch {n} — {title}"
    first, last = chapter_numbers[0], chapter_numbers[-1]
    t0 = CHAPTER_BY_NUM[first][0]
    t1 = CHAPTER_BY_NUM[last][0] if last != first else ""
    suffix = f" · {t1}" if t1 and t1 != t0 else ""
    return f"Ch {first}–{last} — {t0}{suffix}"


def _day(
    *,
    pot_codes: tuple[str, ...] = (),
    chapters: tuple[int, ...] = (),
    topic_label: str | None = None,
    osa: tuple[str, ...],
    lar: str,
    review: str | None = None,
) -> DayAssignment:
    return DayAssignment(chapters, review, pot_codes, topic_label, osa, lar)


def _legacy_day(week: int, day_idx: int, chapters: tuple[int, ...]) -> DayAssignment:
    legacy = LEGACY_TITLES[week][day_idx]
    osa = tuple(OSA_BY_LEGACY.get(legacy, ["1.1"]))
    lar = LAR_BY_WEEK[week][day_idx]
    return _day(chapters=chapters, osa=osa, lar=lar)


def _foundation_weeks() -> dict[tuple[int, int], DayAssignment]:
    return {
        (1, 0): _legacy_day(1, 0, (1, 2)),
        (1, 1): _legacy_day(1, 1, (3, 4)),
        (1, 2): _legacy_day(1, 2, (5, 6)),
        (1, 3): _legacy_day(1, 3, (7, 8)),
        (1, 4): _legacy_day(1, 4, (9, 10)),
        (2, 0): _legacy_day(2, 0, (11, 12)),
        (2, 1): _legacy_day(2, 1, (13, 14)),
        (2, 2): _legacy_day(2, 2, (15, 16)),
        (2, 3): _legacy_day(2, 3, (17, 18)),
        (2, 4): _legacy_day(2, 4, (19, 20)),
    }


def _pot6_weeks() -> dict[tuple[int, int], DayAssignment]:
    return {
        (3, 0): _day(chapters=(21, 22), osa=("2.3",), lar="Lar Ch 1"),
        (3, 1): _day(chapters=(23, 24), osa=("2.3",), lar="Lar Ch 3"),
        (3, 2): _day(chapters=(25, 26), osa=("2.3",), lar="Lar Ch 3"),
        (3, 3): _day(chapters=(27, 28), osa=("2.3",), lar="Lar Ch 6"),
        (3, 4): _day(osa=("1.2", "5.8", "2.3"), lar="Lar Ch 1–4", review=REVIEW_LABELS[3]),
        (4, 0): _day(chapters=(29, 30), osa=("4.1", "5.8"), lar="Lar Ch 7"),
        (4, 1): _day(pot_codes=("T225", "T226", "T227"), chapters=(47, 48), osa=("6.1",), lar="Lar Ch 9"),
        (4, 2): _day(pot_codes=("T228", "T229"), chapters=(51,), osa=("6.1",), lar="Lar Ch 9"),
        (4, 3): _day(pot_codes=("T230", "T231"), chapters=(51,), osa=("6.1",), lar="Lar Ch 9"),
        (4, 4): _day(pot_codes=("T239", "T240"), chapters=(52, 56), osa=("6.1",), lar="Lar Ch 9"),
        (5, 0): _day(pot_codes=("T241",), chapters=(54, 55), osa=("6.1",), lar="Lar Ch 9"),
        (5, 1): _day(pot_codes=("T247",), chapters=(31,), osa=("2.1",), lar="Lar Ch 4"),
        (5, 2): _day(pot_codes=("T248", "T250", "T251"), chapters=(33, 34, 35, 36), osa=("2.1", "4.1", "3.3"), lar="Lar Ch 4–5"),
        (5, 3): _day(pot_codes=("T252", "T254", "T257"), chapters=(31, 26, 27), osa=("2.1", "2.3"), lar="Lar Ch 4"),
        (5, 4): _day(pot_codes=("T258", "T259"), chapters=(37, 38, 29, 30, 36), osa=("4.1", "5.8"), lar="Lar Ch 6–7"),
        (6, 0): _day(pot_codes=("T264", "T265"), chapters=(26, 27), osa=("2.3",), lar="Lar Ch 6"),
        (6, 1): _day(pot_codes=("T266", "T267"), chapters=(57, 58, 59, 60), osa=("1.3",), lar="Lar Ch 11"),
        (6, 2): _day(pot_codes=("T261", "T262"), chapters=(61, 62, 64), osa=("6.1",), lar="Lar Ch 10"),
        (6, 3): _day(pot_codes=("T263", "T289"), chapters=(65, 66, 61, 62, 67, 68), osa=("6.1",), lar="Lar Ch 10"),
        (6, 4): _day(pot_codes=("T282", "T283", "T284"), chapters=(45, 13, 14), osa=("5.8", "6.1"), lar="Lar Ch 1"),
        (7, 0): _day(pot_codes=("T281", "T285", "T286", "T287"), chapters=(46, 47, 45), osa=("3.1", "3.2", "6.1"), lar="Lar Ch 1"),
        (7, 1): _day(
            topic_label="POT 6 Algebra · Review — lines, systems & verbal models",
            chapters=(29, 30),
            osa=("2.2", "4.1", "5.8"),
            lar="Lar Ch 7",
        ),
        (7, 2): _day(
            topic_label="RRISD · Quadratic transformations · OSA §3.5 & §5.1 · Ch 67–68",
            chapters=(67, 68),
            osa=("3.5", "5.1"),
            lar="Lar Ch 10",
        ),
        (7, 3): _day(
            topic_label="RRISD · Domain & range · OSA §3.1 & §3.2",
            chapters=(45, 46),
            osa=("3.1", "3.2"),
            lar="Lar Ch 1",
        ),
        (7, 4): _day(osa=("2.3",), lar="Lar Ch 1–4", review=REVIEW_LABELS[7]),
        (8, 0): _day(
            pot_codes=("T270", "T271"),
            chapters=(18, 39, 40, 41),
            topic_label="RRISD · Scatter plots & linear regression · OSA §4.2 & §4.3 · T270, T271",
            osa=("4.2", "4.3"),
            lar="Lar Ch 4",
        ),
        (8, 1): _day(pot_codes=("T275", "T276", "T277"), chapters=(42, 43), osa=("13.7",), lar="Lar Ch 13"),
        (8, 2): _day(pot_codes=("T278", "T279", "T280"), chapters=(43,), osa=("13.7",), lar="Lar Ch 13"),
        (8, 3): _day(pot_codes=("MIX1",), osa=("1.2", "5.8", "2.3"), lar="Lar Ch 1–13"),
        (8, 4): _day(pot_codes=("T272", "T274"), chapters=(32, 38, 44), osa=("2.1", "3.3", "13.7"), lar="Lar Ch 4"),
        (9, 0): _day(
            topic_label="RRISD · Exponential functions · OSA §6.1 · Ch 19, 49",
            chapters=(19, 49),
            osa=("6.1",),
            lar="Lar Ch 8",
        ),
        (9, 1): _day(
            topic_label="RRISD · Graphing exponentials · OSA §6.2",
            osa=("6.2",),
            lar="Lar Ch 8",
        ),
        (9, 2): _day(
            topic_label="RRISD · Logarithmic functions intro · OSA §6.3",
            osa=("6.3",),
            lar="Lar Ch 8",
        ),
        (9, 3): _day(
            topic_label="POT 6 Algebra · App drills & weak spots",
            osa=("2.1", "6.1", "13.7"),
            lar="Lar Ch 1–13",
        ),
        (9, 4): _day(osa=("1.2", "5.8"), lar="Lar Ch 1–4", review=REVIEW_LABELS[9]),
        (10, 0): _day(
            topic_label="RRISD · Log graphs, exp equations & models · OSA §6.4 · §6.6 · §6.7",
            osa=("6.4", "6.6", "6.7"),
            lar="Lar Ch 8",
        ),
        (10, 1): _day(pot_codes=("MIX2",), osa=("1.2", "5.8", "2.3"), lar="Lar Ch 1–13"),
        (10, 2): _day(pot_codes=("T290",), chapters=(51,), osa=("6.1",), lar="Lar Ch 9"),
        (10, 3): _day(
            topic_label="POT 6 · Weak spots & app drills",
            osa=("1.2", "5.8", "2.3", "6.1"),
            lar="Lar Ch 1–13",
        ),
        (10, 4): _day(osa=("home",), lar="Lar Ch 1–13", review=REVIEW_LABELS[10]),
    }


def _build_plan() -> dict[tuple[int, int], DayAssignment]:
    plan = _foundation_weeks()
    plan.update(_pot6_weeks())
    return plan


PLAN = _build_plan()


def day_assignment(week: int, day_idx: int) -> DayAssignment:
    return PLAN[(week, day_idx)]
