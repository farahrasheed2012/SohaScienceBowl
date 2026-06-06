import SwiftUI

struct QuizRootView: View {
    @Environment(AppState.self) private var appState
    @State private var subjectFilter: Subject? = nil

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Subject", selection: $subjectFilter) {
                        Text("All").tag(Optional<Subject>.none)
                        ForEach(Subject.allCases) { s in
                            Text(s.rawValue).tag(Optional(s))
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("This week's plan") {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Week \(appState.currentWeek) · \(appState.weekTheme(for: appState.currentWeek))")
                            .font(.subheadline.weight(.semibold))
                        Text(ScheduleConstants.passLabel(for: appState.currentPass))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 2)

                    if let block = appState.todayBlocks().first {
                        NavigationLink {
                            PlanDrillView(request: .todayBlock(block, week: appState.currentWeek))
                        } label: {
                            Label("Quiz today's topics", systemImage: "sun.max.fill")
                        }
                    }

                    NavigationLink {
                        PlanDrillView(request: .thisWeek(week: appState.currentWeek))
                    } label: {
                        Label("Quiz this week", systemImage: "calendar")
                    }

                    NavigationLink(value: StudyNavigationRoute.topicBrowser(initialWeek: nil)) {
                        Label("Browse all topics", systemImage: "books.vertical.fill")
                    }
                }

                Section("Encyclopedia practice") {
                    Text("148 questions · MC (W/X/Y/Z) · Toss-up · Free response")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    NavigationLink(value: StudyNavigationRoute.encyclopediaPractice(.multipleChoice, topicIds: nil)) {
                        Label("Multiple Choice", systemImage: "list.bullet.rectangle")
                    }
                    NavigationLink(value: StudyNavigationRoute.encyclopediaPractice(.tossUpBonus, topicIds: nil)) {
                        Label("Toss-Up & Bonus", systemImage: "timer")
                    }
                    NavigationLink(value: StudyNavigationRoute.encyclopediaPractice(.freeResponse, topicIds: nil)) {
                        Label("Free Response", systemImage: "keyboard")
                    }
                    if !appState.encyclopedia.weakTopicIds.isEmpty {
                        NavigationLink(value: StudyNavigationRoute.encyclopediaPractice(.multipleChoice, topicIds: appState.encyclopedia.weakTopicIds)) {
                            Label("Practice weak encyclopedia topics", systemImage: "exclamationmark.circle")
                        }
                    }
                }

                Section("Toss-up Drill") {
                    Text("Rapid fire: tap to reveal, log ✓/✗")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    NavigationLink("Start Drill") {
                        DrillSetupView(mode: .tossup)
                    }
                }

                Section("Topic Quiz") {
                    Text("Multi-choice questions by topic")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    NavigationLink("Start Quiz") {
                        DrillSetupView(mode: .topicQuiz)
                    }
                }

                Section("Mock Round") {
                    Text("25 toss-ups — all DOE categories when downloaded")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    NavigationLink("Start Mock Round") {
                        MockRoundView(questionCount: 25, title: "Mock Round")
                    }
                }

                Section("DOE Official Questions") {
                    if appState.doeStore.isDownloading {
                        VStack(alignment: .leading, spacing: 8) {
                            ProgressView(value: appState.doeStore.downloadProgress)
                            Text("Downloading PDFs \(appState.doeStore.downloadedPDFCount)/\(appState.doeStore.totalPDFCount)…")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } else if appState.isDOELoading {
                        HStack {
                            ProgressView()
                            Text("Parsing DOE questions…")
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        let count = appState.doeStore.doeQuestions.count
                        if count > 0 {
                            Text("\(count) questions · all categories · all downloaded sets")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            ForEach(appState.doeStore.categoryCounts(), id: \.category) { item in
                                HStack {
                                    DOECategoryBadge(category: item.category)
                                    Spacer()
                                    Text("\(item.count)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        } else if let error = appState.doeStore.loadError {
                            Text(error)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    if appState.doeStore.doeQuestions.isEmpty && !appState.doeStore.isDownloading {
                        Button("Download all DOE PDFs") {
                            Task { await appState.downloadDOEQuestions(fullCatalog: true) }
                        }
                    }

                    NavigationLink("Browse by Category") {
                        DOECategoryListView()
                    }
                    .disabled(appState.doeStore.doeQuestions.isEmpty)

                    NavigationLink("Browse by Set") {
                        DOESetListView()
                    }
                    .disabled(appState.doeStore.doeQuestions.isEmpty)

                    NavigationLink("Random DOE Drill (all categories)") {
                        MockRoundView(questionCount: 25, title: "Random DOE Drill", doeOnly: true)
                    }
                    .disabled(appState.doeStore.doeQuestions.isEmpty)

                    NavigationLink("Full DOE Mock Round") {
                        DOEMockRoundView()
                    }
                    .disabled(appState.doeStore.doeQuestions.isEmpty)
                }

                Section("Search Questions") {
                    NavigationLink("Search") {
                        SearchQuestionsView(initialSubject: subjectFilter)
                    }
                }

                Section("Practice Weak Areas") {
                    if appState.weakTopics.isEmpty {
                        Text("Answer more drills to identify weak topics.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(appState.weakTopics.prefix(5)) { topic in
                            NavigationLink(topic.topic) {
                                WeakAreaDrillView(topic: topic)
                            }
                        }
                    }
                }

                Section("Browse Question Sources") {
                    ForEach(QuestionSource.allCases) { source in
                        NavigationLink(source.rawValue) {
                            BrowseSourceView(source: source)
                        }
                    }
                }

                Section {
                    NavigationLink("Formula reference") {
                        FormulaReferenceView()
                    }
                }
            }
            .navigationTitle("Quiz")
            .navigationBarTitleDisplayMode(.large)
            .studyNavigationDestinations()
            .onAppear {
                appState.refreshScheduleFromCalendar()
            }
        }
    }
}

enum DrillMode {
    case tossup
    case topicQuiz
}

struct DrillSetupView: View {
    @Environment(AppState.self) private var appState
    let mode: DrillMode

    @State private var subject: Subject = .biology
    @State private var week: Int = 0 // 0 = all

    var body: some View {
        Form {
            Section("Subject") {
                Picker("Subject", selection: $subject) {
                    ForEach(Subject.allCases) { s in
                        Text(s.rawValue).tag(s)
                    }
                }
            }

            Section("Week") {
                Picker("Week", selection: $week) {
                    Text("All weeks").tag(0)
                    ForEach(1...10, id: \.self) { w in
                        Text("Week \(w)").tag(w)
                    }
                }
            }

            Section {
                NavigationLink(mode == .tossup ? "Start Drill" : "Start Quiz") {
                    if mode == .tossup {
                        TossupDrillView(subject: subject, week: week == 0 ? nil : week)
                    } else {
                        TopicQuizView(subject: subject, week: week == 0 ? nil : week)
                    }
                }
            }
        }
        .navigationTitle(mode == .tossup ? "Toss-up Drill" : "Topic Quiz")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            week = appState.currentWeek
        }
    }
}
