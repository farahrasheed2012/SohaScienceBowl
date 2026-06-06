import SwiftUI

struct EncyclopediaRootView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.themePalette) private var theme

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerCard

                    ForEach(NSBSubject.allCases) { subject in
                        NavigationLink(value: StudyNavigationRoute.encyclopediaSubject(subject)) {
                            encyclopediaSubjectRow(subject)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(20)
            }
            .background(theme.surface)
            .navigationTitle("Learn")
            .navigationBarTitleDisplayMode(.large)
            .studyNavigationDestinations()
        }
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hi, Soha!")
                .font(.system(size: ThemePalette.titleSize, weight: .bold))
                .foregroundStyle(theme.primaryText)

            Text("Pick a subject to study.")
                .font(.system(size: ThemePalette.bodySize))
                .foregroundStyle(theme.secondaryText)

            Text("113 NSB topics across 6 categories — full articles with key terms, traps, and related topics.")
                .font(.system(size: ThemePalette.captionSize))
                .foregroundStyle(theme.secondaryText)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 20) {
                Label("\(appState.encyclopedia.reviewedTopicIds.count) reviewed", systemImage: "checkmark.circle")
                Label("\(appState.encyclopedia.currentStreak) day streak", systemImage: "flame.fill")
            }
            .font(.system(size: ThemePalette.captionSize, weight: .medium))
            .foregroundStyle(theme.secondaryText)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: ThemePalette.cornerRadius))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }

    private func encyclopediaSubjectRow(_ subject: NSBSubject) -> some View {
        let topics = appState.encyclopedia.topics(for: subject)
        let reviewed = topics.filter { appState.encyclopedia.reviewedTopicIds.contains($0.id) }.count
        return HStack(spacing: 16) {
            Text(subject.emoji)
                .font(.system(size: 32))
            VStack(alignment: .leading, spacing: 6) {
                Text(subject.rawValue)
                    .font(.system(size: ThemePalette.bodySize, weight: .semibold))
                    .foregroundStyle(theme.primaryText)
                Text("\(topics.count) topics")
                    .font(.system(size: ThemePalette.captionSize))
                    .foregroundStyle(theme.secondaryText)
            }
            Spacer(minLength: 8)
            if !topics.isEmpty {
                HStack(spacing: 6) {
                    if reviewed == topics.count {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(theme.success)
                            .font(.system(size: ThemePalette.captionSize))
                            .accessibilityLabel("All topics reviewed")
                    }
                    Text("\(reviewed)/\(topics.count)")
                        .font(.system(size: ThemePalette.captionSize, weight: .semibold))
                        .foregroundStyle(reviewed == topics.count ? theme.success : theme.secondaryText)
                }
            }
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(theme.secondaryText.opacity(0.7))
        }
        .frame(minHeight: AppLayout.minTouchTarget)
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: ThemePalette.cornerRadius))
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}

struct EncyclopediaTopicListView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.themePalette) private var theme
    let subject: NSBSubject
    @State private var searchText = ""

    private var subjectTopics: [NSBTopic] {
        appState.encyclopedia.topics(for: subject)
    }

    private var filteredTopics: [NSBTopic] {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmed.isEmpty else { return subjectTopics }
        return subjectTopics.filter {
            $0.title.lowercased().contains(trimmed)
            || $0.whatIsIt.lowercased().contains(trimmed)
            || $0.keyTerms.contains { $0.term.lowercased().contains(trimmed) }
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                if filteredTopics.isEmpty {
                    Text("No topics match your search.")
                        .font(.system(size: ThemePalette.bodySize))
                        .foregroundStyle(theme.secondaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                } else {
                    ForEach(filteredTopics) { topic in
                        NavigationLink(value: StudyNavigationRoute.encyclopediaTopic(id: topic.id)) {
                            topicRow(topic)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(20)
        }
        .background(theme.surface)
        .navigationTitle(subject.rawValue)
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, prompt: "Search topics")
        .studyNavigationDestinations()
    }

    private func topicRow(_ topic: NSBTopic) -> some View {
        HStack(spacing: 14) {
            if appState.encyclopedia.reviewedTopicIds.contains(topic.id) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(theme.success)
                    .font(.system(size: ThemePalette.bodySize))
            } else {
                Image(systemName: "circle")
                    .foregroundStyle(theme.secondaryText.opacity(0.35))
                    .font(.system(size: ThemePalette.bodySize))
            }
            Text(topic.title)
                .font(.system(size: ThemePalette.bodySize))
                .foregroundStyle(theme.primaryText)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 8)
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(theme.secondaryText.opacity(0.7))
        }
        .frame(minHeight: AppLayout.minTouchTarget)
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppLayout.cornerRadius))
    }
}
