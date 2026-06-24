import Foundation

/// Full table of contents — *Big Fat Notebook: High School Chemistry* (ISBN 9781523504251).
enum BFNChemistryCatalog {
    static let editionTitle = "Big Fat Notebook: High School Chemistry"
    static let bookCode = "BFN-C"
    static let isbn = "9781523504251"
    static let chapterCount = 36

    struct Unit: Hashable, Identifiable {
        let number: Int
        let name: String
        let startPage: Int

        var id: Int { number }
    }

    struct Chapter: Hashable, Identifiable {
        let number: Int
        let title: String
        let unitNumber: Int

        var id: Int { number }

        var trackableId: String { "BFN-C-ch-\(number)" }

        var label: String { "Ch \(number) — \(title)" }

        var shortTitle: String { title }
    }

    static let units: [Unit] = [
        Unit(number: 1, name: "Basics of Chemistry", startPage: 1),
        Unit(number: 2, name: "All About Matter", startPage: 73),
        Unit(number: 3, name: "Atomic Theory and Electron Configuration", startPage: 113),
        Unit(number: 4, name: "Elements and the Periodic Table", startPage: 135),
        Unit(number: 5, name: "Bonding and VSEPR Theory", startPage: 179),
        Unit(number: 6, name: "Chemical Compounds", startPage: 231),
        Unit(number: 7, name: "Chemical Reactions and Calculations", startPage: 273),
        Unit(number: 8, name: "Gases", startPage: 311),
        Unit(number: 9, name: "Solutions and Solubility", startPage: 347),
        Unit(number: 10, name: "Acids and Bases", startPage: 383),
        Unit(number: 11, name: "Chemical Equilibrium", startPage: 423),
        Unit(number: 12, name: "Thermodynamics", startPage: 451),
    ]

    static let chapters: [Chapter] = [
        Chapter(number: 1, title: "Introduction to Chemistry", unitNumber: 1),
        Chapter(number: 2, title: "Conducting Experiments", unitNumber: 1),
        Chapter(number: 3, title: "Lab Reports and Evaluating Results", unitNumber: 1),
        Chapter(number: 4, title: "Measurement", unitNumber: 1),
        Chapter(number: 5, title: "Lab Safety and Scientific Tools", unitNumber: 1),
        Chapter(number: 6, title: "Properties of Matter and Changes in Form", unitNumber: 2),
        Chapter(number: 7, title: "States of Matter", unitNumber: 2),
        Chapter(number: 8, title: "Atoms, Elements, Compounds, and Mixtures", unitNumber: 2),
        Chapter(number: 9, title: "Atomic Theory", unitNumber: 3),
        Chapter(number: 10, title: "Waves, Quantum Theory, and Photons", unitNumber: 3),
        Chapter(number: 11, title: "The Periodic Table", unitNumber: 4),
        Chapter(number: 12, title: "Periodic Trends", unitNumber: 4),
        Chapter(number: 13, title: "Electrons", unitNumber: 4),
        Chapter(number: 14, title: "Bonding", unitNumber: 5),
        Chapter(number: 15, title: "Valence Shell Electron Pair Repulsion (VSEPR) Theory", unitNumber: 5),
        Chapter(number: 16, title: "Metallic Bonds and Intramolecular Forces", unitNumber: 5),
        Chapter(number: 17, title: "Naming Substances", unitNumber: 6),
        Chapter(number: 18, title: "The Mole", unitNumber: 6),
        Chapter(number: 19, title: "Finding Compositions in Compounds", unitNumber: 6),
        Chapter(number: 20, title: "Chemical Reactions", unitNumber: 7),
        Chapter(number: 21, title: "Chemical Calculations", unitNumber: 7),
        Chapter(number: 22, title: "Common Gases", unitNumber: 8),
        Chapter(number: 23, title: "Kinetic Molecular Theory", unitNumber: 8),
        Chapter(number: 24, title: "Gas Laws", unitNumber: 8),
        Chapter(number: 25, title: "Solubility", unitNumber: 9),
        Chapter(number: 26, title: "Solubility Rules and Conditions", unitNumber: 9),
        Chapter(number: 27, title: "Concentrations of Solutions", unitNumber: 9),
        Chapter(number: 28, title: "Properties of Acids and Bases", unitNumber: 10),
        Chapter(number: 29, title: "pH Scale and Calculations", unitNumber: 10),
        Chapter(number: 30, title: "Conjugate Acids and Bases", unitNumber: 10),
        Chapter(number: 31, title: "Titrations", unitNumber: 10),
        Chapter(number: 32, title: "Chemical Equilibrium", unitNumber: 11),
        Chapter(number: 33, title: "Le Châtelier's Principle", unitNumber: 11),
        Chapter(number: 34, title: "The First Law of Thermodynamics", unitNumber: 12),
        Chapter(number: 35, title: "The Second Law of Thermodynamics", unitNumber: 12),
        Chapter(number: 36, title: "Reaction Rates", unitNumber: 12),
    ]

    private static let chaptersByNumber: [Int: Chapter] = {
        Dictionary(uniqueKeysWithValues: chapters.map { ($0.number, $0) })
    }()

    private static let unitsByNumber: [Int: Unit] = {
        Dictionary(uniqueKeysWithValues: units.map { ($0.number, $0) })
    }()

    static func chapter(_ number: Int) -> Chapter? {
        chaptersByNumber[number]
    }

    static func unit(_ number: Int) -> Unit? {
        unitsByNumber[number]
    }

    static func unit(forChapter number: Int) -> Unit? {
        chapter(number).flatMap { unit($0.unitNumber) }
    }

    static func pageLabel(forChapter number: Int) -> String {
        guard let unit = unit(forChapter: number) else { return "p1" }
        return "p\(unit.startPage)"
    }

    static func chaptersGroupedByUnit() -> [(unit: Unit, chapters: [Chapter])] {
        units.map { unit in
            (unit, chapters.filter { $0.unitNumber == unit.number })
        }
    }

    static func displayTitle(chapterNumbers: [Int], reviewLabel: String?) -> String {
        if let reviewLabel {
            return reviewLabel
        }
        guard !chapterNumbers.isEmpty else { return "BFN-C reading" }
        let titles = chapterNumbers.compactMap { chapter($0)?.shortTitle }
        if chapterNumbers.count == 1, let n = chapterNumbers.first {
            return "Ch \(n) — \(titles.first ?? "Reading")"
        }
        let range = chapterRangeLabel(chapterNumbers)
        let joined = titles.prefix(2).joined(separator: " · ")
        let suffix = titles.count > 2 ? " · …" : ""
        return "Ch \(range) — \(joined)\(suffix)"
    }

    static func citationLine(chapterNumbers: [Int], reviewLabel: String?) -> String {
        if let reviewLabel {
            return reviewLabel
        }
        guard let first = chapterNumbers.first else {
            return "See index · Match today's chemistry topic"
        }
        let unit = unit(forChapter: first)!
        let chLabel = chapterNumbers.count == 1
            ? "Ch \(first) \(chapter(first)?.title ?? "")"
            : "Ch \(chapterRangeLabel(chapterNumbers))"
        return "Unit \(unit.number) · \(chLabel) · \(pageLabel(forChapter: first))"
    }

    static func optionText(chapterNumbers: [Int], reviewLabel: String?) -> String {
        "\(bookCode) — \(editionTitle) · \(citationLine(chapterNumbers: chapterNumbers, reviewLabel: reviewLabel))"
    }

    static let chapterSectionNames = ["Key Ideas", "Definitions", "Examples", "Mnemonic Devices", "Quiz Yourself"]

    static let chapterSectionGuide = "Key Ideas → Definitions → Examples"

    static func readingLine(chapterNumber: Int) -> String {
        guard let ch = chapter(chapterNumber), let unit = unit(forChapter: chapterNumber) else {
            return "Ch \(chapterNumber)"
        }
        return "Unit \(unit.number) · \(unit.name) · Ch \(ch.number) — \(ch.title) · \(pageLabel(forChapter: chapterNumber))"
    }

    static func compactReadingLine(chapterNumber: Int) -> String {
        guard let ch = chapter(chapterNumber), let unit = unit(forChapter: chapterNumber) else {
            return "Ch \(chapterNumber)"
        }
        return "U\(unit.number) · Ch \(ch.number) — \(ch.shortTitle) · \(pageLabel(forChapter: chapterNumber))"
    }

    static func groupedChapters(_ numbers: [Int]) -> [(unit: Unit, chapters: [Chapter])] {
        var byUnit: [Int: [Chapter]] = [:]
        for number in numbers.sorted() {
            if let chapter = chapter(number) {
                byUnit[chapter.unitNumber, default: []].append(chapter)
            }
        }
        return units.compactMap { unit in
            guard let chapters = byUnit[unit.number], !chapters.isEmpty else { return nil }
            return (unit, chapters)
        }
    }

    private static func chapterRangeLabel(_ numbers: [Int]) -> String {
        guard let first = numbers.first, let last = numbers.last else { return "" }
        if first == last { return "\(first)" }
        return "\(first)–\(last)"
    }
}
