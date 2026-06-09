import Foundation

/// Trackable textbook chapters — **Hewitt (Expl)** and **Focus on Life Science** only.
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
            return explChapters(partIDs: ["p3"])
        case "physics":
            return explChapters(partIDs: ["intro", "p1", "p2"]) + explAppendices
        case "earth-space":
            return explChapters(partIDs: ["p4", "p5"])
        case "biology":
            return flsChapters
        default:
            return []
        }
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
            return "\(summary.completed)/\(summary.total) FLS chapters read"
        default:
            return "\(summary.completed)/\(summary.total) Hewitt chapters read"
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
}
