import Foundation

/// Modern Chemistry (Sarquis) and Introductory Chemistry (Tro) — summer chemistry primaries.
enum ChemistryTextbookCatalog {
    static let modTitle = "Modern Chemistry (Sarquis, Student Edition 2012)"
    static let troTitle = "Introductory Chemistry (Nivaldo Tro, 4th Edition)"
    static let explTitle = ConceptualPhysicalScienceExplorationsCatalog.editionTitle

    static func title(for code: String) -> String {
        switch code {
        case "Mod": return modTitle
        case "Tro": return troTitle
        case "Expl": return explTitle
        default: return code
        }
    }

    static func modLine(chapter: String, title: String) -> String {
        "\(modTitle) — \(chapter) — \(title)"
    }

    static func troLine(chapter: String, title: String) -> String {
        "\(troTitle) — \(chapter) — \(title)"
    }

    static func formattedLine(bookCode: String, chapter: String, title: String) -> String {
        switch bookCode {
        case "Mod": return modLine(chapter: chapter, title: title)
        case "Tro": return troLine(chapter: chapter, title: title)
        default: return "\(bookCode) \(chapter) — \(title)"
        }
    }
}
