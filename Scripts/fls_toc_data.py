"""Section TOC for Prentice Hall Focus on Life Science (California Edition).

Chapters match FocusOnLifeScienceCatalog; sections use chapter.section numbering (e.g. 1.1).
"""

# (chapter_number, [(section_id, title), ...])
FLS_CHAPTERS = [
    (1, "Cell Structure and Function", [
        ("1.1", "Cells and the Cell Theory"),
        ("1.2", "Cell Size"),
        ("1.3", "Parts of a Cell"),
        ("1.4", "Two Kinds of Cells"),
    ]),
    (2, "Cell Processes and Energy", [
        ("2.1", "Chemical Compounds in Cells"),
        ("2.2", "The Cell Membrane"),
        ("2.3", "Chemical Reactions and Energy"),
        ("2.4", "Photosynthesis"),
        ("2.5", "Cellular Respiration"),
    ]),
    (3, "Genetics: The Science of Heredity", [
        ("3.1", "Genetics: The Science of Heredity"),
        ("3.2", "Traits and Inheritance"),
        ("3.3", "Patterns of Heredity"),
    ]),
    (4, "Modern Genetics", [
        ("4.1", "Human Inheritance"),
        ("4.2", "Advances in Modern Genetics"),
        ("4.3", "Genetic Disorders"),
    ]),
    (5, "Evolution", [
        ("5.1", "Evidence for Evolution"),
        ("5.2", "How Evolution Works"),
        ("5.3", "Natural Selection"),
    ]),
    (6, "Earth's History", [
        ("6.1", "Fossil Evidence"),
        ("6.2", "Geologic Time"),
        ("6.3", "Earth's Past"),
    ]),
    (7, "Living Things", [
        ("7.1", "What Is Life?"),
        ("7.2", "Classification of Living Things"),
        ("7.3", "The Six Kingdoms"),
    ]),
    (8, "Viruses and Bacteria", [
        ("8.1", "Bacteria"),
        ("8.2", "Viruses"),
    ]),
    (9, "Protists and Fungi", [
        ("9.1", "Protists"),
        ("9.2", "Fungi"),
    ]),
    (10, "Introduction to Plants", [
        ("10.1", "What Are Plants?"),
        ("10.2", "Roots, Stems, and Leaves"),
        ("10.3", "Reproduction in Flowering Plants"),
    ]),
    (11, "Seed Plants", [
        ("11.1", "Seed Plants"),
        ("11.2", "Plant Responses"),
    ]),
    (12, "Sponges, Cnidarians, and Worms", [
        ("12.1", "Sponges and Cnidarians"),
        ("12.2", "Worms"),
    ]),
    (13, "Mollusks, Arthropods, and Echinoderms", [
        ("13.1", "Mollusks"),
        ("13.2", "Arthropods"),
        ("13.3", "Echinoderms"),
    ]),
    (14, "Fishes, Amphibians, and Reptiles", [
        ("14.1", "Fishes"),
        ("14.2", "Amphibians"),
        ("14.3", "Reptiles"),
    ]),
    (15, "Birds and Mammals", [
        ("15.1", "Birds"),
        ("15.2", "Mammals"),
    ]),
    (16, "Healthy Body Systems", [
        ("16.1", "Your Body Systems"),
        ("16.2", "Staying Healthy"),
    ]),
    (17, "Bones, Muscles, and Skin", [
        ("17.1", "Bones and Muscles"),
        ("17.2", "The Skin"),
    ]),
    (18, "Food and Digestion", [
        ("18.1", "Food and Energy"),
        ("18.2", "The Digestive System"),
    ]),
    (19, "Circulation", [
        ("19.1", "The Circulatory System"),
        ("19.2", "Blood and Lymph"),
    ]),
    (20, "Respiration and Excretion", [
        ("20.1", "The Respiratory System"),
        ("20.2", "The Excretory System"),
    ]),
    (21, "Fighting Disease", [
        ("21.1", "The Body's Defenses"),
        ("21.2", "Infectious Disease"),
    ]),
    (22, "The Nervous System", [
        ("22.1", "The Nervous System"),
        ("22.2", "The Senses"),
    ]),
    (23, "The Endocrine System and Reproduction", [
        ("23.1", "The Endocrine System"),
        ("23.2", "Human Reproduction"),
    ]),
]

_CHAPTER_LOOKUP: dict[int, tuple[str, dict[str, str]]] = {
    num: (title, {sid: stitle for sid, stitle in sections})
    for num, title, sections in FLS_CHAPTERS
}


def format_section_reference(chapter: int, section_id: str) -> str:
    """Match FocusOnLifeScienceCatalog.formatSectionReference in Swift."""
    title, sec_map = _CHAPTER_LOOKUP.get(chapter, ("", {}))
    if section_id not in sec_map:
        return f"§{section_id}"
    rng = _estimated_section_page_range(chapter, section_id)
    if rng:
        return f"§{section_id} {sec_map[section_id]} (~p{rng[0]}–{rng[1]})"
    return f"§{section_id} {sec_map[section_id]}"


def _estimated_section_page_range(chapter: int, section_id: str) -> tuple[int, int] | None:
    sections = _CHAPTER_LOOKUP_SECTIONS.get(chapter, [])
    if section_id not in sections:
        return None
    index = sections.index(section_id)
    total = _chapter_page_count(chapter)
    count = len(sections)
    start_offset = int(total * index / count)
    end_offset = int(total * (index + 1) / count)
    start = START_PAGES[chapter] + start_offset
    end = START_PAGES[chapter] + end_offset - 1
    return start, max(start, end)


def format_chapter_sections(chapter: int, section_ids: list[str]) -> str:
    """Match FocusOnLifeScienceCatalog.formatChapterSections in Swift."""
    title, sec_map = _CHAPTER_LOOKUP.get(chapter, ("", {}))
    if not title:
        return f"Ch {chapter}"
    if not section_ids:
        return f"Ch {chapter} — {title}"
    refs = [format_section_reference(chapter, sid) for sid in section_ids if sid in sec_map]
    if not refs:
        return f"Ch {chapter} — {title}"
    return f"Ch {chapter} — {title} · {' · '.join(refs)}"


def format_fls_reading(chapter_sections: list[tuple[int, list[str]]]) -> str:
    parts = [format_chapter_sections(ch, secs) for ch, secs in chapter_sections]
    return "FLS " + " · ".join(parts)


# (week, day_idx) → chapter/section specs — mirrors BlockAssignedReadingCatalog.flsByKey
# day_idx: Mon=0, Tue=1, Wed=2, Thu=3, Fri=4
FLS_BY_BLOCK: dict[tuple[int, int], list[tuple[int, list[str]]]] = {
    (1, 1): [(1, ["1.3", "1.4"])],
    (1, 4): [(16, ["16.1"])],
    (2, 1): [(4, ["4.1", "4.2"])],
    (2, 4): [(4, ["4.3"])],
    (3, 1): [(7, ["7.2", "7.3"])],
    (3, 4): [(17, ["17.1"]), (18, ["18.1"])],
    (4, 1): [(5, ["5.1", "5.2"])],
    (4, 4): [(6, ["6.1"])],
    (5, 1): [(2, ["2.4"])],
    (5, 4): [(2, ["2.5"])],
    (6, 1): [(7, ["7.3"])],
    (6, 4): [(8, ["8.1", "8.2"])],
    (7, 1): [(21, ["21.1"])],
    (7, 4): [(10, ["10.1", "10.2"])],
    (8, 1): [(11, ["11.1"])],
    (8, 4): [(17, ["17.1"])],
    (9, 1): [(3, ["3.1", "3.2"])],
    (9, 4): [(18, ["18.1"]), (19, ["19.1"])],
}

# Printed start pages — matches FocusOnLifeScienceCatalog.startPage
START_PAGES = {
    1: 4, 2: 38, 3: 68, 4: 100, 5: 134, 6: 160, 7: 204, 8: 236, 9: 268,
    10: 298, 11: 328, 12: 364, 13: 396, 14: 430, 15: 468, 16: 508, 17: 530,
    18: 560, 19: 592, 20: 622, 21: 648, 22: 682, 23: 722,
}
_LAST_PAGE = 752
_CHAPTER_LOOKUP_SECTIONS: dict[int, list[str]] = {
    num: [sid for sid, _ in sections] for num, _, sections in FLS_CHAPTERS
}


def _chapter_page_count(chapter: int) -> int:
    nums = sorted(START_PAGES)
    start = START_PAGES[chapter]
    idx = nums.index(chapter)
    if idx + 1 < len(nums):
        return START_PAGES[nums[idx + 1]] - start
    return _LAST_PAGE - start + 1


def _estimated_section_pages(chapter: int, section_ids: list[str]) -> int:
    sections = _CHAPTER_LOOKUP_SECTIONS.get(chapter, [])
    if not sections or not section_ids:
        return 0
    matched = sum(1 for sid in section_ids if sid in sections)
    if matched == 0:
        return 0
    total = _chapter_page_count(chapter)
    return max(1, round(total * matched / len(sections)))


def estimated_pages(specs: list[tuple[int, list[str]]]) -> int:
    return sum(_estimated_section_pages(ch, secs) for ch, secs in specs)


def reading_pace_summary(specs: list[tuple[int, list[str]]]) -> str:
    pages = estimated_pages(specs)
    refs: list[str] = []
    for ch, secs in specs:
        for sid in secs:
            refs.append(format_section_reference(ch, sid))
    if not refs:
        return "Read assigned sections only — stop when Focus is covered"
    ref_line = " · ".join(refs)
    if len(specs) == 1:
        ch, secs = specs[0]
        whole = _chapter_page_count(ch)
        all_sections = _CHAPTER_LOOKUP_SECTIONS.get(ch, [])
        if len(secs) == len(all_sections):
            return f"Read {ref_line} (~{pages} pp · whole Ch {ch})"
        return f"Read {ref_line} (~{pages} pp · Ch {ch} is {whole} pp)"
    return f"Read {ref_line} (~{pages} pp total)"


def is_heavy_reading(specs: list[tuple[int, list[str]]]) -> bool:
    return estimated_pages(specs) >= 25


def fls_pace_note(week: int, day_idx: int) -> str:
    specs = FLS_BY_BLOCK.get((week, day_idx))
    if not specs:
        return ""
    return reading_pace_summary(specs)


# Primary lines for calendar HTML — § refs and page ranges in the title line
FLS_PRIMARY = {
    key: format_fls_reading(specs)
    + (" · Heavy day — split or OSB backup" if is_heavy_reading(specs) else "")
    for key, specs in FLS_BY_BLOCK.items()
}
FLS_PRIMARY[(10, 1)] = "FLS Review"
FLS_PRIMARY[(10, 4)] = "FLS Review"
