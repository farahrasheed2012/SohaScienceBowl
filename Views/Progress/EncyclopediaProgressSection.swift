import SwiftUI

struct EncyclopediaProgressSection: View {
    @Environment(AppState.self) private var appState
    @Environment(\.themePalette) private var theme

    var body: some View {
        Section {
            overallCard
            streakRow
        } header: {
            Text("Encyclopedia")
        }

        if !appState.encyclopedia.sessionHistory.isEmpty {
            Section("Session history") {
                ForEach(appState.encyclopedia.sessionHistory.prefix(15)) { session in
                    sessionRow(session)
                }
            }
        }

        if !appState.encyclopedia.weakTopicIds.isEmpty {
            Section("Topics to review") {
                NavigationLink(value: StudyNavigationRoute.encyclopediaPractice(.multipleChoice, topicIds: appState.encyclopedia.weakTopicIds)) {
                    HStack(spacing: 10) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .foregroundStyle(theme.accent)
                        Text("Practice weak topics")
                            .font(.system(size: ThemePalette.bodySize, weight: .semibold))
                            .foregroundStyle(theme.accent)
                    }
                    .padding(.vertical, 4)
                }

                ForEach(appState.encyclopedia.weakTopicIds.prefix(10), id: \.self) { topicId in
                    if let topic = appState.encyclopedia.topic(byId: topicId) {
                        NavigationLink(value: StudyNavigationRoute.encyclopediaTopic(id: topic.id)) {
                            HStack {
                                Text(topic.title)
                                    .font(.body)
                                Spacer()
                                Text("\(appState.encyclopedia.wrongCountPerTopicId[topicId] ?? 0) missed")
                                    .font(.caption)
                                    .foregroundStyle(theme.wrong)
                            }
                        }
                    }
                }
            }
        }
    }

    private var overallCard: some View {
        VStack(spacing: 12) {
            Text("\(appState.encyclopedia.reviewedTopicIds.count) of \(appState.encyclopedia.topics.count) topics reviewed")
                .font(.system(size: ThemePalette.titleSize, weight: .bold))
                .foregroundStyle(theme.primaryText)
                .multilineTextAlignment(.center)
            Text("\(appState.encyclopedia.sessionHistory.count) practice sessions")
                .font(.system(size: ThemePalette.bodySize))
                .foregroundStyle(theme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        .listRowBackground(
            RoundedRectangle(cornerRadius: ThemePalette.cornerRadius)
                .fill(theme.cardBackground)
                .padding(.vertical, 4)
        )
    }

    private var streakRow: some View {
        HStack {
            Image(systemName: "flame.fill")
                .font(.title2)
                .foregroundStyle(PlatformColor.systemOrange)
            Text("\(appState.encyclopedia.currentStreak) day streak")
                .font(.system(size: ThemePalette.bodySize))
                .foregroundStyle(theme.primaryText)
            Spacer()
        }
        .listRowBackground(
            RoundedRectangle(cornerRadius: AppLayout.cornerRadius)
                .fill(theme.cardBackground)
                .padding(.vertical, 2)
        )
    }

    private func sessionRow(_ session: EncyclopediaSessionRecord) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(session.subject)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(theme.primaryText)
                Text("\(session.modeDisplay) · \(session.date, style: .date)")
                    .font(.caption)
                    .foregroundStyle(theme.secondaryText)
            }
            Spacer()
            Text("\(session.score)/\(session.total)")
                .font(.system(size: ThemePalette.bodySize, weight: .semibold))
                .foregroundStyle(theme.primaryText)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(session.subject), \(session.modeDisplay), \(session.score) of \(session.total) correct, \(session.date.formatted(date: .abbreviated, time: .omitted))")
    }
}

enum AppLayout {
    static let padding: CGFloat = 16
    static let cardSpacing: CGFloat = 12
    static let cornerRadius: CGFloat = 12
    static let minTouchTarget: CGFloat = 44
}
