import Foundation

/// BFN-C primary chemistry; Hewitt (Expl), Modern Chemistry (Mod), and Tro backups.
enum ChemistryTextbookCatalog {
    static let bfnChemTitle = BFNChemistryCatalog.editionTitle
    static let modTitle = "Modern Chemistry (Sarquis, Student Edition 2012)"
    static let troTitle = "Introductory Chemistry (Nivaldo Tro, 4th Edition)"
    static let explTitle = ConceptualPhysicalScienceExplorationsCatalog.editionTitle

    static func title(for code: String) -> String {
        switch code {
        case "Mod": return modTitle
        case "Tro": return troTitle
        case "Expl": return explTitle
        case "BFN-C": return bfnChemTitle
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

    static func modBackupLine(for block: StudyBlock) -> String {
        if let mod = BlockAssignedReadingCatalog.modAssignment(for: block) {
            return mod.displayText
        }
        guard let code = block.pass2BookCode, code == "Mod",
              let ch = block.pass2Chapter else { return modTitle }
        return modLine(chapter: ch, title: block.pass2ChapterTitle ?? block.chapterTitle)
    }

    static func troBackupLine(for block: StudyBlock) -> String {
        if let tro = BlockAssignedReadingCatalog.troAssignment(for: block) {
            return tro.displayText
        }
        return troTitle
    }
}
