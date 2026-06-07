import SwiftUI

struct EncyclopediaTopicDetailView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.themePalette) private var theme
    let topicId: String

    private var topic: NSBTopic? {
        appState.encyclopedia.topic(byId: topicId)
    }

    var body: some View {
        Group {
            if let topic {
                scrollContent(topic)
            } else {
                ContentUnavailableView("Topic not found", systemImage: "book.closed")
            }
        }
        .navigationTitle(topic?.title ?? "Topic")
        .inlineNavigationBarTitle()
        .studyNavigationDestinations()
    }

    @ViewBuilder
    private func scrollContent(_ topic: NSBTopic) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                LearnTopicHeaderCard(title: topic.title, subject: topic.subject)

                LearnSectionCard(title: "What Is It?", systemImage: "lightbulb.fill", accent: theme.accent) {
                    LearnBodyText(text: topic.whatIsIt)
                }

                LearnSectionCard(title: "How It Works", systemImage: "gears") {
                    LearnBodyText(text: topic.howItWorks)
                }

                LearnSectionCard(title: "Real-World Example", systemImage: "globe.americas.fill") {
                    LearnBodyText(text: topic.realWorldExample)
                }

                LearnSectionCard(title: "Key Terms to Know", systemImage: "character.book.closed.fill") {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(topic.keyTerms, id: \.term) { term in
                            LearnKeyTermRow(term: term.term, definition: term.definition)
                        }
                    }
                }

                LearnSectionCard(title: "Common NSB Traps", systemImage: "exclamationmark.triangle.fill", accent: theme.wrong) {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(Array(topic.nsbTraps.enumerated()), id: \.offset) { _, trap in
                            HStack(alignment: .top, spacing: 12) {
                                Text("•")
                                    .font(.system(size: ThemePalette.bodySize, weight: .bold))
                                    .foregroundStyle(theme.wrong)
                                    .padding(.top, 2)
                                Text(trap)
                                    .font(.system(size: ThemePalette.captionSize))
                                    .foregroundStyle(theme.primaryText)
                                    .lineSpacing(6)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }

                LearnSectionCard(title: "Did You Know?", systemImage: "star.fill") {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(Array(topic.didYouKnow.enumerated()), id: \.offset) { _, fact in
                            Text(fact)
                                .font(.system(size: ThemePalette.captionSize))
                                .italic()
                                .foregroundStyle(theme.secondaryText)
                                .lineSpacing(6)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }

                if !topic.relatedTopics.isEmpty {
                    LearnSectionCard(title: "Related Topics", systemImage: "link") {
                        EncyclopediaTopicChipFlow(topicIds: topic.relatedTopics)
                    }
                }

                LearnSectionCard(title: "Practice this topic", systemImage: "bolt.fill", accent: theme.accent) {
                    VStack(spacing: 4) {
                        ForEach([EncyclopediaPracticeMode.multipleChoice, .tossUpBonus, .freeResponse], id: \.self) { mode in
                            NavigationLink(value: StudyNavigationRoute.encyclopediaPractice(mode, topicIds: [topic.id])) {
                                HStack {
                                    Label(mode.title, systemImage: practiceIcon(mode))
                                        .font(.system(size: ThemePalette.bodySize, weight: .medium))
                                        .foregroundStyle(theme.primaryText)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(theme.secondaryText.opacity(0.7))
                                }
                                .padding(.vertical, 12)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(20)
            .padding(.bottom, 80)
        }
        .background(theme.surface)
        .safeAreaInset(edge: .bottom) {
            if appState.encyclopedia.reviewedTopicIds.contains(topic.id) {
                Label("Reviewed", systemImage: "checkmark.circle.fill")
                    .font(.system(size: ThemePalette.bodySize, weight: .semibold))
                    .foregroundStyle(theme.success)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(theme.cardBackground)
            } else {
                Button {
                    appState.encyclopedia.markReviewed(topicId: topic.id)
                    HapticFeedback.success()
                } label: {
                    Label("Mark as reviewed", systemImage: "checkmark.circle")
                        .font(.system(size: ThemePalette.bodySize, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .buttonStyle(.borderedProminent)
                .tint(theme.accent)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(theme.cardBackground)
                .accessibilityLabel("Mark as reviewed")
                .accessibilityHint("Double tap to mark this topic as reviewed")
            }
        }
    }

    private func practiceIcon(_ mode: EncyclopediaPracticeMode) -> String {
        switch mode {
        case .multipleChoice: return "list.bullet.rectangle"
        case .tossUpBonus: return "timer"
        case .freeResponse: return "keyboard"
        }
    }
}

struct EncyclopediaTopicChipFlow: View {
    @Environment(AppState.self) private var appState
    @Environment(\.themePalette) private var theme
    let topicIds: [String]

    var body: some View {
        FlowLayout(spacing: 10) {
            ForEach(topicIds, id: \.self) { id in
                if let related = appState.encyclopedia.topic(byId: id) {
                    NavigationLink(value: StudyNavigationRoute.encyclopediaTopic(id: related.id)) {
                        Text(related.title)
                            .font(.system(size: ThemePalette.captionSize, weight: .medium))
                            .foregroundStyle(theme.accent)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(theme.accent.opacity(0.15))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        arrange(proposal: proposal, subviews: subviews).size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, pos) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + pos.x, y: bounds.minY + pos.y), proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? 300
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var positions: [CGPoint] = []
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }
        return (CGSize(width: maxWidth, height: y + rowHeight), positions)
    }
}
