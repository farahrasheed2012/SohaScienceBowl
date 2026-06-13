import SwiftUI

struct RegionalSprintRootView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Texas regional fast-recall drills — deeper than the summer MS schedule.")
                        .font(.subheadline)
                    Text("\(RegionalSprintCatalog.packs.count) sprint packs · \(appState.encyclopedia.topics.filter { RegionalSprintCatalog.allTopicIds.contains($0.id) }.count) encyclopedia articles · know-cold + toss-ups")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }

            Section {
                NavigationLink(value: StudyNavigationRoute.regionalSprintMixed(nil)) {
                    Label("Mixed regional drill (all packs)", systemImage: "bolt.horizontal.fill")
                }
            }

            ForEach(RegionalSprintCatalog.Track.allCases) { track in
                Section("\(track.emoji) \(track.rawValue)") {
                    ForEach(RegionalSprintCatalog.packs(for: track)) { pack in
                        NavigationLink(value: StudyNavigationRoute.regionalSprintPack(pack.id)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(pack.title)
                                    .font(.body.weight(.semibold))
                                Text(pack.subtitle)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text("\(pack.knowColdCount) know-cold · \(pack.tossupCount) toss-ups")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 2)
                        }
                    }

                    NavigationLink(value: StudyNavigationRoute.regionalSprintMixed(track)) {
                        Label("Drill all \(track.rawValue) sprints", systemImage: "bolt.fill")
                    }
                }
            }
        }
        .navigationTitle("Regional Sprint")
        .inlineNavigationBarTitle()
    }
}

struct RegionalSprintPackDetailView: View {
    @Environment(AppState.self) private var appState
    let packId: String

    private var pack: RegionalSprintCatalog.Pack? {
        RegionalSprintCatalog.pack(id: packId)
    }

    var body: some View {
        if let pack {
            List {
                Section {
                    Text(pack.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Section("Know cold") {
                    ForEach(Array(pack.knowCold.enumerated()), id: \.offset) { _, line in
                        VStack(alignment: .leading, spacing: 6) {
                            QuestionSpeechBar(questionText: line)
                            Text(line)
                                .font(.body)
                        }
                        .padding(.vertical, 2)
                    }
                }

                Section("Sample toss-ups") {
                    ForEach(Array(pack.tossups.enumerated()), id: \.offset) { _, item in
                        VStack(alignment: .leading, spacing: 4) {
                            QuestionSpeechBar(
                                questionText: item.question,
                                answerText: item.answer,
                                showAnswerButton: true
                            )
                            Text(item.question)
                                .font(.headline)
                            Text(item.answer)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 2)
                    }
                }

                Section {
                    NavigationLink(value: StudyNavigationRoute.encyclopediaTopic(id: pack.topicId)) {
                        Label("Read full article", systemImage: "book.fill")
                    }
                    NavigationLink(value: StudyNavigationRoute.encyclopediaPractice(.tossUpBonus, topicIds: [pack.topicId])) {
                        Label("Encyclopedia practice", systemImage: "list.bullet.rectangle")
                    }
                    NavigationLink(value: StudyNavigationRoute.planDrill(.regionalSprint(packId: packId))) {
                        Label("Start sprint drill", systemImage: "bolt.fill")
                            .font(.headline)
                    }
                }
            }
            .navigationTitle(pack.title)
            .inlineNavigationBarTitle()
        } else {
            ContentUnavailableView("Pack not found", systemImage: "questionmark.circle")
        }
    }
}
