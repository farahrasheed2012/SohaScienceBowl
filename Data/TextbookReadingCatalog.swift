import Foundation

/// Trackable textbook sections — **NSB summer schedule only** (not entire FLS / Hewitt books).
enum TextbookReadingCatalog {
    struct ChapterTrackable: Hashable {
        var id: String
        var label: String
        var sectionIds: [String]
    }

    static let hewittTitle = ConceptualPhysicalScienceExplorationsCatalog.editionTitle
    static let flsTitle = FocusOnLifeScienceCatalog.editionTitle

    static func explChapterID(number: Int) -> String { "Expl-ch-\(number)" }
    static func explSectionID(_ sectionId: String) -> String { "Expl-sec-\(sectionId)" }
    static func explAppendixID(letter: String) -> String { "Expl-app-\(letter)" }

    static func flsChapterID(number: Int) -> String { "FLS-ch-\(number)" }
    static func flsSectionID(_ sectionId: String) -> String { "FLS-sec-\(sectionId)" }

    static func chapters(forCategoryId categoryId: String) -> [ChapterTrackable] {
        switch categoryId {
        case "chemistry":
            return []
        case "mathematics":
            return bfnAlgebraChapters
        case "physics":
            return explChapters(partIDs: ["intro", "p1", "p2"])
                .filter { chapterNumber(from: $0.id).map(MSNSBStudyScope.includes(explChapter:)) == true }
                + explAppendices.filter { $0.id == explAppendixID(letter: "B") }
        case "earth-space":
            return []
        case "biology":
            return flsChapters.filter { chapterNumber(from: $0.id).map(MSNSBStudyScope.includes(flsChapter:)) == true }
        default:
            return []
        }
    }

    private static func chapterNumber(from chapterId: String) -> Int? {
        if chapterId.hasPrefix("Expl-ch-") {
            return Int(chapterId.replacingOccurrences(of: "Expl-ch-", with: ""))
        }
        if chapterId.hasPrefix("FLS-ch-") {
            return Int(chapterId.replacingOccurrences(of: "FLS-ch-", with: ""))
        }
        return nil
    }

    @MainActor
    static func progressSummary(
        forCategoryId categoryId: String,
        store: TextbookReadingProgressStore
    ) -> (completed: Int, total: Int) {
        let items = chapters(forCategoryId: categoryId)
        let completed = items.filter { store.isChapterComplete(chapterId: $0.id, sectionIds: $0.sectionIds) }.count
        return (completed, items.count)
    }

    @MainActor
    static func progressLabel(
        forCategoryId categoryId: String,
        store: TextbookReadingProgressStore
    ) -> String? {
        let summary = progressSummary(forCategoryId: categoryId, store: store)
        guard summary.total > 0 else { return nil }
        switch categoryId {
        case "biology":
            return MSNSBStudyScope.readingProgressLabel(completed: summary.completed, total: summary.total, bookShortName: "FLS")
        case "mathematics":
            return MSNSBStudyScope.readingProgressLabel(completed: summary.completed, total: summary.total, bookShortName: "BFN-A")
        default:
            return MSNSBStudyScope.readingProgressLabel(completed: summary.completed, total: summary.total, bookShortName: "Hewitt")
        }
    }

    // MARK: - Private builders

    private static func explChapters(partIDs: [String]) -> [ChapterTrackable] {
        ConceptualPhysicalScienceExplorationsCatalog.chaptersGroupedByPart(filterPartIDs: Set(partIDs))
            .flatMap(\.chapters)
            .map { chapter in
                let sectionIds = chapter.sections.map { explSectionID($0.id) }
                return ChapterTrackable(
                    id: explChapterID(number: chapter.number),
                    label: "Ch \(chapter.number) — \(chapter.title)",
                    sectionIds: sectionIds
                )
            }
    }

    private static var explAppendices: [ChapterTrackable] {
        ConceptualPhysicalScienceExplorationsCatalog.appendices.map {
            ChapterTrackable(
                id: explAppendixID(letter: $0.letter),
                label: "Appendix \($0.letter) — \($0.title)",
                sectionIds: []
            )
        }
    }

    private static var flsChapters: [ChapterTrackable] {
        FocusOnLifeScienceCatalog.chapters.map { chapter in
            let sectionIds = chapter.sections.map { flsSectionID($0.id) }
            return ChapterTrackable(
                id: flsChapterID(number: chapter.number),
                label: "Ch \(chapter.number) — \(chapter.title)",
                sectionIds: sectionIds
            )
        }
    }

    private static var bfnAlgebraChapters: [ChapterTrackable] {
        BFNAlgebraCatalog.chapters.map { chapter in
            ChapterTrackable(
                id: chapter.trackableId,
                label: chapter.label,
                sectionIds: []
            )
        }
    }
}
