import SwiftUI

struct TrueOrFalseBlitzGameView: View {
    @Environment(AppState.self) private var appState

    @State private var statements: [GameContent.TrueFalseStatement] = []
    @State private var index = 0
    @State private var correct = 0
    @State private var missed = 0
    @State private var feedback: DrillAnswerFeedback?
    @State private var sessionComplete = false

    private var current: GameContent.TrueFalseStatement? {
        guard index < statements.count else { return nil }
        return statements[index]
    }

    var body: some View {
        MiniGameShell(
            title: "True or False Blitz",
            accent: Subject.biology.gameColor,
            correct: correct,
            missed: missed,
            showScore: !sessionComplete
        ) {
            if sessionComplete {
                summaryView
            } else if let statement = current {
                activeRound(statement)
            } else {
                ProgressView()
                    .onAppear { startSession() }
            }
        }
        .onAppear { startSession() }
    }

    private func activeRound(_ statement: GameContent.TrueFalseStatement) -> some View {
        VStack(spacing: 20) {
            DrillDotRow(
                total: statements.count,
                current: index,
                color: statement.subject.gameColor
            )

            Text(statement.statement)
                .font(GameFont.title3())
                .foregroundStyle(GameColors.textPrimary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .gameCard(color: GameColors.cardSurface2)

            if let feedback {
                DrillAnswerFeedbackPanel(
                    feedback: feedback,
                    nextLabel: index + 1 >= statements.count ? "See results" : "Next",
                    onNext: advance
                )
            } else {
                HStack(spacing: 14) {
                    answerButton(title: "False", icon: "xmark", color: GameColors.incorrect) {
                        answer(false, statement: statement)
                    }
                    answerButton(title: "True", icon: "checkmark", color: GameColors.correct) {
                        answer(true, statement: statement)
                    }
                }
            }

            Spacer(minLength: 0)
        }
    }

    private func answerButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title)
                Text(title)
                    .font(GameFont.headline())
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(color)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var summaryView: some View {
        VStack(spacing: 16) {
            Text(CoachCopy.drillHeadline(correct: correct, total: statements.count))
                .font(GameFont.title2())
                .foregroundStyle(GameColors.textPrimary)
            DrillScorePill(correct: correct, missed: missed)
            Text("\(correct) of \(statements.count) correct")
                .font(GameFont.body())
                .foregroundStyle(GameColors.textSecondary)
            Button("Play again") { startSession() }
                .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity)
        .gameCard()
    }

    private func answer(_ choice: Bool, statement: GameContent.TrueFalseStatement) {
        let isCorrect = choice == statement.isTrue
        if isCorrect {
            correct += 1
            XPManager.shared.awardCustom(points: 5)
            DrillFeedbackMessages.onCorrect(appState: appState)
            feedback = DrillAnswerFeedback(
                correct: true,
                headline: DrillFeedbackMessages.praise(for: appState.studentName),
                explanationTopic: nil
            )
        } else {
            missed += 1
            DrillFeedbackMessages.onIncorrect(appState: appState)
            feedback = DrillAnswerFeedback(
                correct: false,
                headline: "\(statement.hint)",
                explanationTopic: nil
            )
        }
    }

    private func advance() {
        feedback = nil
        index += 1
        if index >= statements.count {
            sessionComplete = true
            XPManager.shared.awardCustom(points: 10)
        }
    }

    private func startSession() {
        statements = GameContent.shuffledTrueFalseStatements(count: 12)
        index = 0
        correct = 0
        missed = 0
        feedback = nil
        sessionComplete = false
    }
}
