#!/usr/bin/env python3
"""Build FocusOnLifeScienceCatalog.swift with chapter sections for reading checkboxes."""

from pathlib import Path

from fls_toc_data import FLS_CHAPTERS

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "Data/FocusOnLifeScienceCatalog.swift"

UNITS = [
    ("u1", "Unit 1 — Cell Biology and Genetics", [1, 2, 3, 4]),
    ("u2", "Unit 2 — Evolution and Earth's History", [5, 6]),
    ("u3", "Unit 3 — Structure and Function in Living Things", list(range(7, 16))),
    ("u4", "Unit 4 — Human Body Systems", list(range(16, 24))),
]

START_PAGES = {
    1: 4, 2: 38, 3: 68, 4: 100, 5: 134, 6: 160, 7: 204, 8: 236, 9: 268,
    10: 298, 11: 328, 12: 364, 13: 396, 14: 430, 15: 468, 16: 508, 17: 530,
    18: 560, 19: 592, 20: 622, 21: 648, 22: 682, 23: 722,
}

chapter_by_number = {num: (title, sections) for num, title, sections in FLS_CHAPTERS}


def esc(s: str) -> str:
    return s.replace("\\", "\\\\").replace('"', '\\"')


def unit_var(i: int) -> str:
    return f"units[{i}]"


def emit_chapter(num: int, unit_var_name: str) -> str:
    title, sections = chapter_by_number[num]
    sec_parts = ", ".join(
        f'Section(id: "{esc(sid)}", title: "{esc(stitle)}")' for sid, stitle in sections
    )
    return (
        f'Chapter(number: {num}, title: "{esc(title)}", unit: {unit_var_name}, '
        f"startPage: {START_PAGES[num]}, sections: [{sec_parts}])"
    )


def main() -> None:
    lines = [
        "import Foundation",
        "",
        "/// Prentice Hall Science Explorer: Focus on Life Science — California Edition (2001).",
        "enum FocusOnLifeScienceCatalog {",
        "    struct UnitInfo: Hashable {",
        '        let id: String',
        '        let name: String',
        "    }",
        "",
        "    struct Section: Hashable {",
        '        let id: String',
        '        let title: String',
        "    }",
        "",
        "    struct Chapter: Hashable {",
        "        let number: Int",
        '        let title: String',
        "        let unit: UnitInfo",
        "        let startPage: Int",
        "        let sections: [Section]",
        "    }",
        "",
        '    static let editionTitle = "Prentice Hall Science Explorer: Focus on Life Science (California Edition)"',
        "",
        "    private static let units: [UnitInfo] = [",
    ]
    for uid, name, _ in UNITS:
        lines.append(f'        UnitInfo(id: "{uid}", name: "{esc(name)}"),')
    lines.append("    ]")
    lines.append("")
    lines.append("    static let chapters: [Chapter] = [")
    for i, (_, _, nums) in enumerate(UNITS):
        for num in nums:
            lines.append("        " + emit_chapter(num, unit_var(i)) + ",")
    lines.append("    ]")
    lines.append("")
    lines.extend([
        "    private static let byNumber: [Int: Chapter] = {",
        "        Dictionary(uniqueKeysWithValues: chapters.map { ($0.number, $0) })",
        "    }()",
        "",
        "    static func chapter(_ number: Int) -> Chapter? {",
        "        byNumber[number]",
        "    }",
        "",
        "    static func formatReference(_ chapterPart: String) -> String {",
        "        let numbers = parseChapterNumbers(chapterPart)",
        "        guard !numbers.isEmpty else { return \"Ch \\(chapterPart)\" }",
        "",
        "        return numbers.compactMap { number in",
        "            guard let ch = chapter(number) else { return \"Ch \\(number)\" }",
        "            return \"\\(ch.unit.name) · Ch \\(ch.number) — \\(ch.title)\"",
        "        }.joined(separator: \" · \")",
        "    }",
        "",
        "    static func parseChapterNumbers(_ chapterPart: String) -> [Int] {",
        "        var result: [Int] = []",
        "        let normalized = chapterPart",
        "            .replacingOccurrences(of: \"Ch \", with: \"\")",
        "            .trimmingCharacters(in: .whitespaces)",
        "",
        "        for segment in normalized.split(separator: \"·\").map({ $0.trimmingCharacters(in: .whitespaces) }) {",
        "            if segment.contains(\"–\") {",
        "                let bounds = segment.split(separator: \"–\").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }",
        "                if bounds.count == 2, bounds[0] <= bounds[1] {",
        "                    result.append(contentsOf: bounds[0]...bounds[1])",
        "                    continue",
        "                }",
        "            }",
        "            if let n = Int(segment) {",
        "                result.append(n)",
        "            }",
        "        }",
        "        return result",
        "    }",
        "",
        "    static var chaptersGroupedByUnit: [(unit: UnitInfo, chapters: [Chapter])] {",
        "        var seen = Set<String>()",
        "        var groups: [(UnitInfo, [Chapter])] = []",
        "        for chapter in chapters {",
        "            if seen.insert(chapter.unit.id).inserted {",
        "                groups.append((chapter.unit, chapters.filter { $0.unit.id == chapter.unit.id }))",
        "            }",
        "        }",
        "        return groups",
        "    }",
        "}",
        "",
    ])
    OUT.write_text("\n".join(lines), encoding="utf-8")
    total_sections = sum(len(s) for _, _, s in FLS_CHAPTERS)
    print(f"Wrote {OUT.name} — {len(FLS_CHAPTERS)} chapters, {total_sections} sections")


if __name__ == "__main__":
    main()
