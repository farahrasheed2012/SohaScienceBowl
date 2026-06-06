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
    var isFlashCardOnly: Bool

    var displayBookCode: String {
        pass == .pass2 ? (pass2BookCode ?? bookCode) : bookCode
    }

    var displayChapter: String {
        pass == .pass2 ? (pass2Chapter ?? chapter) : chapter
    }

    var displayChapterTitle: String {
        pass == .pass2 ? (pass2ChapterTitle ?? chapterTitle) : chapterTitle
    }

    var blockLabel: String {
        "\(day.shortName) · \(subject.rawValue)"
    }

    func bookLine(for pass: StudyPass) -> String {
        let code = pass == .pass2 ? (pass2BookCode ?? bookCode) : bookCode
        let ch = pass == .pass2 ? (pass2Chapter ?? chapter) : chapter
        let title = pass == .pass2 ? (pass2ChapterTitle ?? chapterTitle) : chapterTitle
        return "\(code) \(ch) — \(title)"
    }
}

struct KnowColdItem: Identifiable, Codable, Hashable {
    var id: UUID
    var prompt: String
    var answer: String
}
