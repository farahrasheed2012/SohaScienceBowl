import SwiftUI

struct MathCountsSessionView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.themePalette) private var theme
    @Environment(\.dismiss) private var dismiss

    let questions: [MathCountsQuestion]
    let level: MathCountsDifficulty
    var isTopicDrill: Bool = false

    @State private var currentIndex = 0
    @State private var studentAnswer = ""
    @State private var phase: MathCountsCoachingPhase = .guiding
    @State private var wrongAttempts = 0
    @State private var hintsUsed = 0
    @State private var sessionAttempts: [MathCountsAttempt] = []
    @State private var showSummary = false
    @FocusState private var answerFocused: Bool

    private var current: MathCountsQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    private var sectionHeader: String? {
        guard let q = current else { return nil }
        if currentIndex == 0 || questions[currentIndex - 1].section != q.section {
            return q.section.title
        }
        return nil
    }

    var body: some View {
        Group {
            if showSummary {
                MathCountsSessionEndView(
                    attempts: sessionAttempts,
                    level: level,
                    onDone: { dismiss() }
                )
            } else if let q = current {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        progressHeader
                        if let header = sectionHeader {
                            sectionBanner(header, section: q.section)
                        }
                        questionCard(q)
                        coachingCard(q)
                        answerField
                        actionButtons(q)
                    }
                    .padding()
                }
            } else {
                ProgressView()
            }
        }
        .navigationTitle(isTopicDrill ? "Topic Drill" : "Daily Practice")
        .inlineNavigationBarTitle()
        .background(theme.surface.ignoresSafeArea())
        .onAppear {
            resetQuestionState()
        }
        .onDisappear { SpeechManager.shared.stop() }
        .questionSpeech(
            questionText: current?.prompt,
            speechToken: currentIndex
        )
    }

    private var progressHeader: some View {
        HStack {
            Text("Question \(currentIndex + 1) of \(questions.count)")
                .font(.caption)
                .foregroundStyle(theme.secondaryText)
            Spacer()
            Text(level.title)
                .font(.caption.weight(.medium))
                .foregroundStyle(theme.accent)
        }
    }

    private func sectionBanner(_ title: String, section: MathCountsSection) -> some View {
        Label(title, systemImage: section.systemImage)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(theme.accent)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(theme.accent.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private func questionCard(_ q: MathCountsQuestion) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            QuestionSpeechBar(
                questionText: q.prompt,
                answerText: q.answer,
                showAnswerButton: phase == .correct || phase == .revealed
            )
            Text(q.topic)
                .font(.caption.weight(.medium))
                .foregroundStyle(theme.secondaryText)
            Text(q.prompt)
                .font(.system(size: ThemePalette.titleSize, weight: .semibold))
                .foregroundStyle(theme.primaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: ThemePalette.cornerRadius))
    }

    @ViewBuilder
    private func coachingCard(_ q: MathCountsQuestion) -> some View {
        switch phase {
        case .guiding:
            if let guiding = q.guidingQuestion {
                LearnSectionCard(title: "Think first", systemImage: "lightbulb.fill", accent: .yellow) {
                    Text(guiding)
                        .font(.system(size: ThemePalette.bodySize))
                        .foregroundStyle(theme.primaryText)
                    Text(MathCountsCoachPersona.socraticReminder)
                        .font(.caption)
                        .foregroundStyle(theme.secondaryText)
                    Button("Ready to answer") {
                        phase = .answering
                        answerFocused = true
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(theme.accent)
                }
            } else {
                Color.clear
                    .frame(height: 0)
                    .onAppear {
                        phase = .answering
                    }
            }
        case .hint:
            coachMessage(title: "Hint", icon: "questionmark.circle.fill", color: .orange, body: q.hint)
        case .simplerExample:
            if let simpler = q.simplerExample {
                coachMessage(title: "Try a simpler version", icon: "arrow.down.circle.fill", color: .blue, body: simpler)
            }
        case .revealed:
            VStack(alignment: .leading, spacing: 12) {
                DrillFeedbackBanner(
                    feedback: DrillAnswerFeedback(
                        correct: false,
                        headline: DrillFeedbackMessages.encouragement(for: appState.studentName),
                        explanationTopic: nil
                    )
                )
                coachMessage(title: "Solution", icon: "checkmark.seal.fill", color: theme.success, body: q.explanation)
                if let strategy = q.strategy {
                    Label(strategy, systemImage: "bolt.fill")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(theme.accent)
                }
                Text("Answer: \(q.answer)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(theme.primaryText)
            }
        case .correct:
            VStack(alignment: .leading, spacing: 8) {
                DrillFeedbackBanner(
                    feedback: DrillAnswerFeedback(
                        correct: true,
                        headline: DrillFeedbackMessages.praise(for: appState.studentName),
                        explanationTopic: nil
                    )
                )
                if let strategy = q.strategy {
                    Text("Strategy: \(strategy)")
                        .font(.caption)
                        .foregroundStyle(theme.secondaryText)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(theme.success.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        case .answering:
            EmptyView()
        }
    }

    private func coachMessage(title: String, icon: String, color: Color, body: String) -> some View {
        LearnSectionCard(title: title, systemImage: icon, accent: color) {
            Text(body)
                .font(.system(size: ThemePalette.bodySize))
                .foregroundStyle(theme.primaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var answerField: some View {
        VStack(alignment: .leading, spacing: 8) {
            if phase != .guiding {
                Text("Your answer")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(theme.secondaryText)
                TextField("Type your answer", text: $studentAnswer)
                    .textFieldStyle(.roundedBorder)
                    .focused($answerFocused)
                    #if os(iOS)
                    .keyboardType(.numbersAndPunctuation)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    #endif
                    .disabled(phase == .correct || phase == .revealed)
            }
        }
    }

    @ViewBuilder
    private func actionButtons(_ q: MathCountsQuestion) -> some View {
        if phase == .correct || phase == .revealed {
            Button(currentIndex + 1 >= questions.count ? "Finish session" : "Next question") {
                advance(from: q)
            }
            .buttonStyle(.borderedProminent)
            .tint(theme.accent)
            .frame(maxWidth: .infinity)
        } else if phase != .guiding {
            HStack(spacing: 12) {
                Button("Check") { checkAnswer(q) }
                    .buttonStyle(.borderedProminent)
                    .tint(theme.accent)
                    .disabled(studentAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                if wrongAttempts > 0 {
                    Button("Show answer") { revealAnswer(q) }
                        .buttonStyle(.bordered)
                }
            }
        }
    }

    private func checkAnswer(_ q: MathCountsQuestion) {
        let correct = MathCountsAnswerChecker.isCorrect(student: studentAnswer, question: q)
        if correct {
            phase = .correct
            recordAttempt(q, correct: true)
            DrillFeedbackMessages.onCorrect(appState: appState)
        } else {
            DrillFeedbackMessages.onIncorrect(appState: appState)
            wrongAttempts += 1
            if wrongAttempts == 1 {
                hintsUsed += 1
                phase = .hint
            } else if wrongAttempts == 2, q.simplerExample != nil {
                hintsUsed += 1
                phase = .simplerExample
            } else {
                revealAnswer(q)
            }
        }
    }

    private func revealAnswer(_ q: MathCountsQuestion) {
        phase = .revealed
        if !sessionAttempts.contains(where: { $0.questionId == q.id }) {
            recordAttempt(q, correct: false)
        }
    }

    private func recordAttempt(_ q: MathCountsQuestion, correct: Bool) {
        guard !sessionAttempts.contains(where: { $0.questionId == q.id }) else { return }
        sessionAttempts.append(
            MathCountsAttempt(
                questionId: q.id,
                section: q.section,
                topic: q.topic,
                studentAnswer: studentAnswer,
                correct: correct,
                hintsUsed: hintsUsed,
                timestamp: Date()
            )
        )
    }

    private func advance(from q: MathCountsQuestion) {
        if currentIndex + 1 >= questions.count {
            appState.mathCounts.recordSession(attempts: sessionAttempts, level: level)
            showSummary = true
        } else {
            currentIndex += 1
            resetQuestionState()
        }
    }

    private func resetQuestionState() {
        studentAnswer = ""
        wrongAttempts = 0
        hintsUsed = 0
        guard currentIndex < questions.count else { return }
        phase = questions[currentIndex].guidingQuestion == nil ? .answering : .guiding
        answerFocused = phase == .answering
    }
}

struct MathCountsSessionEndView: View {
    @Environment(\.themePalette) private var theme

    let attempts: [MathCountsAttempt]
    let level: MathCountsDifficulty
    let onDone: () -> Void

    private var score: Int { attempts.filter(\.correct).count }
    private var missed: [MathCountsAttempt] { attempts.filter { !$0.correct } }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Session complete")
                        .font(.title2.weight(.bold))
                    Text("\(score) / \(attempts.count) correct · \(level.title)")
                        .foregroundStyle(theme.secondaryText)
                }

                if !missed.isEmpty {
                    LearnSectionCard(title: "Review mistakes", systemImage: "exclamationmark.triangle.fill", accent: .orange) {
                        ForEach(Array(missed.enumerated()), id: \.offset) { _, attempt in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(attempt.topic)
                                    .font(.caption.weight(.semibold))
                                Text("You answered: \(attempt.studentAnswer.isEmpty ? "—" : attempt.studentAnswer)")
                                    .font(.caption)
                                    .foregroundStyle(theme.secondaryText)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                } else {
                    Label("Perfect session — nice work!", systemImage: "star.fill")
                        .foregroundStyle(theme.success)
                }

                Text("Keep building speed with mental math shortcuts. Tomorrow's warmup will match your level.")
                    .font(.subheadline)
                    .foregroundStyle(theme.secondaryText)

                Button("Done", action: onDone)
                    .buttonStyle(.borderedProminent)
                    .tint(theme.accent)
                    .frame(maxWidth: .infinity)
            }
            .padding()
        }
        .background(theme.surface.ignoresSafeArea())
    }
}
