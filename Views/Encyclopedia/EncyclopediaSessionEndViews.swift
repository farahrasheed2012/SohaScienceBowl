import SwiftUI

struct EncyclopediaSessionEndView: View {
    @Environment(\.themePalette) private var theme

    let score: Int
    let total: Int
    let missedTopicIds: [String]
    let practiceMode: EncyclopediaPracticeMode
    var scoreSubtitle: String?

    private var uniqueMissedIds: [String] {
        Array(Set(missedTopicIds)).sorted()
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Session complete!")
                    .font(.system(size: ThemePalette.largeTitleSize, weight: .bold))
                    .foregroundStyle(theme.primaryText)
                    .accessibilityAddTraits(.isHeader)

                Text(scoreLine)
                    .font(.system(size: ThemePalette.titleSize))
                    .foregroundStyle(theme.secondaryText)
                    .multilineTextAlignment(.center)

                if !uniqueMissedIds.isEmpty {
                    VStack(spacing: 12) {
                        Text("Topics to review")
                            .font(.headline)
                            .foregroundStyle(theme.secondaryText)

                        NavigationLink {
                            EncyclopediaWeakTopicsReviewView(topicIds: uniqueMissedIds)
                        } label: {
                            sessionButtonLabel("Review weak topics", filled: true)
                        }
                        .buttonStyle(.plain)
                        .accessibilityHint("Opens articles for topics you missed")

                        NavigationLink {
                            EncyclopediaPracticeSetupView(mode: practiceMode, preferredTopicIds: uniqueMissedIds)
                        } label: {
                            sessionButtonLabel("Practice weak topics", filled: false)
                        }
                        .buttonStyle(.plain)
                        .accessibilityHint("Starts a new session on missed topics only")
                    }
                }

                NavigationLink {
                    EncyclopediaPracticeSetupView(mode: practiceMode, preferredTopicIds: nil)
                } label: {
                    sessionButtonLabel("Practice again", filled: true)
                }
                .buttonStyle(.plain)
                .accessibilityHint("Starts a new session with the same mode")
            }
            .padding(24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.surface.ignoresSafeArea())
    }

    private var scoreLine: String {
        if let scoreSubtitle {
            return "\(score) / \(total) \(scoreSubtitle)"
        }
        return "\(score) / \(total) correct"
    }

    @ViewBuilder
    private func sessionButtonLabel(_ title: String, filled: Bool) -> some View {
        Text(title)
            .font(.system(size: ThemePalette.bodySize, weight: .semibold))
            .foregroundStyle(filled ? Color.white : theme.primaryText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(filled ? theme.accent : theme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: ThemePalette.cornerRadius))
            .overlay {
                if !filled {
                    RoundedRectangle(cornerRadius: ThemePalette.cornerRadius)
                        .stroke(theme.accent, lineWidth: 2)
                }
            }
    }
}

struct EncyclopediaWeakTopicsReviewView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.themePalette) private var theme

    let topicIds: [String]

    var body: some View {
        List {
            ForEach(topicIds, id: \.self) { topicId in
                if let topic = appState.encyclopedia.topic(byId: topicId) {
                    NavigationLink(value: StudyNavigationRoute.encyclopediaTopic(id: topic.id)) {
                        Text(topic.title)
                            .font(.system(size: ThemePalette.bodySize))
                            .foregroundStyle(theme.primaryText)
                    }
                }
            }
        }
        .navigationTitle("Review topics")
        .navigationBarTitleDisplayMode(.inline)
        .studyNavigationDestinations()
    }
}
