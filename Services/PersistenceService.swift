import Foundation

enum PersistenceService {
    private static let checklistKey = "checklistItems"
    private static let drillResultsKey = "drillResults"
    private static let notebookKey = "notebookEntries"
    private static let flashCardsKey = "flashCards"
    private static let topicStatsKey = "topicStats"
    private static let importedQuestionsKey = "importedQuestions"
    private static let duplicateStatsKey = "duplicateStats"

    static func loadChecklist() -> [ChecklistItem]? {
        load([ChecklistItem].self, key: checklistKey)
    }

    static func saveChecklist(_ items: [ChecklistItem]) {
        save(items, key: checklistKey)
    }

    static func loadDrillResults() -> [DrillResult] {
        load([DrillResult].self, key: drillResultsKey) ?? []
    }

    static func saveDrillResults(_ results: [DrillResult]) {
        save(results, key: drillResultsKey)
    }

    static func loadNotebook() -> [NotebookEntry] {
        load([NotebookEntry].self, key: notebookKey) ?? []
    }

    static func saveNotebook(_ entries: [NotebookEntry]) {
        save(entries, key: notebookKey)
    }

    static func loadFlashCards() -> [FlashCardItem] {
        load([FlashCardItem].self, key: flashCardsKey) ?? []
    }

    static func saveFlashCards(_ cards: [FlashCardItem]) {
        save(cards, key: flashCardsKey)
    }

    static func loadTopicStats() -> [TopicStats] {
        load([TopicStats].self, key: topicStatsKey) ?? []
    }

    static func saveTopicStats(_ stats: [TopicStats]) {
        save(stats, key: topicStatsKey)
    }

    static func loadImportedQuestions() -> [UnifiedQuestion] {
        load([UnifiedQuestion].self, key: importedQuestionsKey) ?? []
    }

    static func saveImportedQuestions(_ questions: [UnifiedQuestion]) {
        save(questions, key: importedQuestionsKey)
    }

    static func loadDuplicateStats() -> [DuplicateImportStats] {
        load([DuplicateImportStats].self, key: duplicateStatsKey) ?? []
    }

    static func saveDuplicateStats(_ stats: [DuplicateImportStats]) {
        save(stats, key: duplicateStatsKey)
    }

    static var doeCacheURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("doe_questions_cache.json")
    }

    private static func load<T: Decodable>(_ type: T.Type, key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }

    private static func save<T: Encodable>(_ value: T, key: String) {
        if let data = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

extension String {
    var normalizedForDuplicateCheck: String {
        lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .joined()
    }
}
