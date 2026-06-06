import Foundation
import PDFKit
import UniformTypeIdentifiers

final class QuestionImportService {
    static let shared = QuestionImportService()

    private init() {}

    func importPDF(at url: URL, existing: [UnifiedQuestion]) -> (questions: [UnifiedQuestion], stats: DuplicateImportStats) {
        let parser = DOEPDFParser()
        let parsed = parser.parsePDF(at: url, setNumber: 0, roundNumber: 0, sourceYear: nil)
        let unified = parsed.map { q -> UnifiedQuestion in
            var u = q.toUnified()
            u.source = .importedPDF
            u.sourceFile = url.lastPathComponent
            return u
        }
        return dedupeAndImport(unified, source: .importedPDF, existing: existing)
    }

    func importJSON(at url: URL, existing: [UnifiedQuestion]) -> (questions: [UnifiedQuestion], stats: DuplicateImportStats) {
        guard let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([UnifiedQuestion].self, from: data) else {
            return ([], DuplicateImportStats(imported: 0, skippedDuplicates: 0, source: .importedJSON))
        }
        var mapped = decoded.map { q -> UnifiedQuestion in
            var copy = q
            copy.source = .importedJSON
            copy.sourceFile = url.lastPathComponent
            return copy
        }
        return dedupeAndImport(mapped, source: .importedJSON, existing: existing)
    }

    func importCSV(at url: URL, existing: [UnifiedQuestion]) -> (questions: [UnifiedQuestion], stats: DuplicateImportStats) {
        guard let text = try? String(contentsOf: url, encoding: .utf8) else {
            return ([], DuplicateImportStats(imported: 0, skippedDuplicates: 0, source: .importedCSV))
        }
        let lines = text.components(separatedBy: .newlines).filter { !$0.isEmpty }
        guard lines.count > 1 else { return ([], DuplicateImportStats(imported: 0, skippedDuplicates: 0, source: .importedCSV)) }

        var questions: [UnifiedQuestion] = []
        for line in lines.dropFirst() {
            let cols = parseCSVLine(line)
            guard cols.count >= 3 else { continue }
            let category = DOECategory.allCases.first { cols[0].localizedCaseInsensitiveContains($0.rawValue) } ?? .biology
            let subject = category.subject ?? .biology
            questions.append(UnifiedQuestion(
                id: UUID(),
                source: .importedCSV,
                category: category,
                questionType: .tossUp,
                format: .shortAnswer,
                topic: cols.count > 3 ? cols[3] : subject.rawValue,
                questionText: cols[1],
                choices: [],
                answer: cols[2],
                sourceFile: url.lastPathComponent,
                sourceDescription: "Imported CSV",
                setNumber: nil,
                roundNumber: nil,
                sourceYear: nil
            ))
        }
        return dedupeAndImport(questions, source: .importedCSV, existing: existing)
    }

    private func dedupeAndImport(_ incoming: [UnifiedQuestion], source: QuestionSource, existing: [UnifiedQuestion]) -> (questions: [UnifiedQuestion], stats: DuplicateImportStats) {
        var known = Set(existing.map(\.normalizedText))
        var imported: [UnifiedQuestion] = []
        var skipped = 0

        for var q in incoming {
            let key = q.normalizedText
            if known.contains(key) {
                skipped += 1
                continue
            }
            known.insert(key)
            imported.append(q)
        }

        return (imported, DuplicateImportStats(imported: imported.count, skippedDuplicates: skipped, source: source))
    }

    private func parseCSVLine(_ line: String) -> [String] {
        var result: [String] = []
        var current = ""
        var inQuotes = false
        for char in line {
            if char == "\"" {
                inQuotes.toggle()
            } else if char == "," && !inQuotes {
                result.append(current.trimmingCharacters(in: .whitespaces))
                current = ""
            } else {
                current.append(char)
            }
        }
        result.append(current.trimmingCharacters(in: .whitespaces))
        return result
    }
}
