import SwiftUI

struct PeriodicTableRootView: View {
    @Environment(AppState.self) private var appState

    private var masteryProgress: Double {
        guard ElementData.first20.count > 0 else { return 0 }
        return Double(appState.elementMasteredCount) / Double(ElementData.first20.count)
    }

    var body: some View {
        NavigationStack {
            List {
                progressSection
                learnSection
                practiceSection
                fullTableSection
                nsbTipsSection
            }
            .platformListStyle()
            .navigationTitle("Periodic Table")
            .largeNavigationBarTitle()
            .studyNavigationDestinations()
        }
    }

    private var progressSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Hi, \(appState.studentName)!")
                            .font(.headline)
                        Text("Master H through Ca — symbols, names, and atomic numbers for Science Bowl chemistry toss-ups.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer(minLength: 12)
                    ZStack {
                        Circle()
                            .stroke(Color.secondary.opacity(0.2), lineWidth: 6)
                        Circle()
                            .trim(from: 0, to: masteryProgress)
                            .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                        Text("\(appState.elementMasteredCount)")
                            .font(.title3.weight(.bold))
                    }
                    .frame(width: 56, height: 56)
                    .accessibilityLabel("\(appState.elementMasteredCount) of \(ElementData.first20.count) elements mastered")
                }

                ProgressView(value: masteryProgress)
                    .tint(Color.accentColor)
                Text("\(appState.elementMasteredCount) / \(ElementData.first20.count) elements mastered · checklist completes at \(ElementData.checklistMasteredCount)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
        }
    }

    private var learnSection: some View {
        Section("Learn") {
            NavigationLink(value: StudyNavigationRoute.periodicTableReference) {
                Label("First 20 elements (H–Ca)", systemImage: "square.grid.3x3.fill")
            }
            Text("Tap each element for symbol, atomic number, group, and NSB tips.")
                .font(.caption)
                .foregroundStyle(.secondary)

            NavigationLink(value: StudyNavigationRoute.periodicTableInteractive) {
                Label("Full periodic table (118 elements)", systemImage: "tablecells.fill")
            }
            Text("Interactive study grid with flash cards and quiz — all elements.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var practiceSection: some View {
        Section("Practice") {
            NavigationLink(value: StudyNavigationRoute.elementFlashCards) {
                Label("Element flash cards", systemImage: "rectangle.on.rectangle")
            }
            NavigationLink(value: StudyNavigationRoute.periodicTableDrill) {
                Label("Element drill", systemImage: "atom")
            }
            Text("Symbol ↔ name ↔ atomic number · multiple choice or type the answer.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var fullTableSection: some View {
        Section("Print & reference") {
            NavigationLink(value: StudyNavigationRoute.periodicTablePrint) {
                Label("Printable reference sheet", systemImage: "doc.richtext")
            }
            Text("Full grid plus drill sheet — good for offline review.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var nsbTipsSection: some View {
        Section("NSB quick tips") {
            Label("No periodic table is allowed during competition.", systemImage: "exclamationmark.triangle.fill")
                .font(.subheadline)
                .foregroundStyle(.orange)
            VStack(alignment: .leading, spacing: 8) {
                tipRow("Na", "Sodium — not S or N")
                tipRow("K", "Potassium — not P (phosphorus)")
                tipRow("Cl", "Chlorine — Cl, not C")
                tipRow("Ca", "Calcium — atomic number 20")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
    }

    private func tipRow(_ symbol: String, _ detail: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(symbol)
                .font(.caption.weight(.bold))
                .frame(width: 28, alignment: .leading)
            Text(detail)
        }
    }
}

struct PeriodicTableInteractiveView: View {
    var body: some View {
        Group {
            if let url = ScheduleHTMLResources.url(for: .periodicTableStudy) {
                HTMLWebView(url: url, scrollToWeek: nil)
            } else {
                ContentUnavailableView(
                    "Study table missing",
                    systemImage: "tablecells",
                    description: Text("Rebuild the app to include periodic-table-study.html.")
                )
            }
        }
        .navigationTitle("118 Elements")
        .inlineNavigationBarTitle()
    }
}

struct PeriodicTablePrintView: View {
    var body: some View {
        Group {
            if let url = ScheduleHTMLResources.url(for: .periodicTablePrint) {
                HTMLWebView(url: url, scrollToWeek: nil)
            } else {
                ContentUnavailableView(
                    "Print sheet missing",
                    systemImage: "doc.richtext",
                    description: Text("Rebuild the app to include periodic-table-print.html.")
                )
            }
        }
        .navigationTitle("Printable Table")
        .inlineNavigationBarTitle()
    }
}

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
