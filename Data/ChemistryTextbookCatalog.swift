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

    /// Expl Part Three chapter(s) that parallel this chemistry block (from summer Mod/Tro rotation).
    static func explChapterReference(for block: StudyBlock) -> String {
        let mod = block.chapter.lowercased()
        let title = block.chapterTitle.lowercased()

        if mod.contains("ch 2") || title.contains("measurement") {
            return "App. A"
        }
        if mod.contains("ch 3") || title.contains("atom") {
            return "17"
        }
        if mod.contains("ch 10") || title.contains("states of matter") || title.contains("states") {
            return "17"
        }
        if mod.contains("ch 8") || title.contains("reaction") {
            return "20–21"
        }
        if mod.contains("ch 14") || title.contains("acid") || title.contains("base") {
            return "21"
        }
        if mod.contains("ch 12") || title.contains("solution") {
            return "19"
        }
        if mod.contains("ch 5") && mod.contains("ch 7") || title.contains("ion") || title.contains("formula") {
            return "17–18"
        }
        if mod.contains("ch 5") || title.contains("periodic") {
            return "17"
        }
        return "17"
    }

    static func explAlsoOKLine(for block: StudyBlock) -> String {
        let ref = explChapterReference(for: block)
        return "\(explTitle) — \(ConceptualPhysicalScienceExplorationsCatalog.formatReference(ref)) (optional skim after Mod/Tro)"
    }
}
