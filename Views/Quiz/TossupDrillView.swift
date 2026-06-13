import SwiftUI

struct TossupDrillView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    let subject: Subject
    let week: Int?
    var topicFilter: String? = nil

    @State private var questions: [UnifiedQuestion] = []
    @State private var index = 0
    @State private var revealed = false
    @State private var correctCount = 0
    @State private var finished = false
    @State private var answerFeedback: DrillAnswerFeedback?

    var body: some View {
        VStack(spacing: 20) {
            if finished {
                endScreen
            } else if questions.isEmpty {
                ContentUnavailableView("No Questions", systemImage: "questionmark.circle", description: Text("Try another week or subject."))
            } else {
                DrillQuestionScreen(
                    questionText: questions[index].questionText,
                    header: {
                        VStack(spacing: 16) {
                            ProgressView(value: Double(index), total: Double(questions.count))
                                .tint(PlatformColor.systemBlue)

                            Text("Question \(index + 1) of \(questions.count)")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            QuestionSpeechBar(
                                questionText: questions[index].questionText,
                                answerText: questions[index].answer,
                                showAnswerButton: revealed
                            )
                        }
                    },
                    revealed: {
                        if revealed {
                            Text(questions[index].answer)
                                .font(.body)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)

                            if let feedback = answerFeedback {
                                DrillAnswerFeedbackPanel(
                                    feedback: feedback,
                                    nextLabel: index + 1 >= questions.count ? "Finish drill" : "Next question",
                                    onNext: advanceFromFeedback
                                )
                            }
                        }
                    },
                    footer: {
                        if revealed {
                            if answerFeedback == nil {
                                HStack(spacing: 16) {
                                    logButton(correct: true)
                                    logButton(correct: false)
                                }
                            }
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
                            .accessibilityLabel("Buzz to reveal answer")
                        }
                    }
                )
            }
        }
        .navigationTitle("Toss-up Drill")
        .inlineNavigationBarTitle()
        .onAppear { loadQuestions() }
        .onDisappear { SpeechManager.shared.stop() }
        .questionSpeech(questionText: questions.indices.contains(index) ? questions[index].questionText : nil, speechToken: index)
        .trackDrillQuestion(questions.indices.contains(index) ? questions[index] : nil, token: index)
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
            submitAnswer(correct: correct)
        } label: {
            Label(correct ? "Correct" : "Incorrect", systemImage: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .buttonStyle(.bordered)
        .background(correct ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func submitAnswer(correct: Bool) {
        let q = questions[index]
        if correct {
            correctCount += 1
            DrillFeedbackMessages.onCorrect(appState: appState)
            HapticFeedback.impact(.light)
        } else {
            appState.addMissToFlashCards(question: q)
            DrillFeedbackMessages.onIncorrect(appState: appState)
            HapticFeedback.error()
        }
        appState.recordAttempt(topic: q.topic, subject: subject, correct: correct)
        answerFeedback = DrillFeedbackMessages.makeFeedback(correct: correct, question: q, appState: appState)
    }

    private func advanceFromFeedback() {
        answerFeedback = nil
        if index + 1 >= questions.count {
            appState.recordDrill(subject: subject, week: week, total: questions.count, correct: correctCount, mode: "Toss-up Drill")
            finished = true
        } else {
            index += 1
            revealed = false
        }
    }

    private func loadQuestions() {
        questions = appState.questionsForTossupDrill(
            subject: subject,
            week: week,
            topicFilter: topicFilter,
            limit: 20
        )
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
    @State private var answerFeedback: DrillAnswerFeedback?

    var body: some View {
        VStack(spacing: 0) {
            if finished {
                endView
            } else if questions.isEmpty {
                ContentUnavailableView("No Questions", systemImage: "questionmark.circle")
            } else {
                ProgressView(value: Double(index), total: Double(questions.count))
                    .padding(16)
                    .tint(PlatformColor.systemBlue)

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        QuestionSpeechBar(
                            questionText: questions[index].questionText,
                            answerText: questions[index].answer,
                            showAnswerButton: checked,
                            choiceTexts: topicQuizSpeechChoices(choices)
                        )
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
                        if isCorrect {
                            correctCount += 1
                            DrillFeedbackMessages.onCorrect(appState: appState)
                            HapticFeedback.impact(.light)
                        } else {
                            appState.addMissToFlashCards(question: questions[index])
                            DrillFeedbackMessages.onIncorrect(appState: appState)
                            HapticFeedback.error()
                        }
                        appState.recordAttempt(topic: questions[index].topic, subject: subject, correct: isCorrect)
                        answerFeedback = DrillFeedbackMessages.makeFeedback(
                            correct: isCorrect,
                            question: questions[index],
                            appState: appState
                        )
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(selected == nil)
                    .padding(16)
                } else if let answerFeedback {
                    DrillAnswerFeedbackPanel(
                        feedback: answerFeedback,
                        nextLabel: index + 1 >= questions.count ? "Finish quiz" : "Next question",
                        onNext: advanceFromFeedback
                    )
                    .padding(.bottom, 16)
                }
            }
        }
        .navigationTitle("Topic Quiz")
        .inlineNavigationBarTitle()
        .onAppear { setup() }
        .onDisappear { SpeechManager.shared.stop() }
        .questionSpeech(
            questionText: questions.indices.contains(index) ? questions[index].questionText : nil,
            speechToken: index
        )
        .trackDrillQuestion(questions.indices.contains(index) ? questions[index] : nil, token: index)
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
            return choice == selected ? Color.accentColor.opacity(0.12) : PlatformColor.secondaryGroupedBackground
        }
        if strip(choice) == strip(questions[index].answer) {
            return Color.green.opacity(0.15)
        }
        if choice == selected {
            return Color.red.opacity(0.15)
        }
        return PlatformColor.secondaryGroupedBackground
    }

    private func strip(_ s: String) -> String {
        s.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    private func setup() {
        questions = appState.questionsForTossupDrill(subject: subject, week: week, limit: 15)
        if !questions.isEmpty {
            choices = appState.quizChoices(for: questions[index])
        }
    }

    private func advanceFromFeedback() {
        answerFeedback = nil
        advance()
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
        TossupDrillView(subject: topic.subject, week: nil, topicFilter: topic.topic)
            .navigationTitle("Weak: \(topic.topic)")
    }
}

private func strip(_ s: String) -> String { s.lowercased().trimmingCharacters(in: .whitespaces) }

private func topicQuizSpeechChoices(_ choices: [String]) -> [(key: String, text: String)] {
    choices.enumerated().map { index, text in
        let key = String(UnicodeScalar(65 + index)!)
        return (key, text)
    }
}
