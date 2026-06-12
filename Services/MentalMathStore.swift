import Foundation

@MainActor
@Observable
final class MentalMathStore {
    static let passThreshold = 0.9

    var currentLevel: [String: Int] = [:]
    var sessionHistory: [MentalMathDrillResult] = []
    var bestStreak: Int = 0
    var currentStreak: Int = 0
    var totalProblemsAnswered: Int = 0
    var totalCorrect: Int = 0

    private let levelsKey = "mental_math_levels"
    private let historyKey = "mental_math_history"
    private let bestStreakKey = "mental_math_best_streak"
    private let currentStreakKey = "mental_math_current_streak"
    private let totalAnsweredKey = "mental_math_total_answered"
    private let totalCorrectKey = "mental_math_total_correct"

    init() { loadProgress() }

    func level(for operation: MentalMathOperation) -> Int {
        currentLevel[operation.rawValue] ?? 1
    }

    func setLevel(_ level: Int, for operation: MentalMathOperation) {
        currentLevel[operation.rawValue] = min(max(level, 1), operation.levelCount)
        saveProgress()
    }

    func recordSession(operation: MentalMathOperation, level: Int, correct: Int, total: Int, elapsed: TimeInterval) {
        let result = MentalMathDrillResult(
            id: UUID(), date: Date(), operation: operation, level: level,
            correct: correct, total: total, elapsedSeconds: elapsed
        )
        sessionHistory.insert(result, at: 0)
        if sessionHistory.count > 50 { sessionHistory = Array(sessionHistory.prefix(50)) }
        totalProblemsAnswered += total
        totalCorrect += correct
        if result.passed {
            let next = min(level + 1, operation.levelCount)
            if next > self.level(for: operation) { setLevel(next, for: operation) }
            currentStreak += 1
            bestStreak = max(bestStreak, currentStreak)
        } else {
            currentStreak = 0
        }
        saveProgress()
    }

    func accuracy(for operation: MentalMathOperation) -> Double? {
        let recent = sessionHistory.filter { $0.operation == operation }.prefix(5)
        guard !recent.isEmpty else { return nil }
        let c = recent.reduce(0) { $0 + $1.correct }
        let t = recent.reduce(0) { $0 + $1.total }
        return t > 0 ? Double(c) / Double(t) : nil
    }

    private func loadProgress() {
        if let data = UserDefaults.standard.data(forKey: levelsKey),
           let decoded = try? JSONDecoder().decode([String: Int].self, from: data) { currentLevel = decoded }
        if let data = UserDefaults.standard.data(forKey: historyKey),
           let decoded = try? JSONDecoder().decode([MentalMathDrillResult].self, from: data) { sessionHistory = decoded }
        bestStreak = UserDefaults.standard.integer(forKey: bestStreakKey)
        currentStreak = UserDefaults.standard.integer(forKey: currentStreakKey)
        totalProblemsAnswered = UserDefaults.standard.integer(forKey: totalAnsweredKey)
        totalCorrect = UserDefaults.standard.integer(forKey: totalCorrectKey)
    }

    private func saveProgress() {
        if let data = try? JSONEncoder().encode(currentLevel) { UserDefaults.standard.set(data, forKey: levelsKey) }
        if let data = try? JSONEncoder().encode(sessionHistory) { UserDefaults.standard.set(data, forKey: historyKey) }
        UserDefaults.standard.set(bestStreak, forKey: bestStreakKey)
        UserDefaults.standard.set(currentStreak, forKey: currentStreakKey)
        UserDefaults.standard.set(totalProblemsAnswered, forKey: totalAnsweredKey)
        UserDefaults.standard.set(totalCorrect, forKey: totalCorrectKey)
    }
}
