import SwiftUI

struct StudySessionView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    let block: StudyBlock
    var initialStage: StudySessionStage = .read

    @State private var stage: StudySessionStage = .read
    @State private var revealedRecall = Set<UUID>()
    @State private var revealedKnowCold = Set<Int>()
    @State private var revealedTossups = Set<UUID>()
    @State private var tossupResults: [UUID: Bool] = [:]
    @State private var facts: [String] = ["", "", ""]
    @State private var miss = ""
    @State private var readingDone = false
    @State private var secondsRemaining = ScheduleConstants.scienceSessionMinutes * 60
    @State private var timerActive = false

    private var recallQuestions: [TossupQuestion] {
        appState.recallQuestions(for: block)
    }

    private var knowColdItems: [KnowColdItem] {
        appState.knowColdItems(for: block)
    }

    var body: some View {
        VStack(spacing: 0) {
            stageHeader

            if appState.showSessionTimer && timerActive {
                Text(timerString)
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 8)
            }

            TabView(selection: $stage) {
                recallStage.tag(StudySessionStage.recall)
                readStage.tag(StudySessionStage.read)
                knowColdStage.tag(StudySessionStage.knowCold)
                tossupStage.tag(StudySessionStage.tossups)
            }
            .pagedStudyTabStyle()
            .animation(.easeInOut, value: stage)

            bottomBar
        }
        .navigationTitle(block.subject.rawValue)
        .inlineNavigationBarTitle()
        .onAppear {
            stage = initialStage
            if appState.showSessionTimer {
                timerActive = true
                startTimer()
            }
        }
        .onDisappear { SpeechManager.shared.stop() }
    }

    private var stageHeader: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                ForEach(StudySessionStage.allCases) { s in
                    Button {
                        stage = s
                    } label: {
                        VStack(spacing: 4) {
                            Circle()
                                .fill(s == stage ? Color.accentColor : Color.secondary.opacity(0.3))
                                .frame(width: 10, height: 10)
                            Text(s.title)
                                .font(.caption2)
                                .foregroundStyle(s == stage ? Color.primary : Color.secondary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("\(s.title) stage")
                }
            }
            Text(stage.subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
        }
        .padding(.vertical, 12)
    }

    private var recallStage: some View {
        List {
            if block.isFlashCardOnly {
                Section {
                    Text("Review know-cold prompts from memory. Tap each to reveal.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            Section("5 quick questions from last week") {
                if recallQuestions.isEmpty {
                    ForEach(Array(block.sampleTossups.prefix(5))) { q in
                        recallRow(question: q.question, answer: q.answer, id: q.id)
                    }
                } else {
                    ForEach(recallQuestions) { q in
                        recallRow(question: q.question, answer: q.answer, id: q.id)
                    }
                }
            }
        }
    }

    private func recallRow(question: String, answer: String, id: UUID) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            QuestionSpeechBar(
                questionText: question,
                answerText: answer,
                showAnswerButton: revealedRecall.contains(id)
            )
            Text(question)
                .font(.headline)
            if revealedRecall.contains(id) {
                Text(answer)
                    .font(.body)
                    .foregroundStyle(.secondary)
            } else {
                Button("Tap to reveal") {
                    revealedRecall.insert(id)
                }
                .font(.subheadline)
            }
        }
        .padding(.vertical, 4)
    }

    private var readStage: some View {
        ScrollView {
            if block.isFlashCardOnly {
                StuckBookLinksCard(block: block, activePass: appState.currentPass)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
            }

            if !block.isFlashCardOnly {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "book.pages")
                        .foregroundStyle(Color.accentColor)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Reading pace · \(block.readingScopeShort)")
                            .font(.subheadline.weight(.semibold))
                        Text(block.readingPaceLabel)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(PlatformColor.secondaryGroupedBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }

            StudyMaterialScrollContent(block: block)
                .padding(.horizontal, 20)
                .padding(.vertical, 20)

            Toggle("Done reading", isOn: $readingDone)
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
        }
        .background(PlatformColor.groupedBackground)
    }

    private var knowColdStage: some View {
        List {
            if block.isFlashCardOnly {
                Section {
                    StuckBookLinksCard(block: block, activePass: appState.currentPass)
                }
            }

            Section("Know cold — close the book") {
                ForEach(Array(knowColdItems.enumerated()), id: \.offset) { index, item in
                    VStack(alignment: .leading, spacing: 8) {
                        QuestionSpeechBar(
                            questionText: item.prompt,
                            answerText: item.answer,
                            showAnswerButton: revealedKnowCold.contains(index)
                        )
                        Text(item.prompt)
                            .font(.headline)
                        if revealedKnowCold.contains(index) {
                            Text(item.answer.isEmpty ? "Check your notes" : item.answer)
                                .foregroundStyle(.secondary)
                        } else {
                            Button("Reveal answer") {
                                revealedKnowCold.insert(index)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }

    private var tossupStage: some View {
        List {
            Section("Sample toss-ups") {
                ForEach(block.sampleTossups) { q in
                    VStack(alignment: .leading, spacing: 12) {
                        QuestionSpeechBar(
                            questionText: q.question,
                            answerText: q.answer,
                            showAnswerButton: revealedTossups.contains(q.id)
                        )

                        Text(q.question)
                            .font(.headline)

                        if appState.parentReadsAloud && !appState.readQuestionsAloud {
                            Text("Parent reads aloud — answer verbally, then reveal.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        if revealedTossups.contains(q.id) {
                            Text(q.answer)
                                .foregroundStyle(.secondary)
                            HStack {
                                resultButton(title: "Correct", symbol: "checkmark.circle.fill", correct: true, id: q.id)
                                resultButton(title: "Incorrect", symbol: "xmark.circle.fill", correct: false, id: q.id)
                            }
                        } else {
                            Button("Reveal Answer") {
                                revealedTossups.insert(q.id)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding(.vertical, 6)
                }
            }

            Section("Notebook — 3 facts + 1 miss") {
                ForEach(0..<3, id: \.self) { i in
                    TextField("Fact \(i + 1)", text: $facts[i])
                }
                TextField("One miss (with correct answer)", text: $miss, axis: .vertical)
                    .lineLimit(2...4)
            }
        }
    }

    private func resultButton(title: String, symbol: String, correct: Bool, id: UUID) -> some View {
        Button {
            tossupResults[id] = correct
            if correct {
                if appState.readQuestionsAloud { QuestionSpeechHelper.speakPraiseIfNeeded(appState: appState) }
            } else {
                if let q = block.sampleTossups.first(where: { $0.id == id }) {
                    appState.addFlashCard(prompt: q.question, answer: q.answer, topic: q.topic, subject: q.subject, sourceID: id)
                }
                if appState.readQuestionsAloud { QuestionSpeechHelper.speakEncouragementIfNeeded(appState: appState) }
            }
            appState.recordAttempt(topic: block.sampleTossups.first?.topic ?? block.subject.rawValue, subject: block.subject, correct: correct)
        } label: {
            Label(title, systemImage: symbol)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .tint(correct ? .green : .red)
        .background(
            (tossupResults[id] == correct)
                ? (correct ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                : Color.clear
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .accessibilityLabel("\(title) for toss-up")
    }

    private var bottomBar: some View {
        HStack {
            if stage.rawValue > 0 {
                Button("Back") {
                    if let prev = StudySessionStage(rawValue: stage.rawValue - 1) {
                        stage = prev
                    }
                }
            }
            Spacer()
            if stage == .tossups {
                Button("Save & Finish") {
                    appState.saveNotebook(
                        subject: block.subject,
                        week: block.week,
                        topic: block.sampleTossups.first?.topic ?? block.subject.rawValue,
                        facts: facts.filter { !$0.isEmpty },
                        miss: miss
                    )
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            } else {
                Button("Next") {
                    if stage == .read && !readingDone && !block.isFlashCardOnly {
                        return
                    }
                    if let next = StudySessionStage(rawValue: stage.rawValue + 1) {
                        stage = next
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(stage == .read && !readingDone && !block.isFlashCardOnly)
            }
        }
        .padding(16)
        .background(PlatformColor.groupedBackground)
    }

    private var timerString: String {
        let m = secondsRemaining / 60
        let s = secondsRemaining % 60
        return String(format: "%02d:%02d", m, s)
    }

    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if secondsRemaining > 0 {
                secondsRemaining -= 1
            } else {
                timer.invalidate()
            }
        }
    }
}
