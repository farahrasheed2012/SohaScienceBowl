"""Auto-generated from build_expl_catalog.py — do not edit by hand."""

EXP_CH: dict[int, tuple[str, str]] = {
    1: ("Front Matter", "About Science"),
    2: ("Part One — Mechanics", "Newton's First Law of Motion—The Law of Inertia"),
    3: ("Part One — Mechanics", "Newton's Second Law of Motion—Force and Acceleration"),
    4: ("Part One — Mechanics", "Newton's Third Law of Motion—Action and Reaction"),
    5: ("Part One — Mechanics", "Momentum"),
    6: ("Part One — Mechanics", "Energy"),
    7: ("Part One — Mechanics", "Gravity, Projectiles, and Satellite Motion"),
    8: ("Part One — Mechanics", "Fluid Mechanics"),
    9: ("Part Two — Forms of Energy", "Heat"),
    10: ("Part Two — Forms of Energy", "Electricity"),
    11: ("Part Two — Forms of Energy", "Magnetism"),
    12: ("Part Two — Forms of Energy", "Waves and Sound"),
    13: ("Part Two — Forms of Energy", "Light, Reflection, and Color"),
    14: ("Part Two — Forms of Energy", "Properties of Light"),
    15: ("Part Two — Forms of Energy", "The Atom"),
    16: ("Part Two — Forms of Energy", "Nuclear Energy"),
    17: ("Part Three — Chemistry", "Elements of Chemistry"),
    18: ("Part Three — Chemistry", "How Atoms Bond and Molecules Attract"),
    19: ("Part Three — Chemistry", "How Chemicals Mix"),
    20: ("Part Three — Chemistry", "How Chemicals React"),
    21: ("Part Three — Chemistry", "Two Types of Chemical Reactions"),
    22: ("Part Three — Chemistry", "Organic Compounds"),
    23: ("Part Three — Chemistry", "The Nutrients of Life"),
    24: ("Part Three — Chemistry", "Medicinal Chemistry"),
    25: ("Part Four — Earth Science", "Rocks and Minerals"),
    26: ("Part Four — Earth Science", "The Architecture of Earth"),
    27: ("Part Four — Earth Science", "Plate Tectonics—A Unifying Theory"),
    28: ("Part Four — Earth Science", "Shaping Earth's Surface"),
    29: ("Part Four — Earth Science", "Geologic Time—Reading the Rock Record"),
    30: ("Part Four — Earth Science", "The Atmosphere, the Oceans, and Their Interactions"),
    31: ("Part Four — Earth Science", "Weather"),
    32: ("Part Five — Astronomy", "The Solar System"),
    33: ("Part Five — Astronomy", "Stars"),
    34: ("Part Five — Astronomy", "Galaxies and the Cosmos"),
}

EXP_APPENDIX = {
    "A": "On Measurement and Unit Conversion",
    "B": "Linear and Rotational Motion",
    "C": "Working with Vector Components",
    "D": "Exponential Growth and Doubling Time",
    "E": "Safety",
}

def expl(*parts: str) -> str:
    """Format Expl refs: expl("17"), expl("2", "4"), expl("1 + App. B")."""
    if not parts:
        return ""
    if len(parts) == 1:
        return _expl_single(parts[0])
    return " · ".join(_expl_single(p) for p in parts)

def _expl_single(chapter_spec: str) -> str:
    parts: list[str] = []
    spec = chapter_spec.replace("Ch ", "").strip()
    if "App." in spec:
        for segment in spec.split("+"):
            piece = segment.strip()
            if "App." in piece:
                letter = piece.replace("App.", "").replace("Appendix", "").strip()
                title = EXP_APPENDIX.get(letter, piece)
                parts.append(f"Appendix {letter} — {title}")
            else:
                parts.extend(_format_chapter_piece(piece))
        return " · ".join(parts)
    labels = _format_chapter_piece(spec)
    return " · ".join(labels)

def _format_chapter_piece(piece: str) -> list[str]:
    labels: list[str] = []
    for segment in piece.split("·"):
        segment = segment.strip()
        if "–" in segment or "-" in segment:
            sep = "–" if "–" in segment else "-"
            start, end = segment.split(sep, 1)
            for n in range(int(start.strip()), int(end.strip()) + 1):
                labels.append(_chapter_label(n))
        elif segment.isdigit():
            labels.append(_chapter_label(int(segment)))
    return labels if labels else [piece]

def _chapter_label(n: int) -> str:
    part, title = EXP_CH[n]
    return f"{part} · Ch {n} — {title}"
