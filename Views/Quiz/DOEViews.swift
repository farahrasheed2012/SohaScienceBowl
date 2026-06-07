import SwiftUI

struct MockRoundView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    let questionCount: Int
    let title: String
    var doeOnly: Bool = false
    var categoryFilter: DOECategory? = nil

    @State private var questions: [UnifiedQuestion] = []
    @State private var index = 0
    @State private var revealed = false
    @State private var score = 0
    @State private var finished = false

    var body: some View {
        Group {
            if finished {
                VStack(spacing: 16) {
                    Text("Round Complete")
                        .font(.title2.weight(.semibold))
                    Text("Score: \(score) / \(questions.count)")
                    Button("Done") { dismiss() }
                        .buttonStyle(.borderedProminent)
                }
            } else if questions.isEmpty {
                ContentUnavailableView("No Questions", systemImage: "tray")
            } else {
                VStack(spacing: 20) {
                    ProgressView(value: Double(index), total: Double(questions.count))
                        .padding(.horizontal, 16)
                    Text("\(index + 1) / \(questions.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    if questions[index].subject != nil {
                        SubjectBadge(subject: questions[index].subject!)
                    } else {
                        DOECategoryBadge(category: questions[index].category)
                    }
                    Spacer()
                    Text(questions[index].questionText)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                    Spacer()
                    if revealed {
                        Text(questions[index].answer)
                            .foregroundStyle(.secondary)
                        HStack {
                            Button("Correct") { log(correct: true) }
                                .buttonStyle(.bordered)
                                .background(Color.green.opacity(0.15))
                            Button("Incorrect") { log(correct: false) }
                                .buttonStyle(.bordered)
                                .background(Color.red.opacity(0.15))
                        }
                        .padding(.horizontal, 16)
                    } else {
                        Button("Buzz") { revealed = true }
                            .buttonStyle(.borderedProminent)
                            .padding(.horizontal, 16)
                    }
                }
                .padding(.vertical, 16)
            }
        }
        .navigationTitle(title)
        .inlineNavigationBarTitle()
        .onAppear { load() }
    }

    private func load() {
        if doeOnly {
            var pool = appState.doeStore.allQuestions().map { $0.toUnified() }
            if let categoryFilter {
                pool = pool.filter { $0.category == categoryFilter }
            }
            questions = Array(pool.shuffled().prefix(questionCount))
        } else {
            questions = Array(appState.allUnifiedQuestions.shuffled().prefix(questionCount))
        }
        if questions.count < questionCount {
            let seed = SeedData.tossupQuestions.map { $0.toUnified() }.shuffled()
            questions.append(contentsOf: seed.prefix(questionCount - questions.count))
        }
    }

    private func log(correct: Bool) {
        if correct { score += 1 }
        else { appState.addMissToFlashCards(question: questions[index]) }
        if let sub = questions[index].subject {
            appState.recordAttempt(topic: questions[index].topic, subject: sub, correct: correct)
        } else {
            appState.recordAttempt(topic: questions[index].category.rawValue, subject: .biology, correct: correct)
        }
        if index + 1 >= questions.count {
            appState.recordDrill(subject: nil, week: nil, total: questions.count, correct: score, mode: title)
            finished = true
        } else {
            index += 1
            revealed = false
        }
    }
}

struct DOEMockRoundView: View {
    @Environment(AppState.self) private var appState
    @State private var pairs: [(tossUp: UnifiedQuestion, bonus: UnifiedQuestion?)] = []
    @State private var pairIndex = 0
    @State private var showBonus = false
    @State private var revealed = false
    @State private var score = 0
    @State private var finished = false

    var body: some View {
        Group {
            if finished {
                Text("DOE Mock Score: \(score)")
                    .font(.title2)
            } else if pairs.isEmpty {
                ContentUnavailableView("No DOE Questions", systemImage: "doc.text", description: Text(appState.doeStore.loadError ?? "Download PDFs first"))
            } else {
                VStack(spacing: 16) {
                    Text(showBonus ? "Bonus \(pairIndex + 1)" : "Toss-Up \(pairIndex + 1)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(currentQuestion.questionText)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                    if revealed {
                        Text(currentQuestion.answer)
                            .foregroundStyle(.secondary)
                        Button("Correct (+ points)") {
                            score += showBonus ? 10 : 4
                            advance()
                        }
                        .buttonStyle(.borderedProminent)
                    } else {
                        Button("Reveal") { revealed = true }
                            .buttonStyle(.borderedProminent)
                    }
                }
                .padding(16)
            }
        }
        .navigationTitle("DOE Mock Round")
        .inlineNavigationBarTitle()
        .onAppear { buildPairs() }
    }

    private var currentQuestion: UnifiedQuestion {
        let pair = pairs[pairIndex]
        return showBonus ? (pair.bonus ?? pair.tossUp) : pair.tossUp
    }

    private func buildPairs() {
        let tossUps = appState.doeStore.allQuestions().filter { $0.questionType == .tossUp }.map { $0.toUnified() }
        let bonuses = appState.doeStore.allQuestions().filter { $0.questionType == .bonus }.map { $0.toUnified() }
        pairs = tossUps.prefix(10).enumerated().map { idx, tu in
            (tu, bonuses.indices.contains(idx) ? bonuses[idx] : nil)
        }
    }

    private func advance() {
        revealed = false
        if !showBonus, pairs[pairIndex].bonus != nil {
            showBonus = true
        } else {
            showBonus = false
            if pairIndex + 1 >= pairs.count { finished = true }
            else { pairIndex += 1 }
        }
    }
}

struct DOECategoryListView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        List {
            Section("Browse questions") {
                ForEach(appState.doeStore.categoryCounts(), id: \.category) { item in
                    NavigationLink {
                        DOECategoryQuestionListView(category: item.category)
                    } label: {
                        HStack {
                            DOECategoryBadge(category: item.category)
                            Spacer()
                            Text("\(item.count)")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            Section("Drill by category") {
                ForEach(appState.doeStore.categoryCounts(), id: \.category) { item in
                    NavigationLink("Drill \(item.category.rawValue)") {
                        DOECategoryDrillView(category: item.category)
                    }
                }
            }
        }
        .navigationTitle("Browse by Category")
        .inlineNavigationBarTitle()
    }
}

struct DOECategoryQuestionListView: View {
    @Environment(AppState.self) private var appState
    let category: DOECategory

    private var questions: [DOEQuestion] {
        appState.doeStore.questions(for: category)
    }

    var body: some View {
        List(questions) { q in
            NavigationLink {
                QuestionDetailView(question: q.toUnified())
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(q.questionType.rawValue) \(q.questionNumber) · Set \(q.setNumber) Round \(q.roundNumber)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(q.questionText)
                        .lineLimit(2)
                }
            }
        }
        .navigationTitle(category.rawValue)
        .inlineNavigationBarTitle()
    }
}

struct DOECategoryDrillView: View {
    @Environment(AppState.self) private var appState
    let category: DOECategory

    var body: some View {
        MockRoundView(
            questionCount: 20,
            title: "\(category.rawValue) Drill",
            doeOnly: true,
            categoryFilter: category
        )
    }
}

struct DOESetListView: View {
    @Environment(AppState.self) private var appState

    private var setNumbers: [Int] {
        Array(Set(appState.doeStore.doeQuestions.map(\.setNumber))).sorted()
    }

    var body: some View {
        Group {
            if setNumbers.isEmpty {
                ContentUnavailableView(
                    "No DOE questions yet",
                    systemImage: "doc.text",
                    description: Text(appState.doeStore.loadError ?? "Download PDFs from the Quiz tab.")
                )
            } else {
                List {
                    ForEach(setNumbers, id: \.self) { set in
                        NavigationLink("Set \(set == 0 ? "Sample Rounds" : String(set))") {
                            DOERoundListView(setNumber: set)
                        }
                    }
                }
            }
        }
        .navigationTitle("Browse by Set")
        .inlineNavigationBarTitle()
    }
}

struct DOERoundListView: View {
    @Environment(AppState.self) private var appState
    let setNumber: Int

    private var rounds: [Int] {
        Array(Set(appState.doeStore.doeQuestions.filter { $0.setNumber == setNumber }.map(\.roundNumber))).sorted()
    }

    var body: some View {
        List(rounds, id: \.self) { round in
            NavigationLink("Round \(round)") {
                DOERoundDetailView(setNumber: setNumber, roundNumber: round)
            }
        }
        .navigationTitle("Set \(setNumber)")
        .inlineNavigationBarTitle()
    }
}

struct DOERoundDetailView: View {
    @Environment(AppState.self) private var appState
    let setNumber: Int
    let roundNumber: Int

    private var questions: [DOEQuestion] {
        appState.doeStore.doeQuestions
            .filter { $0.setNumber == setNumber && $0.roundNumber == roundNumber }
            .sorted { $0.questionNumber < $1.questionNumber }
    }

    var body: some View {
        List(questions) { q in
            NavigationLink {
                QuestionDetailView(question: q.toUnified())
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(q.questionType.rawValue) \(q.questionNumber) · \(q.category.rawValue)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(q.questionText)
                        .lineLimit(2)
                }
            }
        }
        .navigationTitle("Round \(roundNumber)")
        .inlineNavigationBarTitle()
    }
}

struct BrowseSourceView: View {
    @Environment(AppState.self) private var appState
    let source: QuestionSource

    private var questions: [UnifiedQuestion] {
        switch source {
        case .customCurriculum: return appState.curriculumQuestions
        case .doeOfficial: return appState.doeStore.doeQuestions.map { $0.toUnified() }
        default: return appState.importedQuestions.filter { $0.source == source }
        }
    }

    var body: some View {
        List(questions.prefix(200)) { q in
            NavigationLink {
                QuestionDetailView(question: q)
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(q.sourceDescription)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(q.questionText)
                        .lineLimit(2)
                }
            }
        }
        .navigationTitle(source.rawValue)
        .inlineNavigationBarTitle()
    }
}

struct QuestionDetailView: View {
    @Environment(AppState.self) private var appState
    let question: UnifiedQuestion
    @State private var revealed = false

    var body: some View {
        List {
            Section {
                Text(question.questionText)
                    .font(.headline)
            }
            if !question.choices.isEmpty {
                Section("Choices") {
                    ForEach(question.choices, id: \.self) { Text($0) }
                }
            }
            Section {
                if revealed {
                    Text(question.answer)
                } else {
                    Button("Reveal Answer") { revealed = true }
                }
            }
            Section {
                NavigationLink("Drill this question") {
                    SingleQuestionDrillView(question: question)
                }
            }
        }
        .navigationTitle(question.category.rawValue)
        .inlineNavigationBarTitle()
    }
}

struct SingleQuestionDrillView: View {
    @Environment(AppState.self) private var appState
    let question: UnifiedQuestion
    @State private var revealed = false

    var body: some View {
        VStack(spacing: 24) {
            Text(question.questionText)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            if revealed {
                Text(question.answer)
                    .foregroundStyle(.secondary)
                HStack {
                    Button("Correct") {
                        if let s = question.subject {
                            appState.recordAttempt(topic: question.topic, subject: s, correct: true)
                        }
                    }
                    Button("Incorrect") {
                        appState.addMissToFlashCards(question: question)
                    }
                }
            } else {
                Button("Buzz") { revealed = true }
                    .buttonStyle(.borderedProminent)
            }
            Spacer()
        }
        .padding(.top, 32)
        .navigationTitle("Drill")
        .inlineNavigationBarTitle()
    }
}

struct SearchQuestionsView: View {
    @Environment(AppState.self) private var appState
    var initialSubject: Subject?

    @State private var query = ""
    @State private var subject: Subject?
    @State private var source: QuestionSource?

    var results: [UnifiedQuestion] {
        appState.searchQuestions(query: query, subject: subject ?? initialSubject, source: source)
    }

    var body: some View {
        List {
            Section {
                TextField("Search (e.g. mitochondria, Darwin, Ohm)", text: $query)
                Picker("Subject", selection: $subject) {
                    Text("All").tag(Optional<Subject>.none)
                    ForEach(Subject.allCases) { Text($0.rawValue).tag(Optional($0)) }
                }
                Picker("Source", selection: $source) {
                    Text("All").tag(Optional<QuestionSource>.none)
                    ForEach(QuestionSource.allCases) { Text($0.rawValue).tag(Optional($0)) }
                }
            }
            Section("Results") {
                ForEach(results.prefix(50)) { q in
                    NavigationLink {
                        SingleQuestionDrillView(question: q)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(q.topic)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(q.questionText)
                                .lineLimit(2)
                        }
                    }
                }
            }
        }
        .navigationTitle("Search Questions")
        .inlineNavigationBarTitle()
        .onAppear { subject = initialSubject }
    }
}
