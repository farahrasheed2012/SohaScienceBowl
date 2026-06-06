import Foundation

enum StudyTextChunk: Equatable {
    case paragraph(String)
    case bullets([String])

    static func parse(_ text: String) -> [StudyTextChunk] {
        text
            .components(separatedBy: "\n\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .map { paragraph in
                if paragraph.contains(" · ") {
                    let items = paragraph
                        .components(separatedBy: " · ")
                        .map { $0.trimmingCharacters(in: .whitespaces) }
                        .filter { !$0.isEmpty }
                    return items.count > 1 ? .bullets(items) : .paragraph(paragraph)
                }
                if paragraph.contains("\n") {
                    let lines = paragraph
                        .components(separatedBy: "\n")
                        .map { $0.trimmingCharacters(in: .whitespaces) }
                        .filter { !$0.isEmpty }
                    if lines.count > 1 {
                        return .bullets(lines)
                    }
                }
                return .paragraph(paragraph)
            }
    }
}
