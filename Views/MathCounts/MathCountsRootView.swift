import SwiftUI

struct MathCountsRootView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var mathCounts = appState.mathCounts

        NavigationStack {
            List {
                welcomeSection(mathCounts: mathCounts)
                dailyPracticeSection(mathCounts: mathCounts)
                topicsSection
                mentalMathSkillsSection
                progressSection(mathCounts: mathCounts)
                coachSection
                nsbMathLinkSection
            }
            .platformListStyle()
            .navigationTitle("MathCounts")
            .largeNavigationBarTitle()
            .studyNavigationDestinations()
        }
    }

    private func welcomeSection(mathCounts: MathCountsStore) -> some View {
        Section {
            VStack(alignment: .leading, spacing: 10) {
                Text("Hi, \(MathCountsCoachPersona.studentName)!")
                    .font(.headline)
                Text(MathCountsCoachPersona.welcomeBlurb)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                HStack(spacing: 16) {
                    Label(mathCounts.currentLevel.title, systemImage: "chart.line.uptrend.xyaxis")
                    Label("\(mathCounts.currentStreak) day streak", systemImage: "flame.fill")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
        }
    }

    private func dailyPracticeSection(mathCounts: MathCountsStore) -> some View {
        Section("Today's training") {
            NavigationLink {
                MathCountsDailyPracticeLoader()
            } label: {
                VStack(alignment: .leading, spacing: 6) {
                    Label("Start daily practice", systemImage: "play.circle.fill")
                        .font(.body.weight(.semibold))
                    Text("5 warmup · 3 number sense · 3 challenge · 1 stretch")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Picker("Difficulty", selection: Binding(
                get: { mathCounts.currentLevel },
                set: { mathCounts.setLevel($0) }
            )) {
                ForEach(MathCountsDifficulty.allCases) { level in
                    Text(level.title).tag(level)
                }
            }
            .pickerStyle(.menu)

            if mathCounts.sessionsCompleted > 0 {
                Text("Recent accuracy: \(Int(mathCounts.recentAccuracy * 100))% — level adjusts when you score high or need more support.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var topicsSection: some View {
        Section("MathCounts topics") {
            ForEach(MathCountsTopicArea.allCases) { topic in
                NavigationLink {
                    MathCountsTopicDrillLoader(topic: topic)
                } label: {
                    HStack(spacing: 12) {
                        Text(topic.emoji)
                            .font(.title2)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(topic.rawValue)
                            Text(topic.practiceFocus)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }

    private var mentalMathSkillsSection: some View {
        Section("Mental math skills") {
            ForEach(mentalMathSkills, id: \.self) { skill in
                Label(skill, systemImage: "bolt.fill")
                    .font(.subheadline)
            }
        }
    }

    private func progressSection(mathCounts: MathCountsStore) -> some View {
        Section("Your progress") {
            LabeledContent("Sessions completed", value: "\(mathCounts.sessionsCompleted)")
            if !mathCounts.weakestTopics.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Focus areas")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(mathCounts.weakestTopics.joined(separator: " · "))
                        .font(.subheadline)
                }
            }
            if let last = mathCounts.sessionHistory.first {
                LabeledContent("Last session", value: "\(last.score)/\(last.total) · \(last.date.formatted(date: .abbreviated, time: .omitted))")
            }
        }
    }

    private var coachSection: some View {
        Section("How your coach works") {
            ForEach(coachPrinciples, id: \.title) { item in
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.subheadline.weight(.semibold))
                    Text(item.detail)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 2)
            }
        }
    }

    private var nsbMathLinkSection: some View {
        Section("Also in Science Bowl") {
            NavigationLink(value: StudyNavigationRoute.encyclopediaSubject(.math)) {
                Label("NSB math topics (Learn tab)", systemImage: "books.vertical.fill")
            }
            Text("Summer algebra blocks use BFN-A chapter-by-chapter — see Today or Weeks. Optional OpenStax/Larson for NSB drills.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var mentalMathSkills: [String] {
        [
            "Multiplication through 20×20",
            "Squares through 30² · cubes through 12³",
            "Fraction / decimal / percent conversions",
            "GCF, LCM, prime factorization",
            "Divisibility rules · percent shortcuts",
            "Compensation · breaking apart numbers · estimation"
        ]
    }

    private var coachPrinciples: [(title: String, detail: String)] {
        [
            ("Socratic coaching", "Guiding questions before answers — explain your thinking."),
            ("Hints first", "Wrong answer? You get a hint, then a simpler example, not the solution immediately."),
            ("Mental math shortcuts", "Compensation, factoring, and patterns beat brute force."),
            ("Adaptive levels", "Score 85%+ to level up; we'll ease back if a session is tough.")
        ]
    }
}
