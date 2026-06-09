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
}
