import Foundation

struct MathDrillQuestion: Identifiable, Codable, Hashable {
    let id: UUID
    let topicCode: String
    let questionText: String
    let answerChoices: [String]?
    let correctAnswer: String
    let solution: String
    let difficulty: DrillDifficulty
    let isMathcountsStyle: Bool
}

enum DrillDifficulty: String, Codable, CaseIterable, Identifiable {
    case scaffold
    case standard
    case challenge

    var id: String { rawValue }

    var label: String {
        switch self {
        case .scaffold: return "Scaffold"
        case .standard: return "Standard"
        case .challenge: return "Challenge"
        }
    }

    var xpValue: Int {
        switch self {
        case .scaffold: return 5
        case .standard: return 10
        case .challenge: return 20
        }
    }
}
