import SwiftUI

struct EncyclopediaRootView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hi, Soha!")
                            .font(.headline)
                        Text("Pick a subject to study.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("113 NSB topics · 6 categories")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        HStack(spacing: 16) {
                            Label("\(appState.encyclopedia.reviewedTopicIds.count) reviewed", systemImage: "checkmark.circle")
                            Label("\(appState.encyclopedia.currentStreak) day streak", systemImage: "flame.fill")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }

                Section("Subjects") {
                    ForEach(NSBSubject.allCases) { subject in
                        NavigationLink(value: StudyNavigationRoute.encyclopediaSubject(subject)) {
                            subjectRow(subject)
                        }
                    }
                }
            }
            .navigationTitle("Learn")
            .largeNavigationBarTitle()
            .studyNavigationDestinations()
        }
    }

    private func subjectRow(_ subject: NSBSubject) -> some View {
        let topics = appState.encyclopedia.topics(for: subject)
        let reviewed = topics.filter { appState.encyclopedia.reviewedTopicIds.contains($0.id) }.count
        return HStack(spacing: 12) {
            Text(subject.emoji)
                .font(.title2)
            VStack(alignment: .leading, spacing: 2) {
                Text(subject.rawValue)
                    .font(.body)
                Text("\(topics.count) topics")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 8)
            if !topics.isEmpty {
                HStack(spacing: 4) {
                    if reviewed == topics.count {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(PlatformColor.systemGreen)
                            .font(.caption)
                            .accessibilityLabel("All topics reviewed")
                    }
                    Text("\(reviewed)/\(topics.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 2)
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
            if filteredTopics.isEmpty {
                Text("No topics match your search.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(filteredTopics) { topic in
                    NavigationLink(value: StudyNavigationRoute.encyclopediaTopic(id: topic.id)) {
                        topicRow(topic)
                    }
                }
            }
        }
        .navigationTitle(subject.rawValue)
        .largeNavigationBarTitle()
        .searchable(text: $searchText, prompt: "Search topics")
        .studyNavigationDestinations()
    }

    private func topicRow(_ topic: NSBTopic) -> some View {
        HStack(spacing: 12) {
            if appState.encyclopedia.reviewedTopicIds.contains(topic.id) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(PlatformColor.systemGreen)
            }
            Text(topic.title)
                .font(.body)
        }
        .padding(.vertical, 2)
    }
}
