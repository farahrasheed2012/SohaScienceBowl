import Foundation

enum Subject: String, CaseIterable, Codable, Identifiable {
    case biology = "Biology"
    case chemistry = "Chemistry"
    case physics = "Physics"

    var id: String { rawValue }

    var systemColorName: String {
        switch self {
        case .biology: return "green"
        case .chemistry: return "blue"
        case .physics: return "orange"
        }
    }
}

enum StudyPass: Int, CaseIterable, Codable, Identifiable {
    case pass1 = 1
    case pass2 = 2
    case pass3 = 3

    var id: Int { rawValue }

    var label: String {
        ScheduleConstants.summerPlanLabel()
    }
}

enum Weekday: Int, CaseIterable, Codable, Identifiable {
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6

    var id: Int { rawValue }

    var shortName: String {
        switch self {
        case .monday: return "Mon"
        case .tuesday: return "Tue"
        case .wednesday: return "Wed"
        case .thursday: return "Thu"
        case .friday: return "Fri"
        }
    }

    var fullName: String {
        switch self {
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        }
    }

    static func from(_ date: Date, calendar: Calendar = .current) -> Weekday? {
        let weekday = calendar.component(.weekday, from: date)
        return Weekday(rawValue: weekday)
    }
}

enum DOECategory: String, CaseIterable, Codable, Identifiable {
    case biology = "Biology"
    case chemistry = "Chemistry"
    case physics = "Physics"
    case earthSpace = "Earth and Space"
    case energy = "Energy"
    case math = "Math"
    case generalScience = "General Science"

    var id: String { rawValue }

    var subject: Subject? {
        switch self {
        case .biology: return .biology
        case .chemistry: return .chemistry
        case .physics: return .physics
        default: return nil
        }
    }

    /// Bio, Chem, Phys — matches Soha's study schedule blocks.
    var isStudyCategory: Bool { subject != nil }

    var isSohaCategory: Bool { isStudyCategory }
}

enum QuestionType: String, Codable {
    case tossUp = "TOSS-UP"
    case bonus = "BONUS"
}

enum QuestionFormat: String, Codable {
    case multipleChoice = "Multiple Choice"
    case shortAnswer = "Short Answer"
}

enum QuestionSource: String, Codable, CaseIterable, Identifiable {
    case customCurriculum = "Soha Curriculum"
    case doeOfficial = "DOE Official"
    case importedPDF = "Imported PDF"
    case importedCSV = "Imported CSV"
    case importedJSON = "Imported JSON"

    var id: String { rawValue }
}

enum ReviewStage: String, Codable, CaseIterable {
    case new
    case learning
    case review
    case mastered

    var nextIntervalDays: Int {
        switch self {
        case .new: return 1
        case .learning: return 3
        case .review: return 7
        case .mastered: return 14
        }
    }

    func advanced() -> ReviewStage {
        switch self {
        case .new: return .learning
        case .learning: return .review
        case .review: return .mastered
        case .mastered: return .mastered
        }
    }

    func regressed() -> ReviewStage {
        switch self {
        case .new: return .new
        case .learning: return .new
        case .review: return .learning
        case .mastered: return .review
        }
    }
}

enum StudySessionStage: Int, CaseIterable, Identifiable {
    case recall = 0
    case read = 1
    case knowCold = 2
    case tossups = 3

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .recall: return "Recall"
        case .read: return "Read"
        case .knowCold: return "Know Cold"
        case .tossups: return "Toss-ups"
        }
    }

    var subtitle: String {
        let mins = ScheduleConstants.scienceSessionMinutes
        switch self {
        case .recall: return "0–10 min · 5 quick questions from last week"
        case .read: return "10–\(mins - 20) min · Textbook section + Focus + Formulas (not always a whole chapter)"
        case .knowCold: return "\(mins - 20)–\(mins - 10) min · Self-check without notes"
        case .tossups: return "\(mins - 10)–\(mins) min · Sample toss-ups + notebook"
        }
    }
}
