import Foundation

enum MentalMathOperation: String, CaseIterable, Codable, Identifiable {
    case addition = "Addition"
    case subtraction = "Subtraction"
    case multiplication = "Multiplication"
    case division = "Division"
    case squares = "Squares"
    case mixed = "Mixed"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .addition: return "plus"
        case .subtraction: return "minus"
        case .multiplication: return "multiply"
        case .division: return "divide"
        case .squares: return "x.squareroot"
        case .mixed: return "shuffle"
        }
    }

    var emoji: String {
        switch self {
        case .addition: return "+"
        case .subtraction: return "−"
        case .multiplication: return "×"
        case .division: return "÷"
        case .squares: return "²"
        case .mixed: return "◎"
        }
    }

    var levelCount: Int {
        switch self {
        case .addition, .subtraction, .division: return 8
        case .multiplication: return 10
        case .squares: return 6
        case .mixed: return 5
        }
    }

    func levelTitle(_ level: Int) -> String {
        switch self {
        case .addition:
            switch level {
            case 1: return "Sums through 10"
            case 2: return "Sums through 20"
            case 3: return "Sums through 50"
            case 4: return "Two-digit + one-digit"
            case 5: return "Two-digit + two-digit"
            case 6: return "Three-digit + two-digit"
            case 7: return "Compensation tricks"
            default: return "Addition mastery"
            }
        case .subtraction:
            switch level {
            case 1: return "Within 10"
            case 2: return "Within 20"
            case 3: return "Within 50"
            case 4: return "Two-digit − one-digit"
            case 5: return "Two-digit − two-digit"
            case 6: return "Across tens"
            case 7: return "Three-digit − two-digit"
            default: return "Subtraction mastery"
            }
        case .multiplication:
            switch level {
            case 1: return "×2 facts"
            case 2: return "×3–×5"
            case 3: return "×6–×9"
            case 4: return "×10–×12"
            case 5: return "Teens × digit"
            case 6: return "Two-digit × digit"
            case 7: return "×11 and ×25"
            case 8: return "20×20 table"
            case 9: return "Three-factor"
            default: return "Multiplication mastery"
            }
        case .division:
            switch level {
            case 1: return "÷2 and ÷5"
            case 2: return "÷3–÷9"
            case 3: return "÷10–÷12"
            case 4: return "Two-digit ÷ digit"
            case 5: return "With remainder"
            case 6: return "Three-digit ÷ digit"
            case 7: return "Fact families"
            default: return "Division mastery"
            }
        case .squares:
            switch level {
            case 1: return "1²–10²"
            case 2: return "11²–15²"
            case 3: return "16²–20²"
            case 4: return "21²–25²"
            case 5: return "26²–30²"
            default: return "Near-squares"
            }
        case .mixed:
            switch level {
            case 1: return "+ and − mix"
            case 2: return "× and ÷ mix"
            case 3: return "All four ops"
            case 4: return "Speed round"
            default: return "Full mix"
            }
        }
    }
}

struct MentalMathProblem: Identifiable, Hashable {
    let id = UUID()
    let prompt: String
    let answer: Int
}

struct MentalMathDrillResult: Codable, Identifiable, Hashable {
    let id: UUID
    let date: Date
    let operation: MentalMathOperation
    let level: Int
    let correct: Int
    let total: Int
    let elapsedSeconds: Double
    let timedMode: Bool

    init(
        id: UUID,
        date: Date,
        operation: MentalMathOperation,
        level: Int,
        correct: Int,
        total: Int,
        elapsedSeconds: Double,
        timedMode: Bool = false
    ) {
        self.id = id
        self.date = date
        self.operation = operation
        self.level = level
        self.correct = correct
        self.total = total
        self.elapsedSeconds = elapsedSeconds
        self.timedMode = timedMode
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        date = try c.decode(Date.self, forKey: .date)
        operation = try c.decode(MentalMathOperation.self, forKey: .operation)
        level = try c.decode(Int.self, forKey: .level)
        correct = try c.decode(Int.self, forKey: .correct)
        total = try c.decode(Int.self, forKey: .total)
        elapsedSeconds = try c.decode(Double.self, forKey: .elapsedSeconds)
        timedMode = try c.decodeIfPresent(Bool.self, forKey: .timedMode) ?? false
    }

    var passed: Bool {
        guard total > 0 else { return false }
        return Double(correct) / Double(total) >= MentalMathStore.passThreshold
    }

    var accuracy: Double {
        guard total > 0 else { return 0 }
        return Double(correct) / Double(total)
    }

    var avgSecondsPerProblem: Double {
        guard total > 0 else { return 0 }
        return elapsedSeconds / Double(total)
    }
}

struct MentalMathLevelBest: Codable, Hashable {
    var fastestPassSeconds: Double?
    var bestCorrect: Int = 0
    var attempts: Int = 0
    var passes: Int = 0

    var formattedBestTime: String? {
        guard let fastestPassSeconds else { return nil }
        return MentalMathFormatting.duration(fastestPassSeconds)
    }
}

enum MentalMathTimedMode: Int, CaseIterable, Identifiable {
    case off = 0
    case relaxed = 10
    case standard = 8
    case sprint = 5

    var id: Int { rawValue }

    var label: String {
        switch self {
        case .off: return "No limit"
        case .relaxed: return "10 sec / problem"
        case .standard: return "8 sec / problem"
        case .sprint: return "5 sec / problem"
        }
    }

    var secondsPerProblem: Int { rawValue }

    static func from(stored: Int) -> MentalMathTimedMode {
        allCases.first { $0.rawValue == stored } ?? .off
    }
}

enum MentalMathFormatting {
    static func duration(_ seconds: TimeInterval) -> String {
        let total = max(0, Int(seconds.rounded()))
        let m = total / 60
        let s = total % 60
        if m > 0 { return String(format: "%d:%02d", m, s) }
        return "\(s)s"
    }
}

enum MentalMathFeedback: Equatable {
    case idle
    case correct
    case incorrect(correctAnswer: Int)
    case timedOut(correctAnswer: Int)
}
