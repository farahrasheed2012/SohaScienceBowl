import SwiftUI

/// POT 6 topic detail — Learn + Drill tabs (distinct from schedule `MathTopicDetailView` in TopicDetailView.swift).
struct POT6TopicDetailView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.themePalette) private var theme
    let topicCode: String
    @State private var selectedTab = 0

    private var topic: MathTopic? {
        MathProgressService.shared.topic(for: topicCode)
    }

    var body: some View {
        Group {
            if let topic {
                VStack(spacing: 0) {
                    Picker("Section", selection: $selectedTab) {
                        Text("Learn").tag(0)
                        Text("Drill").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding()

                    if selectedTab == 0 {
                        learnTab(topic)
                    } else {
                        POT6TopicDrillView(topic: topic)
                    }
                }
                .background(theme.surface)
            } else {
                ContentUnavailableView("Topic not found", systemImage: "function")
            }
        }
        .navigationTitle(topic?.title ?? topicCode)
        .inlineNavigationBarTitle()
        .studyNavigationDestinations()
    }

    @ViewBuilder
    private func learnTab(_ topic: MathTopic) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if POT6TopicReadingSummaryView.hasReading(for: topic.code) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Reading")
                            .font(.headline)
                            .foregroundStyle(MathAccent.color)
                        topicReadingBlock(topic)
                    }
                    .mathCard()
                }

                if appState.readQuestionsAloud {
                    Button {
                        let text = topic.conceptSummary + " Key formulas: " + topic.keyFormulas.joined(separator: ". ")
                        SpeechManager.shared.speak(
                            SpeechTextSanitizer.speakable(text),
                            rate: appState.speechRate,
                            voiceIdentifier: appState.speechVoiceIdentifier
                        )
                    } label: {
                        Label("Read aloud", systemImage: "speaker.wave.2.fill")
                    }
                    .buttonStyle(.bordered)
                }

                VStack(alignment: .leading, spacing: 12) {
                    ForEach(topic.conceptSummary.components(separatedBy: "\n\n"), id: \.self) { paragraph in
                        Text(paragraph)
                            .font(.body)
                            .foregroundStyle(theme.primaryText)
                            .lineSpacing(4)
                    }
                }
                .mathCard()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Key Formulas")
                        .font(.headline)
                        .foregroundStyle(MathAccent.color)
                    ForEach(topic.keyFormulas, id: \.self) { formula in
                        Text(formula)
                            .font(.system(.body, design: .monospaced))
                            .foregroundStyle(theme.primaryText)
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(theme.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .mathCard()

                ForEach(topic.workedExamples) { example in
                    POT6WorkedExampleCard(example: example)
                }
            }
            .padding()
        }
    }

    @ViewBuilder
    private func topicReadingBlock(_ topic: MathTopic) -> some View {
        POT6TopicReadingSummaryView(potCode: topic.code)
    }
}

struct POT6WorkedExampleCard: View {
    @Environment(AppState.self) private var appState
    @Environment(\.themePalette) private var theme
    let example: WorkedExample
    @State private var expanded = false
    @State private var visibleStepCount = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(example.problem)
                .font(.body.weight(.medium))
                .foregroundStyle(theme.primaryText)

            if expanded {
                ForEach(Array(example.steps.prefix(visibleStepCount).enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 8) {
                        Text("\(index + 1).")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(MathAccent.color)
                        Text(step)
                            .font(.subheadline)
                            .foregroundStyle(theme.secondaryText)
                    }
                }

                if visibleStepCount < example.steps.count {
                    Button("Show next step") {
                        visibleStepCount += 1
                        if appState.readQuestionsAloud {
                            SpeechManager.shared.speak(
                                SpeechTextSanitizer.speakable(example.steps[visibleStepCount - 1]),
                                rate: appState.speechRate,
                                voiceIdentifier: appState.speechVoiceIdentifier
                            )
                        }
                    }
                    .buttonStyle(.bordered)
                } else {
                    Text("Answer: \(example.answer)")
                        .font(.headline)
                        .foregroundStyle(theme.success)
                    Text(example.insight)
                        .font(.subheadline)
                        .foregroundStyle(theme.primaryText)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(MathAccent.color.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            } else {
                Button("Show solution") {
                    expanded = true
                    visibleStepCount = 1
                    if appState.readQuestionsAloud {
                        SpeechManager.shared.speak(
                            SpeechTextSanitizer.speakable(example.steps[0]),
                            rate: appState.speechRate,
                            voiceIdentifier: appState.speechVoiceIdentifier
                        )
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(MathAccent.color)
            }
        }
        .mathCard()
    }
}

struct POT6TopicDrillView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.themePalette) private var theme
    let topic: MathTopic
    @State private var difficulty: DrillDifficulty = .standard
    @State private var questions: [MathDrillQuestion] = []
    @State private var index = 0
    @State private var userAnswer = ""
    @State private var submitted = false
    @State private var isCorrect = false
    @State private var sessionCorrect = 0
    @State private var sessionXP = 0
    @State private var showXPFloater = false
    @State private var lastXPGain = 0
    @State private var questionsInRound = 0

    private var current: MathDrillQuestion? {
        guard index < questions.count else { return nil }
        return questions[index]
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Picker("Difficulty", selection: $difficulty) {
                    ForEach(DrillDifficulty.allCases) { d in
                        Text(d.label).tag(d)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: difficulty) { _, _ in startDrill() }

                if let q = current {
                    drillContent(q)
                } else if questionsInRound >= 5 {
                    miniSummary
                } else {
                    ProgressView("Loading…")
                        .onAppear { startDrill() }
                }
            }
            .padding()
        }
        .background(theme.surface)
        .overlay(alignment: .bottom) {
            XPFloater(amount: lastXPGain, isVisible: $showXPFloater)
                .padding(.bottom, 40)
        }
    }

    @ViewBuilder
    private func drillContent(_ q: MathDrillQuestion) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Question \(index + 1)")
                .font(.caption)
                .foregroundStyle(theme.secondaryText)

            Text(q.questionText)
                .font(.body)
                .foregroundStyle(theme.primaryText)
                .questionSpeech(questionText: q.questionText, speechToken: q.id.uuidString)

            if let choices = q.answerChoices, !submitted {
                ForEach(choices, id: \.self) { choice in
                    Button(choice) { userAnswer = choice; check(q) }
                        .buttonStyle(.bordered)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else if !submitted {
                TextField("Your answer", text: $userAnswer)
                    .textFieldStyle(.roundedBorder)
                Button("Check") { check(q) }
                    .buttonStyle(.borderedProminent)
                    .tint(MathAccent.color)
                    .disabled(userAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }

            if submitted {
                Label(isCorrect ? "Correct!" : "Not quite", systemImage: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(isCorrect ? theme.success : theme.wrong)
                    .font(.headline)

                Text(q.solution)
                    .font(.subheadline)
                    .foregroundStyle(theme.secondaryText)

                Button(index + 1 >= questions.count ? "Finish round" : "Next question") {
                    advance()
                }
                .buttonStyle(.borderedProminent)
                .tint(MathAccent.color)
            }
        }
        .mathCard()
    }

    private var miniSummary: some View {
        VStack(spacing: 12) {
            Text("Round complete")
                .font(.title2.weight(.bold))
                .foregroundStyle(theme.primaryText)
            Text("\(sessionCorrect) / \(questionsInRound) correct")
                .foregroundStyle(theme.primaryText)
            Text("+\(sessionXP) XP earned")
                .foregroundStyle(.orange)
            if let updated = MathProgressService.shared.topic(for: topic.code) {
                Text("Mastery: \(updated.masteryLevel.label)")
                    .foregroundStyle(MathAccent.color)
            }
            Button("Drill again") { startDrill() }
                .buttonStyle(.borderedProminent)
                .tint(MathAccent.color)
        }
        .mathCard()
    }

    private func startDrill() {
        questions = POT6DrillBank.questions(for: topic.code, difficulty: difficulty)
        if questions.isEmpty {
            questions = POT6DrillBank.questions(for: topic.code)
        }
        questions = Array(questions.shuffled().prefix(5))
        index = 0
        userAnswer = ""
        submitted = false
        sessionCorrect = 0
        sessionXP = 0
        questionsInRound = 0
    }

    private func check(_ q: MathDrillQuestion) {
        let trimmed = userAnswer.trimmingCharacters(in: .whitespacesAndNewlines)
        isCorrect = trimmed.caseInsensitiveCompare(q.correctAnswer) == .orderedSame
        submitted = true
        questionsInRound += 1
        if isCorrect {
            sessionCorrect += 1
            lastXPGain = q.difficulty.xpValue
            sessionXP += lastXPGain
            showXPFloater = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { showXPFloater = false }
        }
        MathProgressService.shared.recordAnswers([
            .init(topicCode: topic.code, difficulty: q.difficulty, correct: isCorrect)
        ])
        appState.recordStudyActivity()
    }

    private func advance() {
        index += 1
        userAnswer = ""
        submitted = false
        if index >= questions.count { index = questions.count }
    }
}
