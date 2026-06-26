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
                headerSection
                subjectsSection
            }
            .navigationTitle("Learn")
            .largeNavigationBarTitle()
            .studyNavigationDestinations()
        }
    }

    private var subjectsSection: some View {
        Section("Subjects") {
            ForEach(NSBSubject.allCases) { subject in
                NavigationLink(value: StudyNavigationRoute.encyclopediaSubject(subject)) {
                    subjectRow(subject)
                }
            }
        }
    }

    private var headerSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text("Hi, Soha!")
                    .font(.headline)
                Text("Science Bowl articles and practice drills. Math POT 6 has its own tab.")
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
                if subject == .math {
                    Text("\(topics.count) NSB articles · \(POT6TopicRegistry.schoolTopics.count) POT 6 topics")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Text("\(topics.count) topics · \(coverage.ready) with drills")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
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
            if subject == .math {
                mathCatchUpSection
                pot6Section
            }

            if gapCount > 0 && subject != .math {
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

    @ViewBuilder
    private var mathCatchUpSection: some View {
        let janJune = appState.pot6CatchUpJanJuneProgress

        Section {
            NavigationLink(value: StudyNavigationRoute.pot6CatchUp) {
                HStack {
                    Label("13-Day Catch-Up Plan", systemImage: "calendar.badge.clock")
                    Spacer()
                    Text("\(janJune.done)/\(janJune.total)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(janJune.done == janJune.total ? PlatformColor.systemGreen : PlatformColor.systemPurple)
                }
            }
            NavigationLink(value: StudyNavigationRoute.pot6DailyDrill) {
                Label("Daily Math Block", systemImage: "play.circle.fill")
            }
            NavigationLink(value: StudyNavigationRoute.pot6Books(.bfn)) {
                Label("Books & Materials", systemImage: "book.closed.fill")
            }
            NavigationLink(value: StudyNavigationRoute.pot6GeometryCatchUp) {
                Label("8-Day Geometry Plan", systemImage: "triangle.fill")
            }
        } header: {
            Text("POT 6 Study Plan")
        } footer: {
            Text("Algebra catch-up is in the POT 6 tab; geometry is in **POT 6 Geo**.")
        }
    }

    @ViewBuilder
    private var pot6Section: some View {
        let mathProgress = MathProgressService.shared
        let geometryCodes = Set(POT6GeometryCatalog.schoolCodes)
        let pot6Topics = mathProgress.mergedTopics().filter {
            !$0.isCompetitionOnly && !geometryCodes.contains($0.code)
        }

        Section {
            ForEach(pot6Topics) { topic in
                NavigationLink(value: StudyNavigationRoute.pot6Topic(code: topic.code)) {
                    HStack(spacing: 12) {
                        Image(systemName: topic.masteryLevel.systemImage)
                            .foregroundStyle(MathAccent.color)
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 4) {
                                Text(topic.title)
                                    .font(.body)
                                if topic.isCompetitionOnly {
                                    Text("🏆")
                                }
                            }
                            Text("\(topic.code) · \(topic.pot6Category.rawValue)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        Spacer(minLength: 0)
                        if mathProgress.attemptCount(for: topic.code) > 0 {
                            Text("\(Int(topic.accuracyRate * 100))%")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 2)
                }
            }
        } header: {
            Text("POT 6 · Topics & Drills")
        } footer: {
            Text("\(pot6Topics.count) algebra & stats topics — geometry is in the **POT 6 Geo** tab.")
        }
    }
}
