import Foundation

extension StudyBlock {
    /// FLS section assignment with estimated printed pages (biology only).
    var readingPageSummary: String? {
        guard subject == .biology, bookCode == "FLS",
              let sections = BlockAssignedReadingCatalog.flsChapterSections(for: self) else { return nil }
        return FocusOnLifeScienceCatalog.readingPaceSummary(chapterSections: sections)
    }

    var estimatedReadingPages: Int? {
        guard subject == .biology, bookCode == "FLS",
              let sections = BlockAssignedReadingCatalog.flsChapterSections(for: self) else { return nil }
        let pages = FocusOnLifeScienceCatalog.estimatedPages(chapterSections: sections)
        return pages > 0 ? pages : nil
    }

    var isHeavyReadingDay: Bool {
        guard subject == .biology, bookCode == "FLS",
              let sections = BlockAssignedReadingCatalog.flsChapterSections(for: self) else { return false }
        return FocusOnLifeScienceCatalog.isHeavyReading(chapterSections: sections)
    }

    /// User-facing guidance: most blocks are a section or part, not a full chapter in one hour.
    var readingPaceLabel: String {
        let title = chapterTitle.lowercased()
        let focusLower = focus.lowercased()
        let ch = chapter.lowercased()

        if isFlashCardOnly || ch.contains("review") {
            return "Review block — revisit weak topics from your notebook. Open the book only for parts you cannot recall."
        }

        if subject == .biology, bookCode == "FLS", let summary = readingPageSummary {
            var label = "Sections only — not the whole chapter. \(summary). Stop when Focus bullets make sense."
            if isHeavyReadingDay {
                label += " Heavy day: split across the weekend or use OpenStax backup in Reading options."
            }
            return label
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
                return "Read only the assigned sections for today's Focus — not the whole chapter. See Reading options for the section range."
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
        if let pages = estimatedReadingPages {
            if isHeavyReadingDay { return "heavy · ~\(pages) pp · sections" }
            return "~\(pages) pp · sections only"
        }
        if title.contains("part 1") || focusLower.contains("part 1") { return "section · part 1" }
        if title.contains("part 2") || focusLower.contains("part 2") { return "section · part 2" }
        if ch.contains("§") { return "one section" }
        if ch.hasPrefix("Ch ") || ch.hasPrefix("ch ") { return "assigned sections" }
        return "assigned section"
    }
}
