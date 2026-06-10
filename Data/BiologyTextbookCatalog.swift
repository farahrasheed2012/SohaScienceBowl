import Foundation

/// Prentice Hall FLS (California) primary; OpenStax OSB and Campbell CB backups.
enum BiologyTextbookCatalog {
    static var flsTitle: String { FocusOnLifeScienceCatalog.editionTitle }
    static var cbTitle: String { CampbellBiologyCatalog.editionTitle }

    static func studyOptions(for block: StudyBlock, activePass: StudyPass) -> [StudyBookOption] {
        var options: [StudyBookOption] = []

        if block.bookCode != "FLS" {
            if let fls = BlockAssignedReadingCatalog.flsAssignment(for: block) {
                options.append(
                    StudyBookOption(
                        id: "fls-\(block.week)-\(block.day.rawValue)",
                        role: .alsoOK,
                        text: fls.displayText,
                        links: fls.links,
                        isRecommended: false
                    )
                )
            } else if let flsChapter = chapters(for: block).fls {
                options.append(
                    StudyBookOption(
                        id: "fls-\(block.week)-\(block.day.rawValue)",
                        role: .alsoOK,
                        text: "\(flsTitle) — \(flsChapter)",
                        links: [],
                        isRecommended: false
                    )
                )
            } else if block.backupBookLine?.contains("FLS") == true {
                options.append(
                    StudyBookOption(
                        id: "fls-\(block.week)-\(block.day.rawValue)",
                        role: .alsoOK,
                        text: "\(flsTitle) — use index for this topic",
                        links: [],
                        isRecommended: false
                    )
                )
            }
        }

        if let cb = BlockAssignedReadingCatalog.cbAssignment(for: block) {
            options.append(
                StudyBookOption(
                    id: "cb-\(block.week)-\(block.day.rawValue)",
                    role: .alsoOK,
                    text: cb.displayText,
                    links: cb.links,
                    isRecommended: false
                )
            )
        } else if let cbChapter = chapters(for: block).cb {
            options.append(
                StudyBookOption(
                    id: "cb-\(block.week)-\(block.day.rawValue)",
                    role: .alsoOK,
                    text: "\(cbTitle) — \(cbChapter)",
                    links: [],
                    isRecommended: false
                )
            )
        } else if block.bookCode.contains("CB") {
            let part = block.chapter.replacingOccurrences(of: "Ch ", with: "")
            options.append(
                StudyBookOption(
                    id: "cb-\(block.week)-\(block.day.rawValue)",
                    role: .alsoOK,
                    text: "\(cbTitle) — \(CampbellBiologyCatalog.formatReference(part))",
                    links: [],
                    isRecommended: false
                )
            )
        }

        return options
    }

    static func chapters(for block: StudyBlock) -> (fls: String?, cb: String?, osb: String?) {
        if let backup = block.backupBookLine, !backup.isEmpty {
            let parsed = parseBackupLine(backup)
            var osb: String?
            if let osbRange = backup.range(of: "OSB Ch ") {
                let after = backup[osbRange.upperBound...]
                let osbPart: String
                if let cbSplit = after.range(of: " · CB") {
                    osbPart = String(after[..<cbSplit.lowerBound])
                } else {
                    osbPart = String(after)
                }
                osb = "Ch \(osbPart.trimmingCharacters(in: .whitespaces))"
            }
            return (parsed.fls, parsed.cb, osb)
        }
        if block.bookCode.contains("CB") && block.bookCode.contains("FLS") {
            let part = block.chapter.replacingOccurrences(of: "Ch ", with: "")
            return (FocusOnLifeScienceCatalog.formatReference("7"), CampbellBiologyCatalog.formatReference(part), nil)
        }
        return (nil, nil, nil)
    }

    /// Parses lines like `OSB Ch 3 · CB Ch 4` or `FLS Ch 1 · CB Ch 4`.
    static func parseBackupLine(_ line: String) -> (fls: String?, cb: String?) {
        var fls: String?
        var cb: String?

        if let flsRange = line.range(of: "FLS Ch ") {
            let afterFLS = line[flsRange.upperBound...]
            let flsPart: String
            if let cbSplit = afterFLS.range(of: " · CB") {
                flsPart = String(afterFLS[..<cbSplit.lowerBound])
            } else {
                flsPart = String(afterFLS)
            }
            fls = formatFLSChapters(flsPart)
        } else if line.hasPrefix("FLS ·") || line.contains("FLS ·") {
            fls = nil
        }

        if let range = line.range(of: "CB Ch ") {
            cb = formatCampbellChapters(String(line[range.upperBound...]))
        }

        return (fls, cb)
    }

    private static func formatFLSChapters(_ raw: String) -> String {
        let trimmed = raw.trimmingCharacters(in: .whitespaces)
        let part = trimmed.hasPrefix("Ch ") ? String(trimmed.dropFirst(3)) : trimmed
        return FocusOnLifeScienceCatalog.formatReference(part)
    }

    private static func formatCampbellChapters(_ raw: String) -> String {
        let trimmed = raw.trimmingCharacters(in: .whitespaces)
        let part = trimmed.hasPrefix("Ch ") ? String(trimmed.dropFirst(3)) : trimmed
        return CampbellBiologyCatalog.formatReference(part)
    }
}
