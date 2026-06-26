import SwiftUI

/// BFN-A chapter assignments — labeled like Larson / OpenStax blocks.
struct POT6BFNReadingView: View {
    let chapterNumbers: [Int]
    var compact: Bool = false

    var body: some View {
        if !chapterNumbers.isEmpty {
            VStack(alignment: .leading, spacing: 6) {
                Text("BFN-A · \(BFNAlgebraCatalog.editionTitle) (ISBN \(BFNAlgebraCatalog.isbn))")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(PlatformColor.systemOrange)

                if compact {
                    ForEach(chapterNumbers, id: \.self) { chapterNumber in
                        if let chapter = BFNAlgebraCatalog.chapter(chapterNumber),
                           let unit = BFNAlgebraCatalog.unit(forChapter: chapterNumber) {
                            Text("Unit \(unit.number) · Ch \(chapter.number) — \(chapter.title) · \(BFNAlgebraCatalog.pageLabel(forChapter: chapterNumber))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                } else {
                    ForEach(BFNAlgebraCatalog.groupedChapters(chapterNumbers), id: \.unit.id) { group in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Unit \(group.unit.number) — \(group.unit.name) · \(BFNAlgebraCatalog.pageLabel(forChapter: group.chapters.first!.number))")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)

                            ForEach(group.chapters) { chapter in
                                Text("Ch \(chapter.number) — \(chapter.title)")
                                    .font(.caption)
                            }
                        }
                    }
                }

                Text("Sections: \(BFNAlgebraCatalog.chapterSectionGuide)")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
    }
}

/// Larson / OpenStax reading links shared by POT 6 algebra and geometry plans.
struct POT6ReadingOptionsView: View {
    let options: MathAlgebraReadingCatalog.ReadingOptions
    var disclosureLabel: String = "Larson & OpenStax"
    var style: Style = .disclosure

    enum Style {
        case disclosure
        case inline
    }

    var body: some View {
        if !options.isEmpty {
            switch style {
            case .disclosure:
                DisclosureGroup {
                    content
                } label: {
                    Text(disclosureLabel)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(PlatformColor.systemBlue)
                }
            case .inline:
                content
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        VStack(alignment: .leading, spacing: 6) {
            if !options.larsonSections.isEmpty {
                Text("Larson (ISBN \(MathAlgebraReadingCatalog.larsonISBN))")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                ForEach(options.larsonSections) { section in
                    Text(section.label)
                        .font(.caption)
                }
            }

            if !options.openStaxSections.isEmpty {
                Text("OpenStax (free online)")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                ForEach(options.openStaxSections) { section in
                    if let url = section.url {
                        Link(section.label, destination: url)
                            .font(.caption)
                    } else {
                        Text(section.label)
                            .font(.caption)
                    }
                }
            }
        }
    }
}

/// Per-topic BFN-A + Larson + OpenStax — used in catch-up, topic lists, and detail pages.
struct POT6TopicReadingSummaryView: View {
    let potCode: String

    private var bfnChapters: [Int] {
        POT6CatchUpCatalog.allItems.first { $0.potCode == potCode }?.bfnChapters ?? []
    }

    private var alternateReading: MathAlgebraReadingCatalog.ReadingOptions {
        MathAlgebraReadingCatalog.readingOptions(bfnChapterNumbers: bfnChapters, potCode: potCode)
    }

    static func hasReading(for potCode: String) -> Bool {
        let bfn = POT6CatchUpCatalog.allItems.first { $0.potCode == potCode }?.bfnChapters ?? []
        let alt = MathAlgebraReadingCatalog.readingOptions(bfnChapterNumbers: bfn, potCode: potCode)
        return !bfn.isEmpty || !alt.isEmpty
    }

    var body: some View {
        if Self.hasReading(for: potCode) {
            VStack(alignment: .leading, spacing: 8) {
                if !bfnChapters.isEmpty {
                    POT6BFNReadingView(chapterNumbers: bfnChapters, compact: true)
                } else if POT6GeometryCatalog.schoolCodes.contains(potCode) {
                    Text("BFN-A has no geometry chapters")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }

                if !alternateReading.isEmpty {
                    POT6ReadingOptionsView(options: alternateReading, style: .inline)
                }
            }
        }
    }
}
