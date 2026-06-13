import SwiftUI

struct ProgressDashboardView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        NavigationStack {
            List {
                Section("This week") {
                    ForEach(Subject.allCases) { subject in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                SubjectBadge(subject: subject)
                                Spacer()
                                Text("\(Int(appState.weekAccuracy(subject: subject) * 100))%")
                                    .font(.subheadline.weight(.semibold))
                            }
                            ProgressView(value: appState.weekAccuracy(subject: subject))
                                .tint(PlatformColor.systemBlue)
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Lifetime accuracy") {
                    ForEach(Subject.allCases) { subject in
                        HStack {
                            Text(subject.rawValue)
                            Spacer()
                            Text("\(Int(appState.accuracy(for: subject, days: 3650) * 100))%")
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Last 7 days") {
                    ForEach(Subject.allCases) { subject in
                        HStack {
                            Text(subject.rawValue)
                            Spacer()
                            Text("\(Int(appState.accuracy(for: subject, days: 7) * 100))%")
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Last 30 days") {
                    ForEach(Subject.allCases) { subject in
                        HStack {
                            Text(subject.rawValue)
                            Spacer()
                            Text("\(Int(appState.accuracy(for: subject, days: 30) * 100))%")
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Questions answered") {
                    Text("\(appState.lifetimeQuestionsAnswered()) total")
                }

                Section("Flash cards due today") {
                    if appState.flashCardsDueToday.isEmpty {
                        Text("None due — great job!")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(appState.flashCardsDueToday) { card in
                            NavigationLink {
                                FlashCardReviewView(cards: appState.flashCardsDueToday)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    SubjectBadge(subject: card.subject)
                                    Text(card.prompt)
                                        .lineLimit(2)
                                }
                            }
                        }
                    }
                }

                EncyclopediaProgressSection()

                Section("Weakest topics") {
                    if appState.weakTopics.isEmpty {
                        Text("Keep drilling to identify weak areas.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(appState.weakTopics.prefix(5)) { t in
                            HStack {
                                Text(t.topic)
                                Spacer()
                                Text("\(Int(t.accuracy * 100))%")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                Section("Strongest topics") {
                    ForEach(appState.strongTopics.prefix(5)) { t in
                        HStack {
                            Text(t.topic)
                            Spacer()
                            Text("\(Int(t.accuracy * 100))%")
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Category checklist") {
                    Text("\(MSNSBStudyScope.checklistTopicCount) items — DOE Life Science & Physical Science topics for Bio · Chem · Phys.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    NavigationLink("View full checklist") {
                        ChecklistView()
                    }
                }

                Section("Flash cards needed") {
                    if appState.flashCards.isEmpty {
                        Text("Misses from drills appear here.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(appState.flashCards) { card in
                            NavigationLink {
                                FlashCardReviewView(cards: [card])
                            } label: {
                                Text(card.prompt)
                                    .lineLimit(2)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Progress")
            .largeNavigationBarTitle()
            .studyNavigationDestinations()
        }
    }
}

struct ChecklistView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        List {
            Section {
                Text(MSNSBStudyScope.introLong)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ForEach(Subject.allCases) { subject in
                Section(subject.rawValue) {
                    ForEach(appState.checklistItems.filter { $0.subject == subject }) { item in
                        Toggle(isOn: Binding(
                            get: { item.isCompleted },
                            set: { _ in appState.toggleChecklist(item) }
                        )) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.description)
                                    .font(.subheadline)
                                Text(item.category)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Checklist")
        .inlineNavigationBarTitle()
    }
}

struct FlashCardReviewView: View {
    @Environment(AppState.self) private var appState
    let cards: [FlashCardItem]

    @State private var index = 0
    @State private var revealed = false
    @State private var answerFeedback: DrillAnswerFeedback?

    private var currentPrompt: String? {
        cards.indices.contains(index) ? cards[index].prompt : nil
    }

    var body: some View {
        VStack(spacing: 24) {
            if cards.isEmpty {
                Text("No cards")
            } else {
                Text("Card \(index + 1) of \(cards.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                QuestionSpeechBar(
                    questionText: cards[index].prompt,
                    answerText: cards[index].answer,
                    showAnswerButton: revealed
                )

                Text(cards[index].prompt)
                    .font(.title2.weight(.semibold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                if revealed {
                    Text(cards[index].answer)
                        .foregroundStyle(.secondary)
                    if let answerFeedback {
                        DrillAnswerFeedbackPanel(
                            feedback: answerFeedback,
                            nextLabel: index + 1 < cards.count ? "Next card" : "Done",
                            onNext: advanceFromFeedback
                        )
                    } else {
                        HStack {
                            Button("Got it") { updateCard(correct: true) }
                                .buttonStyle(.borderedProminent)
                            Button("Missed") { updateCard(correct: false) }
                                .buttonStyle(.bordered)
                        }
                    }
                } else {
                    Button("Reveal") { revealed = true }
                        .buttonStyle(.borderedProminent)
                }
            }
            Spacer()
        }
        .padding(.top, 32)
        .navigationTitle("Flash Cards")
        .inlineNavigationBarTitle()
        .onDisappear { SpeechManager.shared.stop() }
        .questionSpeech(questionText: currentPrompt, speechToken: index)
        .onChange(of: revealed) { _, isRevealed in
            guard isRevealed, appState.readQuestionsAloud else { return }
            SpeechManager.shared.speakAnswer(
                cards[index].answer,
                rate: appState.speechRate,
                voiceIdentifier: appState.speechVoiceIdentifier
            )
        }
    }

    private func updateCard(correct: Bool) {
        guard let globalIndex = appState.flashCards.firstIndex(where: { $0.id == cards[index].id }) else { return }
        let pace = appState.flashCardReviewPace
        if correct {
            appState.flashCards[globalIndex].markCorrect(pace: pace)
            DrillFeedbackMessages.onCorrect(appState: appState)
        } else {
            appState.flashCards[globalIndex].markIncorrect(pace: pace)
            DrillFeedbackMessages.onIncorrect(appState: appState)
        }
        PersistenceService.saveFlashCards(appState.flashCards)
        let card = cards[index]
        let pseudoQuestion = UnifiedQuestion(
            id: card.id,
            source: .customCurriculum,
            category: card.subject.doeCategory,
            questionType: .tossUp,
            format: .shortAnswer,
            topic: card.topic,
            questionText: card.prompt,
            choices: [],
            answer: card.answer,
            sourceFile: "",
            sourceDescription: "Flash card"
        )
        answerFeedback = DrillFeedbackMessages.makeFeedback(
            correct: correct,
            question: pseudoQuestion,
            appState: appState
        )
    }

    private func advanceFromFeedback() {
        answerFeedback = nil
        revealed = false
        if index + 1 < cards.count {
            index += 1
        }
    }
}
