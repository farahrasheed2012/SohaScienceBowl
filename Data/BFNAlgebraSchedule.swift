import Foundation

/// Summer algebra block — walks through all 68 BFN-A chapters (Jun 8 – Aug 19).
enum BFNAlgebraSchedule {
    struct DayAssignment: Hashable {
        let chapterNumbers: [Int]
        let reviewLabel: String?
        let osaSectionKeys: [String]
        let larBackup: String

        var isReviewDay: Bool { reviewLabel != nil }

        var displayTitle: String {
            BFNAlgebraCatalog.displayTitle(chapterNumbers: chapterNumbers, reviewLabel: reviewLabel)
        }

        var bfnOptionText: String {
            BFNAlgebraCatalog.optionText(chapterNumbers: chapterNumbers, reviewLabel: reviewLabel)
        }
    }

    private static let reviewFridays: Set<Int> = [3, 7, 9, 10]

    private static let reviewLabels: [Int: String] = [
        3: "Units 1–3 · Check Your Knowledge",
        7: "Units 4–7 · Check Your Knowledge",
        9: "Units 8–11 · Check Your Knowledge",
        10: "Full book · Check Your Knowledge",
    ]

    /// Optional OpenStax sections (NSB math backup) — keyed by legacy topic title.
    private static let osaByLegacyTitle: [String: [String]] = [
        "Scientific notation": ["1.1", "1.2"],
        "Ratios": ["5.8"],
        "Graphs & slope": ["2.1", "4.1", "3.3"],
        "Unit conversion": ["1.1", "1.2"],
        "PEMDAS & estimation": ["1.1"],
        "Percent": ["1.1"],
        "Proportions": ["5.8"],
        "F = ma": ["2.3"],
        "Exponents": ["1.2", "6.1"],
        "Body-scale ratios": ["5.8"],
        "Formula substitution": ["2.3"],
        "Graph reading": ["2.1", "3.3"],
        "W = Fd": ["2.3"],
        "Concentration ratios": ["5.8"],
        "Mixed review": ["1.2", "5.8", "2.3"],
        "Number review": ["1.1"],
        "Logic & probability": ["13.7"],
        "v = fλ": ["2.3", "1.3"],
        "Unit conversion review": ["1.1", "1.2"],
        "Formula plug-in": ["2.3"],
        "Graphs": ["2.1", "3.3"],
        "Flash review": ["1.2", "5.8"],
        "Final review": ["home"],
    ]

    private static let larByWeekDay: [Int: [String]] = [
        1: ["Lar Ch 1", "Lar Ch 2", "Lar Ch 4", "Lar Ch 1–2", "Lar Ch 2"],
        2: ["Lar Ch 2", "Lar Ch 3", "Lar Ch 3", "Lar Ch 8", "Lar Ch 3"],
        3: ["Lar Ch 3", "Lar Ch 4", "Lar Ch 3", "Lar Ch 2", "Lar Ch 1–4"],
        4: ["Lar Ch 2", "Lar Ch 13", "Lar Ch 3", "Lar Ch 1–2", "Lar Ch 3"],
        5: ["Lar Ch 1", "Lar Ch 2", "Lar Ch 4", "Lar Ch 1–2", "Lar Ch 2"],
        6: ["Lar Ch 2", "Lar Ch 3", "Lar Ch 3", "Lar Ch 8", "Lar Ch 3"],
        7: ["Lar Ch 3", "Lar Ch 4", "Lar Ch 3", "Lar Ch 2", "Lar Ch 1–4"],
        8: ["Lar Ch 2", "Lar Ch 13", "Lar Ch 3", "Lar Ch 1–2", "Lar Ch 3"],
        9: ["Lar Ch 1", "Lar Ch 2", "Lar Ch 4", "Lar Ch 1–2", "Lar Ch 1–4"],
        10: ["Lar Ch 3", "Lar Ch 4", "Lar Ch 3", "Lar Ch 2", "Lar Ch 1–13"],
    ]

    private static let legacyTitlesByWeekDay: [Int: [String]] = [
        1: ["Scientific notation", "Ratios", "Graphs & slope", "Unit conversion", "PEMDAS & estimation"],
        2: ["Percent", "Proportions", "F = ma", "Exponents", "Body-scale ratios"],
        3: ["Formula substitution", "Graph reading", "W = Fd", "Concentration ratios", "Mixed review"],
        4: ["Number review", "Logic & probability", "v = fλ", "Unit conversion review", "Formula plug-in"],
        5: ["Scientific notation", "Ratios", "Graphs & slope", "Unit conversion", "PEMDAS & estimation"],
        6: ["Percent", "Proportions", "F = ma", "Exponents", "Body-scale ratios"],
        7: ["Formula substitution", "Graph reading", "W = Fd", "Concentration ratios", "Mixed review"],
        8: ["Number review", "Logic & probability", "v = fλ", "Unit conversion review", "Formula plug-in"],
        9: ["Scientific notation", "Ratios", "Graphs", "Unit conversion", "Flash review"],
        10: ["Formula substitution", "Graph reading", "W = Fd", "Concentration ratios", "Final review"],
    ]

    private static let plan: [Int: [Weekday: DayAssignment]] = buildPlan()

    static func assignment(week: Int, day: Weekday) -> DayAssignment? {
        plan[week]?[day]
    }

    static func allChapterNumbersOnSchedule() -> [Int] {
        var numbers: [Int] = []
        for week in 1...10 {
            for day in Weekday.allCases {
                guard let a = assignment(week: week, day: day), !a.isReviewDay else { continue }
                numbers.append(contentsOf: a.chapterNumbers)
            }
        }
        return numbers.sorted()
    }

    // MARK: - Plan builder

    private static func buildPlan() -> [Int: [Weekday: DayAssignment]] {
        var remaining = Array(1...BFNAlgebraCatalog.chapterCount)
        var result: [Int: [Weekday: DayAssignment]] = [:]

        for week in 1...10 {
            var weekPlan: [Weekday: DayAssignment] = [:]
            let dayOrder = Weekday.allCases
            let chapterSlots = dayOrder.filter { day in
                !(day == .friday && reviewFridays.contains(week))
            }

            for day in dayOrder {
                let dayIndex = dayOrder.firstIndex(of: day) ?? 0
                let lar = larByWeekDay[week]?[dayIndex] ?? "Lar Ch 1–13"
                let legacy = legacyTitlesByWeekDay[week]?[dayIndex] ?? ""
                let osa = osaByLegacyTitle[legacy] ?? ["1.1"]

                if day == .friday, let review = reviewLabels[week] {
                    weekPlan[day] = DayAssignment(
                        chapterNumbers: [],
                        reviewLabel: review,
                        osaSectionKeys: osa,
                        larBackup: lar
                    )
                    continue
                }

                let slotsAfterThis = chapterSlots.filter { $0.rawValue > day.rawValue }.count
                let take = remaining.count > slotsAfterThis + 1 ? 2 : 1
                let batch = Array(remaining.prefix(take))
                remaining.removeFirst(batch.count)

                weekPlan[day] = DayAssignment(
                    chapterNumbers: batch,
                    reviewLabel: nil,
                    osaSectionKeys: osa,
                    larBackup: lar
                )
            }
            result[week] = weekPlan
        }
        return result
    }
}
