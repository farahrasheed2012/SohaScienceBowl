#!/usr/bin/env python3
"""Verify POT 6 topic registry covers all school topics from Math POT Program Information.pdf."""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "Scripts"))
from pot6_curriculum import POT6_COMPETITION_CODES, POT6_SCHOOL_CODES

REGISTRY = ROOT / "Data" / "POT6TopicRegistry.swift"
DRILL_BANK = ROOT / "Data" / "POT6DrillBank.swift"
CATCH_UP = ROOT / "Data" / "POT6CatchUpCatalog.swift"
GEOMETRY = ROOT / "Data" / "POT6GeometryCatalog.swift"

EXPECTED_MIN_QUESTIONS_PER_TOPIC = 7
DIFFICULTIES = {"scaffold", "standard", "challenge"}


def extract_topic_entries(swift_text: str) -> list[dict]:
    entries = []
    blocks = re.split(r"MathTopic\(", swift_text)[1:]
    for block in blocks:
        code_m = re.search(r'code: "(T\d+|6HW\d+)"', block)
        comp_m = re.search(r"isCompetitionOnly: (true|false)", block)
        if code_m and comp_m:
            entries.append({
                "code": code_m.group(1),
                "is_competition": comp_m.group(1) == "true",
            })
    return entries


def extract_drill_entries(swift_text: str) -> list[dict]:
    entries = []
    blocks = re.split(r"MathDrillQuestion\(", swift_text)[1:]
    for block in blocks:
        code_m = re.search(r'topicCode: "(T\d+|6HW\d+)"', block)
        diff_m = re.search(r"difficulty: \.(\w+)", block)
        if code_m and diff_m:
            entries.append({"code": code_m.group(1), "difficulty": diff_m.group(1)})
    return entries


def extract_geometry_codes(swift_text: str) -> set[str]:
    codes: set[str] = set()
    for block in re.findall(r"return \[(.*?)\]", swift_text, re.DOTALL):
        codes.update(re.findall(r'"(T\d+|6HW\d+)"', block))
    for block in re.findall(r"potCodes: \[(.*?)\]", swift_text):
        codes.update(re.findall(r'"(T\d+|6HW\d+)"', block))
    return codes


def extract_schedule_algebra_codes() -> set[str]:
    """POT codes assigned on summer algebra weeks 3–10 (from bfn_algebra_catalog.PLAN)."""
    from bfn_algebra_catalog import PLAN

    codes: set[str] = set()
    for (week, _day), assignment in PLAN.items():
        if week >= 3:
            codes.update(assignment.pot_codes)
    return codes


def main() -> int:
    if not REGISTRY.exists() or not DRILL_BANK.exists():
        print("ERROR: POT6 data files missing. Run: python3 Scripts/generate_pot6_content.py")
        return 1

    registry_text = REGISTRY.read_text(encoding="utf-8")
    drill_text = DRILL_BANK.read_text(encoding="utf-8")
    catchup_text = CATCH_UP.read_text(encoding="utf-8") if CATCH_UP.exists() else ""
    geometry_text = GEOMETRY.read_text(encoding="utf-8") if GEOMETRY.exists() else ""

    topics = extract_topic_entries(registry_text)
    drills = extract_drill_entries(drill_text)
    topic_by_code = {t["code"]: t for t in topics}
    registry_codes = set(topic_by_code)

    geometry_codes = extract_geometry_codes(geometry_text) if geometry_text else set()
    algebra_codes = [c for c in POT6_SCHOOL_CODES if c not in geometry_codes]

    errors: list[str] = []

    for code in POT6_SCHOOL_CODES:
        if code not in registry_codes:
            errors.append(f"Missing school topic in registry: {code}")
        elif topic_by_code[code]["is_competition"]:
            errors.append(f"{code}: marked competition but is school-level in PDF")

    for code in POT6_COMPETITION_CODES:
        if code in registry_codes and not topic_by_code[code]["is_competition"]:
            errors.append(f"{code}: marked school but is competition-only in PDF")

    school_in_registry = {c for c in POT6_SCHOOL_CODES if c in registry_codes}
    by_topic: dict[str, dict[str, int]] = {}
    for d in drills:
        by_topic.setdefault(d["code"], {})
        by_topic[d["code"]][d["difficulty"]] = by_topic[d["code"]].get(d["difficulty"], 0) + 1

    for code in sorted(school_in_registry):
        counts = by_topic.get(code, {})
        total = sum(counts.values())
        if total < EXPECTED_MIN_QUESTIONS_PER_TOPIC:
            errors.append(f"{code}: only {total} drill questions (need ≥{EXPECTED_MIN_QUESTIONS_PER_TOPIC})")
        for diff in DIFFICULTIES:
            if counts.get(diff, 0) < 1:
                errors.append(f"{code}: missing {diff} difficulty")

    orphan_drills = set(by_topic) - registry_codes
    for code in sorted(orphan_drills):
        errors.append(f"Orphan drill topicCode: {code}")

    catchup_codes = set(re.findall(r'potCode: "(T\d+|6HW\d+|MIX\d+)"', catchup_text))
    for code in algebra_codes:
        if code not in catchup_codes:
            errors.append(f"Missing algebra topic in POT6CatchUpCatalog: {code}")

    for code in algebra_codes:
        if code in geometry_codes:
            errors.append(f"{code}: listed in both algebra catch-up and geometry catalog")

    for code in sorted(geometry_codes):
        if code not in POT6_SCHOOL_CODES:
            errors.append(f"Geometry catalog has non-school code: {code}")
        elif code not in registry_codes:
            errors.append(f"Geometry catalog missing from registry: {code}")

    schedule_codes = extract_schedule_algebra_codes()
    for code in algebra_codes:
        if code not in schedule_codes:
            errors.append(f"Missing algebra topic on summer calendar (weeks 3–10): {code}")
    for code in sorted(schedule_codes):
        if code.startswith("MIX"):
            continue
        if code in geometry_codes:
            errors.append(f"Geometry code on algebra summer calendar: {code}")
        elif code not in algebra_codes:
            errors.append(f"Non-algebra code on summer calendar: {code}")

    if errors:
        print("POT 6 verify FAILED:")
        for e in errors[:40]:
            print(f"  - {e}")
        if len(errors) > 40:
            print(f"  ... and {len(errors) - 40} more")
        return 1

    comp_covered = sum(1 for c in POT6_COMPETITION_CODES if c in registry_codes)
    print(
        f"POT 6 verify OK: {len(POT6_SCHOOL_CODES)}/{len(POT6_SCHOOL_CODES)} school topics in registry, "
        f"{len(algebra_codes)} algebra in catch-up, {len(geometry_codes)} geometry in Geo tab, "
        f"{len(schedule_codes - {'MIX1', 'MIX2'})}/{len(algebra_codes)} algebra on summer calendar, "
        f"{comp_covered}/{len(POT6_COMPETITION_CODES)} competition topics in registry, "
        f"{len(drills)} drill questions total."
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
