import Foundation

struct DOEQuestion: Identifiable, Codable, Hashable {
    var id: UUID
    var setNumber: Int
    var roundNumber: Int
    var questionNumber: Int
    var category: DOECategory
    var questionType: QuestionType
    var format: QuestionFormat
    var questionText: String
    var choices: [String]
    var answer: String
    var sourceFile: String
    var sourceYear: Int?

    func toUnified() -> UnifiedQuestion {
        let yearLabel = sourceYear.map { "\($0) · " } ?? ""
        return UnifiedQuestion(
            id: id,
            source: .doeOfficial,
            category: category,
            questionType: questionType,
            format: format,
            topic: category.rawValue,
            questionText: questionText,
            choices: choices,
            answer: answer,
            sourceFile: sourceFile,
            sourceDescription: "\(yearLabel)Set \(setNumber) · Round \(roundNumber)",
            setNumber: setNumber,
            roundNumber: roundNumber,
            sourceYear: sourceYear
        )
    }
}
