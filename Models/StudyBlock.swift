import Foundation

struct StudyBlock: Identifiable, Codable, Hashable {
    var id: UUID
    var week: Int
    var day: Weekday
    var subject: Subject
    var pass: StudyPass
    var bookCode: String
    var chapter: String
    var chapterTitle: String
    var focus: String
    var formulasAndTerms: String
    var knowCold: [String]
    var sampleTossups: [TossupQuestion]
    var pass2BookCode: String?
    var pass2Chapter: String?
    var pass2ChapterTitle: String?
    var backupBookLine: String?
    var isFlashCardOnly: Bool

    var displayBookCode: String {
        if bookCode == "OSB" { return bookCode }
        return pass == .pass2 ? (pass2BookCode ?? bookCode) : bookCode
    }

    var displayChapter: String {
        if bookCode == "OSB" { return chapter }
        return pass == .pass2 ? (pass2Chapter ?? chapter) : chapter
    }

    var displayChapterTitle: String {
        if bookCode == "OSB" { return chapterTitle }
        return pass == .pass2 ? (pass2ChapterTitle ?? chapterTitle) : chapterTitle
    }

    var blockLabel: String {
        "\(day.shortName) · \(subject.rawValue)"
    }

    func bookLine(for pass: StudyPass) -> String {
        if bookCode == "Expl" || pass2BookCode == "Expl" {
            let ch = pass == .pass2 && pass2BookCode == "Expl" ? (pass2Chapter ?? chapter) : chapter
            let title = pass == .pass2 && pass2BookCode == "Expl" ? (pass2ChapterTitle ?? chapterTitle) : chapterTitle
            return ConceptualPhysicalScienceExplorationsCatalog.formattedLine(chapter: ch, title: title)
        }
        if subject == .chemistry {
            if bookCode.contains("/") {
                let names = bookCode
                    .split(separator: "/")
                    .map { ChemistryTextbookCatalog.title(for: String($0)) }
                    .joined(separator: " · ")
                return "\(names) — \(chapter) — \(chapterTitle)"
            }
            let code = pass == .pass2 ? (pass2BookCode ?? bookCode) : bookCode
            let ch = pass == .pass2 ? (pass2Chapter ?? chapter) : chapter
            let title = pass == .pass2 ? (pass2ChapterTitle ?? chapterTitle) : chapterTitle
            if code == "Mod" || code == "Tro" {
                return ChemistryTextbookCatalog.formattedLine(bookCode: code, chapter: ch, title: title)
            }
        }
        let code = bookCode == "OSB" ? bookCode : (pass == .pass2 ? (pass2BookCode ?? bookCode) : bookCode)
        let ch = bookCode == "OSB" ? chapter : (pass == .pass2 ? (pass2Chapter ?? chapter) : chapter)
        let title = bookCode == "OSB" ? chapterTitle : (pass == .pass2 ? (pass2ChapterTitle ?? chapterTitle) : chapterTitle)
        return "\(code) \(ch) — \(title)"
    }

    func pass1BookLine() -> String {
        "\(bookCode) \(chapter) — \(chapterTitle)"
    }

    func pass2BookLine() -> String? {
        guard let pass2BookCode else { return nil }
        return "\(pass2BookCode) \(pass2Chapter ?? chapter) — \(pass2ChapterTitle ?? chapterTitle)"
    }

    /// All reading choices for this block — primary, alternate pass, optional, and backup.
    func allBookOptions(activePass: StudyPass) -> [StudyBookOption] {
        var options: [StudyBookOption] = []

        switch subject {
        case .chemistry:
            if !bookCode.contains("/") {
                options.append(
                    StudyBookOption(
                        id: "pass1-\(week)-\(day.rawValue)",
                        role: .pass1Primary,
                        text: ChemistryTextbookCatalog.modLine(chapter: chapter, title: chapterTitle),
                        links: [],
                        isRecommended: activePass == .pass1
                    )
                )
            }
            if let pass2BookCode, let pass2Chapter, let pass2ChapterTitle {
                options.append(
                    StudyBookOption(
                        id: "pass2-\(week)-\(day.rawValue)",
                        role: .pass2Primary,
                        text: ChemistryTextbookCatalog.formattedLine(
                            bookCode: pass2BookCode,
                            chapter: pass2Chapter,
                            title: pass2ChapterTitle
                        ),
                        links: [],
                        isRecommended: activePass == .pass2
                    )
                )
            } else if bookCode.contains("/") {
                let names = bookCode
                    .split(separator: "/")
                    .map { ChemistryTextbookCatalog.title(for: String($0)) }
                    .joined(separator: " · ")
                options.append(
                    StudyBookOption(
                        id: "pass3-\(week)-\(day.rawValue)",
                        role: .pass2Primary,
                        text: "\(names) — \(chapter) — \(chapterTitle)",
                        links: [],
                        isRecommended: activePass == .pass3
                    )
                )
            }
            if day == .monday || day == .thursday {
                options.append(
                    StudyBookOption(
                        id: "expl-\(week)-\(day.rawValue)",
                        role: .alsoOK,
                        text: ChemistryTextbookCatalog.explAlsoOKLine(for: self),
                        links: [],
                        isRecommended: false
                    )
                )
            }
            options.append(
                StudyBookOption(
                    id: "bfn-sci-\(week)-\(day.rawValue)",
                    role: .alsoOK,
                    text: ScheduleBFNCatalog.scienceOptionText(for: self),
                    links: [],
                    isRecommended: false
                )
            )

        case .biology:
            if let assigned = BlockAssignedReadingCatalog.osbAssignment(for: self) {
                options.append(
                    StudyBookOption(
                        id: "osb-\(week)-\(day.rawValue)",
                        role: .pass1Primary,
                        text: assigned.displayText,
                        links: assigned.links,
                        isRecommended: true
                    )
                )
            } else if let reading = ScheduleOpenStaxCatalog.biologyReading(for: self) {
                let osbLinks = Array(zip(reading.chapters, reading.urls)).map { ch, url in
                    StudyBookLink(label: "OSB Ch \(ch) online", url: url)
                }
                options.append(
                    StudyBookOption(
                        id: "osb-\(week)-\(day.rawValue)",
                        role: .pass1Primary,
                        text: "OSB \(chapter) — \(chapterTitle)",
                        links: osbLinks,
                        isRecommended: true
                    )
                )
            } else {
                options.append(
                    StudyBookOption(
                        id: "bio-primary-\(week)-\(day.rawValue)",
                        role: .pass1Primary,
                        text: pass1BookLine(),
                        links: [],
                        isRecommended: true
                    )
                )
            }
            if let backup = backupBookLine, !backup.isEmpty {
                options.append(contentsOf: BiologyTextbookCatalog.studyOptions(for: self, activePass: activePass))
            } else if bookCode.contains("FLS") || bookCode.contains("CB") {
                options.append(contentsOf: BiologyTextbookCatalog.studyOptions(for: self, activePass: activePass))
            }
            options.append(
                StudyBookOption(
                    id: "bfn-sci-bio-\(week)-\(day.rawValue)",
                    role: .alsoOK,
                    text: ScheduleBFNCatalog.scienceOptionText(for: self),
                    links: [],
                    isRecommended: false
                )
            )
            options.append(
                StudyBookOption(
                    id: "bfn-bio-\(week)-\(day.rawValue)",
                    role: .backup,
                    text: ScheduleBFNCatalog.biologyOptionText(for: self),
                    links: [],
                    isRecommended: false
                )
            )

        case .physics:
            options.append(
                StudyBookOption(
                    id: "expl-\(week)-\(day.rawValue)",
                    role: .pass1Primary,
                    text: ConceptualPhysicalScienceExplorationsCatalog.formattedLine(
                        chapter: chapter,
                        title: chapterTitle
                    ),
                    links: [],
                    isRecommended: true
                )
            )
            if let pass2BookCode, pass2BookCode == "Expl",
               let pass2Chapter, let pass2ChapterTitle {
                options.append(
                    StudyBookOption(
                        id: "expl-pass2-\(week)-\(day.rawValue)",
                        role: .pass2Primary,
                        text: ConceptualPhysicalScienceExplorationsCatalog.formattedLine(
                            chapter: pass2Chapter,
                            title: pass2ChapterTitle
                        ),
                        links: [],
                        isRecommended: activePass == .pass2 || activePass == .pass3
                    )
                )
            }
            options.append(
                StudyBookOption(
                    id: "bfn-sci-\(week)-\(day.rawValue)",
                    role: .alsoOK,
                    text: ScheduleBFNCatalog.scienceOptionText(for: self),
                    links: [],
                    isRecommended: false
                )
            )
        }

        return options
    }
}

struct StudyBookLink: Identifiable, Hashable {
    var id: String { url.absoluteString }
    let label: String
    let url: URL
}

struct StudyBookOption: Identifiable, Hashable {
    enum Role: String, Hashable {
        case pass1Primary = "Primary"
        case pass2Primary = "Alternate"
        case alsoOK = "Also OK"
        case backup = "Backup"

        var displayLabel: String { rawValue }
    }

    let id: String
    let role: Role
    let text: String
    let links: [StudyBookLink]
    let isRecommended: Bool
}

struct KnowColdItem: Identifiable, Codable, Hashable {
    var id: UUID
    var prompt: String
    var answer: String
}
