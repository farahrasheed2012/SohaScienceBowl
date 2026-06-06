import SwiftUI

struct EncyclopediaRootView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.themePalette) private var theme

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    StudyMaterialCard(title: "Hi, Soha!", systemImage: "sparkles", accent: theme.accent) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("113 NSB topics · 6 categories")
                                .font(.subheadline.weight(.semibold))
                            Text("Full articles with What Is It, How It Works, key terms, NSB traps, and related topics — from your original Science Bowl app.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                            HStack {
                                Label("\(appState.encyclopedia.reviewedTopicIds.count) reviewed", systemImage: "checkmark.circle")
                                Spacer()
                                Label("\(appState.encyclopedia.currentStreak) day streak", systemImage: "flame.fill")
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                    }

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

    private func encyclopediaSubjectRow(_ subject: NSBSubject) -> some View {
        let topics = appState.encyclopedia.topics(for: subject)
        let reviewed = topics.filter { appState.encyclopedia.reviewedTopicIds.contains($0.id) }.count
        return HStack(spacing: 14) {
            Text(subject.emoji)
                .font(.title2)
            VStack(alignment: .leading, spacing: 4) {
                Text(subject.rawValue)
                    .font(.headline)
                    .foregroundStyle(theme.primaryText)
                Text("\(topics.count) topics")
                    .font(.caption)
                    .foregroundStyle(theme.secondaryText)
            }
            Spacer()
            if !topics.isEmpty {
                HStack(spacing: 4) {
                    if reviewed == topics.count {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(theme.success)
                            .font(.body)
                            .accessibilityLabel("All topics reviewed")
                    }
                    Text("\(reviewed)/\(topics.count)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(reviewed == topics.count ? theme.success : theme.secondaryText)
                }
            }
            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(16)
        .background(theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct EncyclopediaTopicListView: View {
    @Environment(AppState.self) private var appState
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
        List {
            ForEach(filteredTopics) { topic in
                NavigationLink(value: StudyNavigationRoute.encyclopediaTopic(id: topic.id)) {
                    HStack(spacing: 12) {
                        if appState.encyclopedia.reviewedTopicIds.contains(topic.id) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color(uiColor: .systemGreen))
                        }
                        Text(topic.title)
                            .font(.body)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle(subject.rawValue)
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, prompt: "Search topics")
        .studyNavigationDestinations()
    }
}
