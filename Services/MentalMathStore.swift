import Foundation

@MainActor
@Observable
final class MentalMathStore {
    static let passThreshold = 0.9

    var currentLevel: [String: Int] = [:]
    var sessionHistory: [MentalMathDrillResult] = []
    var bestByLevel: [String: MentalMathLevelBest] = [:]
    var timedMode: MentalMathTimedMode = .off
    var bestStreak: Int = 0
    var currentStreak: Int = 0
    var totalProblemsAnswered: Int = 0
    var totalCorrect: Int = 0

    private let levelsKey = "mental_math_levels"
    private let historyKey = "mental_math_history"
    private let bestsKey = "mental_math_bests"
    private let timedModeKey = "mental_math_timed_mode"
    private let bestStreakKey = "mental_math_best_streak"
    private let currentStreakKey = "mental_math_current_streak"
    private let totalAnsweredKey = "mental_math_total_answered"
    private let totalCorrectKey = "mental_math_total_correct"

    init() { loadProgress() }

    static func levelKey(operation: MentalMathOperation, level: Int) -> String {
        "\(operation.rawValue)-\(level)"
    }

    func level(for operation: MentalMathOperation) -> Int {
        currentLevel[operation.rawValue] ?? 1
    }

    func setLevel(_ level: Int, for operation: MentalMathOperation) {
        currentLevel[operation.rawValue] = min(max(level, 1), operation.levelCount)
        saveProgress()
    }

    func best(for operation: MentalMathOperation, level: Int) -> MentalMathLevelBest? {
        bestByLevel[Self.levelKey(operation: operation, level: level)]
    }

    func setTimedMode(_ mode: MentalMathTimedMode) {
        timedMode = mode
        UserDefaults.standard.set(mode.rawValue, forKey: timedModeKey)
    }

    struct SessionRecordOutcome {
        var isNewBestTime: Bool = false
        var isNewBestScore: Bool = false
        var previousBestTime: Double?
        var previousBestCorrect: Int = 0
    }

    @discardableResult
    func recordSession(
        operation: MentalMathOperation,
        level: Int,
        correct: Int,
        total: Int,
        elapsed: TimeInterval,
        timedMode: Bool
    ) -> SessionRecordOutcome {
        let key = Self.levelKey(operation: operation, level: level)
        var best = bestByLevel[key] ?? MentalMathLevelBest()
        var outcome = SessionRecordOutcome(
            previousBestTime: best.fastestPassSeconds,
            previousBestCorrect: best.bestCorrect
        )

        best.attempts += 1

        let result = MentalMathDrillResult(
            id: UUID(),
            date: Date(),
            operation: operation,
            level: level,
            correct: correct,
            total: total,
            elapsedSeconds: elapsed,
            timedMode: timedMode
        )
        sessionHistory.insert(result, at: 0)
        if sessionHistory.count > 50 { sessionHistory = Array(sessionHistory.prefix(50)) }

        totalProblemsAnswered += total
        totalCorrect += correct

        if correct > best.bestCorrect {
            best.bestCorrect = correct
            outcome.isNewBestScore = true
        }

        if result.passed {
            best.passes += 1
            let next = min(level + 1, operation.levelCount)
            if next > self.level(for: operation) { setLevel(next, for: operation) }
            currentStreak += 1
            bestStreak = max(bestStreak, currentStreak)

            if best.fastestPassSeconds == nil || elapsed < best.fastestPassSeconds! {
                outcome.isNewBestTime = true
                best.fastestPassSeconds = elapsed
            }
        } else {
            currentStreak = 0
        }

        bestByLevel[key] = best
        saveProgress()
        return outcome
    }

    func accuracy(for operation: MentalMathOperation) -> Double? {
        let recent = sessionHistory.filter { $0.operation == operation }.prefix(5)
        guard !recent.isEmpty else { return nil }
        let c = recent.reduce(0) { $0 + $1.correct }
        let t = recent.reduce(0) { $0 + $1.total }
        return t > 0 ? Double(c) / Double(t) : nil
    }

    func recentResults(for operation: MentalMathOperation, level: Int, limit: Int = 3) -> [MentalMathDrillResult] {
        Array(sessionHistory.filter { $0.operation == operation && $0.level == level }.prefix(limit))
    }

    private func loadProgress() {
        if let data = UserDefaults.standard.data(forKey: levelsKey),
           let decoded = try? JSONDecoder().decode([String: Int].self, from: data) { currentLevel = decoded }
        if let data = UserDefaults.standard.data(forKey: historyKey),
           let decoded = try? JSONDecoder().decode([MentalMathDrillResult].self, from: data) {
            sessionHistory = decoded
        }
        if let data = UserDefaults.standard.data(forKey: bestsKey),
           let decoded = try? JSONDecoder().decode([String: MentalMathLevelBest].self, from: data) {
            bestByLevel = decoded
        }
        timedMode = MentalMathTimedMode.from(stored: UserDefaults.standard.integer(forKey: timedModeKey))
        bestStreak = UserDefaults.standard.integer(forKey: bestStreakKey)
        currentStreak = UserDefaults.standard.integer(forKey: currentStreakKey)
        totalProblemsAnswered = UserDefaults.standard.integer(forKey: totalAnsweredKey)
        totalCorrect = UserDefaults.standard.integer(forKey: totalCorrectKey)
    }

    private func saveProgress() {
        if let data = try? JSONEncoder().encode(currentLevel) { UserDefaults.standard.set(data, forKey: levelsKey) }
        if let data = try? JSONEncoder().encode(sessionHistory) { UserDefaults.standard.set(data, forKey: historyKey) }
        if let data = try? JSONEncoder().encode(bestByLevel) { UserDefaults.standard.set(data, forKey: bestsKey) }
        UserDefaults.standard.set(timedMode.rawValue, forKey: timedModeKey)
        UserDefaults.standard.set(bestStreak, forKey: bestStreakKey)
        UserDefaults.standard.set(currentStreak, forKey: currentStreakKey)
        UserDefaults.standard.set(totalProblemsAnswered, forKey: totalAnsweredKey)
        UserDefaults.standard.set(totalCorrect, forKey: totalCorrectKey)
    }
}
