import SwiftUI

struct TextbookSectionItem: Hashable {
    var id: String
    var label: String
}

struct TextbookReadingProgressHeader: View {
    let completed: Int
    let total: Int

    var body: some View {
        if total > 0 {
            HStack(spacing: 8) {
                Image(systemName: completed == total ? "checkmark.circle.fill" : "book.closed.fill")
                    .foregroundStyle(completed == total ? PlatformColor.systemGreen : PlatformColor.systemBlue)
                Text("\(completed)/\(total) NSB-scheduled sections")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct TextbookSimpleChapterRow: View {
    @Environment(AppState.self) private var appState
    let chapterId: String
    let label: String

    private var isComplete: Bool {
        appState.textbookReading.isChapterComplete(chapterId: chapterId)
    }

    var body: some View {
        Button {
            appState.textbookReading.toggleSimpleChapter(chapterId)
            HapticFeedback.impact(.light)
        } label: {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: isComplete ? "checkmark.square.fill" : "square")
                    .font(.title3)
                    .foregroundStyle(isComplete ? PlatformColor.systemGreen : Color.secondary)
                Text(label)
                    .font(.subheadline)
                    .foregroundStyle(isComplete ? .secondary : .primary)
                    .strikethrough(isComplete, color: .secondary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
        .accessibilityValue(isComplete ? "Completed" : "Not completed")
    }
}

struct TextbookExpandableChapterRow: View {
    @Environment(AppState.self) private var appState
    let chapterId: String
    let chapterNumber: Int
    let chapterTitle: String
    let sections: [TextbookSectionItem]

    @State private var isExpanded = false

    private var sectionIds: [String] {
        sections.map(\.id)
    }

    private var isComplete: Bool {
        appState.textbookReading.isChapterComplete(chapterId: chapterId, sectionIds: sectionIds)
    }

    private var completedSections: Int {
        appState.textbookReading.completedSectionCount(chapterId: chapterId, sectionIds: sectionIds)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top, spacing: 8) {
                Button {
                    appState.textbookReading.toggleChapter(chapterId: chapterId, sectionIds: sectionIds)
                    HapticFeedback.impact(.light)
                } label: {
                    Image(systemName: isComplete ? "checkmark.square.fill" : "square")
                        .font(.title3)
                        .foregroundStyle(isComplete ? PlatformColor.systemGreen : Color.secondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Mark chapter \(chapterNumber) complete")

                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isExpanded.toggle()
                    }
                } label: {
                    HStack(alignment: .top, spacing: 6) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Ch \(chapterNumber) — \(chapterTitle)")
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(isComplete ? .secondary : .primary)
                                .strikethrough(isComplete, color: .secondary)
                                .multilineTextAlignment(.leading)
                            if !sections.isEmpty {
                                Text("\(completedSections)/\(sections.count) sections")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Spacer(minLength: 4)
                        if !sections.isEmpty {
                            Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.tertiary)
                                .padding(.top, 3)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .disabled(sections.isEmpty)
            }

            if isExpanded, !sections.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(sections, id: \.id) { section in
                        sectionRow(section)
                    }
                }
                .padding(.leading, 36)
            }
        }
        .padding(.vertical, 2)
    }

    private func sectionRow(_ section: TextbookSectionItem) -> some View {
        let done = appState.textbookReading.isSectionComplete(
            sectionId: section.id,
            chapterId: chapterId,
            allSectionIds: sectionIds
        )

        return Button {
            appState.textbookReading.toggleSection(
                sectionId: section.id,
                chapterId: chapterId,
                allSectionIds: sectionIds
            )
            HapticFeedback.impact(.light)
        } label: {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: done ? "checkmark.square.fill" : "square")
                    .font(.body)
                    .foregroundStyle(done ? PlatformColor.systemGreen : Color.secondary)
                Text(section.label)
                    .font(.caption)
                    .foregroundStyle(done ? .secondary : .primary)
                    .strikethrough(done, color: .secondary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

typealias TextbookExplChapterRow = TextbookExpandableChapterRow

extension TextbookExpandableChapterRow {
    init(
        chapterNumber: Int,
        chapterTitle: String,
        sections: [ConceptualPhysicalScienceExplorationsCatalog.Section]
    ) {
        self.chapterId = TextbookReadingCatalog.explChapterID(number: chapterNumber)
        self.chapterNumber = chapterNumber
        self.chapterTitle = chapterTitle
        self.sections = sections.map {
            TextbookSectionItem(
                id: TextbookReadingCatalog.explSectionID($0.id),
                label: "\($0.id) \($0.title)"
            )
        }
    }
}

extension TextbookExpandableChapterRow {
    init(chapter: FocusOnLifeScienceCatalog.Chapter) {
        self.chapterId = TextbookReadingCatalog.flsChapterID(number: chapter.number)
        self.chapterNumber = chapter.number
        self.chapterTitle = chapter.title
        self.sections = chapter.sections.map {
            TextbookSectionItem(
                id: TextbookReadingCatalog.flsSectionID($0.id),
                label: "\($0.id) \($0.title)"
            )
        }
    }
}
