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

    mutating func markCorrect(calendar: Calendar = .current) {
        let stage = reviewStage.advanced()
        reviewStage = stage
        let days = stage == .mastered ? 30 : stage.nextIntervalDays
        nextReviewDate = calendar.date(byAdding: .day, value: days, to: Date()) ?? Date()
    }

    mutating func markIncorrect(calendar: Calendar = .current) {
        reviewStage = reviewStage.regressed()
        nextReviewDate = calendar.date(byAdding: .day, value: 1, to: Date()) ?? Date()
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
