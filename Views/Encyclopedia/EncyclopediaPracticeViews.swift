import SwiftUI

struct EncyclopediaPracticeSetupView: View {
    @Environment(AppState.self) private var appState
    let mode: EncyclopediaPracticeMode
    var preferredTopicIds: [String]? = nil

    @State private var selectedSubject = "All Subjects"
    @State private var selectedDifficulty = "Both"
    @State private var questionCount = 10

    private let subjects = ["All Subjects"] + NSBSubject.allCases.map(\.rawValue)
    private let difficulties = ["Grade 6", "Grade 7", "Both"]
    private let counts = [10, 20, 30]

    var body: some View {
        Form {
            if preferredTopicIds == nil {
                Section("Subject") {
                    Picker("Subject", selection: $selectedSubject) {
                        ForEach(subjects, id: \.self) { Text($0).tag($0) }
                    }
                }
                Section("Difficulty") {
                    Picker("Difficulty", selection: $selectedDifficulty) {
                        ForEach(difficulties, id: \.self) { Text($0).tag($0) }
                    }
                    .pickerStyle(.segmented)
                }
            } else {
                Section {
                    Text("Questions from selected topic(s) only.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Section("Number of questions") {
                Picker("Count", selection: $questionCount) {
                    ForEach(counts, id: \.self) { Text("\($0)").tag($0) }
                }
                .pickerStyle(.segmented)
            }

            Section {
                NavigationLink("Start \(mode.title)") {
                    practiceDestination
                }
            }
        }
        .navigationTitle(preferredTopicIds == nil ? mode.title : "Practice topic")
        .inlineNavigationBarTitle()
    }

    private var fetchedQuestions: [NSBQuestion] {
        if let ids = preferredTopicIds, !ids.isEmpty {
            return appState.encyclopedia.questions(forTopicIds: ids, limit: questionCount, type: mode.questionType)
        }
        let diff: String? = switch selectedDifficulty {
        case "Grade 6": "grade6"
        case "Grade 7": "grade7"
        default: nil
        }
        let subj = selectedSubject == "All Subjects" ? nil : selectedSubject
        return appState.encyclopedia.questions(subject: subj, difficulty: diff, limit: questionCount, type: mode.questionType)
    }

    @ViewBuilder
    private var practiceDestination: some View {
        switch mode {
        case .multipleChoice:
            EncyclopediaMultipleChoiceView(questions: fetchedQuestions, practiceMode: mode)
        case .tossUpBonus:
            EncyclopediaTossUpView(questions: fetchedQuestions, practiceMode: mode)
        case .freeResponse:
            EncyclopediaFreeResponseView(questions: fetchedQuestions, practiceMode: mode)
        }
    }
}

// MARK: - Multiple Choice

struct EncyclopediaMultipleChoiceView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.themePalette) private var theme

    let questions: [NSBQuestion]
    let practiceMode: EncyclopediaPracticeMode

    @State private var currentIndex = 0
    @State private var selectedKey: String?
    @State private var showResult = false
    @State private var showExplanation = false
    @State private var score = 0
    @State private var missedTopicIds: [String] = []

    private var current: NSBQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    var body: some View {
        Group {
            if questions.isEmpty {
                ContentUnavailableView("No questions", systemImage: "questionmark.circle", description: Text("Try different settings."))
            } else if showExplanation, let q = current, let topic = appState.encyclopedia.topic(byId: q.topicId) {
                explanationView(topic: topic) { advance() }
            } else if let q = current {
                questionView(q)
            } else {
                EncyclopediaSessionEndView(
                    score: score,
                    total: questions.count,
                    missedTopicIds: missedTopicIds,
                    practiceMode: practiceMode
                )
            }
        }
        .navigationTitle("Multiple Choice")
        .inlineNavigationBarTitle()
        .background(theme.surface.ignoresSafeArea())
        .onDisappear { SpeechManager.shared.stop() }
    }

    private func questionView(_ q: NSBQuestion) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Question \(currentIndex + 1) of \(questions.count)")
                    .font(.system(size: ThemePalette.captionSize))
                    .foregroundStyle(theme.secondaryText)
                QuestionSpeechBar(
                    questionText: q.questionText,
                    answerText: q.correctAnswer,
                    showAnswerButton: showResult,
                    choiceTexts: encyclopediaSpeechChoices(for: q)
                )
                Text(q.questionText)
                    .font(.system(size: ThemePalette.bodySize, weight: .semibold))
                    .foregroundStyle(theme.primaryText)
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(theme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: AppLayout.cornerRadius))

                if let choices = q.answerChoices {
                    ForEach(["W", "X", "Y", "Z"], id: \.self) { key in
                        if let text = choices[key] {
                            optionButton(key: key, text: text, correct: q.correctAnswer, correctText: choices[q.correctAnswer] ?? q.correctAnswer)
                        }
                    }
                }

                if showResult {
                    Text(selectedKey == q.correctAnswer ? "Correct!" : "Answer: \(q.correctAnswer)")
                        .font(.system(size: ThemePalette.bodySize, weight: .semibold))
                        .foregroundStyle(selectedKey == q.correctAnswer ? theme.success : theme.wrong)
                        .accessibilityLabel(selectedKey == q.correctAnswer ? "Correct" : "Incorrect. Correct answer is \(q.correctAnswer)")
                    HStack {
                        Button("Show explanation") { showExplanation = true }
                            .accessibilityHint("Shows the encyclopedia article for this topic")
                        Button(currentIndex + 1 < questions.count ? "Next" : "Results") { advance() }
                            .buttonStyle(.borderedProminent)
                            .accessibilityHint(currentIndex + 1 < questions.count ? "Go to the next question" : "See your session results")
                    }
                }
            }
            .padding(24)
        }
        .questionSpeech(questionText: q.questionText, speechToken: currentIndex)
    }

    private func optionButton(key: String, text: String, correct: String, correctText: String) -> some View {
        let isSelected = selectedKey == key
        let showCorrect = showResult && key == correct
        let showWrong = showResult && isSelected && key != correct

        return Button {
            guard selectedKey == nil else { return }
            selectedKey = key
            if key == correct {
                score += 1
                HapticFeedback.impact(.light)
                if appState.readQuestionsAloud { QuestionSpeechHelper.speakPraiseIfNeeded(appState: appState) }
            } else {
                missedTopicIds.append(current?.topicId ?? "")
                HapticFeedback.error()
                if appState.readQuestionsAloud { QuestionSpeechHelper.speakEncouragementIfNeeded(appState: appState) }
            }
            showResult = true
        } label: {
            HStack {
                Text("\(key).")
                    .fontWeight(.semibold)
                    .foregroundStyle(theme.primaryText)
                    .frame(width: 24, alignment: .leading)
                Text(text)
                    .font(.system(size: ThemePalette.bodySize))
                    .foregroundStyle(theme.primaryText)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding(.vertical, 18)
            .padding(.horizontal, AppLayout.padding)
            .background(theme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppLayout.cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: AppLayout.cornerRadius)
                    .stroke(
                        showCorrect ? theme.success : (showWrong ? theme.wrong : (isSelected ? theme.accent : Color.clear)),
                        lineWidth: 3
                    )
            )
        }
        .buttonStyle(.plain)
        .disabled(selectedKey != nil)
        .accessibilityLabel("Option \(key): \(text)")
        .accessibilityHint(showResult ? (key == correct ? "Correct" : "Incorrect. Correct answer: \(correctText)") : "Double tap to select")
    }

    private func explanationView(topic: NSBTopic, onContinue: @escaping () -> Void) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Topic: \(topic.title)")
                    .font(.system(size: ThemePalette.titleSize, weight: .bold))
                    .foregroundStyle(theme.primaryText)
                Text(topic.whatIsIt)
                    .font(.system(size: ThemePalette.bodySize))
                    .foregroundStyle(theme.primaryText)
                Text(topic.howItWorks)
                    .font(.system(size: ThemePalette.captionSize))
                    .foregroundStyle(theme.secondaryText)
                Button(currentIndex + 1 < questions.count ? "Next question" : "See results", action: onContinue)
                    .font(.system(size: ThemePalette.bodySize, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(theme.accent)
                    .clipShape(RoundedRectangle(cornerRadius: ThemePalette.cornerRadius))
                    .buttonStyle(.plain)
                    .accessibilityLabel(currentIndex + 1 < questions.count ? "Next question" : "See results")
                    .accessibilityHint("Double tap to continue")
            }
            .padding(24)
        }
        .background(theme.surface.ignoresSafeArea())
    }

    private func advance() {
        showExplanation = false
        selectedKey = nil
        showResult = false
        if currentIndex + 1 < questions.count {
            currentIndex += 1
        } else {
            HapticFeedback.impact()
            appState.encyclopedia.recordSession(
                subject: current?.subject ?? "Mixed",
                mode: practiceMode.title,
                score: score,
                total: questions.count,
                missedTopicIds: missedTopicIds
            )
            currentIndex = questions.count
        }
    }
}

// MARK: - Toss-Up

struct EncyclopediaTossUpView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.themePalette) private var theme

    let questions: [NSBQuestion]
    let practiceMode: EncyclopediaPracticeMode

    @State private var currentIndex = 0
    @State private var selectedKey: String?
    @State private var showExplanation = false
    @State private var score = 0
    @State private var missedTopicIds: [String] = []

    private var current: NSBQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    var body: some View {
        Group {
            if questions.isEmpty {
                ContentUnavailableView("No questions", systemImage: "bolt.slash")
            } else if showExplanation, let q = current, let topic = appState.encyclopedia.topic(byId: q.topicId) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Topic: \(topic.title)")
                            .font(.system(size: ThemePalette.titleSize, weight: .bold))
                            .foregroundStyle(theme.primaryText)
                        Text(topic.whatIsIt)
                            .font(.system(size: ThemePalette.bodySize))
                            .foregroundStyle(theme.primaryText)
                        Button(currentIndex + 1 < questions.count ? "Next" : "Results") { advance() }
                            .font(.system(size: ThemePalette.bodySize, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(theme.accent)
                            .clipShape(RoundedRectangle(cornerRadius: ThemePalette.cornerRadius))
                            .buttonStyle(.plain)
                            .accessibilityLabel(currentIndex + 1 < questions.count ? "Next question" : "See results")
                    }
                    .padding(24)
                }
                .background(theme.surface.ignoresSafeArea())
            } else if let q = current {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Toss-up \(currentIndex + 1) of \(questions.count)")
                            .font(.system(size: ThemePalette.captionSize))
                            .foregroundStyle(theme.secondaryText)
                        QuestionSpeechBar(
                            questionText: q.questionText,
                            answerText: q.correctAnswer,
                            showAnswerButton: selectedKey != nil,
                            choiceTexts: encyclopediaSpeechChoices(for: q)
                        )
                        Text(q.questionText)
                            .font(.system(size: ThemePalette.bodySize, weight: .semibold))
                            .foregroundStyle(theme.primaryText)
                        if let choices = q.answerChoices {
                            ForEach(["W", "X", "Y", "Z"], id: \.self) { key in
                                if let text = choices[key] {
                                    tossUpOptionButton(key: key, text: text, question: q, correctText: choices[q.correctAnswer] ?? q.correctAnswer)
                                }
                            }
                        }
                    }
                    .padding(24)
                }
                .questionSpeech(questionText: q.questionText, speechToken: currentIndex)
            } else {
                EncyclopediaSessionEndView(
                    score: score,
                    total: questions.count,
                    missedTopicIds: missedTopicIds,
                    practiceMode: practiceMode
                )
            }
        }
        .navigationTitle("Toss-Up & Bonus")
        .inlineNavigationBarTitle()
        .background(theme.surface.ignoresSafeArea())
        .onDisappear { SpeechManager.shared.stop() }
    }

    private func tossUpOptionButton(key: String, text: String, question: NSBQuestion, correctText: String) -> some View {
        Button {
            guard selectedKey == nil else { return }
            selectedKey = key
            if key == question.correctAnswer {
                score += 1
                HapticFeedback.impact(.light)
                if appState.readQuestionsAloud { QuestionSpeechHelper.speakPraiseIfNeeded(appState: appState) }
            } else {
                missedTopicIds.append(question.topicId)
                HapticFeedback.error()
                if appState.readQuestionsAloud { QuestionSpeechHelper.speakEncouragementIfNeeded(appState: appState) }
            }
            showExplanation = true
        } label: {
            HStack {
                Text("\(key).").fontWeight(.semibold).foregroundStyle(theme.primaryText)
                Text(text)
                    .font(.system(size: ThemePalette.bodySize))
                    .foregroundStyle(theme.primaryText)
                Spacer()
            }
            .padding(16)
            .background(theme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppLayout.cornerRadius))
        }
        .buttonStyle(.plain)
        .disabled(selectedKey != nil)
        .accessibilityLabel("Option \(key): \(text)")
        .accessibilityHint("Double tap to buzz in with this answer")
    }

    private func advance() {
        showExplanation = false
        selectedKey = nil
        if currentIndex + 1 < questions.count {
            currentIndex += 1
        } else {
            HapticFeedback.impact()
            appState.encyclopedia.recordSession(
                subject: current?.subject ?? "Mixed",
                mode: practiceMode.title,
                score: score,
                total: questions.count,
                missedTopicIds: missedTopicIds
            )
            currentIndex = questions.count
        }
    }
}

// MARK: - Free Response

struct EncyclopediaFreeResponseView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.themePalette) private var theme

    let questions: [NSBQuestion]
    let practiceMode: EncyclopediaPracticeMode

    @State private var currentIndex = 0
    @State private var userAnswer = ""
    @State private var showAnswer = false
    @State private var showExplanation = false
    @State private var score = 0
    @State private var missedTopicIds: [String] = []

    private var current: NSBQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    var body: some View {
        Group {
            if questions.isEmpty {
                ContentUnavailableView("No questions", systemImage: "keyboard")
            } else if showExplanation, let topic = current.flatMap({ appState.encyclopedia.topic(byId: $0.topicId) }) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Topic: \(topic.title)")
                            .font(.system(size: ThemePalette.titleSize, weight: .bold))
                            .foregroundStyle(theme.primaryText)
                        Text(topic.whatIsIt)
                            .font(.system(size: ThemePalette.bodySize))
                            .foregroundStyle(theme.primaryText)
                        Button(currentIndex + 1 < questions.count ? "Next" : "Results") { advance() }
                            .font(.system(size: ThemePalette.bodySize, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(theme.accent)
                            .clipShape(RoundedRectangle(cornerRadius: ThemePalette.cornerRadius))
                            .buttonStyle(.plain)
                    }
                    .padding(24)
                }
                .background(theme.surface.ignoresSafeArea())
            } else if let q = current {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Question \(currentIndex + 1) of \(questions.count)")
                            .font(.system(size: ThemePalette.captionSize))
                            .foregroundStyle(theme.secondaryText)
                        QuestionSpeechBar(
                            questionText: q.questionText,
                            answerText: q.correctAnswer,
                            showAnswerButton: showAnswer
                        )
                        Text(q.questionText)
                            .font(.system(size: ThemePalette.bodySize, weight: .semibold))
                            .foregroundStyle(theme.primaryText)
                        TextField("Your answer", text: $userAnswer)
                            .textFieldStyle(.roundedBorder)
                            .font(.system(size: ThemePalette.bodySize))
                            .disabled(showAnswer)
                            .accessibilityLabel("Your answer")
                        if showAnswer {
                            Text("Correct answer: \(q.correctAnswer)")
                                .font(.system(size: ThemePalette.bodySize, weight: .semibold))
                                .foregroundStyle(theme.primaryText)
                                .accessibilityLabel("Correct answer: \(q.correctAnswer)")
                            HStack {
                                Button("I got it right") {
                                    score += 1
                                    HapticFeedback.success()
                                    if appState.readQuestionsAloud { QuestionSpeechHelper.speakPraiseIfNeeded(appState: appState) }
                                    showExplanation = true
                                }
                                .foregroundStyle(theme.success)
                                .accessibilityHint("Mark this question as correct")
                                Button("I got it wrong") {
                                    missedTopicIds.append(q.topicId)
                                    HapticFeedback.error()
                                    if appState.readQuestionsAloud { QuestionSpeechHelper.speakEncouragementIfNeeded(appState: appState) }
                                    showExplanation = true
                                }
                                .foregroundStyle(theme.wrong)
                                .accessibilityHint("Mark this question as incorrect")
                            }
                        } else {
                            Button("Submit") { showAnswer = true }
                                .buttonStyle(.borderedProminent)
                                .disabled(userAnswer.trimmingCharacters(in: .whitespaces).isEmpty)
                                .accessibilityHint("Reveal the correct answer to compare")
                        }
                    }
                    .padding(24)
                }
                .questionSpeech(questionText: q.questionText, speechToken: currentIndex)
            } else {
                EncyclopediaSessionEndView(
                    score: score,
                    total: questions.count,
                    missedTopicIds: missedTopicIds,
                    practiceMode: practiceMode,
                    scoreSubtitle: "(self-reported)"
                )
            }
        }
        .navigationTitle("Free Response")
        .inlineNavigationBarTitle()
        .background(theme.surface.ignoresSafeArea())
        .onDisappear { SpeechManager.shared.stop() }
    }

    private func advance() {
        showExplanation = false
        showAnswer = false
        userAnswer = ""
        if currentIndex + 1 < questions.count {
            currentIndex += 1
        } else {
            HapticFeedback.impact()
            appState.encyclopedia.recordSession(
                subject: current?.subject ?? "Mixed",
                mode: practiceMode.title,
                score: score,
                total: questions.count,
                missedTopicIds: missedTopicIds
            )
            currentIndex = questions.count
        }
    }
}

private func encyclopediaSpeechChoices(for q: NSBQuestion) -> [(key: String, text: String)] {
    guard let choices = q.answerChoices else { return [] }
    return ["W", "X", "Y", "Z"].compactMap { key in
        choices[key].map { (key, $0) }
    }
}
