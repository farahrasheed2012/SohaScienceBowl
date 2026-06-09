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
        topicIdsByTitle[reading.title] ?? ["math-word-problems", "math-fractions"]
    }
}
