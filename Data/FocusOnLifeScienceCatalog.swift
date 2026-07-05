import Foundation

/// Prentice Hall Science Explorer: Focus on Life Science — California Edition (2001).
enum FocusOnLifeScienceCatalog {
    struct UnitInfo: Hashable {
        let id: String
        let name: String
    }

    struct Section: Hashable {
        let id: String
        let title: String
    }

    struct Chapter: Hashable {
        let number: Int
        let title: String
        let unit: UnitInfo
        let startPage: Int
        let sections: [Section]
    }

    static let editionTitle = "Prentice Hall Science Explorer: Focus on Life Science (California Edition)"

    private static let units: [UnitInfo] = [
        UnitInfo(id: "u1", name: "Unit 1 — Cell Biology and Genetics"),
        UnitInfo(id: "u2", name: "Unit 2 — Evolution and Earth's History"),
        UnitInfo(id: "u3", name: "Unit 3 — Structure and Function in Living Things"),
        UnitInfo(id: "u4", name: "Unit 4 — Human Body Systems"),
    ]

    static let chapters: [Chapter] = [
        Chapter(number: 1, title: "Cell Structure and Function", unit: units[0], startPage: 4, sections: [Section(id: "1.1", title: "Cells and the Cell Theory"), Section(id: "1.2", title: "Cell Size"), Section(id: "1.3", title: "Parts of a Cell"), Section(id: "1.4", title: "Two Kinds of Cells")]),
        Chapter(number: 2, title: "Cell Processes and Energy", unit: units[0], startPage: 38, sections: [Section(id: "2.1", title: "Chemical Compounds in Cells"), Section(id: "2.2", title: "The Cell Membrane"), Section(id: "2.3", title: "Chemical Reactions and Energy"), Section(id: "2.4", title: "Photosynthesis"), Section(id: "2.5", title: "Cellular Respiration")]),
        Chapter(number: 3, title: "Genetics: The Science of Heredity", unit: units[0], startPage: 68, sections: [Section(id: "3.1", title: "Genetics: The Science of Heredity"), Section(id: "3.2", title: "Traits and Inheritance"), Section(id: "3.3", title: "Patterns of Heredity")]),
        Chapter(number: 4, title: "Modern Genetics", unit: units[0], startPage: 100, sections: [Section(id: "4.1", title: "Human Inheritance"), Section(id: "4.2", title: "Advances in Modern Genetics"), Section(id: "4.3", title: "Genetic Disorders")]),
        Chapter(number: 5, title: "Evolution", unit: units[1], startPage: 134, sections: [Section(id: "5.1", title: "Evidence for Evolution"), Section(id: "5.2", title: "How Evolution Works"), Section(id: "5.3", title: "Natural Selection")]),
        Chapter(number: 6, title: "Earth's History", unit: units[1], startPage: 160, sections: [Section(id: "6.1", title: "Fossil Evidence"), Section(id: "6.2", title: "Geologic Time"), Section(id: "6.3", title: "Earth's Past")]),
        Chapter(number: 7, title: "Living Things", unit: units[2], startPage: 204, sections: [Section(id: "7.1", title: "What Is Life?"), Section(id: "7.2", title: "Classification of Living Things"), Section(id: "7.3", title: "The Six Kingdoms")]),
        Chapter(number: 8, title: "Viruses and Bacteria", unit: units[2], startPage: 236, sections: [Section(id: "8.1", title: "Bacteria"), Section(id: "8.2", title: "Viruses")]),
        Chapter(number: 9, title: "Protists and Fungi", unit: units[2], startPage: 268, sections: [Section(id: "9.1", title: "Protists"), Section(id: "9.2", title: "Fungi")]),
        Chapter(number: 10, title: "Introduction to Plants", unit: units[2], startPage: 298, sections: [Section(id: "10.1", title: "What Are Plants?"), Section(id: "10.2", title: "Roots, Stems, and Leaves"), Section(id: "10.3", title: "Reproduction in Flowering Plants")]),
        Chapter(number: 11, title: "Seed Plants", unit: units[2], startPage: 328, sections: [Section(id: "11.1", title: "Seed Plants"), Section(id: "11.2", title: "Plant Responses")]),
        Chapter(number: 12, title: "Sponges, Cnidarians, and Worms", unit: units[2], startPage: 364, sections: [Section(id: "12.1", title: "Sponges and Cnidarians"), Section(id: "12.2", title: "Worms")]),
        Chapter(number: 13, title: "Mollusks, Arthropods, and Echinoderms", unit: units[2], startPage: 396, sections: [Section(id: "13.1", title: "Mollusks"), Section(id: "13.2", title: "Arthropods"), Section(id: "13.3", title: "Echinoderms")]),
        Chapter(number: 14, title: "Fishes, Amphibians, and Reptiles", unit: units[2], startPage: 430, sections: [Section(id: "14.1", title: "Fishes"), Section(id: "14.2", title: "Amphibians"), Section(id: "14.3", title: "Reptiles")]),
        Chapter(number: 15, title: "Birds and Mammals", unit: units[2], startPage: 468, sections: [Section(id: "15.1", title: "Birds"), Section(id: "15.2", title: "Mammals")]),
        Chapter(number: 16, title: "Healthy Body Systems", unit: units[3], startPage: 508, sections: [Section(id: "16.1", title: "Your Body Systems"), Section(id: "16.2", title: "Staying Healthy")]),
        Chapter(number: 17, title: "Bones, Muscles, and Skin", unit: units[3], startPage: 530, sections: [Section(id: "17.1", title: "Bones and Muscles"), Section(id: "17.2", title: "The Skin")]),
        Chapter(number: 18, title: "Food and Digestion", unit: units[3], startPage: 560, sections: [Section(id: "18.1", title: "Food and Energy"), Section(id: "18.2", title: "The Digestive System")]),
        Chapter(number: 19, title: "Circulation", unit: units[3], startPage: 592, sections: [Section(id: "19.1", title: "The Circulatory System"), Section(id: "19.2", title: "Blood and Lymph")]),
        Chapter(number: 20, title: "Respiration and Excretion", unit: units[3], startPage: 622, sections: [Section(id: "20.1", title: "The Respiratory System"), Section(id: "20.2", title: "The Excretory System")]),
        Chapter(number: 21, title: "Fighting Disease", unit: units[3], startPage: 648, sections: [Section(id: "21.1", title: "The Body's Defenses"), Section(id: "21.2", title: "Infectious Disease")]),
        Chapter(number: 22, title: "The Nervous System", unit: units[3], startPage: 682, sections: [Section(id: "22.1", title: "The Nervous System"), Section(id: "22.2", title: "The Senses")]),
        Chapter(number: 23, title: "The Endocrine System and Reproduction", unit: units[3], startPage: 722, sections: [Section(id: "23.1", title: "The Endocrine System"), Section(id: "23.2", title: "Human Reproduction")]),
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

    static func sectionTitle(chapter chapterNumber: Int, sectionId: String) -> String? {
        guard let ch = chapter(chapterNumber) else { return nil }
        return ch.sections.first { $0.id == sectionId }?.title
    }

    /// e.g. `§4.1 Human Inheritance (~p100–110)`
    static func formatSectionReference(chapter chapterNumber: Int, sectionId: String) -> String {
        guard let title = sectionTitle(chapter: chapterNumber, sectionId: sectionId),
              let range = estimatedSectionPageRange(chapter: chapterNumber, sectionId: sectionId) else {
            return "§\(sectionId)"
        }
        return "§\(sectionId) \(title) (~p\(range.start)–\(range.end))"
    }

    /// e.g. `Ch 4 — Modern Genetics · §4.1 Human Inheritance (~p100–110) · §4.2 Advances… (~p111–121)`
    static func formatChapterSections(chapter chapterNumber: Int, sectionIds: [String]) -> String {
        guard let ch = chapter(chapterNumber) else { return "Ch \(chapterNumber)" }
        if sectionIds.isEmpty {
            return "Ch \(ch.number) — \(ch.title)"
        }
        let refs = sectionIds.map { formatSectionReference(chapter: chapterNumber, sectionId: $0) }
        return "Ch \(ch.number) — \(ch.title) · \(refs.joined(separator: " · "))"
    }

    /// One or more chapters; section ids are internal catalog keys mapped to printed section titles.
    static func formatReadingLine(chapterSections: [(chapter: Int, sectionIds: [String])]) -> String {
        chapterSections
            .map { formatChapterSections(chapter: $0.chapter, sectionIds: $0.sectionIds) }
            .joined(separator: " · ")
    }

    private static let lastPrintedPage = 752

    /// Printed page span for a full chapter (not assigned reading — context only).
    static func chapterPageCount(_ number: Int) -> Int {
        guard let ch = chapter(number) else { return 0 }
        if let next = chapters.first(where: { $0.number == number + 1 }) {
            return next.startPage - ch.startPage
        }
        return lastPrintedPage - ch.startPage + 1
    }

    /// Rough printed page range for one section (even split within chapter).
    static func estimatedSectionPageRange(chapter number: Int, sectionId: String) -> (start: Int, end: Int)? {
        guard let ch = chapter(number),
              let index = ch.sections.firstIndex(where: { $0.id == sectionId }) else { return nil }
        let total = chapterPageCount(number)
        let count = ch.sections.count
        let startOffset = Int((Double(total) * Double(index) / Double(count)).rounded(.down))
        let endOffset = Int((Double(total) * Double(index + 1) / Double(count)).rounded(.down))
        let start = ch.startPage + startOffset
        let end = ch.startPage + endOffset - 1
        return (start, max(start, end))
    }

    /// Rough page count for assigned section ids (even split across chapter sections).
    static func estimatedSectionPages(chapter number: Int, sectionIds: [String]) -> Int {
        guard let ch = chapter(number), !ch.sections.isEmpty, !sectionIds.isEmpty else { return 0 }
        let total = chapterPageCount(number)
        let matched = sectionIds.filter { id in ch.sections.contains { $0.id == id } }.count
        guard matched > 0 else { return 0 }
        return max(1, Int((Double(total) * Double(matched) / Double(ch.sections.count)).rounded()))
    }

    static func estimatedPages(chapterSections: [(chapter: Int, sectionIds: [String])]) -> Int {
        chapterSections.reduce(0) { partial, spec in
            partial + estimatedSectionPages(chapter: spec.chapter, sectionIds: spec.sectionIds)
        }
    }

    /// ≥25 estimated pages in one bio block — split or use OSB backup.
    static func isHeavyReading(chapterSections: [(chapter: Int, sectionIds: [String])]) -> Bool {
        estimatedPages(chapterSections: chapterSections) >= 25
    }

    /// e.g. `Read §4.1 Human Inheritance (~p100–110) · §4.2 Advances… (~p111–121) (~23 pp · Ch 4 is 34 pp)`
    static func readingPaceSummary(chapterSections: [(chapter: Int, sectionIds: [String])]) -> String {
        let pages = estimatedPages(chapterSections: chapterSections)
        let refs = chapterSections.flatMap { spec in
            spec.sectionIds.map { formatSectionReference(chapter: spec.chapter, sectionId: $0) }
        }
        guard !refs.isEmpty else { return "Read assigned sections only — stop when Focus is covered" }

        let refLine = refs.joined(separator: " · ")
        if chapterSections.count == 1, let spec = chapterSections.first {
            let whole = chapterPageCount(spec.chapter)
            if let ch = chapter(spec.chapter), spec.sectionIds.count == ch.sections.count {
                return "Read \(refLine) (~\(pages) pp · whole Ch \(spec.chapter))"
            }
            return "Read \(refLine) (~\(pages) pp · Ch \(spec.chapter) is \(whole) pp)"
        }
        return "Read \(refLine) (~\(pages) pp total)"
    }
}
