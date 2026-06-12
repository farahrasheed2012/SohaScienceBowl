import Foundation

enum MathCountsAnswerChecker {
    static func isCorrect(student: String, question: MathCountsQuestion) -> Bool {
        let normalizedStudent = normalize(student)
        guard !normalizedStudent.isEmpty else { return false }

        let candidates = [question.answer] + question.acceptableAnswers
        for candidate in candidates {
            if normalizedStudent == normalize(candidate) { return true }
            if numericEqual(normalizedStudent, normalize(candidate)) { return true }
        }
        return false
    }

    static func normalize(_ raw: String) -> String {
        raw
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: "$", with: "")
            .replacingOccurrences(of: " ", with: "")
    }

    private static func numericEqual(_ a: String, _ b: String) -> Bool {
        guard let va = parseNumber(a), let vb = parseNumber(b) else { return false }
        return abs(va - vb) < 0.0001
    }

    private static func parseNumber(_ s: String) -> Double? {
        if s.contains("/") {
            let parts = s.split(separator: "/")
            guard parts.count == 2,
                  let num = Double(parts[0]),
                  let den = Double(parts[1]),
                  den != 0 else { return nil }
            return num / den
        }
        return Double(s)
    }
}
