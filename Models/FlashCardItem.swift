import Foundation

struct FlashCardItem: Identifiable, Codable, Hashable {
    var id: UUID
    var prompt: String
    var answer: String
    var topic: String
    var subject: Subject
    var reviewStage: ReviewStage
    var nextReviewDate: Date
    var sourceQuestionID: UUID?

    var isDue: Bool { nextReviewDate <= Date() }

    mutating func markCorrect(pace: FlashCardReviewPace = .normal, calendar: Calendar = .current) {
        let stage = reviewStage.advanced()
        reviewStage = stage
        let days = pace.intervalDays(for: stage)
        nextReviewDate = calendar.date(byAdding: .day, value: days, to: Date()) ?? Date()
    }

    mutating func markIncorrect(pace: FlashCardReviewPace = .normal, calendar: Calendar = .current) {
        reviewStage = reviewStage.regressed()
        let days = pace == .quick ? 1 : (pace == .longTerm ? 2 : 1)
        nextReviewDate = calendar.date(byAdding: .day, value: days, to: Date()) ?? Date()
    }
}

struct NotebookEntry: Identifiable, Codable, Hashable {
    var id: UUID
    var date: Date
    var subject: Subject
    var week: Int
    var threeFacts: [String]
    var oneMiss: String
    var blockTopic: String
}
