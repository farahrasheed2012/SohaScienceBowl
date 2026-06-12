import Foundation

@MainActor
@Observable
final class MathCountsStore {
    var currentLevel: MathCountsDifficulty = .level2
    var sessionHistory: [MathCountsSessionRecord] = []
    var topicCorrectCounts: [String: Int] = [:]
    var topicAttemptCounts: [String: Int] = [:]
    var currentStreak: Int = 0
    var lastPracticeDate: Date?

    private let levelKey = "mathcounts_current_level"
    private let sessionsKey = "mathcounts_session_history"
    private let topicCorrectKey = "mathcounts_topic_correct"
    private let topicAttemptKey = "mathcounts_topic_attempts"
    private let streakKey = "mathcounts_streak"
    private let lastDateKey = "mathcounts_last_practice_date"

    init() {
        loadProgress()
    }

    var sessionsCompleted: Int { sessionHistory.count }

    var recentAccuracy: Double {
        let recent = sessionHistory.suffix(5)
        guard !recent.isEmpty else { return 0 }
        let correct = recent.reduce(0) { $0 + $1.score }
        let total = recent.reduce(0) { $0 + $1.total }
        guard total > 0 else { return 0 }
        return Double(correct) / Double(total)
    }

    var weakestTopics: [String] {
        topicAttemptCounts
            .filter { $0.value >= 2 }
            .map { topic, attempts in
                let correct = topicCorrectCounts[topic] ?? 0
                return (topic, Double(correct) / Double(attempts))
            }
            .sorted { $0.1 < $1.1 }
            .prefix(3)
            .map(\.0)
    }

    func recordSession(attempts: [MathCountsAttempt], level: MathCountsDifficulty) {
        let score = attempts.filter(\.correct).count
        let record = MathCountsSessionRecord(
            id: UUID(),
            date: Date(),
            level: level.rawValue,
            attempts: attempts,
            score: score,
            total: attempts.count
        )
        sessionHistory.insert(record, at: 0)
        if sessionHistory.count > 40 {
            sessionHistory = Array(sessionHistory.prefix(40))
        }

        for attempt in attempts {
            topicAttemptCounts[attempt.topic, default: 0] += 1
            if attempt.correct {
                topicCorrectCounts[attempt.topic, default: 0] += 1
            }
        }

        updateStreak()
        adaptLevel(after: record)
        saveProgress()
    }

    func setLevel(_ level: MathCountsDifficulty) {
        currentLevel = level
        UserDefaults.standard.set(level.rawValue, forKey: levelKey)
    }

    func questionsForToday() -> [MathCountsQuestion] {
        let daySeed = UInt64(Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1)
        return MathCountsQuestionBank.dailySession(level: currentLevel, seed: daySeed)
    }

    func questionsForTopic(_ topic: MathCountsTopicArea, count: Int = 10) -> [MathCountsQuestion] {
        MathCountsQuestionBank.topicDrill(topic: topic, level: currentLevel, count: count)
    }

    private func adaptLevel(after session: MathCountsSessionRecord) {
        guard session.total >= 8 else { return }
        if session.accuracy >= 0.85, currentLevel.rawValue < 5 {
            currentLevel = MathCountsDifficulty(rawValue: currentLevel.rawValue + 1) ?? currentLevel
        } else if session.accuracy < 0.45, currentLevel.rawValue > 1 {
            currentLevel = MathCountsDifficulty(rawValue: currentLevel.rawValue - 1) ?? currentLevel
        }
        UserDefaults.standard.set(currentLevel.rawValue, forKey: levelKey)
    }

    private func updateStreak() {
        let today = Calendar.current.startOfDay(for: Date())
        if let last = lastPracticeDate {
            let lastDay = Calendar.current.startOfDay(for: last)
            let days = Calendar.current.dateComponents([.day], from: lastDay, to: today).day ?? 0
            if days == 0 {
                return
            } else if days == 1 {
                currentStreak += 1
            } else {
                currentStreak = 1
            }
        } else {
            currentStreak = 1
        }
        lastPracticeDate = today
    }

    private func loadProgress() {
        let levelRaw = UserDefaults.standard.integer(forKey: levelKey)
        if let level = MathCountsDifficulty(rawValue: levelRaw == 0 ? 2 : levelRaw) {
            currentLevel = level
        }
        if let data = UserDefaults.standard.data(forKey: sessionsKey),
           let decoded = try? JSONDecoder().decode([MathCountsSessionRecord].self, from: data) {
            sessionHistory = decoded
        }
        if let data = UserDefaults.standard.data(forKey: topicCorrectKey),
           let decoded = try? JSONDecoder().decode([String: Int].self, from: data) {
            topicCorrectCounts = decoded
        }
        if let data = UserDefaults.standard.data(forKey: topicAttemptKey),
           let decoded = try? JSONDecoder().decode([String: Int].self, from: data) {
            topicAttemptCounts = decoded
        }
        currentStreak = UserDefaults.standard.integer(forKey: streakKey)
        if let ts = UserDefaults.standard.object(forKey: lastDateKey) as? TimeInterval {
            lastPracticeDate = Date(timeIntervalSince1970: ts)
        }
    }

    private func saveProgress() {
        UserDefaults.standard.set(currentLevel.rawValue, forKey: levelKey)
        if let data = try? JSONEncoder().encode(sessionHistory) {
            UserDefaults.standard.set(data, forKey: sessionsKey)
        }
        if let data = try? JSONEncoder().encode(topicCorrectCounts) {
            UserDefaults.standard.set(data, forKey: topicCorrectKey)
        }
        if let data = try? JSONEncoder().encode(topicAttemptCounts) {
            UserDefaults.standard.set(data, forKey: topicAttemptKey)
        }
        UserDefaults.standard.set(currentStreak, forKey: streakKey)
        if let lastPracticeDate {
            UserDefaults.standard.set(lastPracticeDate.timeIntervalSince1970, forKey: lastDateKey)
        }
    }
}
