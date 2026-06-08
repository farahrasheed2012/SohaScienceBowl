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
                        text: pass1BookLine(),
                        links: [],
                        isRecommended: activePass == .pass1
                    )
                )
            }
            if let pass2Line = pass2BookLine() {
                options.append(
                    StudyBookOption(
                        id: "pass2-\(week)-\(day.rawValue)",
                        role: .pass2Primary,
                        text: pass2Line,
                        links: [],
                        isRecommended: activePass == .pass2
                    )
                )
            } else if bookCode.contains("/") {
                options.append(
                    StudyBookOption(
                        id: "pass3-\(week)-\(day.rawValue)",
                        role: .pass2Primary,
                        text: pass1BookLine(),
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
                        text: "Expl Ch 17–24 (optional skim after Mod/Tro)",
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
            if let reading = ScheduleOpenStaxCatalog.biologyReading(for: self) {
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
                options.append(
                    StudyBookOption(
                        id: "fls-cb-\(week)-\(day.rawValue)",
                        role: .alsoOK,
                        text: backup,
                        links: [],
                        isRecommended: false
                    )
                )
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
                    text: "Expl \(chapter) — \(chapterTitle)",
                    links: [],
                    isRecommended: true
                )
            )
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
        case pass1Primary = "Pass 1 primary"
        case pass2Primary = "Pass 2–3 primary"
        case alsoOK = "Also OK"
        case backup = "Backup"
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
