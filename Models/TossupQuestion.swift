import Foundation

struct TossupQuestion: Identifiable, Codable, Hashable {
    var id: UUID
    var question: String
    var answer: String
    var subject: Subject
    var week: Int
    var topic: String

    func toUnified(sourceDescription: String? = nil) -> UnifiedQuestion {
        UnifiedQuestion(
            id: id,
            source: .customCurriculum,
            category: subject.doeCategory,
            questionType: .tossUp,
            format: .shortAnswer,
            topic: topic,
            questionText: question,
            choices: [],
            answer: answer,
            sourceFile: "",
            sourceDescription: sourceDescription ?? "Week \(week) · \(topic)",
            setNumber: nil,
            roundNumber: nil,
            sourceYear: nil
        )
    }
}

extension Subject {
    var doeCategory: DOECategory {
        switch self {
        case .biology: return .biology
        case .chemistry: return .chemistry
        case .physics: return .physics
        case .math: return .math
        }
    }
}
