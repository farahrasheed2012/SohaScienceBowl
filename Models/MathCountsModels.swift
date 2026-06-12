import Foundation

enum MathCountsDifficulty: Int, CaseIterable, Codable, Identifiable {
    case level1 = 1
    case level2 = 2
    case level3 = 3
    case level4 = 4
    case level5 = 5

    var id: Int { rawValue }

    var title: String { "Level \(rawValue)" }

    var subtitle: String {
        switch self {
        case .level1: return "Basic arithmetic & number sense"
        case .level2: return "Advanced arithmetic & fractions"
        case .level3: return "Pre-algebra & ratios"
        case .level4: return "MathCounts chapter problems"
        case .level5: return "State-level challenge"
        }
    }
}

enum MathCountsSection: String, CaseIterable, Codable, Identifiable {
    case mentalMathWarmup
    case numberSenseDrill
    case challenge
    case stretch

    var id: String { rawValue }

    var title: String {
        switch self {
        case .mentalMathWarmup: return "Mental Math Warmup"
        case .numberSenseDrill: return "Number Sense Drill"
        case .challenge: return "MathCounts Challenge"
        case .stretch: return "Stretch Problem"
        }
    }

    var systemImage: String {
        switch self {
        case .mentalMathWarmup: return "bolt.fill"
        case .numberSenseDrill: return "brain.head.profile"
        case .challenge: return "flag.checkered"
        case .stretch: return "star.fill"
        }
    }

    var questionCount: Int {
        switch self {
        case .mentalMathWarmup: return 5
        case .numberSenseDrill: return 3
        case .challenge: return 3
        case .stretch: return 1
        }
    }
}

enum MathCountsTopicArea: String, CaseIterable, Identifiable {
    case numberTheory = "Number Theory"
    case algebra = "Algebra"
    case geometry = "Geometry"
    case countingProbability = "Counting & Probability"
    case ratios = "Ratios & Proportions"
    case sequences = "Sequences & Patterns"
    case mentalMath = "Mental Math"
    case logic = "Logic"

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .numberTheory: return "🔢"
        case .algebra: return "📈"
        case .geometry: return "📐"
        case .countingProbability: return "🎲"
        case .ratios: return "⚖️"
        case .sequences: return "〰️"
        case .mentalMath: return "⚡"
        case .logic: return "🧩"
        }
    }

    var practiceFocus: String {
        switch self {
        case .numberTheory: return "Primes, factors, GCF/LCM, divisibility"
        case .algebra: return "Expressions, equations, word problems"
        case .geometry: return "Angles, area, perimeter, Pythagorean theorem"
        case .countingProbability: return "Combinations, probability, counting paths"
        case .ratios: return "Proportions, unit rates, scale"
        case .sequences: return "Arithmetic & geometric patterns"
        case .mentalMath: return "Speed arithmetic, squares, estimation"
        case .logic: return "Deduction, working backwards"
        }
    }
}

struct MathCountsQuestion: Identifiable, Codable, Hashable {
    let id: String
    let section: MathCountsSection
    let level: Int
    let topic: String
    let prompt: String
    let guidingQuestion: String?
    let answer: String
    let acceptableAnswers: [String]
    let hint: String
    let simplerExample: String?
    let explanation: String
    let strategy: String?
}

struct MathCountsAttempt: Codable, Hashable {
    let questionId: String
    let section: MathCountsSection
    let topic: String
    let studentAnswer: String
    let correct: Bool
    let hintsUsed: Int
    let timestamp: Date
}

struct MathCountsSessionRecord: Codable, Identifiable, Hashable {
    let id: UUID
    let date: Date
    let level: Int
    let attempts: [MathCountsAttempt]
    let score: Int
    let total: Int

    var accuracy: Double {
        guard total > 0 else { return 0 }
        return Double(score) / Double(total)
    }
}

enum MathCountsCoachingPhase: Equatable {
    case guiding
    case answering
    case hint
    case simplerExample
    case revealed
    case correct
}
