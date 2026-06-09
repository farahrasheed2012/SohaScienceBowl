import Foundation

/// Prentice Hall Science Explorer: Focus on Life Science — California Edition (2001).
enum FocusOnLifeScienceCatalog {
    struct UnitInfo: Hashable {
        let id: String
        let name: String
    }

    struct Chapter: Hashable {
        let number: Int
        let title: String
        let unit: UnitInfo
        let startPage: Int
    }

    static let editionTitle = "Prentice Hall Science Explorer: Focus on Life Science (California Edition)"

    private static let units: [UnitInfo] = [
        UnitInfo(id: "u1", name: "Unit 1 — Cell Biology and Genetics"),
        UnitInfo(id: "u2", name: "Unit 2 — Evolution and Earth's History"),
        UnitInfo(id: "u3", name: "Unit 3 — Structure and Function in Living Things"),
        UnitInfo(id: "u4", name: "Unit 4 — Human Body Systems"),
    ]

    static let chapters: [Chapter] = [
        Chapter(number: 1, title: "Cell Structure and Function", unit: units[0], startPage: 4),
        Chapter(number: 2, title: "Cell Processes and Energy", unit: units[0], startPage: 38),
        Chapter(number: 3, title: "Genetics: The Science of Heredity", unit: units[0], startPage: 68),
        Chapter(number: 4, title: "Modern Genetics", unit: units[0], startPage: 100),
        Chapter(number: 5, title: "Evolution", unit: units[1], startPage: 134),
        Chapter(number: 6, title: "Earth's History", unit: units[1], startPage: 160),
        Chapter(number: 7, title: "Living Things", unit: units[2], startPage: 204),
        Chapter(number: 8, title: "Viruses and Bacteria", unit: units[2], startPage: 236),
        Chapter(number: 9, title: "Protists and Fungi", unit: units[2], startPage: 268),
        Chapter(number: 10, title: "Introduction to Plants", unit: units[2], startPage: 298),
        Chapter(number: 11, title: "Seed Plants", unit: units[2], startPage: 328),
        Chapter(number: 12, title: "Sponges, Cnidarians, and Worms", unit: units[2], startPage: 364),
        Chapter(number: 13, title: "Mollusks, Arthropods, and Echinoderms", unit: units[2], startPage: 396),
        Chapter(number: 14, title: "Fishes, Amphibians, and Reptiles", unit: units[2], startPage: 430),
        Chapter(number: 15, title: "Birds and Mammals", unit: units[2], startPage: 468),
        Chapter(number: 16, title: "Healthy Body Systems", unit: units[3], startPage: 508),
        Chapter(number: 17, title: "Bones, Muscles, and Skin", unit: units[3], startPage: 530),
        Chapter(number: 18, title: "Food and Digestion", unit: units[3], startPage: 560),
        Chapter(number: 19, title: "Circulation", unit: units[3], startPage: 592),
        Chapter(number: 20, title: "Respiration and Excretion", unit: units[3], startPage: 622),
        Chapter(number: 21, title: "Fighting Disease", unit: units[3], startPage: 648),
        Chapter(number: 22, title: "The Nervous System", unit: units[3], startPage: 682),
        Chapter(number: 23, title: "The Endocrine System and Reproduction", unit: units[3], startPage: 722),
    ]

    private static let byNumber: [Int: Chapter] = {
        Dictionary(uniqueKeysWithValues: chapters.map { ($0.number, $0) })
    }()

    static func chapter(_ number: Int) -> Chapter? {
        byNumber[number]
    }

    static func formatReference(_ chapterPart: String) -> String {
        let numbers = parseChapterNumbers(chapterPart)
        guard !numbers.isEmpty else { return "Ch \(chapterPart)" }

        return numbers.compactMap { number in
            guard let ch = chapter(number) else { return "Ch \(number)" }
            return "\(ch.unit.name) · Ch \(ch.number) — \(ch.title)"
        }.joined(separator: " · ")
    }

    static func parseChapterNumbers(_ chapterPart: String) -> [Int] {
        var result: [Int] = []
        let normalized = chapterPart
            .replacingOccurrences(of: "Ch ", with: "")
            .trimmingCharacters(in: .whitespaces)

        for segment in normalized.split(separator: "·").map({ $0.trimmingCharacters(in: .whitespaces) }) {
            if segment.contains("–") {
                let bounds = segment.split(separator: "–").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
                if bounds.count == 2, bounds[0] <= bounds[1] {
                    result.append(contentsOf: bounds[0]...bounds[1])
                    continue
                }
            }
            if let n = Int(segment) {
                result.append(n)
            }
        }
        return result
    }

    static var chaptersGroupedByUnit: [(unit: UnitInfo, chapters: [Chapter])] {
        var seen = Set<String>()
        var groups: [(UnitInfo, [Chapter])] = []
        for chapter in chapters {
            if seen.insert(chapter.unit.id).inserted {
                groups.append((chapter.unit, chapters.filter { $0.unit.id == chapter.unit.id }))
            }
        }
        return groups
    }
}
