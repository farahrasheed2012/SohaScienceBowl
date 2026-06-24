import Foundation

/// Summer chemistry blocks (Mon/Thu) — BFN-C chapters aligned to NSB topics in SeedData.
enum BFNChemistrySchedule {
    struct DayAssignment: Hashable {
        let chapterNumbers: [Int]
        let reviewLabel: String?

        var isReviewDay: Bool { reviewLabel != nil }

        var displayTitle: String {
            BFNChemistryCatalog.displayTitle(chapterNumbers: chapterNumbers, reviewLabel: reviewLabel)
        }

        var bfnOptionText: String {
            BFNChemistryCatalog.optionText(chapterNumbers: chapterNumbers, reviewLabel: reviewLabel)
        }
    }

    private static let plan: [Int: [Weekday: DayAssignment]] = [
        1: [
            .monday: day(chapters: [8, 9]),
            .thursday: day(chapters: [11, 12]),
        ],
        2: [
            .monday: day(chapters: [9, 10]),
            .thursday: day(chapters: [14]),
        ],
        3: [
            .monday: day(chapters: [25, 26]),
            .thursday: day(chapters: [20]),
        ],
        4: [
            .monday: day(chapters: [6, 7]),
            .thursday: day(chapters: [4, 5]),
        ],
        5: [
            .monday: day(chapters: [14, 15]),
            .thursday: day(chapters: [18, 19]),
        ],
        6: [
            .monday: day(chapters: [27]),
            .thursday: day(chapters: [28, 29, 31]),
        ],
        7: [
            .monday: day(chapters: [20, 21]),
            .thursday: day(chapters: [12, 13]),
        ],
        8: [
            .monday: day(chapters: [4, 19]),
            .thursday: day(chapters: [6, 7]),
        ],
        9: [
            .monday: day(chapters: [9, 10]),
            .thursday: day(chapters: [16, 17]),
        ],
        10: [
            .monday: day(review: "Units 1–6 · Check Your Knowledge"),
            .thursday: day(review: "Units 7–10 · Check Your Knowledge"),
        ],
    ]

    static func assignment(week: Int, day: Weekday) -> DayAssignment? {
        plan[week]?[day]
    }

    static func allChapterNumbersOnSchedule() -> [Int] {
        var numbers: [Int] = []
        for week in 1...10 {
            for day in [Weekday.monday, .thursday] {
                guard let a = assignment(week: week, day: day), !a.isReviewDay else { continue }
                numbers.append(contentsOf: a.chapterNumbers)
            }
        }
        return numbers.sorted()
    }

    private static func day(chapters: [Int] = [], review: String? = nil) -> DayAssignment {
        DayAssignment(chapterNumbers: chapters, reviewLabel: review)
    }
}
