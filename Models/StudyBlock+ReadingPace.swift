import Foundation

extension StudyBlock {
    /// User-facing guidance: most blocks are a section or part, not a full chapter in one hour.
    var readingPaceLabel: String {
        let title = chapterTitle.lowercased()
        let focusLower = focus.lowercased()
        let ch = chapter.lowercased()

        if isFlashCardOnly || ch.contains("review") {
            return "Review block — revisit weak topics from your notebook. Open the book only for parts you cannot recall."
        }
        if title.contains("part 1") || focusLower.contains("part 1") {
            return "Read part 1 only today — not the whole chapter. Finish on the next same-subject day this week (e.g. Tue/Fri for biology, Mon/Thu for chemistry, Wed for physics)."
        }
        if title.contains("part 2") || focusLower.contains("part 2") {
            return "Finish part 2 today — you started this chapter on an earlier same-subject day. Still not rushing the whole book; just complete today's section."
        }
        if ch.contains("§") {
            return "Read only the listed section (§) — not the entire chapter. Stop when the Focus bullets make sense."
        }
        if ch.hasPrefix("Ch ") || ch.hasPrefix("ch ") {
            if !ch.contains("+") && !title.contains("part") {
                return "Read only the assigned § sections for today's Focus — not the whole chapter. See Reading options for the section range."
            }
        }
        if ch.contains("–") || (ch.contains("-") && ch.contains("ch")) {
            return "Read only today's page range — not the full chapter span. Take the full hour if you need it."
        }
        if ch.contains("+") {
            return "Two short sections today — read each part listed in the chapter line, then stop."
        }
        return "Read today's assigned pages until the Focus list is covered. Skip sections that are not NSB-relevant — quality over speed."
    }

    /// Short label for study-session stage header.
    var readingScopeShort: String {
        let title = chapterTitle.lowercased()
        let focusLower = focus.lowercased()
        let ch = chapter.lowercased()

        if isFlashCardOnly || ch.contains("review") { return "review" }
        if title.contains("part 1") || focusLower.contains("part 1") { return "section · part 1" }
        if title.contains("part 2") || focusLower.contains("part 2") { return "section · part 2" }
        if ch.contains("§") { return "one section" }
        if ch.hasPrefix("Ch ") || ch.hasPrefix("ch ") { return "assigned § sections" }
        return "assigned section"
    }
}
