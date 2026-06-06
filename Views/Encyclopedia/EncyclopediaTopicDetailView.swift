import SwiftUI

struct EncyclopediaTopicDetailView: View {
    @Environment(AppState.self) private var appState
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
        .navigationBarTitleDisplayMode(.inline)
        .studyNavigationDestinations()
    }

    @ViewBuilder
    private func scrollContent(_ topic: NSBTopic) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                StudyMaterialCard(title: topic.title, systemImage: "text.book.closed.fill", accent: Color(uiColor: .systemBlue)) {
                    Text(topic.subject)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                StudyMaterialCard(title: "What Is It?", systemImage: "lightbulb.fill", accent: Color(uiColor: .systemYellow)) {
                    StudyMaterialBodyText(text: topic.whatIsIt)
                }

                StudyMaterialCard(title: "How It Works", systemImage: "gears", accent: Color(uiColor: .systemTeal)) {
                    StudyMaterialBodyText(text: topic.howItWorks)
                }

                StudyMaterialCard(title: "Real-World Example", systemImage: "globe.americas.fill", accent: Color(uiColor: .systemGreen)) {
                    StudyMaterialBodyText(text: topic.realWorldExample)
                }

                StudyMaterialCard(title: "Key Terms to Know", systemImage: "character.book.closed.fill", accent: Color(uiColor: .systemPurple)) {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(topic.keyTerms, id: \.term) { term in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(term.term)
                                    .font(.subheadline.weight(.semibold))
                                Text(term.definition)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                StudyMaterialCard(title: "Common NSB Traps", systemImage: "exclamationmark.triangle.fill", accent: Color(uiColor: .systemOrange)) {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(Array(topic.nsbTraps.enumerated()), id: \.offset) { _, trap in
                            HStack(alignment: .top, spacing: 10) {
                                Text("•")
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color(uiColor: .systemOrange))
                                Text(trap)
                                    .font(.body)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }

                StudyMaterialCard(title: "Did You Know?", systemImage: "star.fill", accent: Color(uiColor: .systemIndigo)) {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(Array(topic.didYouKnow.enumerated()), id: \.offset) { _, fact in
                            Text(fact)
                                .font(.subheadline)
                                .italic()
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }

                if !topic.relatedTopics.isEmpty {
                    StudyMaterialCard(title: "Related Topics", systemImage: "link", accent: Color(uiColor: .systemBlue)) {
                        EncyclopediaTopicChipFlow(topicIds: topic.relatedTopics)
                    }
                }

                StudyMaterialCard(title: "Practice this topic", systemImage: "bolt.fill", accent: Color(uiColor: .systemOrange)) {
                    VStack(spacing: 10) {
                        ForEach([EncyclopediaPracticeMode.multipleChoice, .tossUpBonus, .freeResponse], id: \.self) { mode in
                            NavigationLink(value: StudyNavigationRoute.encyclopediaPractice(mode, topicIds: [topic.id])) {
                                Label(mode.title, systemImage: practiceIcon(mode))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 10)
                            }
                        }
                    }
                }
            }
            .padding(20)
            .padding(.bottom, 80)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .safeAreaInset(edge: .bottom) {
            if appState.encyclopedia.reviewedTopicIds.contains(topic.id) {
                Label("Reviewed", systemImage: "checkmark.circle.fill")
                    .font(.headline)
                    .foregroundStyle(Color(uiColor: .systemGreen))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(.bar)
            } else {
                Button {
                    appState.encyclopedia.markReviewed(topicId: topic.id)
                    HapticFeedback.success()
                } label: {
                    Label("Mark as reviewed", systemImage: "checkmark.circle")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(.bar)
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
    let topicIds: [String]

    var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(topicIds, id: \.self) { id in
                if let related = appState.encyclopedia.topic(byId: id) {
                    NavigationLink(value: StudyNavigationRoute.encyclopediaTopic(id: related.id)) {
                        Text(related.title)
                            .font(.caption.weight(.medium))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(uiColor: .systemBlue).opacity(0.12))
                            .foregroundStyle(Color(uiColor: .systemBlue))
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
