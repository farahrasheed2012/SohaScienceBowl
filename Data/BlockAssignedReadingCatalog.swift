import Foundation

/// NSB-topic **sections** per block — not whole chapters (maps to existing book TOCs).
enum BlockAssignedReadingCatalog {
    struct BookAssignment: Hashable {
        var displayText: String
        var links: [StudyBookLink]
    }

    private struct Key: Hashable {
        var week: Int
        var day: Weekday
        var subject: Subject
    }

    /// OpenStax chapter + section ids for this block's primary reading.
    private static let osbByKey: [Key: (chapter: Int, sections: [String])] = [
        Key(week: 1, day: .tuesday, subject: .biology): (3, ["3.2", "3.3", "3.4"]),
        Key(week: 1, day: .friday, subject: .biology): (1, ["1.1"]),
        Key(week: 2, day: .tuesday, subject: .biology): (8, ["8.1", "8.2"]),
        Key(week: 2, day: .friday, subject: .biology): (8, ["8.2", "8.3"]),
        Key(week: 3, day: .tuesday, subject: .biology): (19, ["19.1"]),
        Key(week: 3, day: .friday, subject: .biology): (18, ["18.1", "18.2"]),
        Key(week: 4, day: .tuesday, subject: .biology): (11, ["11.1", "11.2"]),
        Key(week: 4, day: .friday, subject: .biology): (12, ["12.1", "12.2"]),
        Key(week: 5, day: .tuesday, subject: .biology): (5, ["5.1", "5.2"]),
        Key(week: 5, day: .friday, subject: .biology): (6, ["6.1", "6.2"]),
        Key(week: 6, day: .tuesday, subject: .biology): (20, ["20.1", "20.3"]),
        Key(week: 6, day: .friday, subject: .biology): (13, ["13.1", "13.2"]),
        Key(week: 7, day: .tuesday, subject: .biology): (17, ["17.1", "17.2"]),
        Key(week: 7, day: .friday, subject: .biology): (14, ["14.1", "14.2"]),
        Key(week: 8, day: .tuesday, subject: .biology): (14, ["14.2", "14.3"]),
        Key(week: 8, day: .friday, subject: .biology): (15, ["15.1", "15.2"]),
        Key(week: 9, day: .tuesday, subject: .biology): (7, ["7.2"]),
        Key(week: 9, day: .friday, subject: .biology): (16, ["16.1", "16.3"]),
    ]

    /// FLS chapter number + section ids (from FocusOnLifeScienceCatalog).
    private static let flsByKey: [Key: (chapter: Int, sections: [String])] = [
        Key(week: 1, day: .tuesday, subject: .biology): (1, ["1.3", "1.4"]),
        Key(week: 1, day: .friday, subject: .biology): (2, ["2.1", "2.2"]),
        Key(week: 2, day: .tuesday, subject: .biology): (4, ["4.1", "4.2"]),
        Key(week: 2, day: .friday, subject: .biology): (4, ["4.3"]),
        Key(week: 3, day: .tuesday, subject: .biology): (7, ["7.2", "7.3"]),
        Key(week: 3, day: .friday, subject: .biology): (17, ["17.1", "18.1"]),
        Key(week: 4, day: .tuesday, subject: .biology): (5, ["5.1", "5.2"]),
        Key(week: 4, day: .friday, subject: .biology): (6, ["6.1"]),
        Key(week: 5, day: .tuesday, subject: .biology): (2, ["2.4"]),
        Key(week: 5, day: .friday, subject: .biology): (2, ["2.5"]),
        Key(week: 6, day: .tuesday, subject: .biology): (7, ["7.3"]),
        Key(week: 6, day: .friday, subject: .biology): (8, ["8.1", "8.2"]),
        Key(week: 7, day: .tuesday, subject: .biology): (21, ["21.1"]),
        Key(week: 7, day: .friday, subject: .biology): (10, ["10.1", "10.2"]),
        Key(week: 8, day: .tuesday, subject: .biology): (11, ["11.1"]),
        Key(week: 8, day: .friday, subject: .biology): (16, ["16.1"]),
        Key(week: 9, day: .tuesday, subject: .biology): (3, ["3.1", "3.2"]),
        Key(week: 9, day: .friday, subject: .biology): (18, ["18.1", "19.1"]),
    ]

    /// Campbell chapter + section ids (7th ed. Concepts & Connections).
    private static let cbByKey: [Key: (chapter: Int, sections: [String])] = [
        Key(week: 1, day: .tuesday, subject: .biology): (4, ["4.3", "4.4", "4.5"]),
        Key(week: 1, day: .friday, subject: .biology): (6, ["6.1", "6.2"]),
        Key(week: 2, day: .tuesday, subject: .biology): (9, ["9.1", "9.2"]),
        Key(week: 2, day: .friday, subject: .biology): (9, ["9.3"]),
        Key(week: 3, day: .tuesday, subject: .biology): (36, ["36.1", "36.2"]),
        Key(week: 3, day: .friday, subject: .biology): (21, ["21.1", "23.1"]),
        Key(week: 4, day: .tuesday, subject: .biology): (13, ["13.1", "13.2"]),
        Key(week: 4, day: .friday, subject: .biology): (14, ["14.1"]),
        Key(week: 5, day: .tuesday, subject: .biology): (8, ["8.1", "8.2"]),
        Key(week: 5, day: .friday, subject: .biology): (9, ["9.1"]),
        Key(week: 6, day: .tuesday, subject: .biology): (36, ["36.2"]),
        Key(week: 6, day: .friday, subject: .biology): (16, ["16.1"]),
        Key(week: 7, day: .tuesday, subject: .biology): (24, ["24.1", "24.2"]),
        Key(week: 7, day: .friday, subject: .biology): (31, ["31.1", "31.2"]),
        Key(week: 8, day: .tuesday, subject: .biology): (31, ["31.3"]),
        Key(week: 8, day: .friday, subject: .biology): (20, ["20.1", "20.2"]),
        Key(week: 9, day: .tuesday, subject: .biology): (8, ["8.3"]),
        Key(week: 9, day: .friday, subject: .biology): (21, ["21.2", "23.2"]),
    ]

    static func osbAssignment(for block: StudyBlock) -> BookAssignment? {
        let key = Key(week: block.week, day: block.day, subject: block.subject)
        guard block.subject == .biology, block.bookCode == "OSB",
              let spec = osbByKey[key] else { return nil }
        let text = OpenStaxBiologyCatalog.formatAssignment(
            chapter: spec.chapter,
            sectionIds: spec.sections,
            chapterTitle: nil
        )
        let links = OpenStaxBiologyCatalog.links(chapter: spec.chapter, sectionIds: spec.sections)
        return BookAssignment(displayText: "OSB \(text)", links: links)
    }

    static func flsAssignment(for block: StudyBlock) -> BookAssignment? {
        let key = Key(week: block.week, day: block.day, subject: block.subject)
        guard let spec = flsByKey[key],
              let chapter = FocusOnLifeScienceCatalog.chapter(spec.chapter) else { return nil }
        let sectionLabels = spec.sections.compactMap { sid in
            chapter.sections.first { $0.id == sid }.map { "§\(sid) \($0.title)" }
        }
        let range = spec.sections.joined(separator: "–")
        let text = "\(FocusOnLifeScienceCatalog.editionTitle) — Ch \(chapter.number) §\(range) — \(sectionLabels.prefix(2).joined(separator: "; "))"
        return BookAssignment(displayText: text, links: [])
    }

    static func cbAssignment(for block: StudyBlock) -> BookAssignment? {
        let key = Key(week: block.week, day: block.day, subject: block.subject)
        guard let spec = cbByKey[key],
              let chapter = CampbellBiologyCatalog.chapter(spec.chapter) else { return nil }
        let range = CampbellBiologyCatalog.sectionRangeLabel(spec.sections)
        let text = "\(CampbellBiologyCatalog.editionTitle) — Ch \(chapter.number) §\(range) — \(chapter.title)"
        return BookAssignment(displayText: text, links: [])
    }

    /// Hewitt / Mod section assignment when block uses § in chapter line.
    static func explSectionAssignment(for block: StudyBlock) -> BookAssignment? {
        guard block.bookCode == "Expl" || block.pass2BookCode == "Expl" else { return nil }
        let chLine = block.chapter
        guard chLine.contains("§") else { return nil }
        return BookAssignment(
            displayText: ConceptualPhysicalScienceExplorationsCatalog.formattedLine(
                chapter: block.chapter,
                title: block.chapterTitle
            ),
            links: []
        )
    }
}
