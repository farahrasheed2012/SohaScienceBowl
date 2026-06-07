import Foundation
import SwiftUI

@MainActor
@Observable
final class AppState {
    var currentWeek: Int {
        didSet { UserDefaults.standard.set(currentWeek, forKey: "currentWeek") }
    }
    var currentPass: StudyPass {
        didSet { UserDefaults.standard.set(currentPass.rawValue, forKey: "currentPass") }
    }
    var showSessionTimer: Bool {
        didSet { UserDefaults.standard.set(showSessionTimer, forKey: "showSessionTimer") }
    }
    var parentReadsAloud: Bool {
        didSet { UserDefaults.standard.set(parentReadsAloud, forKey: "parentReadsAloud") }
    }
    var autoSyncScheduleFromCalendar: Bool {
        didSet { UserDefaults.standard.set(autoSyncScheduleFromCalendar, forKey: "autoSyncScheduleFromCalendar") }
    }
    var weekManuallySet: Bool {
        didSet { UserDefaults.standard.set(weekManuallySet, forKey: "weekManuallySet") }
    }
    var passManuallySet: Bool {
        didSet { UserDefaults.standard.set(passManuallySet, forKey: "passManuallySet") }
    }
    var appAppearance: AppAppearance {
        didSet { UserDefaults.standard.set(appAppearance.rawValue, forKey: "appAppearance") }
    }

    var checklistItems: [ChecklistItem]
    var drillResults: [DrillResult]
    var notebookEntries: [NotebookEntry]
    var flashCards: [FlashCardItem]
    var topicStats: [TopicStats]
    var importedQuestions: [UnifiedQuestion]
    var duplicateStats: [DuplicateImportStats]

    var doeStore = DOEQuestionStore.shared
    var encyclopedia = EncyclopediaStore()
    var isDOELoading = false

    init() {
        currentWeek = UserDefaults.standard.object(forKey: "currentWeek") as? Int ?? ScheduleConstants.weekNumber(for: Date())
        let passRaw = UserDefaults.standard.object(forKey: "currentPass") as? Int ?? 1
        currentPass = StudyPass(rawValue: passRaw) ?? .pass1
        showSessionTimer = UserDefaults.standard.object(forKey: "showSessionTimer") as? Bool ?? true
        parentReadsAloud = UserDefaults.standard.object(forKey: "parentReadsAloud") as? Bool ?? false
        autoSyncScheduleFromCalendar = UserDefaults.standard.object(forKey: "autoSyncScheduleFromCalendar") as? Bool ?? true
        weekManuallySet = UserDefaults.standard.object(forKey: "weekManuallySet") as? Bool ?? false
        passManuallySet = UserDefaults.standard.object(forKey: "passManuallySet") as? Bool ?? false
        let appearanceRaw = UserDefaults.standard.string(forKey: "appAppearance") ?? AppAppearance.dark.rawValue
        appAppearance = AppAppearance(rawValue: appearanceRaw) ?? .dark

        checklistItems = PersistenceService.loadChecklist() ?? SeedData.checklistItems
        drillResults = PersistenceService.loadDrillResults()
        notebookEntries = PersistenceService.loadNotebook()
        flashCards = PersistenceService.loadFlashCards()
        topicStats = PersistenceService.loadTopicStats()
        importedQuestions = PersistenceService.loadImportedQuestions()
        duplicateStats = PersistenceService.loadDuplicateStats()
        refreshScheduleFromCalendar()
        seedElementFlashCardsIfNeeded()
    }

    var elementFlashCards: [FlashCardItem] {
        flashCards.filter { $0.topic == ElementData.flashCardTopic }
    }

    var elementMasteredCount: Int {
        ElementProgressStore.masteredCount(flashCards: flashCards)
    }

    func seedElementFlashCardsIfNeeded() {
        guard !ElementProgressStore.flashCardsSeeded else { return }
        let newCards = ElementData.seedFlashCards(existing: flashCards)
        guard !newCards.isEmpty else {
            ElementProgressStore.flashCardsSeeded = true
            return
        }
        flashCards.append(contentsOf: newCards)
        PersistenceService.saveFlashCards(flashCards)
        ElementProgressStore.flashCardsSeeded = true
    }

    func recordElementDrillAnswer(symbol: String, correct: Bool) {
        if correct {
            ElementProgressStore.recordCorrect(symbol: symbol)
        }
        updateElementChecklistProgress()
    }

    func updateElementChecklistProgress() {
        ElementProgressStore.updateChecklistIfNeeded(appState: self)
    }

    var studyBlocks: [StudyBlock] { SeedData.studyBlocks }

    var curriculumQuestions: [UnifiedQuestion] {
        SeedData.tossupQuestions.map { $0.toUnified() }
    }

    var allUnifiedQuestions: [UnifiedQuestion] {
        curriculumQuestions + doeStore.doeQuestions.map { $0.toUnified() } + importedQuestions
    }

    var sohaUnifiedQuestions: [UnifiedQuestion] {
        allUnifiedQuestions
    }

    var doeUnifiedQuestions: [UnifiedQuestion] {
        doeStore.doeQuestions.map { $0.toUnified() }
    }

    func blocks(for week: Int, pass: StudyPass) -> [StudyBlock] {
        studyBlocks.filter { $0.week == week }.map { block in
            var copy = block
            copy.pass = pass
            return copy
        }
    }

    func todayBlocks(for date: Date = Date()) -> [StudyBlock] {
        guard let weekday = Weekday.from(date) else { return [] }
        return blocks(for: currentWeek, pass: currentPass).filter { $0.day == weekday }
    }

    func block(for week: Int, day: Weekday, subject: Subject) -> StudyBlock? {
        studyBlocks.first { $0.week == week && $0.day == day && $0.subject == subject }
    }

    func recallQuestions(for block: StudyBlock) -> [TossupQuestion] {
        let prevWeek = max(1, block.week - 1)
        let pool = SeedData.tossupQuestions.filter { $0.week == prevWeek && $0.subject == block.subject }
        return Array(pool.prefix(5))
    }

    func knowColdItems(for block: StudyBlock) -> [KnowColdItem] {
        block.knowCold.map { line in
            if let range = line.range(of: "("), line.hasSuffix(")") {
                let prompt = String(line[..<range.lowerBound]).trimmingCharacters(in: .whitespaces)
                let answer = String(line[range.upperBound..<line.index(before: line.endIndex)])
                return KnowColdItem(id: UUID(), prompt: prompt, answer: answer)
            }
            return KnowColdItem(id: UUID(), prompt: line, answer: "")
        }
    }

    func toggleChecklist(_ item: ChecklistItem) {
        guard let idx = checklistItems.firstIndex(where: { $0.id == item.id }) else { return }
        checklistItems[idx].isCompleted.toggle()
        PersistenceService.saveChecklist(checklistItems)
    }

    func recordDrill(subject: Subject?, week: Int?, total: Int, correct: Int, mode: String) {
        let result = DrillResult(id: UUID(), date: Date(), subject: subject, week: week, total: total, correct: correct, mode: mode)
        drillResults.append(result)
        PersistenceService.saveDrillResults(drillResults)
    }

    func recordAttempt(topic: String, subject: Subject, correct: Bool) {
        if let idx = topicStats.firstIndex(where: { $0.topic == topic && $0.subject == subject }) {
            topicStats[idx].attempts += 1
            if correct { topicStats[idx].correct += 1 }
        } else {
            topicStats.append(TopicStats(topic: topic, subject: subject, attempts: 1, correct: correct ? 1 : 0))
        }
        PersistenceService.saveTopicStats(topicStats)
    }

    var weakTopics: [TopicStats] {
        topicStats.filter(\.isWeak).sorted { $0.accuracy < $1.accuracy }
    }

    var strongTopics: [TopicStats] {
        topicStats.filter { $0.attempts >= 3 && $0.accuracy >= 0.8 }.sorted { $0.accuracy > $1.accuracy }
    }

    func addFlashCard(prompt: String, answer: String, topic: String, subject: Subject, sourceID: UUID? = nil) {
        let card = FlashCardItem(
            id: UUID(),
            prompt: prompt,
            answer: answer,
            topic: topic,
            subject: subject,
            reviewStage: .new,
            nextReviewDate: Date(),
            sourceQuestionID: sourceID
        )
        flashCards.append(card)
        PersistenceService.saveFlashCards(flashCards)
    }

    func addMissToFlashCards(question: UnifiedQuestion) {
        addFlashCard(prompt: question.questionText, answer: question.answer, topic: question.topic, subject: question.subject ?? .biology, sourceID: question.id)
    }

    func saveNotebook(subject: Subject, week: Int, topic: String, facts: [String], miss: String) {
        let entry = NotebookEntry(id: UUID(), date: Date(), subject: subject, week: week, threeFacts: facts, oneMiss: miss, blockTopic: topic)
        notebookEntries.append(entry)
        PersistenceService.saveNotebook(notebookEntries)
    }

    func weekAccuracy(subject: Subject) -> Double {
        let weekResults = drillResults.filter {
            Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .weekOfYear) && $0.subject == subject
        }
        let total = weekResults.reduce(0) { $0 + $1.total }
        let correct = weekResults.reduce(0) { $0 + $1.correct }
        guard total > 0 else { return 0 }
        return Double(correct) / Double(total)
    }

    func accuracy(for subject: Subject, days: Int) -> Double {
        let cutoff = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        let filtered = drillResults.filter { ($0.subject == subject || $0.subject == nil) && $0.date >= cutoff }
        let total = filtered.reduce(0) { $0 + $1.total }
        let correct = filtered.reduce(0) { $0 + $1.correct }
        guard total > 0 else { return 0 }
        return Double(correct) / Double(total)
    }

    func lifetimeQuestionsAnswered() -> Int {
        drillResults.reduce(0) { $0 + $1.total }
    }

    var flashCardsDueToday: [FlashCardItem] {
        flashCards.filter(\.isDue)
    }

    func fridaySummary() -> (commonMisses: [String], strongest: [String], weakest: [String]) {
        let recent = notebookEntries.suffix(10)
        let misses = recent.map(\.oneMiss).filter { !$0.isEmpty }
        let missCounts = Dictionary(misses.map { ($0, 1) }, uniquingKeysWith: +)
        let common = missCounts.sorted { $0.value > $1.value }.prefix(3).map(\.key)
        return (Array(common), strongTopics.prefix(3).map(\.topic), weakTopics.prefix(3).map(\.topic))
    }

    func loadDOEQuestions(forceReload: Bool = false) async {
        isDOELoading = true
        if forceReload {
            await doeStore.reload(forceDownload: false)
        } else {
            await doeStore.loadIfNeeded()
        }
        isDOELoading = false
    }

    func downloadDOEQuestions(fullCatalog: Bool = false) async {
        isDOELoading = true
        await doeStore.downloadPDFs(starterOnly: !fullCatalog)
        await doeStore.reload(forceDownload: false)
        isDOELoading = false
    }

    func importQuestions(from url: URL) {
        let ext = url.pathExtension.lowercased()
        let result: (questions: [UnifiedQuestion], stats: DuplicateImportStats)
        switch ext {
        case "pdf":
            result = QuestionImportService.shared.importPDF(at: url, existing: allUnifiedQuestions)
        case "json":
            result = QuestionImportService.shared.importJSON(at: url, existing: allUnifiedQuestions)
        case "csv":
            result = QuestionImportService.shared.importCSV(at: url, existing: allUnifiedQuestions)
        default:
            return
        }
        importedQuestions.append(contentsOf: result.questions)
        duplicateStats.append(result.stats)
        PersistenceService.saveImportedQuestions(importedQuestions)
        PersistenceService.saveDuplicateStats(duplicateStats)
    }

    func searchQuestions(query: String, subject: Subject?, source: QuestionSource?) -> [UnifiedQuestion] {
        let q = query.lowercased().trimmingCharacters(in: .whitespaces)
        return sohaUnifiedQuestions.filter { question in
            if let subject, question.subject != subject { return false }
            if let source, question.source != source { return false }
            if q.isEmpty { return true }
            return question.searchBlob.contains(q)
        }
    }

    func quizChoices(for question: UnifiedQuestion) -> [String] {
        if !question.choices.isEmpty {
            return question.choices.map { stripChoicePrefix($0) }
        }
        let distractors = sohaUnifiedQuestions
            .filter { $0.id != question.id && $0.subject == question.subject }
            .map(\.answer)
            .filter { $0 != question.answer }
        let unique = Array(Set(distractors)).shuffled().prefix(3)
        return (Array(unique) + [question.answer]).shuffled()
    }

    private func stripChoicePrefix(_ text: String) -> String {
        if let range = text.range(of: #"^[WXYZ]\)\s*"#, options: .regularExpression) {
            return String(text[range.upperBound...])
        }
        return text
    }
}
