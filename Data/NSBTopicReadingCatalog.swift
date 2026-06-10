import Foundation

struct NSBTopicReadingLine: Codable, Hashable, Identifiable {
    var id: String { "\(bookCode)-\(label)-\(role)" }
    let bookCode: String
    let label: String
    let role: String
}

enum NSBTopicReadingCatalog {
    private static let loaded: [String: [NSBTopicReadingLine]] = loadFromBundle()

    static func readings(for topicId: String) -> [NSBTopicReadingLine] {
        loaded[topicId] ?? []
    }

    static func bookTitle(for code: String) -> String {
        switch code {
        case "OSB": return "OpenStax Concepts of Biology"
        case "FLS": return FocusOnLifeScienceCatalog.editionTitle
        case "CB": return CampbellBiologyCatalog.editionTitle
        case "Mod": return ChemistryTextbookCatalog.modTitle
        case "Tro": return ChemistryTextbookCatalog.troTitle
        case "Expl": return ConceptualPhysicalScienceExplorationsCatalog.editionTitle
        case "OSA": return "OpenStax Algebra and Trigonometry 2e"
        case "Lar": return "Holt McDougal Larson Algebra 1"
        case "BFN-A": return "Big Fat Notebook: Pre-Algebra & Algebra"
        case "BFN-Bio": return "Big Fat Notebook: Biology"
        case "BFN-Sci": return "Big Fat Notebook: Science"
        case "DOE-ESS": return "DOE-recommended Earth & Space textbooks"
        case "DOE-Energy": return "DOE Energy resources"
        default: return code
        }
    }

    static func roleLabel(for role: String) -> String {
        switch role {
        case "primary": return "Primary"
        case "pass1": return "Primary"
        case "pass2": return "Backup"
        case "alsoOK": return "Also OK"
        case "backup": return "Backup"
        case "doe": return "DOE"
        default: return role.capitalized
        }
    }

    static func roleColorName(for role: String) -> String {
        switch role {
        case "primary": return "blue"
        case "pass1", "pass2": return "indigo"
        case "alsoOK": return "teal"
        case "backup": return "orange"
        default: return "gray"
        }
    }

    private static func loadFromBundle() -> [String: [NSBTopicReadingLine]] {
        let url = Bundle.main.url(forResource: "topic_readings", withExtension: "json", subdirectory: "StudyContent")
            ?? Bundle.main.url(forResource: "topic_readings", withExtension: "json")
        guard let url,
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([String: [NSBTopicReadingLine]].self, from: data)
        else { return [:] }
        return decoded
    }
}
