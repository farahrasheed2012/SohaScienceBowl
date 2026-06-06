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

    var body: some View {
        VStack(spacing: 16) {
            if finished {
                endScreen
            } else if questions.isEmpty {
                ContentUnavailableView(
                    "No questions yet",
                    systemImage: "calendar",
                    description: Text("Complete a study session first, or add DOE PDFs for more drills.")
                )
            } else {
                ProgressView(value: Double(index), total: Double(questions.count))
                    .padding(.horizontal, 16)
                    .tint(Color(uiColor: .systemBlue))

                VStack(spacing: 4) {
                    Text("Question \(index + 1) of \(questions.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(request.subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
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
                    .padding(.horizontal, 16)
                    .accessibilityLabel("Buzz to reveal answer")
                }
            }
        }
        .padding(.vertical, 16)
        .navigationTitle(request.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            questions = appState.questions(for: request)
        }
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

            Button("Done") { dismiss() }
                .buttonStyle(.borderedProminent)
        }
        .padding(16)
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
                    week: request.week,
                    total: questions.count,
                    correct: correctCount,
                    mode: request.mode
                )
                finished = true
            } else {
                index += 1
                revealed = false
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

struct WeekPlanView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Week \(appState.currentWeek) · \(appState.weekTheme(for: appState.currentWeek))")
                        .font(.headline)
                    Text(ScheduleConstants.passLabel(for: appState.currentPass))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)

                NavigationLink {
                    PlanDrillView(request: .thisWeek(week: appState.currentWeek))
                } label: {
                    Label("Quiz full week", systemImage: "calendar")
                }
            }

            Section("This week's topics") {
                ForEach(appState.scienceBlocks(for: appState.currentWeek)) { block in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top, spacing: 12) {
                            SubjectBadge(subject: block.subject)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(block.day.fullName) · \(ScheduleConstants.blockTimeLabel(day: block.day, subject: block.subject))")
                                    .font(.subheadline.weight(.semibold))
                                Text(block.primaryTopic)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(block.bookLine(for: appState.currentPass))
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                        }

                        HStack(spacing: 12) {
                            NavigationLink {
                                BlockStudyMaterialView(block: block)
                            } label: {
                                Text("Read")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)

                            NavigationLink {
                                PlanDrillView(request: .dayBlock(block, week: appState.currentWeek))
                            } label: {
                                Text("Quiz")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Week plan")
        .navigationBarTitleDisplayMode(.inline)
    }
}
