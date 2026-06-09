import Foundation

@MainActor
enum ElementProgressStore {
    private static let countsKey = "element_correct_counts"
    private static let seededKey = "element_flash_cards_seeded"

    static var correctCounts: [String: Int] {
        get {
            guard let data = UserDefaults.standard.data(forKey: countsKey),
                  let decoded = try? JSONDecoder().decode([String: Int].self, from: data) else {
                return [:]
            }
            return decoded
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: countsKey)
            }
        }
    }

    static var flashCardsSeeded: Bool {
        get { UserDefaults.standard.bool(forKey: seededKey) }
        set { UserDefaults.standard.set(newValue, forKey: seededKey) }
    }

    static func masteredSymbols(flashCards: [FlashCardItem]) -> Set<String> {
        var mastered = Set<String>()
        for element in ElementData.first20 {
            if (correctCounts[element.symbol] ?? 0) >= ElementData.masteryThreshold {
                mastered.insert(element.symbol)
                continue
            }
            if let card = flashCards.first(where: {
                $0.topic == ElementData.flashCardTopic && $0.prompt.contains(element.symbol)
            }), card.reviewStage == .review || card.reviewStage == .mastered {
                mastered.insert(element.symbol)
            }
        }
        return mastered
    }

    static func masteredCount(flashCards: [FlashCardItem]) -> Int {
        masteredSymbols(flashCards: flashCards).count
    }

    static func recordCorrect(symbol: String) {
        var counts = correctCounts
        counts[symbol, default: 0] += 1
        correctCounts = counts
    }

    static func importCounts(_ counts: [String: Int]) {
        correctCounts = counts
    }

    static func reset() {
        UserDefaults.standard.removeObject(forKey: countsKey)
        UserDefaults.standard.removeObject(forKey: seededKey)
    }

    static func updateChecklistIfNeeded(appState: AppState) {
        let mastered = masteredCount(flashCards: appState.flashCards)
        guard mastered >= ElementData.checklistMasteredCount else { return }
        guard let index = appState.checklistItems.firstIndex(where: {
            $0.subject == .chemistry && $0.description.contains("first 20 symbols")
        }) else { return }
        guard !appState.checklistItems[index].isCompleted else { return }
        appState.checklistItems[index].isCompleted = true
        PersistenceService.saveChecklist(appState.checklistItems)
    }
}
