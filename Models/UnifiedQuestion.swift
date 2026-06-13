import Foundation

struct UnifiedQuestion: Identifiable, Codable, Hashable {
    var id: UUID
    var source: QuestionSource
    var category: DOECategory
    var questionType: QuestionType
    var format: QuestionFormat
    var topic: String
    var questionText: String
    var choices: [String]
    var answer: String
    var sourceFile: String
    var sourceDescription: String
    var setNumber: Int?
    var roundNumber: Int?
    var sourceYear: Int?
    var topicId: String? = nil

    var subject: Subject? { category.subject }

    var normalizedText: String {
        questionText
            .lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .joined()
    }

    var searchBlob: String {
        "\(questionText) \(answer) \(topic) \(category.rawValue) \(source.rawValue)".lowercased()
    }
}

struct TopicStats: Identifiable, Codable, Hashable {
    var id: String { topic }
    var topic: String
    var subject: Subject
    var attempts: Int
    var correct: Int

    var accuracy: Double {
        guard attempts > 0 else { return 0 }
        return Double(correct) / Double(attempts)
    }

    var isWeak: Bool { attempts >= 3 && accuracy < 0.7 }
}

struct DrillResult: Identifiable, Codable {
    var id: UUID
    var date: Date
    var subject: Subject?
    var week: Int?
    var total: Int
    var correct: Int
    var mode: String

    var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(correct) / Double(total)
    }
}

struct DuplicateImportStats: Codable {
    var imported: Int
    var skippedDuplicates: Int
    var source: QuestionSource
}
