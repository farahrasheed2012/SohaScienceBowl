import Foundation
import PDFKit

final class DOEPDFParser {
    func parsePDF(at url: URL, setNumber: Int, roundNumber: Int, sourceYear: Int?) -> [DOEQuestion] {
        guard let doc = PDFDocument(url: url) else { return [] }
        let text = (0..<doc.pageCount).compactMap { doc.page(at: $0)?.string }.joined(separator: "\n")
        return parseText(text, setNumber: setNumber, roundNumber: roundNumber, sourceFile: url.lastPathComponent, sourceYear: sourceYear)
    }

    func parseText(_ text: String, setNumber: Int, roundNumber: Int, sourceFile: String, sourceYear: Int?) -> [DOEQuestion] {
        var questions: [DOEQuestion] = []
        let lines = text.components(separatedBy: .newlines).map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }

        var i = 0
        var currentType: QuestionType = .tossUp
        var questionNumber = 0
        var stem = ""
        var choices: [String] = []
        var category: DOECategory = .biology
        var format: QuestionFormat = .shortAnswer

        func flushQuestion(answer: String) {
            guard !stem.isEmpty else { return }
            questions.append(DOEQuestion(
                id: UUID(),
                setNumber: setNumber,
                roundNumber: roundNumber,
                questionNumber: questionNumber,
                category: category,
                questionType: currentType,
                format: format,
                questionText: stem,
                choices: choices,
                answer: answer.trimmingCharacters(in: .whitespaces),
                sourceFile: sourceFile,
                sourceYear: sourceYear
            ))
            stem = ""
            choices = []
        }

        while i < lines.count {
            let line = lines[i]
            if shouldSkipLine(line) {
                i += 1
                continue
            }
            let upper = line.uppercased()

            if upper == "TOSS-UP" {
                currentType = .tossUp
                i += 1
                continue
            }
            if upper == "BONUS" {
                currentType = .bonus
                i += 1
                continue
            }

            if upper.hasPrefix("ANSWER:") {
                let answer = String(line.dropFirst("ANSWER:".count)).trimmingCharacters(in: .whitespaces)
                flushQuestion(answer: answer)
                i += 1
                continue
            }

            if let parsed = parseQuestionHeader(line) {
                questionNumber = parsed.number
                category = parsed.category
                format = parsed.format
                stem = parsed.stem
                choices = []
                i += 1
                while i < lines.count {
                    let next = lines[i]
                    if next.uppercased().hasPrefix("ANSWER:") || next.uppercased() == "BONUS" || next.uppercased() == "TOSS-UP" || parseQuestionHeader(next) != nil {
                        break
                    }
                    if next.range(of: #"^[WXYZ]\)"#, options: .regularExpression) != nil {
                        choices.append(next)
                        format = .multipleChoice
                    } else if format == .shortAnswer && stem.isEmpty == false && !next.uppercased().hasPrefix("ANSWER") {
                        stem += " " + next
                    }
                    i += 1
                }
                continue
            }

            i += 1
        }

        return questions
    }

    private struct ParsedHeader {
        var number: Int
        var category: DOECategory
        var format: QuestionFormat
        var stem: String
    }

    private func parseQuestionHeader(_ line: String) -> ParsedHeader? {
        // e.g. "1) LIFE SCIENCE Short Answer What is..." or "1) BIOLOGY — Multiple Choice ..."
        let patterns = [
            #"^(\d+)\)\s*(.+?)\s+(Short Answer|Multiple Choice)\s+(.*)$"#,
            #"^(\d+)\)\s*([^—\-]+)[—\-]\s*(Multiple Choice|Short Answer)\s*(.*)$"#
        ]

        for pattern in patterns {
            guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]),
                  let match = regex.firstMatch(in: line, range: NSRange(line.startIndex..., in: line)),
                  match.numberOfRanges >= 5,
                  let numRange = Range(match.range(at: 1), in: line),
                  let catRange = Range(match.range(at: 2), in: line),
                  let fmtRange = Range(match.range(at: 3), in: line),
                  let stemRange = Range(match.range(at: 4), in: line),
                  let number = Int(line[numRange]) else { continue }

            let catString = line[catRange].trimmingCharacters(in: .whitespaces)
            let fmtString = line[fmtRange].lowercased()
            let format: QuestionFormat = fmtString.contains("multiple") ? .multipleChoice : .shortAnswer
            let stem = String(line[stemRange]).trimmingCharacters(in: .whitespaces)
            let category = mapCategory(catString)
            return ParsedHeader(number: number, category: category, format: format, stem: stem)
        }
        return nil
    }

    private func mapCategory(_ raw: String) -> DOECategory {
        let upper = raw.uppercased()
        if upper.contains("LIFE") || upper.contains("BIO") { return .biology }
        if upper.contains("CHEM") { return .chemistry }
        if upper.contains("PHYS") { return .physics }
        if upper.contains("EARTH") { return .earthSpace }
        if upper.contains("ENERGY") { return .energy }
        if upper.contains("MATH") { return .math }
        if upper.contains("GENERAL") { return .generalScience }
        return .generalScience
    }

    private func shouldSkipLine(_ line: String) -> Bool {
        let upper = line.uppercased()
        if upper.hasPrefix("MIDDLE SCHOOL ROUND") && upper.contains("PAGE") { return true }
        if upper.hasPrefix("ROUND ") && upper.count < 20 { return true }
        return false
    }
}

struct DOEPDFCatalog {
    struct Entry {
        var url: String
        var setNumber: Int
        var roundNumber: Int
        var folder: String
        var filename: String
        var sourceYear: Int?
    }

    static let allEntries: [Entry] = buildCatalog()

    private static func buildCatalog() -> [Entry] {
        var entries: [Entry] = []

        func addSet(_ set: Int, year: Int?, folder: String, urls: [String]) {
            for (idx, url) in urls.enumerated() {
                let filename = URL(string: url)?.lastPathComponent ?? "round\(idx + 1).pdf"
                entries.append(Entry(url: url, setNumber: set, roundNumber: idx + 1, folder: folder, filename: filename, sourceYear: year))
            }
        }

        let set1 = (1...18).map { "https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-1/m_round\(String(format: "%02d", $0)).pdf" }
        addSet(1, year: 2009, folder: "Set-1", urls: set1)

        let set2 = (1...10).map { "https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-2/sample_questions_r\($0).pdf" }
        addSet(2, year: 2008, folder: "Set-2", urls: set2)

        var set3 = (1...15).map { "https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-3/Round-\($0)C-MS.pdf" }
        set3.append("https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-3/Energy-Category.pdf")
        addSet(3, year: 2007, folder: "Set-3", urls: set3)

        let set4 = (1...17).map { "https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-4/Round\($0).pdf" }
        addSet(4, year: 2010, folder: "Set-4", urls: set4)

        let set5 = (1...16).map { "https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-5/Round\($0).pdf" }
        addSet(5, year: 2011, folder: "Set-5", urls: set5)

        let set6 = (1...17).map { "https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-6/Round\($0).pdf" }
        addSet(6, year: 2012, folder: "Set-6", urls: set6)

        let set7 = (1...15).map { "https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-7/MS_Round-\($0).pdf" }
        addSet(7, year: 2013, folder: "Set-7", urls: set7)

        let set8 = (1...17).map { "https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-8/Round-\($0)-A.pdf" }
        addSet(8, year: 2014, folder: "Set-8", urls: set8)

        let set9Names = ["RegionalMS_1.pdf", "RegionalMS_2.pdf"] + (3...17).map { "RegionalMS_\($0)A.pdf" }
        let set9 = set9Names.map { "https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-9/\($0)" }
        addSet(9, year: 2015, folder: "Set-9", urls: set9)

        let set10 = (1...17).map { "https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-10/\($0)A_MS_Reg_2016.pdf" }
        addSet(10, year: 2016, folder: "Set-10", urls: set10)

        let set11 = ["MS_1.pdf", "MS_2.pdf"] + (3...17).map { "MS_\($0)A.pdf" }
        let set11URLs = set11.map { "https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-set-11/\($0)" }
        addSet(11, year: 2017, folder: "Set-11", urls: set11URLs)

        let set12 = (1...17).map { "https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-12/MSRound-\($0).pdf" }
        addSet(12, year: 2018, folder: "Set-12", urls: set12)

        let set13 = (1...17).map { "https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-13/2019-NSB-MSR-Round-\($0)A.pdf" }
        addSet(13, year: 2019, folder: "Set-13", urls: set13)

        let sampleRounds = ["rr2_for_web.pdf", "rr5_for_web.pdf", "de1_for_web.pdf", "de3_for_web.pdf"]
        addSet(0, year: nil, folder: "Sample-Rounds", urls: sampleRounds.map { "https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Rounds/\($0)" })

        let set14 = (1...17).map { "https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-14/2020-MS-Rd\($0).pdf" }
        addSet(14, year: 2020, folder: "Set-14", urls: set14)

        let set15 = [
            "Set-1-MS-2021.pdf", "Set-2-MS-2021.pdf", "Set-3-MS-2021.pdf", "Set-4-MS-2021.pdf",
            "Set-5-MS-2021.pdf", "Set-6-MS-2021.pdf",
            "https://science.osti.gov/-/media/wdts/nsb/pdf/HS-Sample-Questions/Sample-Set-16/Set-7-HS-2021.pdf",
            "Set-8-MS-2021.pdf", "Set-9-MS-2021.pdf", "Set-10-MS-2021.pdf"
        ].enumerated().map { idx, name in
            if name.hasPrefix("http") { return name }
            return "https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-15/\(name)"
        }
        addSet(15, year: 2021, folder: "Set-15", urls: set15)

        let set16 = (1...9).map { "https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-16/2022-MS-\($0).pdf" }
        addSet(16, year: 2022, folder: "Set-16", urls: set16)

        return entries
    }
}

@MainActor
@Observable
final class DOEQuestionStore {
    static let shared = DOEQuestionStore()
    private let parser = DOEPDFParser()
    private static let starterSetNumbers: Set<Int> = [0, 1]

    private(set) var doeQuestions: [DOEQuestion] = []
    private(set) var isLoaded = false
    private(set) var isDownloading = false
    private(set) var downloadProgress: Double = 0
    private(set) var downloadedPDFCount = 0
    private(set) var totalPDFCount = 0
    private(set) var loadError: String?
    private(set) var usesBundledStarter = false

    var studyCategoryQuestionCount: Int {
        doeQuestions.filter { $0.category.isStudyCategory }.count
    }

    var isDrillReady: Bool {
        studyCategoryQuestionCount >= 15
    }

    var drillReadinessLabel: String {
        if isDownloading {
            return "Downloading PDFs… \(downloadedPDFCount)/\(totalPDFCount)"
        }
        if isDrillReady {
            return usesBundledStarter
                ? "Ready to drill (bundled starter — download full PDFs for more)"
                : "Ready to drill"
        }
        if usesBundledStarter {
            return "Starter cache loaded — expanding bank in background"
        }
        return "Need more questions — download DOE PDFs in Settings"
    }

    private var documentsPDFRoot: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("DOE-PDFs", isDirectory: true)
    }

    private var bundlePDFRoot: URL? {
        Bundle.main.resourceURL?.appendingPathComponent("DOE-PDFs", isDirectory: true)
    }

    func loadIfNeeded() async {
        guard !isLoaded else { return }
        if let cached = loadCache(), !cached.isEmpty {
            doeQuestions = cached
            isLoaded = true
            usesBundledStarter = false
            return
        }
        if let bundled = loadBundledStarter(), !bundled.isEmpty {
            doeQuestions = bundled
            isLoaded = true
            usesBundledStarter = true
            saveCache(bundled)
            Task { await loadFromPDFs(autoDownloadStarter: true, mergeWithExisting: true) }
            return
        }
        await loadFromPDFs(autoDownloadStarter: true)
    }

    func reload(forceDownload: Bool = false) async {
        isLoaded = false
        loadError = nil
        try? FileManager.default.removeItem(at: PersistenceService.doeCacheURL)
        if forceDownload {
            await downloadPDFs(starterOnly: false)
        }
        await loadFromPDFs(autoDownloadStarter: false)
    }

    func downloadPDFs(starterOnly: Bool) async {
        let entries = DOEPDFCatalog.allEntries.filter { starterOnly ? Self.starterSetNumbers.contains($0.setNumber) : true }
        guard !entries.isEmpty else { return }

        isDownloading = true
        downloadProgress = 0
        downloadedPDFCount = 0
        totalPDFCount = entries.count
        loadError = nil

        for (index, entry) in entries.enumerated() {
            let dest = documentsPDFRoot
                .appendingPathComponent(entry.folder, isDirectory: true)
                .appendingPathComponent(entry.filename)

            if !FileManager.default.fileExists(atPath: dest.path) {
                do {
                    try await downloadPDF(from: entry.url, to: dest)
                } catch {
                    // Keep going — one failed PDF shouldn't block the rest
                }
            }

            downloadedPDFCount = index + 1
            downloadProgress = Double(downloadedPDFCount) / Double(totalPDFCount)
        }

        isDownloading = false
    }

    private func downloadPDF(from urlString: String, to dest: URL) async throws {
        guard let url = URL(string: urlString) else { return }
        try FileManager.default.createDirectory(at: dest.deletingLastPathComponent(), withIntermediateDirectories: true)
        let (tempURL, response) = try await URLSession.shared.download(from: url)
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw URLError(.badServerResponse)
        }
        if FileManager.default.fileExists(atPath: dest.path) {
            try FileManager.default.removeItem(at: dest)
        }
        try FileManager.default.moveItem(at: tempURL, to: dest)
    }

    @MainActor
    private func loadFromPDFs(autoDownloadStarter: Bool, mergeWithExisting: Bool = false) async {
        var all = parseLocalPDFs()

        if all.isEmpty && autoDownloadStarter {
            let hasAnyPDF = pdfFilesExist()
            if !hasAnyPDF {
                await downloadPDFs(starterOnly: true)
                all = parseLocalPDFs()
            }
        }

        if mergeWithExisting, !all.isEmpty {
            let merged = dedupeQuestions(doeQuestions + all)
            doeQuestions = merged
            usesBundledStarter = false
        } else if !all.isEmpty {
            doeQuestions = all
            usesBundledStarter = false
        }

        isLoaded = true

        if !doeQuestions.isEmpty {
            saveCache(doeQuestions)
            loadError = nil
        } else if isDownloading {
            loadError = "Downloading DOE PDFs…"
        } else if pdfFilesExist() {
            loadError = "PDFs found but no questions parsed — try Re-parse in Settings."
        } else {
            loadError = "No DOE PDFs yet. Tap Download starter or full set in Settings."
        }
    }

    private func dedupeQuestions(_ questions: [DOEQuestion]) -> [DOEQuestion] {
        var seen = Set<String>()
        var result: [DOEQuestion] = []
        for q in questions {
            let key = q.questionText
                .lowercased()
                .components(separatedBy: CharacterSet.alphanumerics.inverted)
                .joined()
            if seen.contains(key) { continue }
            seen.insert(key)
            result.append(q)
        }
        return result
    }

    private func loadBundledStarter() -> [DOEQuestion]? {
        let url = Bundle.main.url(forResource: "doe_starter_cache", withExtension: "json", subdirectory: "StudyContent")
            ?? Bundle.main.url(forResource: "doe_starter_cache", withExtension: "json")
        guard let url, let data = try? Data(contentsOf: url),
              let questions = try? JSONDecoder().decode([DOEQuestion].self, from: data) else { return nil }
        return questions
    }

    private func pdfFilesExist() -> Bool {
        for entry in DOEPDFCatalog.allEntries {
            if localPDFURL(for: entry) != nil { return true }
        }
        return false
    }

    private func parseLocalPDFs() -> [DOEQuestion] {
        var all: [DOEQuestion] = []
        for entry in DOEPDFCatalog.allEntries {
            guard let url = localPDFURL(for: entry) else { continue }
            let parsed = parser.parsePDF(at: url, setNumber: entry.setNumber, roundNumber: entry.roundNumber, sourceYear: entry.sourceYear)
            all.append(contentsOf: parsed)
        }
        return all
    }

    private func localPDFURL(for entry: DOEPDFCatalog.Entry) -> URL? {
        let docURL = documentsPDFRoot
            .appendingPathComponent(entry.folder, isDirectory: true)
            .appendingPathComponent(entry.filename)
        if FileManager.default.fileExists(atPath: docURL.path) { return docURL }

        let bundleURL = bundlePDFRoot?
            .appendingPathComponent(entry.folder, isDirectory: true)
            .appendingPathComponent(entry.filename)
        if let bundleURL, FileManager.default.fileExists(atPath: bundleURL.path) { return bundleURL }
        return nil
    }

    private func loadCache() -> [DOEQuestion]? {
        let url = PersistenceService.doeCacheURL
        guard FileManager.default.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url),
              let questions = try? JSONDecoder().decode([DOEQuestion].self, from: data) else { return nil }
        return questions
    }

    private func saveCache(_ questions: [DOEQuestion]) {
        if let data = try? JSONEncoder().encode(questions) {
            try? data.write(to: PersistenceService.doeCacheURL)
        }
    }

    func questions(for category: DOECategory?) -> [DOEQuestion] {
        guard let category else { return doeQuestions }
        return doeQuestions.filter { $0.category == category }
    }

    /// All parsed DOE questions (every category, every downloaded PDF).
    func allQuestions() -> [DOEQuestion] { doeQuestions }

    /// Bio, Chem, Phys only — for schedule-aligned study blocks.
    func studyQuestions() -> [DOEQuestion] {
        doeQuestions.filter { $0.category.isStudyCategory }
    }

    /// Backward-compatible alias — now returns the full bank.
    func sohaQuestions() -> [DOEQuestion] { doeQuestions }

    func categoryCounts() -> [(category: DOECategory, count: Int)] {
        DOECategory.allCases.compactMap { category in
            let count = doeQuestions.filter { $0.category == category }.count
            return count > 0 ? (category, count) : nil
        }
    }
}
