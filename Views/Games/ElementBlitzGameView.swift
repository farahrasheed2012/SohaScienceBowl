import SwiftUI

struct ElementBlitzGameView: View {
    @Environment(AppState.self) private var appState

    private let duration: TimeInterval = 90

    @State private var timeRemaining: TimeInterval = 90
    @State private var timerTask: Task<Void, Never>?
    @State private var streak = 0
    @State private var bestStreak = 0
    @State private var correct = 0
    @State private var missed = 0
    @State private var question: ElementData.DrillQuestion?
    @State private var choices: [String] = []
    @State private var feedback: DrillAnswerFeedback?
    @State private var sessionEnded = false

    var body: some View {
        MiniGameShell(
            title: "Element Blitz",
            accent: Subject.chemistry.gameColor,
            correct: correct,
            missed: missed,
            showScore: true
        ) {
            if sessionEnded {
                endView
            } else {
                activeView
            }
        }
        .onAppear { startSession() }
        .onDisappear { timerTask?.cancel() }
    }

    private var activeView: some View {
        VStack(spacing: 16) {
            HStack {
                Label("\(Int(timeRemaining))s", systemImage: "timer")
                    .font(GameFont.headline())
                    .foregroundStyle(timeRemaining < 15 ? GameColors.incorrect : GameColors.textPrimary)
                Spacer()
                Label("Streak \(streak)", systemImage: "flame.fill")
                    .font(GameFont.caption(.semibold))
                    .foregroundStyle(GameColors.streakFlame)
            }

            DrillThinProgressBar(
                progress: timeRemaining / duration,
                color: Subject.chemistry.gameColor
            )
            .frame(height: 6)

            if let question {
                Text(question.prompt)
                    .font(GameFont.title3())
                    .foregroundStyle(GameColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .gameCard(color: GameColors.cardSurface2)

                if let feedback {
                    DrillFeedbackBanner(feedback: feedback)
                }

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(choices, id: \.self) { choice in
                        Button {
                            select(choice, question: question)
                        } label: {
                            Text(choice)
                                .font(GameFont.headline())
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(GameColors.cardSurface2)
                                .foregroundStyle(GameColors.textPrimary)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                        .buttonStyle(.plain)
                        .disabled(feedback != nil)
                    }
                }
            }
            Spacer(minLength: 0)
        }
    }

    private var endView: some View {
        VStack(spacing: 14) {
            Text("Time's up! ⚡")
                .font(GameFont.title2())
                .foregroundStyle(GameColors.textPrimary)
            DrillScorePill(correct: correct, missed: missed)
            Text("Best streak: \(bestStreak)")
                .font(GameFont.body())
                .foregroundStyle(GameColors.textSecondary)
            Button("Play again") { startSession() }
                .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity)
        .gameCard()
    }

    private func startSession() {
        timerTask?.cancel()
        timeRemaining = duration
        streak = 0
        bestStreak = 0
        correct = 0
        missed = 0
        feedback = nil
        sessionEnded = false
        loadNextQuestion()
        timerTask = Task {
            while !Task.isCancelled, timeRemaining > 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                guard !Task.isCancelled else { return }
                timeRemaining -= 1
                if timeRemaining <= 0 { endSession() }
            }
        }
    }

    private func endSession() {
        timerTask?.cancel()
        sessionEnded = true
        XPManager.shared.awardCustom(points: min(correct * 2, 40))
    }

    private func loadNextQuestion() {
        feedback = nil
        let questions = ElementData.makeDrillQuestions(
            count: 1,
            mode: .mixed,
            answerMode: .multipleChoice
        )
        question = questions.first
        choices = question?.choices ?? []
    }

    private func select(_ choice: String, question: ElementData.DrillQuestion) {
        let isCorrect = choice == question.correctAnswer
        if isCorrect {
            correct += 1
            streak += 1
            bestStreak = max(bestStreak, streak)
            feedback = DrillAnswerFeedback(
                correct: true,
                headline: DrillFeedbackMessages.praise(for: appState.studentName),
                explanationTopic: nil
            )
            DrillFeedbackMessages.onCorrect(appState: appState)
        } else {
            missed += 1
            streak = 0
            feedback = DrillAnswerFeedback(
                correct: false,
                headline: "Answer: \(question.correctAnswer)",
                explanationTopic: nil
            )
            DrillFeedbackMessages.onIncorrect(appState: appState)
        }
        Task {
            try? await Task.sleep(nanoseconds: 600_000_000)
            guard !sessionEnded else { return }
            loadNextQuestion()
        }
    }
}
