import SwiftUI

struct EncyclopediaPracticeCoverageBadge: View {
    let coverage: EncyclopediaPracticeCoverage
    var compact: Bool = false

    var body: some View {
        if let title = coverage.badgeTitle {
            Label(title, systemImage: coverage.systemImage)
                .font(.caption2.weight(.medium))
                .foregroundStyle(coverage == .none ? PlatformColor.systemOrange : PlatformColor.systemYellow)
                .padding(.horizontal, compact ? 6 : 8)
                .padding(.vertical, compact ? 2 : 4)
                .background(
                    (coverage == .none ? PlatformColor.systemOrange : PlatformColor.systemYellow)
                        .opacity(0.15)
                )
                .clipShape(Capsule())
                .accessibilityLabel(title)
        }
    }
}

struct EncyclopediaRootView: View {
    @Environment(AppState.self) private var appState

    private var encyclopedia: EncyclopediaStore { appState.encyclopedia }

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
                        Text("\(encyclopedia.topics.count) NSB topics · 6 categories")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        HStack(spacing: 16) {
                            Label("\(encyclopedia.reviewedTopicIds.count) reviewed", systemImage: "checkmark.circle")
                            Label("\(encyclopedia.currentStreak) day streak", systemImage: "flame.fill")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        practiceCoverageSummary
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

    @ViewBuilder
    private var practiceCoverageSummary: some View {
        let ready = encyclopedia.topicsWithAdequatePractice
        let thin = encyclopedia.topicsWithThinPractice
        let none = encyclopedia.topicsMissingPractice
        let total = encyclopedia.topics.count

        VStack(alignment: .leading, spacing: 4) {
            Label("\(ready)/\(total) topics with practice drills", systemImage: "bolt.fill")
            if none > 0 || thin > 0 {
                Text("\(none) no practice · \(thin) need more questions")
                    .foregroundStyle(.secondary)
            }
        }
        .font(.caption)
    }

    private func subjectRow(_ subject: NSBSubject) -> some View {
        let topics = encyclopedia.topics(for: subject)
        let reviewed = topics.filter { encyclopedia.reviewedTopicIds.contains($0.id) }.count
        let coverage = encyclopedia.practiceCoverageSummary(for: subject)
        return HStack(spacing: 12) {
            Text(subject.emoji)
                .font(.title2)
            VStack(alignment: .leading, spacing: 2) {
                Text(subject.rawValue)
                    .font(.body)
                Text("\(topics.count) topics · \(coverage.ready) with drills")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 8)
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 4) {
                    if reviewed == topics.count, !topics.isEmpty {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(PlatformColor.systemGreen)
                            .font(.caption)
                            .accessibilityLabel("All topics reviewed")
                    }
                    Text("\(reviewed)/\(topics.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                if coverage.none > 0 {
                    Text("\(coverage.none) no practice")
                        .font(.caption2)
                        .foregroundStyle(PlatformColor.systemOrange)
                } else if coverage.thin > 0 {
                    Text("\(coverage.thin) need more")
                        .font(.caption2)
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
    @State private var showCoverageGapsOnly = false

    private var encyclopedia: EncyclopediaStore { appState.encyclopedia }

    private var subjectTopics: [NSBTopic] {
        encyclopedia.topics(for: subject)
    }

    private var filteredTopics: [NSBTopic] {
        var list = subjectTopics
        if showCoverageGapsOnly {
            list = list.filter { encyclopedia.practiceCoverage(for: $0.id) != .ready }
        }
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmed.isEmpty else { return list }
        return list.filter {
            $0.title.lowercased().contains(trimmed)
            || $0.whatIsIt.lowercased().contains(trimmed)
            || $0.keyTerms.contains { $0.term.lowercased().contains(trimmed) }
        }
    }

    private var gapCount: Int {
        subjectTopics.filter { encyclopedia.practiceCoverage(for: $0.id) != .ready }.count
    }

    var body: some View {
        List {
            if gapCount > 0 {
                Section {
                    Toggle("Show practice gaps only", isOn: $showCoverageGapsOnly)
                } footer: {
                    Text("\(gapCount) topic(s) in this subject have fewer than \(EncyclopediaPracticeCoverage.minimumQuestions) built-in practice questions. Read the article, then use Regional Sprint or DOE drills where linked.")
                }
            }

            if filteredTopics.isEmpty {
                Text(showCoverageGapsOnly ? "All topics in this subject have adequate practice." : "No topics match your search.")
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
        let coverage = encyclopedia.practiceCoverage(for: topic.id)
        return HStack(spacing: 12) {
            if encyclopedia.reviewedTopicIds.contains(topic.id) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(PlatformColor.systemGreen)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(topic.title)
                    .font(.body)
                if coverage != .ready {
                    EncyclopediaPracticeCoverageBadge(coverage: coverage, compact: true)
                } else if encyclopedia.questionCount(for: topic.id) > 0 {
                    Text("\(encyclopedia.questionCount(for: topic.id)) practice questions")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, 2)
    }
}
