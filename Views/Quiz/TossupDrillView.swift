import SwiftUI

struct TossupDrillView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    let subject: Subject
    let week: Int?
    var topicFilter: String? = nil

    @State private var questions: [UnifiedQuestion] = []
    @State private var index = 0
    @State private var choices: [String] = []
    @State private var drillState: DrillScreenState = .countdown
    @State private var arcProgress: CGFloat = 1.0
    @State private var countdownText = "3"
    @State private var liveCorrect = 0
    @State private var liveMissed = 0
    @State private var finished = false
    @State private var flashColor: Color?
    @State private var showXPFloater = false
    @State private var results: [(question: UnifiedQuestion, correct: Bool)] = []
    @State private var xpAtStart = 0

    private let arcTimer = ArcCountdownTimer()
    @State private var countdownTask: Task<Void, Never>?
    @State private var transitionTask: Task<Void, Never>?

    private var subjectColor: Color { subject.gameColor }

    var body: some View {
        ZStack {
            GameColors.appBackground.ignoresSafeArea()
            subjectBleed(subject)

            if finished {
                endScreen
            } else if questions.isEmpty {
                ContentUnavailableView("No Questions", systemImage: "questionmark.circle", description: Text("Try another week or subject."))
            } else {
                drillBody
            }

            DrillFlashOverlay(color: flashColor)

            if showXPFloater {
                VStack {
                    HStack {
                        Spacer()
                        Text("+10 XP")
                            .font(GameFont.headline(.bold))
                            .foregroundStyle(GameColors.xpGold)
                            .padding(.top, 8)
                            .padding(.trailing, 20)
                    }
                    Spacer()
                }
            }

            if drillState == .countdown {
                DrillCountdownOverlay(text: countdownText, subjectColor: subjectColor)
            }
        }
        .navigationTitle("Buzzer Drill")
        .inlineNavigationBarTitle()
        .onAppear {
            xpAtStart = XPManager.shared.totalXP
            let loaded = appState.questionsForTossupDrill(
                subject: subject,
                week: week,
                topicFilter: topicFilter,
                limit: 20
            )
            questions = loaded
            if let first = loaded.first {
                choices = appState.quizChoices(for: first)
                startCountdown()
            }
        }
        .onDisappear {
            arcTimer.cancel()
            countdownTask?.cancel()
            transitionTask?.cancel()
            SpeechManager.shared.stop()
        }
        .questionSpeech(questionText: questions.indices.contains(index) ? questions[index].questionText : nil, speechToken: index)
        .trackDrillQuestion(questions.indices.contains(index) ? questions[index] : nil, token: index)
    }

    private var drillBody: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    Text("Question \(index + 1) of \(questions.count)")
                        .font(GameFont.caption())
                        .foregroundStyle(GameColors.textSecondary)
                    Spacer()
                    DrillScorePill(correct: liveCorrect, missed: liveMissed)
                }

                DrillThinProgressBar(
                    progress: Double(index) / Double(max(questions.count, 1)),
                    color: subjectColor
                )

                questionCard

                footer
            }
            .padding(20)
        }
    }

    private var questionCard: some View {
        let q = questions[index]
        let showAnswer = drillState == .revealed || drillState == .transitioning

        return VStack(alignment: .leading, spacing: 14) {
            SubjectBadge(subject: subject, suffix: "Toss-Up")

            QuestionSpeechBar(
                questionText: q.questionText,
                answerText: q.answer,
                showAnswerButton: showAnswer,
                choiceTexts: topicQuizSpeechChoices(choices)
            )

            Text(q.questionText)
                .font(GameFont.title3())
                .foregroundStyle(GameColors.textPrimary)

            if !choices.isEmpty {
                ForEach(choices, id: \.self) { choice in
                    let isCorrect = showAnswer && (strip(choice) == strip(q.answer))
                    Text(choice)
                        .font(GameFont.body())
                        .foregroundStyle(isCorrect ? subjectColor : GameColors.textPrimary)
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(isCorrect ? subjectColor.opacity(0.2) : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }

            if showAnswer {
                VStack(alignment: .leading, spacing: 4) {
                    Text("ANSWER").font(GameFont.caption(.bold)).foregroundStyle(subjectColor)
                    Text(q.answer).font(GameFont.title2(.bold)).foregroundStyle(GameColors.textPrimary)
                }
            }
        }
        .gameCard(color: subjectColor.opacity(0.06))
    }

    @ViewBuilder
    private var footer: some View {
        switch drillState {
        case .questionLive:
            BuzzButton(subjectColor: subjectColor, progress: arcProgress, action: buzz)
            DrillDotRow(total: questions.count, current: index, color: subjectColor)
            Button("Skip →") { skipQuestion() }
                .font(GameFont.caption())
                .foregroundStyle(GameColors.textSecondary)
        case .buzzed:
            Button("Reveal Answer →") { revealAnswer() }
                .font(GameFont.headline())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(subjectColor)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        case .revealed:
            DrillOutcomeButtons(onCorrect: { logOutcome(correct: true) }, onMissed: { logOutcome(correct: false) })
        default:
            EmptyView()
        }
    }

    private var endScreen: some View {
        DrillRoundEndView(
            correct: liveCorrect,
            missed: liveMissed,
            total: questions.count,
            xpEarned: max(0, XPManager.shared.totalXP - xpAtStart),
            streak: XPManager.shared.currentStreak,
            subjectRows: [(subject.rawValue, liveCorrect, questions.count, subjectColor)],
            primaryActionTitle: "Drill Again →",
            onPrimary: { dismiss() },
            secondaryActionTitle: "Add misses to flash cards",
            onSecondary: {
                for item in results where !item.correct {
                    appState.addMissToFlashCards(question: item.question)
                }
            }
        )
    }

    // MARK: - Actions

    private func startCountdown() {
        drillState = .countdown
        let sequence = ["3", "2", "1", "Go!"]
        countdownTask?.cancel()
        countdownTask = Task {
            for (i, label) in sequence.enumerated() {
                guard !Task.isCancelled else { return }
                await MainActor.run {
                    countdownText = label
                    HapticFeedback.impact(.heavy)
                }
                try? await Task.sleep(nanoseconds: label == "Go!" ? 600_000_000 : 800_000_000)
                if i == sequence.count - 1 {
                    await MainActor.run { beginQuestionLive() }
                }
            }
        }
    }

    private func beginQuestionLive() {
        drillState = .questionLive
        arcProgress = 1
        arcTimer.start(duration: 5, onProgress: { progress in
            arcProgress = progress
        }, onExpired: {
            handleTimeExpired()
        })
    }

    private func buzz() {
        guard drillState == .questionLive else { return }
        arcTimer.cancel()
        drillState = .buzzed
        HapticFeedback.impact(.medium)
    }

    private func revealAnswer() {
        guard drillState == .buzzed else { return }
        withAnimation { drillState = .revealed }
    }

    private func logOutcome(correct: Bool) {
        guard drillState == .revealed else { return }
        let q = questions[index]
        results.append((q, correct))
        appState.recordAttempt(topic: q.topic, subject: subject, correct: correct)

        if correct {
            liveCorrect += 1
            _ = XPManager.shared.award(.tossupCorrect)
            flash(GameColors.correct)
            HapticFeedback.impact(.light)
            showXPFloater = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { showXPFloater = false }
        } else {
            liveMissed += 1
            appState.addMissToFlashCards(question: q)
            flash(GameColors.incorrect)
            HapticFeedback.error()
            DrillFeedbackMessages.onIncorrect(appState: appState)
        }

        if correct {
            DrillFeedbackMessages.onCorrect(appState: appState)
        }

        drillState = .transitioning
        transitionTask?.cancel()
        transitionTask = Task {
            try? await Task.sleep(nanoseconds: 800_000_000)
            guard !Task.isCancelled else { return }
            await MainActor.run { advance() }
        }
    }

    private func handleTimeExpired() {
        guard drillState == .questionLive else { return }
        let q = questions[index]
        results.append((q, false))
        liveMissed += 1
        appState.addMissToFlashCards(question: q)
        appState.recordAttempt(topic: q.topic, subject: subject, correct: false)
        flash(GameColors.incorrect)
        HapticFeedback.error()
        withAnimation { drillState = .revealed }
        transitionTask?.cancel()
        transitionTask = Task {
            try? await Task.sleep(nanoseconds: 1_200_000_000)
            guard !Task.isCancelled else { return }
            await MainActor.run { advance() }
        }
    }

    private func skipQuestion() {
        arcTimer.cancel()
        let q = questions[index]
        results.append((q, false))
        liveMissed += 1
        appState.addMissToFlashCards(question: q)
        appState.recordAttempt(topic: q.topic, subject: subject, correct: false)
        flash(GameColors.incorrect)
        advance()
    }

    private func advance() {
        arcTimer.cancel()
        flashColor = nil
        if index + 1 >= questions.count {
            appState.recordDrill(subject: subject, week: week, total: questions.count, correct: liveCorrect, mode: "Toss-up Drill")
            _ = XPManager.shared.award(.studySessionComplete)
            XPManager.shared.recordActivity()
            finished = true
        } else {
            index += 1
            choices = appState.quizChoices(for: questions[index])
            beginQuestionLive()
        }
    }

    private func flash(_ color: Color) {
        withAnimation { flashColor = color }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { flashColor = nil }
    }

    private func loadQuestions() {
        questions = appState.questionsForTossupDrill(
            subject: subject,
            week: week,
            topicFilter: topicFilter,
            limit: 20
        )
    }

    private func strip(_ s: String) -> String {
        s.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
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
