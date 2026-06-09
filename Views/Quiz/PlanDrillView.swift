import SwiftUI

/// Toss-up drill driven by the weekly study plan (today's block, full week, buzzer slot).
struct PlanDrillView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    let request: PlanDrillRequest

    @State private var questions: [UnifiedQuestion] = []
    @State private var index = 0
    @State private var revealed = false
    @State private var correctCount = 0
    @State private var finished = false
    @State private var buzzer = BuzzerNetworkService.shared
    @State private var countdown = 5
    @State private var countdownActive = false

    private var isBuzzerMode: Bool { request.mode == "Buzzer drill" }

    var body: some View {
        VStack(spacing: 16) {
            if finished {
                endScreen
            } else if questions.isEmpty {
                ContentUnavailableView(
                    "No questions yet",
                    systemImage: "calendar",
                    description: Text(emptyMessage)
                )
            } else {
                ProgressView(value: Double(index), total: Double(questions.count))
                    .padding(.horizontal, 16)
                    .tint(PlatformColor.systemBlue)

                VStack(spacing: 4) {
                    Text("Question \(index + 1) of \(questions.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(request.subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                    if isBuzzerMode {
                        buzzerStatusRow
                    }
                    if let subject = questions[index].subject {
                        SubjectBadge(subject: subject)
                    } else {
                        DOECategoryBadge(category: questions[index].category)
                    }
                }

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
                } else if isBuzzerMode && countdownActive && countdown > 0 {
                    Text("\(countdown)")
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundStyle(.secondary)
                    Text("Get ready to buzz…")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Button {
                        revealAnswer()
                    } label: {
                        Label(isBuzzerMode ? "Buzz (B)" : "Buzz", systemImage: "bolt.fill")
                            .font(.title2.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal, 16)
                    .keyboardShortcut("b", modifiers: [])
                    .accessibilityLabel("Buzz to reveal answer")
                }
            }
        }
        .padding(.vertical, 16)
        .navigationTitle(request.title)
        .inlineNavigationBarTitle()
        .onAppear {
            questions = appState.questions(for: request)
            if isBuzzerMode {
                buzzer.onRemoteBuzz = { revealAnswer() }
                buzzer.startHosting()
                startCountdownIfNeeded()
            }
        }
        .onDisappear {
            if isBuzzerMode {
                buzzer.stopAll()
            }
        }
        .onKeyPress(.space) {
            if !revealed && !finished && !questions.isEmpty && (!countdownActive || countdown == 0) {
                revealAnswer()
                return .handled
            }
            return .ignored
        }
    }

    private var buzzerStatusRow: some View {
        HStack(spacing: 8) {
            Image(systemName: buzzer.isConnected ? "iphone.gen3.radiowaves.left.and.right" : "iphone.gen3")
                .foregroundStyle(buzzer.isConnected ? .green : .secondary)
            Text(buzzer.isConnected ? "Remote connected" : "Host ready — open Buzzer remote on iPhone")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    private var emptyMessage: String {
        if request.mode == "Math quiz" {
            return "No math questions mapped for this day yet."
        }
        if request.weakAreaReview {
            return "Complete a drill or add flash cards — weak-area review fills in as you practice."
        }
        return "Complete a study session first, or add DOE PDFs for more drills."
    }

    private var endScreen: some View {
        VStack(spacing: 16) {
            Text("Drill complete")
                .font(.title2.weight(.semibold))
            Text("\(correctCount) / \(questions.count) correct")
                .font(.title3)
            Text(request.subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)

            if !request.weakAreaReview, correctCount < questions.count {
                Text("Misses were added to flash cards and today's review.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
            }

            Button("Done") { dismiss() }
                .buttonStyle(.borderedProminent)
        }
        .padding(16)
    }

    private func startCountdownIfNeeded() {
        countdown = 5
        countdownActive = true
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if countdown > 0 {
                countdown -= 1
            } else {
                countdownActive = false
                timer.invalidate()
            }
        }
    }

    private func revealAnswer() {
        guard !revealed else { return }
        revealed = true
        HapticFeedback.impact(.medium)
    }

    private func logButton(correct: Bool) -> some View {
        Button {
            let q = questions[index]
            let subject = q.subject ?? request.subject ?? .biology
            if correct { correctCount += 1 }
            else { appState.addMissToFlashCards(question: q) }
            appState.recordAttempt(topic: q.topic, subject: subject, correct: correct)

            if index + 1 >= questions.count {
                appState.recordDrill(
                    subject: request.subject,
                    week: request.week > 0 ? request.week : appState.currentWeek,
                    total: questions.count,
                    correct: correctCount,
                    mode: request.mode
                )
                finished = true
            } else {
                index += 1
                revealed = false
                if isBuzzerMode {
                    startCountdownIfNeeded()
                }
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
}
