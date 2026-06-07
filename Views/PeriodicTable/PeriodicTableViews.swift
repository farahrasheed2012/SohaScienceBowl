import SwiftUI

struct PeriodicTableDrillSetupView: View {
    @Environment(AppState.self) private var appState

    @State private var drillMode: ElementDrillMode = .mixed
    @State private var answerMode: ElementAnswerMode = .multipleChoice
    @State private var questionCount = 10

    private let counts = [10, 20]

    var body: some View {
        Form {
            Section {
                Text("\(appState.elementMasteredCount) / \(ElementData.first20.count) elements mastered")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section("Question style") {
                Picker("Style", selection: $drillMode) {
                    ForEach(ElementDrillMode.allCases) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
            }

            Section("Answer mode") {
                Picker("Mode", selection: $answerMode) {
                    ForEach(ElementAnswerMode.allCases) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Number of questions") {
                Picker("Count", selection: $questionCount) {
                    ForEach(counts, id: \.self) { Text("\($0)").tag($0) }
                }
                .pickerStyle(.segmented)
            }

            Section {
                NavigationLink("Start drill") {
                    PeriodicTableDrillView(
                        questions: ElementData.makeDrillQuestions(
                            count: questionCount,
                            mode: drillMode,
                            answerMode: answerMode
                        ),
                        answerMode: answerMode
                    )
                }
            }
        }
        .navigationTitle("Element Drill")
        .inlineNavigationBarTitle()
    }
}

struct PeriodicTableDrillView: View {
    @Environment(AppState.self) private var appState
    let questions: [ElementData.DrillQuestion]
    let answerMode: ElementAnswerMode

    @State private var index = 0
    @State private var selectedChoice: String?
    @State private var typedAnswer = ""
    @State private var showResult = false
    @State private var score = 0

    private var current: ElementData.DrillQuestion? {
        guard index < questions.count else { return nil }
        return questions[index]
    }

    var body: some View {
        Group {
            if questions.isEmpty {
                ContentUnavailableView("No questions", systemImage: "atom")
            } else if index >= questions.count {
                endView
            } else if let question = current {
                questionView(question)
            }
        }
        .navigationTitle("Element Drill")
        .inlineNavigationBarTitle()
    }

    private func questionView(_ question: ElementData.DrillQuestion) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Question \(index + 1) of \(questions.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(question.prompt)
                    .font(.title3.weight(.semibold))
                    .fixedSize(horizontal: false, vertical: true)

                if answerMode == .multipleChoice {
                    ForEach(question.choices, id: \.self) { choice in
                        choiceButton(choice, question: question)
                    }
                } else {
                    TextField("Your answer", text: $typedAnswer)
                        .textFieldStyle(.roundedBorder)
                        .disabled(showResult)
                        .autocorrectionDisabled()
                        .platformTextAutocapitalizationWords()
                    if showResult {
                        Text("Answer: \(question.correctAnswer)")
                            .font(.headline)
                            .foregroundStyle(isCurrentCorrect(question) ? PlatformColor.systemGreen : PlatformColor.systemRed)
                    } else {
                        Button("Submit") { submitTyped(question) }
                            .buttonStyle(.borderedProminent)
                            .disabled(typedAnswer.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }

                if showResult && answerMode == .multipleChoice {
                    Text(isCurrentCorrect(question) ? "Correct!" : "Answer: \(question.correctAnswer)")
                        .font(.headline)
                        .foregroundStyle(isCurrentCorrect(question) ? PlatformColor.systemGreen : PlatformColor.systemRed)
                    Button(index + 1 < questions.count ? "Next" : "See results") { advance(question) }
                        .buttonStyle(.borderedProminent)
                }

                if showResult && answerMode == .typeAnswer {
                    Button(index + 1 < questions.count ? "Next" : "See results") { advance(question) }
                        .buttonStyle(.borderedProminent)
                }
            }
            .padding(20)
        }
    }

    private func choiceButton(_ choice: String, question: ElementData.DrillQuestion) -> some View {
        let isSelected = selectedChoice == choice
        let isCorrect = showResult && choice == question.correctAnswer
        let isWrong = showResult && isSelected && choice != question.correctAnswer
        return Button {
            guard selectedChoice == nil else { return }
            selectedChoice = choice
            showResult = true
        } label: {
            HStack {
                Text(choice)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding(16)
            .background(PlatformColor.secondaryGroupedBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isCorrect ? PlatformColor.systemGreen
                            : (isWrong ? PlatformColor.systemRed : (isSelected ? Color.accentColor : .clear)),
                        lineWidth: 2
                    )
            )
        }
        .buttonStyle(.plain)
        .disabled(selectedChoice != nil)
    }

    private func submitTyped(_ question: ElementData.DrillQuestion) {
        showResult = true
    }

    private func isCurrentCorrect(_ question: ElementData.DrillQuestion) -> Bool {
        if answerMode == .multipleChoice {
            return selectedChoice == question.correctAnswer
        }
        return ElementData.matchesTypedAnswer(typedAnswer, question: question)
    }

    private func advance(_ question: ElementData.DrillQuestion) {
        let correct = isCurrentCorrect(question)
        if correct { score += 1 }
        appState.recordElementDrillAnswer(symbol: question.element.symbol, correct: correct)

        selectedChoice = nil
        typedAnswer = ""
        showResult = false
        index += 1

        if index >= questions.count {
            appState.recordDrill(
                subject: .chemistry,
                week: appState.currentWeek,
                total: questions.count,
                correct: score,
                mode: "Element symbols drill"
            )
        }
    }

    private var endView: some View {
        VStack(spacing: 20) {
            Text("Session complete!")
                .font(.title2.weight(.semibold))
            Text("\(score) / \(questions.count) correct")
                .font(.title3)
            Text("\(appState.elementMasteredCount) / \(ElementData.first20.count) elements mastered overall")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            NavigationLink("Practice again") {
                PeriodicTableDrillSetupView()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(24)
    }
}

struct ElementFlashCardDeckView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        Group {
            if appState.elementFlashCards.isEmpty {
                ContentUnavailableView(
                    "No element cards",
                    systemImage: "rectangle.on.rectangle",
                    description: Text("Element flash cards will appear after the app seeds the deck.")
                )
            } else {
                FlashCardReviewView(cards: appState.elementFlashCards)
            }
        }
        .navigationTitle("Element Flash Cards")
        .inlineNavigationBarTitle()
        .onDisappear {
            appState.updateElementChecklistProgress()
        }
    }
}

struct PeriodicTableReferenceView: View {
    @State private var selectedElement: Element?

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 4)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Tap an element to see its name, atomic number, and group. Focus on H through Ca for NSB.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                legendView

                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(ElementData.first20) { element in
                        Button {
                            selectedElement = element
                        } label: {
                            elementCell(element)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(20)
        }
        .navigationTitle("Periodic Table")
        .inlineNavigationBarTitle()
        .sheet(item: $selectedElement) { element in
            elementDetailSheet(element)
        }
    }

    private var legendView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(ElementCategory.allCases, id: \.self) { category in
                    HStack(spacing: 6) {
                        Circle()
                            .fill(category.color)
                            .frame(width: 10, height: 10)
                        Text(category.rawValue)
                            .font(.caption)
                    }
                }
            }
        }
    }

    private func elementCell(_ element: Element) -> some View {
        VStack(spacing: 4) {
            Text("\(element.atomicNumber)")
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(element.symbol)
                .font(.title2.weight(.bold))
            Text(element.name)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(element.category.color.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(element.category.color.opacity(0.35), lineWidth: 1)
        )
    }

    private func elementDetailSheet(_ element: Element) -> some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text(element.symbol)
                            .font(.largeTitle.weight(.bold))
                        Spacer()
                        Text(element.name)
                            .font(.title2)
                    }
                }
                Section("Details") {
                    LabeledContent("Atomic number", value: "\(element.atomicNumber)")
                    LabeledContent("Group", value: "\(element.group)")
                    LabeledContent("Period", value: "\(element.period)")
                    LabeledContent("Category", value: element.category.rawValue)
                }
                Section("NSB tip") {
                    Text(nsbTip(for: element))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle(element.symbol)
            .inlineNavigationBarTitle()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { selectedElement = nil }
                }
            }
        }
        .presentationDetents([.medium])
    }

    private func nsbTip(for element: Element) -> String {
        switch element.symbol {
        case "Na": return "Sodium — symbol Na, not S or N."
        case "Cl": return "Chlorine has 17 protons; symbol is Cl, not C or S."
        case "K": return "Potassium — symbol K (from Kalium), not P (phosphorus)."
        case "Fe": return "Iron is Fe — not in the first 20, but a common NSB stretch symbol."
        case "Ca": return "Calcium — symbol Ca; atomic number 20."
        default: return "\(element.name) is in Group \(element.group), Period \(element.period)."
        }
    }
}
