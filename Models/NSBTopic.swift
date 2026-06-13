import Foundation

struct NSBKeyTerm: Codable, Hashable {
    var term: String
    var definition: String
}

struct NSBTopic: Codable, Identifiable, Hashable {
    var id: String
    var subject: String
    var title: String
    var whatIsIt: String
    var howItWorks: String
    var realWorldExample: String
    var keyTerms: [NSBKeyTerm]
    var nsbTraps: [String]
    var didYouKnow: [String]
    var relatedTopics: [String]
}

struct NSBQuestion: Codable, Identifiable, Hashable {
    var id: String
    var subject: String
    var subtopic: String
    var type: String
    var questionText: String
    var answerChoices: [String: String]?
    var correctAnswer: String
    var difficulty: String
    var topicId: String
}

extension NSBQuestion {
    func toUnified() -> UnifiedQuestion {
        let category: DOECategory = switch subject {
        case "Life Science": .biology
        case "Chemistry": .chemistry
        case "Physical Science": .physics
        case "Earth & Space Science": .earthSpace
        case "Energy": .energy
        case "Math": .math
        default: .generalScience
        }

        var choices: [String] = []
        var answer = correctAnswer
        if let answerChoices {
            choices = answerChoices.keys.sorted().map { key in
                "\(key)) \(answerChoices[key] ?? "")"
            }
            answer = answerChoices[correctAnswer] ?? correctAnswer
        }

        let questionType: QuestionType = type == "bonus" ? .bonus : .tossUp
        let format: QuestionFormat = choices.isEmpty ? .shortAnswer : .multipleChoice

        return UnifiedQuestion(
            id: UUID(uuidString: id.stableUUIDString) ?? UUID(),
            source: .customCurriculum,
            category: category,
            questionType: questionType,
            format: format,
            topic: subtopic,
            questionText: questionText,
            choices: choices,
            answer: answer,
            sourceFile: "questions.json",
            sourceDescription: "Encyclopedia · \(subject)",
            setNumber: nil,
            roundNumber: nil,
            sourceYear: nil,
            topicId: topicId
        )
    }
}

private extension String {
    /// Deterministic UUID string from encyclopedia question ids (e.g. math-001).
    var stableUUIDString: String {
        var bytes = [UInt8](repeating: 0, count: 16)
        let data = Array(utf8)
        for (index, byte) in data.enumerated() {
            bytes[index % 16] ^= byte
        }
        bytes[6] = (bytes[6] & 0x0F) | 0x40
        bytes[8] = (bytes[8] & 0x3F) | 0x80
        let hex = bytes.map { String(format: "%02X", $0) }.joined()
        let idx = hex.index(hex.startIndex, offsetBy: 8)
        let idx2 = hex.index(idx, offsetBy: 4)
        let idx3 = hex.index(idx2, offsetBy: 4)
        let idx4 = hex.index(idx3, offsetBy: 4)
        return "\(hex[..<idx])-\(hex[idx..<idx2])-\(hex[idx2..<idx3])-\(hex[idx3..<idx4])-\(hex[idx4...])"
    }
}

enum NSBSubject: String, CaseIterable, Identifiable, Hashable {
    case lifeScience = "Life Science"
    case physicalScience = "Physical Science"
    case chemistry = "Chemistry"
    case earthSpace = "Earth & Space Science"
    case energy = "Energy"
    case math = "Math"

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .lifeScience: return "🧬"
        case .physicalScience: return "⚛️"
        case .chemistry: return "🧪"
        case .earthSpace: return "🌍"
        case .energy: return "⚡"
        case .math: return "📐"
        }
    }

    var scheduleSubject: Subject? {
        switch self {
        case .lifeScience: return .biology
        case .chemistry: return .chemistry
        case .physicalScience: return .physics
        default: return nil
        }
    }
}

enum EncyclopediaPracticeCoverage: Hashable {
    case none
    case thin
    case ready

    static let minimumQuestions = 2

    init(questionCount: Int) {
        if questionCount == 0 {
            self = .none
        } else if questionCount < Self.minimumQuestions {
            self = .thin
        } else {
            self = .ready
        }
    }

    var badgeTitle: String? {
        switch self {
        case .none: return "No practice"
        case .thin: return "Needs more"
        case .ready: return nil
        }
    }

    var systemImage: String {
        switch self {
        case .none: return "questionmark.circle"
        case .thin: return "exclamationmark.circle"
        case .ready: return "checkmark.circle"
        }
    }
}

enum EncyclopediaPracticeMode: String, Hashable {
    case multipleChoice
    case tossUpBonus
    case freeResponse

    var title: String {
        switch self {
        case .multipleChoice: return "Multiple Choice"
        case .tossUpBonus: return "Toss-Up & Bonus"
        case .freeResponse: return "Free Response"
        }
    }

    var questionType: String {
        switch self {
        case .multipleChoice: return "multipleChoice"
        case .tossUpBonus: return "tossUp"
        case .freeResponse: return "freeResponse"
        }
    }
}

struct EncyclopediaSessionRecord: Codable, Identifiable, Hashable {
    var id: String
    var date: Date
    var subject: String
    var mode: String
    var score: Int
    var total: Int
    var missedTopicIds: [String]

    var modeDisplay: String { mode }
}
