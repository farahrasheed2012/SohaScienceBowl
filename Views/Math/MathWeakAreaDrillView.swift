import SwiftUI

struct MathWeakAreaDrillView: View {
    enum Mode {
        case allTopics
        case geometry
    }

    var mode: Mode = .allTopics

    @Environment(AppState.self) private var appState
    @Environment(\.themePalette) private var theme
    @State private var queue: [MathDrillQuestion] = []
    @State private var index = 0
    @State private var userAnswer = ""
    @State private var submitted = false
    @State private var isCorrect = false
    @State private var correctCount = 0
    @State private var xpEarned = 0
    @State private var finished = false
    @State private var showTip = false
    @State private var tipText = ""
    @State private var showXPFloater = false
    @State private var lastXPGain = 0
    @Environment(\.dismiss) private var dismiss

    private var current: MathDrillQuestion? {
        guard index < queue.count else { return nil }
        return queue[index]
    }

    var body: some View {
        Group {
            if finished {
                summaryView
            } else if let q = current {
                drillView(q)
            } else {
                ProgressView("Building your drill…")
                    .onAppear { loadQueue() }
            }
        }
        .navigationTitle(mode == .geometry ? "Daily Geometry Drill" : "Daily Math Block")
        .inlineNavigationBarTitle()
        .background(theme.surface)
        .overlay(alignment: .bottom) {
            XPFloater(amount: lastXPGain, isVisible: $showXPFloater)
                .padding(.bottom, 40)
        }
    }

    private func loadQueue() {
        switch mode {
        case .allTopics:
            queue = MathProgressService.shared.buildDailyDrillQueue(count: 15)
        case .geometry:
            queue = MathProgressService.shared.buildGeometryDrillQueue(count: 15)
        }
    }

    @ViewBuilder
    private func drillView(_ q: MathDrillQuestion) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Question \(index + 1) of \(queue.count)")
                        .font(.caption)
                        .foregroundStyle(theme.secondaryText)
                    Spacer()
                    Text(q.difficulty.label)
                        .font(.caption2.weight(.semibold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(MathAccent.color.opacity(0.15))
                        .foregroundStyle(MathAccent.color)
                        .clipShape(Capsule())
                }

                Text(q.questionText)
                    .font(.body)
                    .foregroundStyle(theme.primaryText)
                    .questionSpeech(questionText: q.questionText, speechToken: q.id.uuidString)

                if let choices = q.answerChoices, !submitted {
                    ForEach(choices, id: \.self) { choice in
                        Button(choice) { userAnswer = choice; submit(q) }
                            .buttonStyle(.bordered)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                } else if !submitted {
                    TextField("Your answer", text: $userAnswer)
                        .textFieldStyle(.roundedBorder)
                    Button("Check") { submit(q) }
                        .buttonStyle(.borderedProminent)
                        .tint(MathAccent.color)
                        .disabled(userAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }

                if submitted {
                    resultSection(q)
                }

                if showTip {
                    VStack(alignment: .leading, spacing: 6) {
                        Label("Mathcounts Tip", systemImage: "lightbulb.fill")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.orange)
                        Text(tipText)
                            .font(.subheadline)
                            .foregroundStyle(theme.secondaryText)
                    }
                    .mathCard()
                }
            }
            .padding()
        }
    }

    @ViewBuilder
    private func resultSection(_ q: MathDrillQuestion) -> some View {
        Label(isCorrect ? "Correct!" : "Not quite", systemImage: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
            .foregroundStyle(isCorrect ? theme.success : theme.wrong)
            .font(.headline)

        Text(q.solution)
            .font(.subheadline)
            .foregroundStyle(theme.secondaryText)

        Button(index + 1 >= queue.count ? "See results" : "Next") {
            if index + 1 >= queue.count {
                finished = true
            } else {
                index += 1
                userAnswer = ""
                submitted = false
                showTip = false
            }
        }
        .buttonStyle(.borderedProminent)
        .tint(MathAccent.color)
    }

    private var summaryView: some View {
        VStack(spacing: 16) {
            Text(CoachCopy.drillHeadline(correct: correctCount, total: queue.count))
                .font(.title2.weight(.bold))
                .foregroundStyle(theme.primaryText)
            Text("\(correctCount) / \(queue.count) correct")
                .foregroundStyle(theme.primaryText)
            Text("+\(xpEarned) XP")
                .foregroundStyle(.orange)
                .font(.headline)
            Button("Done") { dismiss() }
                .buttonStyle(.borderedProminent)
                .tint(MathAccent.color)
        }
        .padding()
        .mathCard()
        .padding()
    }

    private func submit(_ q: MathDrillQuestion) {
        let trimmed = userAnswer.trimmingCharacters(in: .whitespacesAndNewlines)
        isCorrect = trimmed.caseInsensitiveCompare(q.correctAnswer) == .orderedSame
        submitted = true

        if isCorrect {
            correctCount += 1
            lastXPGain = q.difficulty.xpValue
            xpEarned += lastXPGain
            showXPFloater = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { showXPFloater = false }
        } else if q.difficulty == .challenge {
            showTip = true
            tipText = MathcountsTips.tip(for: q.topicCode)
        }

        MathProgressService.shared.recordAnswers([
            .init(topicCode: q.topicCode, difficulty: q.difficulty, correct: isCorrect)
        ])
        appState.recordStudyActivity()
    }
}

enum MathcountsTips {
    static func tip(for topicCode: String) -> String {
        if let topic = POT6TopicRegistry.topic(for: topicCode) {
            return "On \(topic.title) problems, write the givens first and look for a pattern before calculating — Mathcounts rewards setup speed."
        }
        return "Break the problem into smaller steps and estimate the answer magnitude before computing exactly."
    }
}
