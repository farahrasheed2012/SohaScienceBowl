import SwiftUI

struct TossupDrillView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    let subject: Subject
    let week: Int?

    @State private var questions: [UnifiedQuestion] = []
    @State private var index = 0
    @State private var revealed = false
    @State private var correctCount = 0
    @State private var finished = false

    var body: some View {
        VStack(spacing: 20) {
            if finished {
                endScreen
            } else if questions.isEmpty {
                ContentUnavailableView("No Questions", systemImage: "questionmark.circle", description: Text("Try another week or subject."))
            } else {
                ProgressView(value: Double(index), total: Double(questions.count))
                    .padding(.horizontal, 16)
                    .tint(Color(uiColor: .systemBlue))

                Text("Question \(index + 1) of \(questions.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Text(questions[index].questionText)
                    .font(.title2.weight(.semibold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)

                Spacer()

                if revealed {
                    Text(questions[index].answer)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)

                    HStack(spacing: 16) {
                        logButton(correct: true)
                        logButton(correct: false)
                    }
                    .padding(.horizontal, 16)
                } else {
                    Button {
                        revealed = true
                    } label: {
                        Label("Buzz", systemImage: "bolt.fill")
                            .font(.title2.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal, 16)
                    .accessibilityLabel("Buzz to reveal answer")
                }
            }
        }
        .padding(.vertical, 16)
        .navigationTitle("Toss-up Drill")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { loadQuestions() }
    }

    private var endScreen: some View {
        VStack(spacing: 16) {
            Text("Drill Complete")
                .font(.title.weight(.semibold))
            Text("\(correctCount) / \(questions.count) correct")
                .font(.title2)
            Text("\(subject.rawValue) · Week \(week.map(String.init) ?? "All")")
                .foregroundStyle(.secondary)

            Button("Add misses to flash cards") {
                for q in questions {
                    appState.addMissToFlashCards(question: q)
                }
            }
            .buttonStyle(.bordered)

            Button("Done") { dismiss() }
                .buttonStyle(.borderedProminent)
        }
        .padding(16)
    }

    private func logButton(correct: Bool) -> some View {
        Button {
            if correct { correctCount += 1 }
            else { appState.addMissToFlashCards(question: questions[index]) }
            appState.recordAttempt(topic: questions[index].topic, subject: subject, correct: correct)

            if index + 1 >= questions.count {
                appState.recordDrill(subject: subject, week: week, total: questions.count, correct: correctCount, mode: "Toss-up Drill")
                finished = true
            } else {
                index += 1
                revealed = false
            }
        } label: {
            Label(correct ? "Correct" : "Incorrect", systemImage: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .buttonStyle(.bordered)
        .background(correct ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func loadQuestions() {
        var pool = appState.allUnifiedQuestions.filter { $0.subject == subject || $0.category.subject == subject }
        if let week {
            let curriculum = pool.filter {
                $0.source == .customCurriculum && $0.sourceDescription.contains("Week \(week)")
            }
            let doe = appState.doeUnifiedQuestions.filter { $0.category == subject.doeCategory }
            pool = curriculum + doe
        }
        if pool.isEmpty {
            pool = SeedData.tossupQuestions.filter { $0.subject == subject && (week == nil || $0.week == week) }.map { $0.toUnified() }
            pool.append(contentsOf: appState.doeUnifiedQuestions.filter { $0.category == subject.doeCategory })
        }
        questions = dedupe(pool).shuffled()
        if questions.count > 20 { questions = Array(questions.prefix(20)) }
    }

    private func dedupe(_ questions: [UnifiedQuestion]) -> [UnifiedQuestion] {
        var seen = Set<String>()
        return questions.filter { q in
            let key = q.normalizedText
            if seen.contains(key) { return false }
            seen.insert(key)
            return true
        }
    }
}

struct TopicQuizView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    let subject: Subject
    let week: Int?

    @State private var questions: [UnifiedQuestion] = []
    @State private var index = 0
    @State private var selected: String?
    @State private var checked = false
    @State private var correctCount = 0
    @State private var finished = false
    @State private var choices: [String] = []

    var body: some View {
        VStack(spacing: 0) {
            if finished {
                endView
            } else if questions.isEmpty {
                ContentUnavailableView("No Questions", systemImage: "questionmark.circle")
            } else {
                ProgressView(value: Double(index), total: Double(questions.count))
                    .padding(16)
                    .tint(Color(uiColor: .systemBlue))

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(questions[index].questionText)
                            .font(.headline)
                            .padding(.horizontal, 16)

                        ForEach(choices, id: \.self) { choice in
                            Button {
                                guard !checked else { return }
                                selected = choice
                            } label: {
                                HStack {
                                    Text(choice)
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    if checked {
                                        if choice == questions[index].answer || strip(choice) == strip(questions[index].answer) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundStyle(.green)
                                        } else if choice == selected {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundStyle(.red)
                                        }
                                    }
                                }
                                .padding(16)
                                .background(rowBackground(for: choice))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .disabled(checked)
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.vertical, 16)
                }

                if !checked {
                    Button("Check") {
                        checked = true
                        let isCorrect = selected.map { strip($0) == strip(questions[index].answer) } ?? false
                        if isCorrect { correctCount += 1 }
                        else { appState.addMissToFlashCards(question: questions[index]) }
                        appState.recordAttempt(topic: questions[index].topic, subject: subject, correct: isCorrect)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(selected == nil)
                    .padding(16)
                } else {
                    Button("Next") { advance() }
                        .buttonStyle(.borderedProminent)
                        .padding(16)
                }
            }
        }
        .navigationTitle("Topic Quiz")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { setup() }
    }

    private var endView: some View {
        VStack(spacing: 16) {
            Text("Quiz Complete")
                .font(.title2.weight(.semibold))
            Text("\(correctCount) / \(questions.count) correct")
            Button("Done") { dismiss() }
                .buttonStyle(.borderedProminent)
        }
        .padding(16)
    }

    private func rowBackground(for choice: String) -> Color {
        guard checked else {
            return choice == selected ? Color.accentColor.opacity(0.12) : Color(uiColor: .secondarySystemGroupedBackground)
        }
        if strip(choice) == strip(questions[index].answer) {
            return Color.green.opacity(0.15)
        }
        if choice == selected {
            return Color.red.opacity(0.15)
        }
        return Color(uiColor: .secondarySystemGroupedBackground)
    }

    private func strip(_ s: String) -> String {
        s.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    private func setup() {
        var pool = SeedData.tossupQuestions.filter { $0.subject == subject }
        if let week { pool = pool.filter { $0.week == week } }
        var built = pool.map { $0.toUnified() }
        let doeLimit = appState.currentPass == .pass2 ? 12 : 8
        built.append(contentsOf: appState.doeUnifiedQuestions.filter { $0.category == subject.doeCategory }.shuffled().prefix(doeLimit))
        if built.isEmpty {
            built = appState.allUnifiedQuestions.filter { $0.subject == subject }
        }
        var seen = Set<String>()
        questions = built.filter { q in
            if seen.contains(q.normalizedText) { return false }
            seen.insert(q.normalizedText)
            return true
        }.shuffled()
        if questions.count > 15 { questions = Array(questions.prefix(15)) }
        if !questions.isEmpty {
            choices = appState.quizChoices(for: questions[index])
        }
    }

    private func advance() {
        if index + 1 >= questions.count {
            appState.recordDrill(subject: subject, week: week, total: questions.count, correct: correctCount, mode: "Topic Quiz")
            finished = true
        } else {
            index += 1
            selected = nil
            checked = false
            choices = appState.quizChoices(for: questions[index])
        }
    }
}

struct WeakAreaDrillView: View {
    let topic: TopicStats

    var body: some View {
        TossupDrillView(subject: topic.subject, week: nil)
            .navigationTitle("Weak: \(topic.topic)")
    }
}

private func strip(_ s: String) -> String { s.lowercased().trimmingCharacters(in: .whitespaces) }
