import Foundation

/// Expanded reading material — explanations, examples, and NSB tips beyond the focus bullets.
enum BlockReadingContent {
    struct Key: Hashable {
        var week: Int
        var day: Weekday
        var subject: Subject
    }

    static func sections(for block: StudyBlock, pass: StudyPass) -> [ReadingSection] {
        let key = Key(week: block.week, day: block.day, subject: block.subject)
        var sections: [ReadingSection] = []

        if block.week >= 1 && block.week <= 4 && pass == .pass1 {
            sections = pass1[key] ?? defaultSections(for: block, pass: pass)
        } else if block.week >= 5 && block.week <= 8 && pass == .pass2 {
            sections = pass2[key] ?? defaultSections(for: block, pass: pass)
        } else if block.week >= 9 && pass == .pass3 {
            sections = pass3[key] ?? defaultSections(for: block, pass: pass)
        } else {
            sections = defaultSections(for: block, pass: pass)
        }

        let refs = StudyReferenceSheets.sheets(for: block)
        for ref in refs where !sections.contains(where: { $0.title == ref.title }) {
            sections.append(ref)
        }
        return sections
    }

    private static func defaultSections(for block: StudyBlock, pass: StudyPass) -> [ReadingSection] {
        var list: [ReadingSection] = [
            ReadingSection(
                title: "What to get from today's reading",
                body: block.focus
            ),
            ReadingSection(
                title: "While you read",
                body: """
                Open \(block.bookLine(for: pass)). Plan **~35–40 min** for today's chapter (one chapter or one part of a split topic). Copy every formula from today's block into your Science Bowl notebook.

                Write three facts you did not know before reading. Mark anything that could become a toss-up — definitions, numbers, organelle jobs, and formula units.
                """
            )
        ]
        if let deep = DeepDiveContent.blockContent(for: block, pass: pass), deep != block.focus {
            list.insert(
                ReadingSection(title: "Study notes", body: deep),
                at: 1
            )
        }
        return list
    }

    private static func rs(_ title: String, _ body: String) -> ReadingSection {
        ReadingSection(title: title, body: body)
    }

    // MARK: - Pass 1 (Weeks 1–4)

    static let pass1: [Key: [ReadingSection]] = Pass1ReadingContent.map
    static let pass2: [Key: [ReadingSection]] = Pass2ReadingContent.map
    static let pass3: [Key: [ReadingSection]] = Pass3ReadingContent.map
}
