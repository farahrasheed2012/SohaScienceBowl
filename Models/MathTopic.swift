import Foundation

enum POT6Category: String, CaseIterable, Codable, Identifiable {
    case polynomials = "Polynomials"
    case coordinateGeometry = "Coordinate Geometry"
    case quadratics = "Quadratics"
    case counting = "Counting & Probability"
    case numberTheory = "Number Theory"
    case sequences = "Sequences & Series"
    case geometry = "Geometry"
    case functions = "Functions & Relations"
    case statistics = "Statistics"
    case radicals = "Radicals & Complex"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .polynomials: return "x.squareroot"
        case .coordinateGeometry: return "point.3.connected.trianglepath.dotted"
        case .quadratics: return "chart.xyaxis.line"
        case .counting: return "dice.fill"
        case .numberTheory: return "number"
        case .sequences: return "ellipsis.rectangle"
        case .geometry: return "triangle.fill"
        case .functions: return "function"
        case .statistics: return "chart.bar.fill"
        case .radicals: return "square.root"
        }
    }
}

enum MasteryLevel: String, Codable, CaseIterable {
    case unseen, learning, review, mastered

    var label: String {
        switch self {
        case .unseen: return "Unseen"
        case .learning: return "Learning"
        case .review: return "Review"
        case .mastered: return "Mastered"
        }
    }

    var systemImage: String {
        switch self {
        case .unseen: return "circle"
        case .learning: return "circle.lefthalf.filled"
        case .review: return "arrow.clockwise.circle"
        case .mastered: return "checkmark.circle.fill"
        }
    }
}

struct WorkedExample: Identifiable, Codable, Hashable {
    let id: UUID
    let problem: String
    let steps: [String]
    let answer: String
    let insight: String
}

struct MathTopic: Identifiable, Codable, Hashable {
    let id: String
    let code: String
    let title: String
    let pot6Category: POT6Category
    let isCompetitionOnly: Bool
    let conceptSummary: String
    let workedExamples: [WorkedExample]
    let keyFormulas: [String]
    var masteryLevel: MasteryLevel
    var lastPracticed: Date?
    var accuracyRate: Double

    init(
        id: String,
        code: String,
        title: String,
        pot6Category: POT6Category,
        isCompetitionOnly: Bool,
        conceptSummary: String,
        workedExamples: [WorkedExample],
        keyFormulas: [String],
        masteryLevel: MasteryLevel = .unseen,
        lastPracticed: Date? = nil,
        accuracyRate: Double = 0
    ) {
        self.id = id
        self.code = code
        self.title = title
        self.pot6Category = pot6Category
        self.isCompetitionOnly = isCompetitionOnly
        self.conceptSummary = conceptSummary
        self.workedExamples = workedExamples
        self.keyFormulas = keyFormulas
        self.masteryLevel = masteryLevel
        self.lastPracticed = lastPracticed
        self.accuracyRate = accuracyRate
    }

    var displayTitle: String {
        if isCompetitionOnly { return "\(title) 🏆" }
        return title
    }
}
