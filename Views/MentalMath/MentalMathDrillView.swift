import SwiftUI

struct MentalMathDrillView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.themePalette) private var theme
    @Environment(\.dismiss) private var dismiss

    let operation: MentalMathOperation
    let level: Int

    @State private var problems: [MentalMathProblem] = []
    @State private var index = 0
    @State private var answer = ""
    @State private var correctCount = 0
    @State private var feedback: MentalMathFeedback = .idle
    @State private var finished = false
    @State private var startTime = Date()
    @State private var problemStartTime = Date()
    @State private var now = Date()
    @State private var problemTimeRemaining: TimeInterval?
    @State private var sessionOutcome: MentalMathStore.SessionRecordOutcome?
    @State private var tickTimer: Timer?
    @State private var lifecycleGeneration = 0
    @FocusState private var answerFocused: Bool

    private var timedMode: MentalMathTimedMode { appState.mentalMath.timedMode }
    private var perProblemLimit: TimeInterval? {
        let sec = timedMode.secondsPerProblem
        return sec > 0 ? TimeInterval(sec) : nil
    }

    private var current: MentalMathProblem? {
        guard index < problems.count else { return nil }
        return problems[index]
    }

    private var elapsed: TimeInterval {
        now.timeIntervalSince(startTime)
    }

    var body: some View {
        VStack(spacing: 0) {
            if finished {
                endScreen
            } else if let problem = current {
                drillHeader
                Spacer()
                problemDisplay(problem)
                Spacer()
                answerArea
                feedbackBanner
                Spacer(minLength: 24)
            } else {
                ProgressView("Loading…")
            }
        }
        .padding()
        .background(theme.surface.ignoresSafeArea())
        .navigationTitle("\(operation.rawValue) · L\(level)")
        .inlineNavigationBarTitle()
        .task { beginDrill() }
        .onDisappear { invalidateDrill() }
        .onSubmit { submitAnswer() }
    }

    private var drillHeader: some View {
        VStack(spacing: 8) {
            HStack {
                Label(MentalMathFormatting.duration(elapsed), systemImage: "timer")
                    .font(.subheadline.weight(.semibold))
                    .monospacedDigit()
                Spacer()
                if let limit = perProblemLimit, let remaining = problemTimeRemaining {
                    problemTimerBadge(remaining: remaining, limit: limit)
                }
            }

            ProgressView(value: Double(index), total: Double(problems.count))
                .tint(theme.accent)

            HStack {
                Text("\(index + 1) / \(problems.count)")
                    .font(.caption.weight(.medium))
                Spacer()
                Text("\(correctCount) correct")
                    .font(.caption)
                    .foregroundStyle(theme.secondaryText)
            }

            if let best = appState.mentalMath.best(for: operation, level: level),
               let bestTime = best.formattedBestTime {
                Text("Best: \(bestTime) · \(best.bestCorrect)/\(MentalMathEngine.problemsPerSession)")
                    .font(.caption2)
                    .foregroundStyle(theme.secondaryText)
            }
        }
    }

    private func problemTimerBadge(remaining: TimeInterval, limit: TimeInterval) -> some View {
        let urgent = remaining <= 2
        return HStack(spacing: 4) {
            Image(systemName: "hourglass")
            Text(String(format: "%.0f", max(0, remaining.rounded(.up))))
                .monospacedDigit()
        }
        .font(.caption.weight(.bold))
        .foregroundStyle(urgent ? theme.wrong : theme.accent)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background((urgent ? theme.wrong : theme.accent).opacity(0.15))
        .clipShape(Capsule())
    }

    private func problemDisplay(_ problem: MentalMathProblem) -> some View {
        Text(problem.prompt)
            .font(.system(size: 48, weight: .bold, design: .rounded))
            .minimumScaleFactor(0.5)
            .lineLimit(2)
            .multilineTextAlignment(.center)
            .foregroundStyle(theme.primaryText)
            .padding(.horizontal, 8)
    }

    private var answerArea: some View {
        HStack(spacing: 12) {
            TextField("?", text: $answer)
                .font(.system(size: 36, weight: .semibold, design: .rounded))
                .multilineTextAlignment(.center)
                .textFieldStyle(.roundedBorder)
                .focused($answerFocused)
                #if os(iOS)
                .keyboardType(.numbersAndPunctuation)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                #endif
                .disabled(feedback != .idle)
                .frame(maxWidth: 200)
                .onSubmit { submitAnswer() }

            Button("Go") { submitAnswer() }
                .buttonStyle(.borderedProminent)
                .tint(theme.accent)
                .disabled(answer.trimmingCharacters(in: .whitespaces).isEmpty || feedback != .idle)
        }
    }

    @ViewBuilder
    private var feedbackBanner: some View {
        switch feedback {
        case .idle:
            EmptyView()
        case .correct:
            Label("Correct!", systemImage: "checkmark.circle.fill")
                .font(.title3.weight(.semibold))
                .foregroundStyle(theme.success)
                .padding(.top, 12)
        case .incorrect(let correctAnswer):
            Text("Answer: \(correctAnswer)")
                .font(.title3.weight(.semibold))
                .foregroundStyle(theme.wrong)
                .padding(.top, 12)
        case .timedOut(let correctAnswer):
            Text("Time's up — \(correctAnswer)")
                .font(.title3.weight(.semibold))
                .foregroundStyle(theme.wrong)
                .padding(.top, 12)
        }
    }

    private var endScreen: some View {
        let total = problems.count
        let passed = total > 0 && Double(correctCount) / Double(total) >= MentalMathStore.passThreshold
        let elapsedNow = Date().timeIntervalSince(startTime)
        let avg = total > 0 ? elapsedNow / Double(total) : 0

        return VStack(spacing: 16) {
            Image(systemName: passed ? "star.circle.fill" : "arrow.clockwise.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(passed ? theme.success : theme.accent)

            Text(passed ? "Level passed!" : "Keep practicing")
                .font(.title2.weight(.bold))

            Text("\(correctCount) / \(total) correct")
                .font(.title3)

            VStack(spacing: 4) {
                Text("Time: \(MentalMathFormatting.duration(elapsedNow))")
                Text(String(format: "Avg %.1f sec / problem", avg))
            }
            .font(.subheadline)
            .foregroundStyle(theme.secondaryText)

            if let outcome = sessionOutcome {
                if outcome.isNewBestTime {
                    Label("New best time!", systemImage: "trophy.fill")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(theme.success)
                }
                if outcome.isNewBestScore {
                    Label("New best score!", systemImage: "medal.fill")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(theme.accent)
                }
                if let best = appState.mentalMath.best(for: operation, level: level),
                   let bestTime = best.formattedBestTime {
                    Text("Personal best: \(bestTime) · \(best.bestCorrect)/\(total)")
                        .font(.caption)
                        .foregroundStyle(theme.secondaryText)
                }
            }

            if passed, level < operation.levelCount {
                Text("Unlocked: Level \(level + 1)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(theme.success)
            }

            HStack(spacing: 12) {
                Button("Try again") { resetDrill() }
                    .buttonStyle(.bordered)
                Button("Done") { dismiss() }
                    .buttonStyle(.borderedProminent)
                    .tint(theme.accent)
            }
        }
        .padding()
    }

    private func invalidateDrill() {
        lifecycleGeneration += 1
        tickTimer?.invalidate()
        tickTimer = nil
    }

    private func beginDrill() {
        invalidateDrill()
        index = 0
        answer = ""
        correctCount = 0
        feedback = .idle
        finished = false
        sessionOutcome = nil
        problems = MentalMathEngine.problems(operation: operation, level: level)
        startTime = Date()
        now = startTime
        problemStartTime = startTime
        resetProblemTimer()
        startTickTimer()
        answerFocused = true
    }

    private func startTickTimer() {
        let generation = lifecycleGeneration
        tickTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            Task { @MainActor in
                guard generation == lifecycleGeneration else { return }
                now = Date()
                guard feedback == .idle, let limit = perProblemLimit else { return }
                let remaining = limit - now.timeIntervalSince(problemStartTime)
                problemTimeRemaining = remaining
                if remaining <= 0 {
                    handleTimeout()
                }
            }
        }
    }

    private func resetProblemTimer() {
        problemStartTime = Date()
        if let limit = perProblemLimit {
            problemTimeRemaining = limit
        } else {
            problemTimeRemaining = nil
        }
    }

    private func handleTimeout() {
        guard feedback == .idle, let problem = current else { return }
        let generation = lifecycleGeneration
        feedback = .timedOut(correctAnswer: problem.answer)
        HapticFeedback.impact(.medium)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            guard generation == lifecycleGeneration else { return }
            advance()
        }
    }

    private func submitAnswer() {
        guard feedback == .idle, let problem = current else { return }
        let trimmed = answer.trimmingCharacters(in: .whitespaces)
        guard let value = Int(trimmed) else { return }

        let isCorrect = value == problem.answer
        if isCorrect {
            correctCount += 1
            feedback = .correct
            HapticFeedback.impact(.light)
        } else {
            feedback = .incorrect(correctAnswer: problem.answer)
            HapticFeedback.impact(.medium)
        }

        let generation = lifecycleGeneration
        DispatchQueue.main.asyncAfter(deadline: .now() + (isCorrect ? 0.35 : 0.9)) {
            guard generation == lifecycleGeneration else { return }
            advance()
        }
    }

    private func advance() {
        if index + 1 >= problems.count {
            invalidateDrill()
            let elapsedFinal = Date().timeIntervalSince(startTime)
            sessionOutcome = appState.mentalMath.recordSession(
                operation: operation,
                level: level,
                correct: correctCount,
                total: problems.count,
                elapsed: elapsedFinal,
                timedMode: perProblemLimit != nil
            )
            finished = true
        } else {
            index += 1
            answer = ""
            feedback = .idle
            resetProblemTimer()
            answerFocused = true
        }
    }

    private func resetDrill() {
        beginDrill()
    }
}
