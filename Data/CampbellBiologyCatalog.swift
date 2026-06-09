import Foundation

/// Campbell Biology: Concepts & Connections, 7th Edition — official unit/chapter index.
enum CampbellBiologyCatalog {
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

    static let editionTitle = "Campbell Biology: Concepts & Connections (7th Edition)"

    private static let units: [UnitInfo] = [
        UnitInfo(id: "intro", name: "Intro"),
        UnitInfo(id: "u1", name: "Unit I — The Life of the Cell"),
        UnitInfo(id: "u2", name: "Unit II — Cellular Reproduction and Genetics"),
        UnitInfo(id: "u3", name: "Unit III — Concepts of Evolution"),
        UnitInfo(id: "u4", name: "Unit IV — The Evolution of Biological Diversity"),
        UnitInfo(id: "u5", name: "Unit V — Animals: Form and Function"),
        UnitInfo(id: "u6", name: "Unit VI — Plants: Form and Function"),
        UnitInfo(id: "u7", name: "Unit VII — Ecology"),
    ]

    static let chapters: [Chapter] = [
        Chapter(number: 1, title: "Biology: Exploring Life", unit: units[0], startPage: 1),
        Chapter(number: 2, title: "The Chemical Basis of Life", unit: units[1], startPage: 16),
        Chapter(number: 3, title: "The Molecules of Cells", unit: units[1], startPage: 32),
        Chapter(number: 4, title: "A Tour of the Cell", unit: units[1], startPage: 50),
        Chapter(number: 5, title: "The Working Cell", unit: units[1], startPage: 72),
        Chapter(number: 6, title: "How Cells Harvest Chemical Energy", unit: units[1], startPage: 88),
        Chapter(number: 7, title: "Photosynthesis: Using Light to Make Food", unit: units[1], startPage: 106),
        Chapter(number: 8, title: "The Cellular Basis of Reproduction and Inheritance", unit: units[2], startPage: 124),
        Chapter(number: 9, title: "Patterns of Inheritance", unit: units[2], startPage: 152),
        Chapter(number: 10, title: "Molecular Biology of the Gene", unit: units[2], startPage: 180),
        Chapter(number: 11, title: "How Genes Are Controlled", unit: units[2], startPage: 208),
        Chapter(number: 12, title: "DNA Technology and Genomics", unit: units[2], startPage: 230),
        Chapter(number: 13, title: "How Populations Evolve", unit: units[3], startPage: 254),
        Chapter(number: 14, title: "The Origin of Species", unit: units[3], startPage: 276),
        Chapter(number: 15, title: "Tracing Evolutionary History", unit: units[3], startPage: 292),
        Chapter(number: 16, title: "Microbial Life: Prokaryotes and Protists", unit: units[4], startPage: 318),
        Chapter(number: 17, title: "The Evolution of Plant and Fungal Diversity", unit: units[4], startPage: 340),
        Chapter(number: 18, title: "The Evolution of Invertebrate Diversity", unit: units[4], startPage: 364),
        Chapter(number: 19, title: "The Evolution of Vertebrate Diversity", unit: units[4], startPage: 388),
        Chapter(number: 20, title: "Unifying Concepts of Animal Structure and Function", unit: units[5], startPage: 412),
        Chapter(number: 21, title: "Nutrition and Digestion", unit: units[5], startPage: 428),
        Chapter(number: 22, title: "Gas Exchange", unit: units[5], startPage: 452),
        Chapter(number: 23, title: "Circulation", unit: units[5], startPage: 466),
        Chapter(number: 24, title: "The Immune System", unit: units[5], startPage: 484),
        Chapter(number: 25, title: "Control of Body Temperature and Water Balance", unit: units[5], startPage: 504),
        Chapter(number: 26, title: "Hormones and the Endocrine System", unit: units[5], startPage: 516),
        Chapter(number: 27, title: "Reproduction and Embryonic Development", unit: units[5], startPage: 532),
        Chapter(number: 28, title: "Nervous Systems", unit: units[5], startPage: 562),
        Chapter(number: 29, title: "The Senses", unit: units[5], startPage: 586),
        Chapter(number: 30, title: "How Animals Move", unit: units[5], startPage: 602),
        Chapter(number: 31, title: "Plant Structure, Growth, and Reproduction", unit: units[6], startPage: 620),
        Chapter(number: 32, title: "Plant Nutrition and Transport", unit: units[6], startPage: 642),
        Chapter(number: 33, title: "Control Systems in Plants", unit: units[6], startPage: 660),
        Chapter(number: 34, title: "The Biosphere: An Introduction to Earth's Diverse Environments", unit: units[7], startPage: 678),
        Chapter(number: 35, title: "Behavioral Adaptations to the Environment", unit: units[7], startPage: 698),
        Chapter(number: 36, title: "Population Ecology", unit: units[7], startPage: 722),
        Chapter(number: 37, title: "Communities and Ecosystems", unit: units[7], startPage: 738),
        Chapter(number: 38, title: "Conservation Biology", unit: units[7], startPage: 760),
    ]

    private static let byNumber: [Int: Chapter] = {
        Dictionary(uniqueKeysWithValues: chapters.map { ($0.number, $0) })
    }()

    static func chapter(_ number: Int) -> Chapter? {
        byNumber[number]
    }

    /// Formats `4`, `6–7`, `21–23`, or `16 · 24` (without a leading `Ch`).
    static func formatReference(_ chapterPart: String) -> String {
        let numbers = parseChapterNumbers(chapterPart)
        guard !numbers.isEmpty else { return "Ch \(chapterPart)" }

        return numbers.compactMap { number in
            guard let ch = chapter(number) else { return "Ch \(number)" }
            return "\(ch.unit.name) · Ch \(ch.number) — \(ch.title)"
        }.joined(separator: " · ")
    }

    /// Single-line label for topic browser rows: `Unit I · Ch 4 — A Tour of the Cell`
    static func shortLabel(forChapterPart chapterPart: String) -> String {
        formatReference(chapterPart)
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

    /// All chapters grouped by unit (for Topics reference).
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
