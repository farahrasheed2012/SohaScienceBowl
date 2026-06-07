import SwiftUI

// MARK: - Layout primitives

struct StudyMaterialCard<Content: View>: View {
    let title: String
    var systemImage: String? = nil
    var accent: Color = PlatformColor.systemBlue
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(accent)
                        .frame(width: 28, height: 28)
                        .background(accent.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                }
                Text(title)
                    .font(.title3.weight(.semibold))
                    .fixedSize(horizontal: false, vertical: true)
            }

            content()
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(PlatformColor.secondaryGroupedBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct StudyMaterialHeader: View {
    let block: StudyBlock
    let pass: StudyPass

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center) {
                SubjectBadge(subject: block.subject)
                Spacer()
                Text("Week \(block.week)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(PlatformColor.tertiaryFill)
                    .clipShape(Capsule())
            }

            Text(block.primaryTopic)
                .font(.title2.weight(.bold))
                .fixedSize(horizontal: false, vertical: true)

            if let theme = DeepDiveContent.weekTheme(week: block.week, pass: pass) {
                Text(theme)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(PlatformColor.systemBlue)
            }

            Label(block.bookLine(for: pass), systemImage: "book.closed.fill")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(PlatformColor.secondaryGroupedBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

// MARK: - Text formatting

struct StudyMaterialBodyText: View {
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(Array(chunks.enumerated()), id: \.offset) { _, chunk in
                switch chunk {
                case .paragraph(let body):
                    Text(body)
                        .font(.body)
                        .lineSpacing(6)
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                case .bullets(let items):
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                            HStack(alignment: .top, spacing: 10) {
                                Text("•")
                                    .font(.body.weight(.semibold))
                                    .foregroundStyle(PlatformColor.systemBlue)
                                    .padding(.top, 1)
                                Text(item)
                                    .font(.body)
                                    .lineSpacing(5)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
            }
        }
    }

    private enum Chunk {
        case paragraph(String)
        case bullets([String])
    }

    private var chunks: [Chunk] {
        StudyTextChunk.parse(text).map { chunk in
            switch chunk {
            case .paragraph(let body): return .paragraph(body)
            case .bullets(let items): return .bullets(items)
            }
        }
    }
}

struct StudyKnowColdCards: View {
    let items: [KnowColdItem]

    var body: some View {
        VStack(spacing: 12) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(index + 1). \(item.prompt)")
                        .font(.body.weight(.medium))
                        .fixedSize(horizontal: false, vertical: true)

                    if !item.answer.isEmpty {
                        HStack(alignment: .top, spacing: 8) {
                            Text("Answer")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)
                                .frame(width: 52, alignment: .leading)
                            Text(item.answer)
                                .font(.subheadline)
                                .foregroundStyle(PlatformColor.systemGreen)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.top, 2)
                    }
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(PlatformColor.tertiaryGroupedBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
    }
}

struct StudyDeepDiveSections: View {
    let block: StudyBlock
    let pass: StudyPass

    private var sections: [ReadingSection] {
        BlockReadingContent.sections(for: block, pass: pass)
    }

    var body: some View {
        VStack(spacing: 14) {
            ForEach(sections) { section in
                VStack(alignment: .leading, spacing: 12) {
                    Text(section.title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    StudyMaterialBodyText(text: section.body)
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(PlatformColor.tertiaryGroupedBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
    }
}

// MARK: - Shared scroll content

struct StudyMaterialScrollContent: View {
    @Environment(AppState.self) private var appState
    let block: StudyBlock

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            StudyMaterialHeader(block: block, pass: appState.currentPass)

            if let workflow = DeepDiveContent.passWorkflow(week: block.week, pass: appState.currentPass) {
                StudyMaterialCard(title: "How to use this block", systemImage: "clock.fill", accent: PlatformColor.systemIndigo) {
                    StudyMaterialBodyText(text: workflow)
                }
            }

            StudyMaterialCard(title: "Focus", systemImage: "scope", accent: PlatformColor.systemBlue) {
                StudyMaterialBodyText(text: block.focus)
            }

            StudyMaterialCard(title: "Deep dive", systemImage: "text.alignleft", accent: PlatformColor.systemTeal) {
                StudyDeepDiveSections(block: block, pass: appState.currentPass)
            }

            StudyMaterialCard(title: "Formulas & key terms", systemImage: "function", accent: PlatformColor.systemPurple) {
                StudyMaterialBodyText(text: block.formulasAndTerms)
            }

            StudyMaterialCard(title: "Know cold", systemImage: "brain.head.profile", accent: PlatformColor.systemGreen) {
                StudyKnowColdCards(items: appState.knowColdItems(for: block))
            }

            if block.day == .friday, let note = DeepDiveContent.fridayReviewNote(week: block.week) {
                StudyMaterialCard(title: "Friday review block", systemImage: "calendar.badge.clock", accent: PlatformColor.systemOrange) {
                    StudyMaterialBodyText(text: note)
                }
            }

            let related = appState.encyclopedia.relatedTopics(for: block)
            if !related.isEmpty {
                StudyMaterialCard(title: "Encyclopedia articles", systemImage: "books.vertical.fill", accent: PlatformColor.systemIndigo) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Full NSB topic articles matched to today's block — What Is It, How It Works, traps, and more.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        ForEach(related) { topic in
                            NavigationLink(value: StudyNavigationRoute.encyclopediaTopic(id: topic.id)) {
                                HStack {
                                    Text(topic.title)
                                        .font(.subheadline.weight(.medium))
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundStyle(.tertiary)
                                }
                                .padding(.vertical, 8)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }
}
