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
    @FocusState private var answerFocused: Bool

    private var current: MentalMathProblem? {
        guard index < problems.count else { return nil }
        return problems[index]
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
        .task {
            guard problems.isEmpty else { return }
            problems = MentalMathEngine.problems(operation: operation, level: level)
            startTime = Date()
            answerFocused = true
        }
        .onSubmit { submitAnswer() }
    }

    private var drillHeader: some View {
        VStack(spacing: 8) {
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
            Text("Type the answer and press Return")
                .font(.caption2)
                .foregroundStyle(theme.secondaryText)
        }
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
        }
    }

    private var endScreen: some View {
        let total = problems.count
        let passed = total > 0 && Double(correctCount) / Double(total) >= MentalMathStore.passThreshold
        let elapsed = Date().timeIntervalSince(startTime)

        return VStack(spacing: 20) {
            Image(systemName: passed ? "star.circle.fill" : "arrow.clockwise.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(passed ? theme.success : theme.accent)

            Text(passed ? "Level passed!" : "Keep practicing")
                .font(.title2.weight(.bold))

            Text("\(correctCount) / \(total) correct")
                .font(.title3)

            Text(String(format: "Time: %.0f sec · Need %d/%d to advance",
                        elapsed,
                        Int(ceil(MentalMathStore.passThreshold * Double(total))),
                        total))
                .font(.subheadline)
                .foregroundStyle(theme.secondaryText)
                .multilineTextAlignment(.center)

            if passed, level < operation.levelCount {
                Text("Unlocked: Level \(level + 1)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(theme.success)
            }

            HStack(spacing: 12) {
                Button("Try again") {
                    resetDrill()
                }
                .buttonStyle(.bordered)

                Button("Done") { dismiss() }
                    .buttonStyle(.borderedProminent)
                    .tint(theme.accent)
            }
        }
        .padding()
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

        DispatchQueue.main.asyncAfter(deadline: .now() + (isCorrect ? 0.35 : 0.9)) {
            advance()
        }
    }

    private func advance() {
        if index + 1 >= problems.count {
            appState.mentalMath.recordSession(
                operation: operation,
                level: level,
                correct: correctCount,
                total: problems.count,
                elapsed: Date().timeIntervalSince(startTime)
            )
            finished = true
        } else {
            index += 1
            answer = ""
            feedback = .idle
            answerFocused = true
        }
    }

    private func resetDrill() {
        index = 0
        answer = ""
        correctCount = 0
        feedback = .idle
        finished = false
        startTime = Date()
        problems = MentalMathEngine.problems(operation: operation, level: level)
        answerFocused = true
    }
}
