import Foundation

@MainActor
@Observable
final class MathProgressService {
    static let shared = MathProgressService()

    private let storageKey = "mathProgress_v1"
    private let dailyXPKey = "mathDailyXP_v1"
    private let dailyXPDateKey = "mathDailyXPDate_v1"
    private let drillStreakKey = "mathDrillStreakBest_v1"
    private let lastDrillDayKey = "mathLastDrillDay_v1"
    private let mathStreakDaysKey = "mathStreakDays_v1"

    private(set) var topicProgress: [String: TopicProgress] = [:]
    private(set) var mathXPTotal: Int = 0
    private(set) var mathStreakDays: Int = 0
    private(set) var longestDrillStreak: Int = 0
    private(set) var todayXP: Int = 0

    struct TopicProgress: Codable, Hashable {
        var masteryLevel: MasteryLevel = .unseen
        var lastPracticed: Date?
        var accuracyRate: Double = 0
        var totalDrillsAttempted: Int = 0
        var totalDrillsCorrect: Int = 0
        var currentStreak: Int = 0
        var recentResults: [Bool] = []
    }

    struct AnswerRecord {
        let topicCode: String
        let difficulty: DrillDifficulty
        let correct: Bool
    }

    private init() {
        load()
        refreshTodayXP()
    }

    // MARK: - Public API

    func mergedTopics() -> [MathTopic] {
        POT6TopicRegistry.allTopics.map { base in
            var topic = base
            if let progress = topicProgress[base.code] {
                topic.masteryLevel = progress.masteryLevel
                topic.lastPracticed = progress.lastPracticed
                topic.accuracyRate = progress.accuracyRate
            }
            return topic
        }
    }

    func topic(for code: String) -> MathTopic? {
        mergedTopics().first { $0.code == code }
    }

    var weakTopics: [MathTopic] {
        mergedTopics()
            .filter { attemptCount(for: $0.code) > 0 && $0.accuracyRate < 0.6 }
            .sorted { $0.accuracyRate < $1.accuracyRate }
    }

    var dueForReview: [MathTopic] {
        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date()
        return mergedTopics()
            .filter { topic in
                topic.masteryLevel == .mastered
                    && (topic.lastPracticed ?? .distantPast) < threeDaysAgo
            }
            .sorted { ($0.lastPracticed ?? .distantPast) < ($1.lastPracticed ?? .distantPast) }
    }

    var masteredCount: Int {
        mergedTopics().filter { !$0.isCompetitionOnly && $0.masteryLevel == .mastered }.count
    }

    var overallAccuracy: Double {
        let topics = mergedTopics().filter { attemptCount(for: $0.code) > 0 }
        guard !topics.isEmpty else { return 0 }
        return topics.reduce(0.0) { $0 + $1.accuracyRate } / Double(topics.count)
    }

    func categoryAccuracy(_ category: POT6Category) -> Double {
        let topics = mergedTopics().filter { $0.pot6Category == category && attemptCount(for: $0.code) > 0 }
        guard !topics.isEmpty else { return 0 }
        return topics.reduce(0.0) { $0 + $1.accuracyRate } / Double(topics.count)
    }

    func attemptCount(for code: String) -> Int {
        topicProgress[code]?.totalDrillsAttempted ?? 0
    }

    func recordAnswers(_ records: [AnswerRecord]) {
        guard !records.isEmpty else { return }

        for record in records {
            var progress = topicProgress[record.topicCode] ?? TopicProgress()
            progress.totalDrillsAttempted += 1
            progress.recentResults.append(record.correct)
            if progress.recentResults.count > 20 {
                progress.recentResults = Array(progress.recentResults.suffix(20))
            }

            if record.correct {
                progress.totalDrillsCorrect += 1
                progress.currentStreak += 1
                let xp = record.difficulty.xpValue
                mathXPTotal += xp
                todayXP += xp
                XPManager.shared.awardCustom(points: xp)
                advanceMastery(for: &progress)
            } else {
                progress.currentStreak = 0
                regressMastery(for: &progress)
            }

            let correctCount = progress.recentResults.filter { $0 }.count
            progress.accuracyRate = Double(correctCount) / Double(progress.recentResults.count)
            progress.lastPracticed = Date()
            topicProgress[record.topicCode] = progress
            longestDrillStreak = max(longestDrillStreak, progress.currentStreak)
        }

        recordDailyActivity()
        save()
        refreshTodayXP()
    }

    func recommendedDailyTopics(limit: Int = 3) -> [MathTopic] {
        var picks: [MathTopic] = []
        picks.append(contentsOf: weakTopics.prefix(2))
        for topic in dueForReview where picks.count < limit {
            if !picks.contains(where: { $0.code == topic.code }) {
                picks.append(topic)
            }
        }
        if picks.count < limit {
            let unseen = mergedTopics().filter { $0.masteryLevel == .unseen }
            for topic in unseen where picks.count < limit {
                picks.append(topic)
            }
        }
        return Array(picks.prefix(limit))
    }

    func buildDailyDrillQueue(count: Int = 15) -> [MathDrillQuestion] {
        buildDrillQueue(count: count, topicFilter: Set(POT6AlgebraCatalog.schoolCodes))
    }

    func geometryTrackTopics() -> [MathTopic] {
        let codes = Set(POT6GeometryCatalog.schoolCodes)
        return mergedTopics().filter { codes.contains($0.code) }
    }

    var geometryMasteredCount: Int {
        geometryTrackTopics().filter { $0.masteryLevel == .mastered }.count
    }

    func buildGeometryDrillQueue(count: Int = 15) -> [MathDrillQuestion] {
        buildDrillQueue(count: count, topicFilter: Set(POT6GeometryCatalog.schoolCodes))
    }

    private func buildDrillQueue(count: Int, topicFilter: Set<String>?) -> [MathDrillQuestion] {
        func matches(_ topic: MathTopic) -> Bool {
            guard let filter = topicFilter else { return true }
            return filter.contains(topic.code)
        }

        let weak = weakTopics.filter { matches($0) }
        let due = dueForReview.filter { matches($0) }
        var weakCount = Int(Double(count) * 0.6)
        var dueCount = count - weakCount
        if due.isEmpty {
            weakCount = count
            dueCount = 0
        } else if weak.isEmpty {
            dueCount = count
            weakCount = 0
        }

        var queue: [MathDrillQuestion] = []
        queue.append(contentsOf: questions(from: weak, count: weakCount))
        queue.append(contentsOf: questions(from: due, count: dueCount))

        if queue.count < count {
            let extras = mergedTopics().filter { t in
                matches(t) && !queue.contains(where: { $0.topicCode == t.code })
            }
            queue.append(contentsOf: questions(from: extras, count: count - queue.count))
        }

        return Array(queue.shuffled().prefix(count))
    }

    func resetProgress() {
        topicProgress = [:]
        mathXPTotal = 0
        mathStreakDays = 0
        longestDrillStreak = 0
        todayXP = 0
        UserDefaults.standard.removeObject(forKey: storageKey)
        UserDefaults.standard.removeObject(forKey: dailyXPKey)
        UserDefaults.standard.removeObject(forKey: dailyXPDateKey)
        UserDefaults.standard.removeObject(forKey: drillStreakKey)
        UserDefaults.standard.removeObject(forKey: lastDrillDayKey)
        UserDefaults.standard.removeObject(forKey: mathStreakDaysKey)
    }

    // MARK: - Private

    private func questions(from topics: [MathTopic], count: Int) -> [MathDrillQuestion] {
        guard count > 0, !topics.isEmpty else { return [] }
        var result: [MathDrillQuestion] = []
        var idx = 0
        while result.count < count {
            let topic = topics[idx % topics.count]
            let difficulties: [DrillDifficulty] = [.scaffold, .standard, .challenge]
            let diff = difficulties[result.count % difficulties.count]
            if let q = POT6DrillBank.randomQuestion(for: topic.code, difficulty: diff)
                ?? POT6DrillBank.questions(for: topic.code).randomElement() {
                result.append(q)
            }
            idx += 1
            if idx > count * 4 { break }
        }
        return result
    }

    private func advanceMastery(for progress: inout TopicProgress) {
        guard progress.currentStreak >= 3 else { return }
        switch progress.masteryLevel {
        case .unseen: progress.masteryLevel = .learning
        case .learning: progress.masteryLevel = .review
        case .review: progress.masteryLevel = .mastered
        case .mastered: break
        }
        progress.currentStreak = 0
    }

    private func regressMastery(for progress: inout TopicProgress) {
        switch progress.masteryLevel {
        case .mastered: progress.masteryLevel = .review
        case .review: progress.masteryLevel = .learning
        case .learning, .unseen: progress.masteryLevel = .learning
        }
    }

    private func recordDailyActivity() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        XPManager.shared.recordActivity(on: today)

        if let lastRaw = UserDefaults.standard.object(forKey: lastDrillDayKey) as? Date {
            let last = calendar.startOfDay(for: lastRaw)
            let delta = calendar.dateComponents([.day], from: last, to: today).day ?? 0
            switch delta {
            case 0: break
            case 1: mathStreakDays += 1
            default: mathStreakDays = 1
            }
        } else {
            mathStreakDays = 1
        }
        UserDefaults.standard.set(today, forKey: lastDrillDayKey)
        UserDefaults.standard.set(todayXP, forKey: dailyXPKey)
        UserDefaults.standard.set(today, forKey: dailyXPDateKey)
    }

    private func refreshTodayXP() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        if let storedDate = UserDefaults.standard.object(forKey: dailyXPDateKey) as? Date,
           calendar.isDate(storedDate, inSameDayAs: today) {
            todayXP = UserDefaults.standard.integer(forKey: dailyXPKey)
        } else {
            todayXP = 0
            UserDefaults.standard.set(0, forKey: dailyXPKey)
            UserDefaults.standard.set(today, forKey: dailyXPDateKey)
        }
    }

    private struct StoredState: Codable {
        var topicProgress: [String: TopicProgress]
        var mathXPTotal: Int
        var mathStreakDays: Int
        var longestDrillStreak: Int
    }

    private func load() {
        mathStreakDays = UserDefaults.standard.integer(forKey: mathStreakDaysKey)
        longestDrillStreak = UserDefaults.standard.integer(forKey: drillStreakKey)
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let state = try? JSONDecoder().decode(StoredState.self, from: data) else { return }
        topicProgress = state.topicProgress
        mathXPTotal = state.mathXPTotal
        mathStreakDays = state.mathStreakDays
        longestDrillStreak = state.longestDrillStreak
    }

    private func save() {
        let state = StoredState(
            topicProgress: topicProgress,
            mathXPTotal: mathXPTotal,
            mathStreakDays: mathStreakDays,
            longestDrillStreak: longestDrillStreak
        )
        if let data = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
        UserDefaults.standard.set(mathStreakDays, forKey: mathStreakDaysKey)
        UserDefaults.standard.set(longestDrillStreak, forKey: drillStreakKey)
        UserDefaults.standard.set(todayXP, forKey: dailyXPKey)
    }
}
