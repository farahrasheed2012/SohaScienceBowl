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

    var displayBookCode: String { bookCode }

    var displayChapter: String { chapter }

    var displayChapterTitle: String { chapterTitle }

    var blockLabel: String {
        "\(day.shortName) · \(subject.rawValue)"
    }

    /// Primary reading line with assigned § sections when the catalog defines them.
    var primaryReadingLine: String {
        switch subject {
        case .chemistry:
            if let hewitt = BlockAssignedReadingCatalog.hewittChemAssignment(for: self) {
                return hewitt.displayText
            }
            if let mod = BlockAssignedReadingCatalog.modAssignment(for: self) {
                return mod.displayText
            }
            if bookCode.contains("/") {
                let names = bookCode
                    .split(separator: "/")
                    .map { ChemistryTextbookCatalog.title(for: String($0)) }
                    .joined(separator: " · ")
                return "\(names) — \(chapter) — \(chapterTitle)"
            }
            return ChemistryTextbookCatalog.formattedLine(bookCode: bookCode, chapter: chapter, title: chapterTitle)
        case .biology:
            if let fls = BlockAssignedReadingCatalog.flsAssignment(for: self) {
                return fls.displayText
            }
            if let osb = BlockAssignedReadingCatalog.osbAssignment(for: self) {
                return osb.displayText
            }
            return "\(bookCode) \(chapter) — \(chapterTitle)"
        case .physics:
            if let hewitt = BlockAssignedReadingCatalog.hewittPhysAssignment(for: self) {
                return hewitt.displayText
            }
            if let expl = BlockAssignedReadingCatalog.explSectionAssignment(for: self) {
                return expl.displayText
            }
            return ConceptualPhysicalScienceExplorationsCatalog.formattedLine(chapter: chapter, title: chapterTitle)
        }
    }

    func bookLine(for pass: StudyPass) -> String {
        primaryReadingLine
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
            if let hewitt = BlockAssignedReadingCatalog.hewittChemAssignment(for: self) {
                options.append(
                    StudyBookOption(
                        id: "hewitt-\(week)-\(day.rawValue)",
                        role: .primary,
                        text: hewitt.displayText,
                        links: hewitt.links,
                        isRecommended: false
                    )
                )
            } else if let mod = BlockAssignedReadingCatalog.modAssignment(for: self), bookCode == "Mod" {
                options.append(
                    StudyBookOption(
                        id: "mod-\(week)-\(day.rawValue)",
                        role: .primary,
                        text: mod.displayText,
                        links: mod.links,
                        isRecommended: false
                    )
                )
            } else if !bookCode.contains("/") {
                options.append(
                    StudyBookOption(
                        id: "pass1-\(week)-\(day.rawValue)",
                        role: .primary,
                        text: ConceptualPhysicalScienceExplorationsCatalog.formattedLine(
                            chapter: chapter,
                            title: chapterTitle
                        ),
                        links: [],
                        isRecommended: false
                    )
                )
            }
            if let mod = BlockAssignedReadingCatalog.modAssignment(for: self), pass2BookCode == "Mod" {
                options.append(
                    StudyBookOption(
                        id: "mod-backup-\(week)-\(day.rawValue)",
                        role: .backup,
                        text: mod.displayText,
                        links: mod.links,
                        isRecommended: false
                    )
                )
            }
            if let tro = BlockAssignedReadingCatalog.troAssignment(for: self) {
                options.append(
                    StudyBookOption(
                        id: "tro-\(week)-\(day.rawValue)",
                        role: .backup,
                        text: tro.displayText,
                        links: tro.links,
                        isRecommended: false
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
                        role: .primary,
                        text: "\(names) — \(chapter) — \(chapterTitle)",
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
            if let fls = BlockAssignedReadingCatalog.flsAssignment(for: self) {
                options.append(
                    StudyBookOption(
                        id: "fls-\(week)-\(day.rawValue)",
                        role: .primary,
                        text: fls.displayText,
                        links: fls.links,
                        isRecommended: false
                    )
                )
            } else if let assigned = BlockAssignedReadingCatalog.osbAssignment(for: self), bookCode == "OSB" {
                options.append(
                    StudyBookOption(
                        id: "osb-\(week)-\(day.rawValue)",
                        role: .primary,
                        text: assigned.displayText,
                        links: assigned.links,
                        isRecommended: false
                    )
                )
            } else if let reading = ScheduleOpenStaxCatalog.biologyReading(for: self) {
                let osbLinks = Array(zip(reading.chapters, reading.urls)).map { ch, url in
                    StudyBookLink(label: "OSB Ch \(ch) online", url: url)
                }
                options.append(
                    StudyBookOption(
                        id: "osb-\(week)-\(day.rawValue)",
                        role: .primary,
                        text: "OSB \(chapter) — \(chapterTitle)",
                        links: osbLinks,
                        isRecommended: false
                    )
                )
            } else {
                options.append(
                    StudyBookOption(
                        id: "bio-primary-\(week)-\(day.rawValue)",
                        role: .primary,
                        text: pass1BookLine(),
                        links: [],
                        isRecommended: false
                    )
                )
            }
            if let osb = BlockAssignedReadingCatalog.osbAssignment(for: self), bookCode == "FLS" {
                options.append(
                    StudyBookOption(
                        id: "osb-backup-\(week)-\(day.rawValue)",
                        role: .backup,
                        text: osb.displayText,
                        links: osb.links,
                        isRecommended: false
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
            if let hewitt = BlockAssignedReadingCatalog.hewittPhysAssignment(for: self) {
                options.append(
                    StudyBookOption(
                        id: "hewitt-\(week)-\(day.rawValue)",
                        role: .primary,
                        text: hewitt.displayText,
                        links: hewitt.links,
                        isRecommended: false
                    )
                )
            } else {
                options.append(
                    StudyBookOption(
                        id: "hewitt-\(week)-\(day.rawValue)",
                        role: .primary,
                        text: ConceptualPhysicalScienceExplorationsCatalog.formattedLine(
                            chapter: chapter,
                            title: chapterTitle
                        ),
                        links: [],
                        isRecommended: false
                    )
                )
            }
            if let pass2BookCode, pass2BookCode == "Expl",
               let pass2Chapter, let pass2ChapterTitle {
                options.append(
                    StudyBookOption(
                        id: "expl-pass2-\(week)-\(day.rawValue)",
                        role: .backup,
                        text: ConceptualPhysicalScienceExplorationsCatalog.formattedLine(
                            chapter: pass2Chapter,
                            title: pass2ChapterTitle
                        ),
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
        case primary = "Primary"
        case alternate = "Alternate"
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
