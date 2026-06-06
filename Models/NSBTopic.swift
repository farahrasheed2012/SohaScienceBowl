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
