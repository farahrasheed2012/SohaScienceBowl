import Foundation
import SwiftUI

enum ElementCategory: String, Codable, CaseIterable {
    case alkaliMetal = "Alkali metal"
    case alkalineEarth = "Alkaline earth"
    case metalloid = "Metalloid"
    case nonmetal = "Nonmetal"
    case halogen = "Halogen"
    case nobleGas = "Noble gas"

    var color: Color {
        switch self {
        case .alkaliMetal: return PlatformColor.systemOrange
        case .alkalineEarth: return PlatformColor.systemYellow
        case .metalloid: return PlatformColor.systemTeal
        case .nonmetal: return PlatformColor.systemGreen
        case .halogen: return PlatformColor.systemPurple
        case .nobleGas: return PlatformColor.systemBlue
        }
    }
}

struct Element: Identifiable, Hashable, Codable {
    var symbol: String
    var name: String
    var atomicNumber: Int
    var group: Int
    var period: Int
    var category: ElementCategory

    var id: String { symbol }
}

enum ElementDrillMode: String, CaseIterable, Identifiable {
    case symbolToName
    case nameToSymbol
    case numberToSymbol
    case mixed

    var id: String { rawValue }

    var title: String {
        switch self {
        case .symbolToName: return "Symbol → Name"
        case .nameToSymbol: return "Name → Symbol"
        case .numberToSymbol: return "Atomic # → Symbol"
        case .mixed: return "Mixed (NSB style)"
        }
    }
}

enum ElementAnswerMode: String, CaseIterable, Identifiable {
    case multipleChoice
    case typeAnswer

    var id: String { rawValue }

    var title: String {
        switch self {
        case .multipleChoice: return "Multiple choice"
        case .typeAnswer: return "Type the answer"
        }
    }
}

enum ElementData {
    static let flashCardTopic = "Element symbols"
    static let masteryThreshold = 3
    static let checklistMasteredCount = 18

    static let first20: [Element] = [
        Element(symbol: "H", name: "Hydrogen", atomicNumber: 1, group: 1, period: 1, category: .nonmetal),
        Element(symbol: "He", name: "Helium", atomicNumber: 2, group: 18, period: 1, category: .nobleGas),
        Element(symbol: "Li", name: "Lithium", atomicNumber: 3, group: 1, period: 2, category: .alkaliMetal),
        Element(symbol: "Be", name: "Beryllium", atomicNumber: 4, group: 2, period: 2, category: .alkalineEarth),
        Element(symbol: "B", name: "Boron", atomicNumber: 5, group: 13, period: 2, category: .metalloid),
        Element(symbol: "C", name: "Carbon", atomicNumber: 6, group: 14, period: 2, category: .nonmetal),
        Element(symbol: "N", name: "Nitrogen", atomicNumber: 7, group: 15, period: 2, category: .nonmetal),
        Element(symbol: "O", name: "Oxygen", atomicNumber: 8, group: 16, period: 2, category: .nonmetal),
        Element(symbol: "F", name: "Fluorine", atomicNumber: 9, group: 17, period: 2, category: .halogen),
        Element(symbol: "Ne", name: "Neon", atomicNumber: 10, group: 18, period: 2, category: .nobleGas),
        Element(symbol: "Na", name: "Sodium", atomicNumber: 11, group: 1, period: 3, category: .alkaliMetal),
        Element(symbol: "Mg", name: "Magnesium", atomicNumber: 12, group: 2, period: 3, category: .alkalineEarth),
        Element(symbol: "Al", name: "Aluminum", atomicNumber: 13, group: 13, period: 3, category: .metalloid),
        Element(symbol: "Si", name: "Silicon", atomicNumber: 14, group: 14, period: 3, category: .metalloid),
        Element(symbol: "P", name: "Phosphorus", atomicNumber: 15, group: 15, period: 3, category: .nonmetal),
        Element(symbol: "S", name: "Sulfur", atomicNumber: 16, group: 16, period: 3, category: .nonmetal),
        Element(symbol: "Cl", name: "Chlorine", atomicNumber: 17, group: 17, period: 3, category: .halogen),
        Element(symbol: "Ar", name: "Argon", atomicNumber: 18, group: 18, period: 3, category: .nobleGas),
        Element(symbol: "K", name: "Potassium", atomicNumber: 19, group: 1, period: 4, category: .alkaliMetal),
        Element(symbol: "Ca", name: "Calcium", atomicNumber: 20, group: 2, period: 4, category: .alkalineEarth),
    ]

    static func element(forSymbol symbol: String) -> Element? {
        first20.first { $0.symbol.caseInsensitiveCompare(symbol) == .orderedSame }
    }

    static func element(forName name: String) -> Element? {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return first20.first { $0.name.caseInsensitiveCompare(trimmed) == .orderedSame }
    }

    static func element(forAtomicNumber number: Int) -> Element? {
        first20.first { $0.atomicNumber == number }
    }

    static func isPeriodicTableRelevant(block: StudyBlock) -> Bool {
        guard block.subject == .chemistry else { return false }
        let topic = block.primaryTopic.lowercased()
        return topic.contains("periodic")
            || topic.contains("element")
            || topic.contains("atom")
            || topic.contains("ion")
    }

    static func shouldPromoteElementPractice(week: Int, blocks: [StudyBlock]) -> Bool {
        if week == 2 || week == 4 { return true }
        return blocks.contains { isPeriodicTableRelevant(block: $0) }
    }

    static func seedFlashCards(existing: [FlashCardItem]) -> [FlashCardItem] {
        guard !existing.contains(where: { $0.topic == flashCardTopic }) else { return [] }
        return first20.map { element in
            FlashCardItem(
                id: UUID(),
                prompt: "What element is \(element.symbol)?",
                answer: "\(element.name) (atomic number \(element.atomicNumber))",
                topic: flashCardTopic,
                subject: .chemistry,
                reviewStage: .new,
                nextReviewDate: Date(),
                sourceQuestionID: nil
            )
        }
    }

    struct DrillQuestion: Identifiable, Hashable {
        var id: String { "\(element.symbol)-\(mode.rawValue)" }
        let element: Element
        let mode: ElementDrillMode
        let prompt: String
        let correctAnswer: String
        let choices: [String]

        var acceptsTypedAnswers: [String] {
            switch mode {
            case .symbolToName:
                return [element.name]
            case .nameToSymbol, .numberToSymbol:
                return [element.symbol]
            case .mixed:
                return prompt.contains("atomic number") ? [element.symbol] : [element.name, element.symbol]
            }
        }
    }

    static func makeDrillQuestions(
        count: Int,
        mode: ElementDrillMode,
        answerMode: ElementAnswerMode
    ) -> [DrillQuestion] {
        let pool = first20.shuffled()
        let selected = Array(pool.prefix(min(count, pool.count)))
        return selected.map { element in
            let questionMode: ElementDrillMode = mode == .mixed
                ? [.symbolToName, .nameToSymbol, .numberToSymbol].randomElement()!
                : mode
            let prompt: String
            let correct: String
            switch questionMode {
            case .symbolToName:
                prompt = "What is the name of the element with symbol \(element.symbol)?"
                correct = element.name
            case .nameToSymbol:
                prompt = "What is the symbol for \(element.name)?"
                correct = element.symbol
            case .numberToSymbol:
                prompt = "What is the symbol of the element with atomic number \(element.atomicNumber)?"
                correct = element.symbol
            case .mixed:
                prompt = ""
                correct = element.symbol
            }
            let choices = answerMode == .multipleChoice
                ? makeChoices(correct: correct, mode: questionMode)
                : []
            return DrillQuestion(
                element: element,
                mode: questionMode,
                prompt: prompt,
                correctAnswer: correct,
                choices: choices
            )
        }
    }

    private static func makeChoices(correct: String, mode: ElementDrillMode) -> [String] {
        var distractors: [String] = []
        switch mode {
        case .symbolToName:
            distractors = first20.map(\.name).filter { $0 != correct }
        case .nameToSymbol, .numberToSymbol:
            distractors = first20.map(\.symbol).filter { $0 != correct }
        case .mixed:
            distractors = first20.map(\.symbol).filter { $0 != correct }
        }
        let picks = Array(distractors.shuffled().prefix(3))
        return (picks + [correct]).shuffled()
    }

    static func matchesTypedAnswer(_ input: String, question: DrillQuestion) -> Bool {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        return question.acceptsTypedAnswers.contains {
            $0.caseInsensitiveCompare(trimmed) == .orderedSame
        }
    }
}
