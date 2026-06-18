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

            if block.isFlashCardOnly {
                Label("Review block — open books only if stuck", systemImage: "rectangle.on.rectangle")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                Label(block.readingPaceLabel, systemImage: "book.pages")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(PlatformColor.secondaryGroupedBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct StudyBookOptionsCard: View {
    let block: StudyBlock
    let activePass: StudyPass
    var compact: Bool = false

    private var options: [StudyBookOption] {
        block.allBookOptions(activePass: activePass)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: compact ? 8 : 12) {
            Label("Reading options", systemImage: "books.vertical.fill")
                .font(compact ? .subheadline.weight(.semibold) : .headline)

            Text("Primary · Also OK · Backup — read assigned § sections only (stop when Focus is covered)")
                .font(.caption)
                .foregroundStyle(.secondary)

            ForEach(options) { option in
                StudyBookOptionRow(option: option, compact: compact)
            }
        }
    }
}

struct StudyBookOptionRow: View {
    let option: StudyBookOption
    var compact: Bool = false

    private var roleColor: Color {
        switch option.role {
        case .primary, .alternate: return PlatformColor.systemBlue
        case .alsoOK: return PlatformColor.systemTeal
        case .backup: return PlatformColor.systemOrange
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Text(option.role.displayLabel)
                    .font(.caption2.weight(.bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(roleColor.opacity(0.14))
                    .foregroundStyle(roleColor)
                    .clipShape(Capsule())

                if option.isRecommended {
                    Text("Recommended now")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(PlatformColor.systemGreen)
                }
            }

            Text(option.text)
                .font(compact ? .caption.weight(.medium) : .subheadline.weight(.medium))
                .fixedSize(horizontal: false, vertical: true)

            ForEach(option.links) { link in
                Link(destination: link.url) {
                    Label(link.label, systemImage: "safari")
                        .font(.caption.weight(.medium))
                }
            }
        }
        .padding(compact ? 10 : 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(PlatformColor.tertiaryGroupedBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

struct StudyMathBookOptionsCard: View {
    let reading: ScheduleOpenStaxCatalog.MathReading

    private var osaLabel: String {
        let sections = reading.sectionKeys.filter { $0 != "home" }
        if sections.isEmpty { return "OpenStax — review" }
        return "OSA §\(sections.joined(separator: " · §"))"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Math reading options", systemImage: "books.vertical.fill")
                .font(.headline)

            StudyBookOptionRow(
                option: StudyBookOption(
                    id: "bfn-a-primary",
                    role: .primary,
                    text: reading.bfnOptionText,
                    links: [],
                    isRecommended: true
                )
            )

            if !reading.sectionKeys.isEmpty {
                StudyBookOptionRow(
                    option: StudyBookOption(
                        id: "osa-also",
                        role: .alsoOK,
                        text: osaLabel,
                        links: Array(zip(reading.sectionKeys, reading.urls)).map { key, url in
                            StudyBookLink(
                                label: key == "home" ? "OpenStax book overview" : "OpenStax §\(key)",
                                url: url
                            )
                        },
                        isRecommended: false
                    )
                )
            }

            if !reading.larBackupLine.isEmpty {
                StudyBookOptionRow(
                    option: StudyBookOption(
                        id: "lar-backup",
                        role: .backup,
                        text: reading.larBackupLine,
                        links: [],
                        isRecommended: false
                    )
                )
            }
        }
    }
}

/// Books/chapters first, optional videos second — one combined block for Today & topic screens.
struct StudyBlockReadingAndVideos: View {
    let block: StudyBlock
    let activePass: StudyPass
    var compact: Bool = false

    private var videos: [ScheduleVideoLink] {
        ScheduleVideoCatalog.scienceLinks(for: block)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: compact ? 12 : 16) {
            StudyBookOptionsCard(block: block, activePass: activePass, compact: compact)

            if !videos.isEmpty {
                Divider()

                Label("Optional videos", systemImage: "play.rectangle.fill")
                    .font(compact ? .subheadline.weight(.semibold) : .headline)
                    .foregroundStyle(PlatformColor.systemRed)

                Text("~5–12 min each · read your assigned section first")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                ForEach(videos) { link in
                    ScheduleVideoLinkRow(link: link)
                }
            }
        }
    }
}

struct StudyMathReadingAndVideos: View {
    let reading: ScheduleOpenStaxCatalog.MathReading
    let week: Int
    let day: Weekday

    private var videos: [ScheduleVideoLink] {
        ScheduleVideoCatalog.mathLinks(week: week, day: day)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            StudyMathBookOptionsCard(reading: reading)

            if !videos.isEmpty {
                Divider()

                Label("Optional math videos", systemImage: "play.rectangle.fill")
                    .font(.headline)
                    .foregroundStyle(PlatformColor.systemRed)

                Text("~5–12 min each · read BFN-A first")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                ForEach(videos) { link in
                    ScheduleVideoLinkRow(link: link)
                }
            }
        }
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

// MARK: - Optional YouTube links

struct ScheduleVideoLinkRow: View {
    let link: ScheduleVideoLink
    var subtitle: String? = nil
    var accent: Color = PlatformColor.systemRed

    var body: some View {
        Link(destination: link.url) {
            HStack(alignment: .top, spacing: 10) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(link.title)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.primary)
                    if let subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else {
                        Text(link.note)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer(minLength: 0)
                Image(systemName: "play.circle.fill")
                    .foregroundStyle(accent)
            }
        }
    }
}

struct StudyVideoLinksCard: View {
    let title: String
    let links: [ScheduleVideoLink]
    var accent: Color = PlatformColor.systemRed

    var body: some View {
        if !links.isEmpty {
            StudyMaterialCard(title: title, systemImage: "play.rectangle.fill", accent: accent) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Optional ~5–12 min previews. Read your assigned section first.")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ForEach(links) { link in
                        Link(destination: link.url) {
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "play.circle.fill")
                                    .font(.body)
                                    .foregroundStyle(accent)
                                    .padding(.top, 1)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(link.title)
                                        .font(.subheadline.weight(.medium))
                                        .foregroundStyle(.primary)
                                    Text(link.note)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer(minLength: 0)
                                Image(systemName: "arrow.up.right")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                            .padding(.vertical, 6)
                        }
                    }
                }
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

            StudyBlockReadingAndVideos(
                block: block,
                activePass: appState.currentPass,
                compact: false
            )

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
