import Foundation

/// Maps daily math readings to encyclopedia topic IDs for plan-aligned math quizzes.
enum MathQuizCatalog {
    private static let topicIdsByTitle: [String: [String]] = [
        "Scientific notation": ["math-exponents", "math-word-problems"],
        "Ratios": ["math-ratios", "math-fractions"],
        "Graphs & slope": ["math-functions", "math-data-graphs", "math-linear-eq"],
        "Unit conversion": ["math-word-problems", "math-fractions"],
        "PEMDAS & estimation": ["math-pemdas", "math-number-theory"],
        "Percent": ["math-fractions", "math-ratios"],
        "Proportions": ["math-ratios", "math-word-problems"],
        "F = ma": ["math-algebra-expressions", "math-word-problems"],
        "Exponents": ["math-exponents", "math-roots"],
        "Body-scale ratios": ["math-ratios", "math-word-problems"],
        "Balancing & moles intro": ["math-algebra-expressions", "math-fractions"],
        "Heart rate & scale": ["math-ratios", "math-word-problems"],
        "Work & power": ["math-algebra-expressions", "math-word-problems"],
        "pH & logs intro": ["math-exponents", "math-algebra-expressions"],
        "Population math": ["math-fractions", "math-statistics"],
        "Circuit math": ["math-algebra-expressions", "math-word-problems"],
        "Classification logic": ["math-probability", "math-number-theory"],
        "Wave math": ["math-algebra-expressions", "math-functions"],
        "Electricity units": ["math-word-problems", "math-exponents"],
        "Climate data": ["math-data-graphs", "math-statistics"],
        "Probability intro": ["math-probability", "math-fractions"],
        "Trig intro": ["math-geom-angles", "math-pythagorean"],
        "Logarithms": ["math-exponents", "math-algebra-expressions"],
        "Systems of equations": ["math-systems", "math-linear-eq"],
        "Review mix": ["math-pemdas", "math-ratios", "math-word-problems", "math-functions"],
    ]

    static func topicIds(for reading: ScheduleOpenStaxCatalog.MathReading) -> [String] {
        if reading.isReviewDay {
            return ["math-pemdas", "math-ratios", "math-word-problems", "math-functions"]
        }
        if !reading.bfnChapterNumbers.isEmpty {
            return topicIds(forBFNChapters: reading.bfnChapterNumbers)
        }
        return topicIdsByTitle[reading.title] ?? ["math-word-problems", "math-fractions"]
    }

    private static func topicIds(forBFNChapters chapters: [Int]) -> [String] {
        guard let first = chapters.min() else { return ["math-word-problems"] }
        switch first {
        case 1...3: return ["math-pemdas", "math-number-theory"]
        case 4...10: return ["math-fractions", "math-number-theory"]
        case 11...18: return ["math-ratios", "math-fractions"]
        case 19...23: return ["math-exponents", "math-algebra-expressions"]
        case 24...30: return ["math-linear-eq", "math-systems", "math-word-problems"]
        case 31...38: return ["math-data-graphs", "math-coordinate", "math-functions"]
        case 39...44: return ["math-statistics", "math-probability"]
        case 45...47: return ["math-functions", "math-linear-eq"]
        case 48...56: return ["math-algebra-expressions", "math-linear-eq"]
        case 57...60: return ["math-roots", "math-exponents"]
        case 61...68: return ["math-algebra-expressions", "math-functions"]
        default: return ["math-word-problems", "math-fractions"]
        }
    }
}
