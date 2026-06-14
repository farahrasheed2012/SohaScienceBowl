import Foundation

/// What Middle School NSB actually requires — **topics**, not whole textbooks cover-to-cover.
enum MSNSBStudyScope {
    /// Bio · Chem · Phys summer blocks (Earth/Energy/Math are separate DOE categories).
    static let summerScienceSubjects: [Subject] = [.biology, .chemistry, .physics]

    static let checklistTopicCount = 22

    static let introShort =
        "Study DOE topic areas (Life Science · Physical Science · Math) — read textbook sections for those topics only, not whole books."

    static let introLong = """
    DOE Tips & Resources lists middle-school study topics — not every chapter in a textbook. Summer blocks, the Progress checklist (\(checklistTopicCount) Bio/Chem/Phys items), and Learn articles target those NSB topics only.

    Life Science: cell biology, genetics, anatomy & physiology, plant biology, ecology, animal behavior.
    Physical Science: chemistry (reactions, periodic table, states of matter) · physics (forces, motion, waves, electromagnetism, thermodynamics).
    Mathematics (algebra block): Algebra I & II, geometry, probability, statistics, number sense.
    """

    static let bookUseGuidance =
        "Textbooks are a lookup tool. Open the assigned section, read until Focus makes sense, then drill toss-ups."

    /// FLS chapters referenced by summer biology blocks (not every chapter in the book).
    static let scheduledFLSChapterNumbers: Set<Int> = [1, 2, 3, 4, 5, 7, 8, 10, 11, 16, 21]

    /// Hewitt (Expl) chapters on the summer physics plan.
    static let scheduledExplChapterNumbers: Set<Int> = [1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 15]

    static func includes(flsChapter number: Int) -> Bool {
        scheduledFLSChapterNumbers.contains(number)
    }

    static func includes(explChapter number: Int) -> Bool {
        scheduledExplChapterNumbers.contains(number)
    }

    static func readingProgressLabel(completed: Int, total: Int, bookShortName: String) -> String {
        "\(completed)/\(total) NSB-scheduled \(bookShortName) sections"
    }
}
