import Foundation

// MARK: - Study badges

enum StudyBadge: String, CaseIterable, Identifiable {
    case streak3
    case streak7
    case elements18
    case checklistHalf
    case drills50
    case encyclopediaStreak5

    var id: String { rawValue }

    var title: String {
        switch self {
        case .streak3: return "3-day streak"
        case .streak7: return "7-day streak"
        case .elements18: return "18 elements mastered"
        case .checklistHalf: return "Half the checklist"
        case .drills50: return "50 drill questions"
        case .encyclopediaStreak5: return "5-day Learn streak"
        }
    }

    var systemImage: String {
        switch self {
        case .streak3, .streak7, .encyclopediaStreak5: return "flame.fill"
        case .elements18: return "atom"
        case .checklistHalf: return "checklist"
        case .drills50: return "bolt.fill"
        }
    }

    @MainActor
    func isEarned(appState: AppState) -> Bool {
        switch self {
        case .streak3: return appState.studyStreakDays >= 3
        case .streak7: return appState.studyStreakDays >= 7
        case .elements18: return appState.elementMasteredCount >= 18
        case .checklistHalf:
            let done = appState.checklistItems.filter(\.isCompleted).count
            return done >= appState.checklistItems.count / 2
        case .drills50: return appState.lifetimeQuestionsAnswered() >= 50
        case .encyclopediaStreak5: return appState.encyclopedia.currentStreak >= 5
        }
    }
}

// MARK: - Next up & weak-area review

extension AppState {
    struct NextUpItem: Hashable {
        var title: String
        var subtitle: String
        var duration: String
        var route: StudyNavigationRoute?
    }

    private static let lastStudyDateKey = "studyStreakLastDate"
    private static let streakDaysKey = "studyStreakDays"

    func clearAllProgress() {
        checklistItems = SeedData.checklistItems
        drillResults = []
        notebookEntries = []
        flashCards = []
        topicStats = []
        importedQuestions = []
        duplicateStats = []

        encyclopedia.resetProgress()
        ElementProgressStore.reset()
        textbookReading.reset()

        UserDefaults.standard.removeObject(forKey: Self.lastStudyDateKey)
        UserDefaults.standard.removeObject(forKey: Self.streakDaysKey)

        weekManuallySet = false
        passManuallySet = false
        resetScheduleToCalendar()

        PersistenceService.saveChecklist(checklistItems)
        PersistenceService.saveDrillResults(drillResults)
        PersistenceService.saveNotebook(notebookEntries)
        PersistenceService.saveFlashCards(flashCards)
        PersistenceService.saveTopicStats(topicStats)
        PersistenceService.saveImportedQuestions(importedQuestions)
        PersistenceService.saveDuplicateStats(duplicateStats)

        seedElementFlashCardsIfNeeded()
    }

    var studyStreakDays: Int {
        UserDefaults.standard.integer(forKey: Self.streakDaysKey)
    }

    func recordStudyActivity(on date: Date = Date()) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: date)
        let last = UserDefaults.standard.object(forKey: Self.lastStudyDateKey) as? Date
        var streak = studyStreakDays

        if let last {
            let lastDay = calendar.startOfDay(for: last)
            let days = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0
            if days == 0 { return }
            if days == 1 { streak += 1 } else { streak = 1 }
        } else {
            streak = max(1, streak)
        }

        UserDefaults.standard.set(today, forKey: Self.lastStudyDateKey)
        UserDefaults.standard.set(streak, forKey: Self.streakDaysKey)
    }

    func earnedBadges() -> [StudyBadge] {
        StudyBadge.allCases.filter { $0.isEarned(appState: self) }
    }

    func nextUpItem(for date: Date = Date()) -> NextUpItem? {
        if !flashCardsDueToday.isEmpty {
            return NextUpItem(
                title: "Review flash cards",
                subtitle: "\(flashCardsDueToday.count) due today",
                duration: "10 min",
                route: .weakAreaReview
            )
        }

        if let weekday = Weekday.from(date) {
            if let block = todayBlocks(for: date).first {
                return NextUpItem(
                    title: "Next: \(block.day.shortName) \(block.subject.rawValue)",
                    subtitle: "\(block.displayChapter) · \(block.primaryTopic)",
                    duration: "30 min",
                    route: .fullSession(block)
                )
            }

            if let math = ScheduleOpenStaxCatalog.mathReading(week: currentWeek, day: weekday) {
                return NextUpItem(
                    title: "Next: Math · \(math.title)",
                    subtitle: math.larBackupLine,
                    duration: "30 min",
                    route: .mathTopicDetail(MathTopicRef(week: currentWeek, day: weekday))
                )
            }
        }

        if let suggestion = weekendSuggestion(for: date) {
            return suggestion
        }

        return nil
    }

    func weekendSuggestion(for date: Date = Date()) -> NextUpItem? {
        guard Weekday.from(date) == nil else { return nil }

        if let weak = weakTopics.first {
            return NextUpItem(
                title: "Weekend review: \(weak.topic)",
                subtitle: "\(Int(weak.accuracy * 100))% accuracy — optional",
                duration: "15 min",
                route: .weakAreaReview
            )
        }

        if elementMasteredCount < 18 {
            return NextUpItem(
                title: "Weekend: element deck",
                subtitle: "\(elementMasteredCount)/\(ElementData.first20.count) mastered",
                duration: "10 min",
                route: .elementFlashCards
            )
        }

        return NextUpItem(
            title: "Weekend mock round",
            subtitle: "Light practice — quiz this week",
            duration: "20 min",
            route: .planDrill(.thisWeek(week: currentWeek))
        )
    }

    func todaysWeakAreaQuestions(limit: Int = 10) -> [UnifiedQuestion] {
        var pool: [UnifiedQuestion] = []

        for card in flashCardsDueToday.prefix(5) {
            pool.append(UnifiedQuestion(
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
                sourceDescription: "Flash card review",
                setNumber: nil,
                roundNumber: nil,
                sourceYear: nil
            ))
        }

        for stat in weakTopics.prefix(3) {
            let matches = SeedData.tossupQuestions
                .filter { $0.subject == stat.subject && $0.topic == stat.topic }
                .map { $0.toUnified() }
            pool.append(contentsOf: matches)
        }

        if pool.count < limit {
            pool.append(contentsOf: doeUnifiedQuestions.shuffled().prefix(limit - pool.count))
        }

        return Array(dedupeWeakReview(pool).shuffled().prefix(limit))
    }

    private func dedupeWeakReview(_ questions: [UnifiedQuestion]) -> [UnifiedQuestion] {
        var seen = Set<String>()
        var result: [UnifiedQuestion] = []
        for q in questions {
            let key = q.normalizedText
            if seen.contains(key) { continue }
            seen.insert(key)
            result.append(q)
        }
        return result
    }
}
