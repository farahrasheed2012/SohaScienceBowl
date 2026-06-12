import SwiftUI

struct QuizRootView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        NavigationStack {
            List {
                if !appState.doeStore.hasFullDOEBank {
                    Section {
                        DOEQuizBankBanner()
                    } header: {
                        Text("DOE official questions")
                    }
                }

                Section("Texas Regional Sprint") {
                    NavigationLink(value: StudyNavigationRoute.regionalSprint) {
                        Label("Regional Sprint packs", systemImage: "flag.fill")
                    }
                    Text("11 fast-recall packs — phyla, IUPAC, gas laws, pedigrees, centripetal, and more")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    NavigationLink(value: StudyNavigationRoute.regionalSprintMixed(nil)) {
                        Label("Mixed regional drill", systemImage: "bolt.horizontal.fill")
                    }
                }

                Section("Buzzer") {
                    NavigationLink(value: StudyNavigationRoute.buzzerRemote) {
                        Label("iPhone buzzer remote", systemImage: "iphone.gen3.radiowaves.left.and.right")
                    }
                    Text("Use during a buzzer drill on Mac — same Wi‑Fi network")
                        .font(.caption)
                        .foregroundStyle(.secondary)
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

                    ForEach(appState.todayBlocks()) { block in
                        NavigationLink {
                            PlanDrillView(request: .todayBlock(block, week: appState.currentWeek))
                        } label: {
                            Label("Quiz today · \(block.subject.rawValue)", systemImage: quizIcon(for: block.subject))
                        }
                    }

                    NavigationLink {
                        PlanDrillView(request: .thisWeek(week: appState.currentWeek))
                    } label: {
                        Label("Quiz all subjects", systemImage: "square.grid.3x3.fill")
                    }
                    Text("Mixed Bio + Chem + Phys from this week's plan")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ForEach(Subject.allCases) { subject in
                        NavigationLink {
                            PlanDrillView(request: .thisWeek(week: appState.currentWeek, subject: subject))
                        } label: {
                            Label("\(subject.rawValue) only", systemImage: quizIcon(for: subject))
                        }
                    }

                    NavigationLink(value: StudyNavigationRoute.topicBrowser(initialWeek: nil)) {
                        Label("Browse all topics", systemImage: "books.vertical.fill")
                    }
                }

                Section("Periodic table (H–Ca)") {
                    Text("\(appState.elementMasteredCount) / \(ElementData.first20.count) elements mastered")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    NavigationLink(value: StudyNavigationRoute.elementFlashCards) {
                        Label("Element flash cards", systemImage: "rectangle.on.rectangle")
                    }
                    NavigationLink(value: StudyNavigationRoute.periodicTableDrill) {
                        Label("Element drill", systemImage: "atom")
                    }
                    NavigationLink(value: StudyNavigationRoute.periodicTableReference) {
                        Label("Periodic table reference", systemImage: "tablecells")
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
                            if appState.doeStore.hasFullDOEBank {
                                Text("\(count) questions · all \(DOEQuestionStore.catalogPDFCount) PDF sets")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            } else {
                                Text("\(count) questions · \(appState.doeStore.localPDFCount)/\(DOEQuestionStore.catalogPDFCount) PDFs")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
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

                    if !appState.doeStore.hasFullDOEBank && !appState.doeStore.isDownloading && !appState.isDOELoading {
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
                        SearchQuestionsView(initialSubject: nil)
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
            .platformListStyle()
            .navigationTitle("Quiz")
            .largeNavigationBarTitle()
            .studyNavigationDestinations()
            .onAppear {
                appState.refreshScheduleFromCalendar()
                Task { await appState.loadDOEQuestions() }
            }
        }
    }

    private func quizIcon(for subject: Subject) -> String {
        switch subject {
        case .biology: return "leaf.fill"
        case .chemistry: return "flask.fill"
        case .physics: return "bolt.fill"
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
        .inlineNavigationBarTitle()
        .onAppear {
            week = appState.currentWeek
        }
    }
}
