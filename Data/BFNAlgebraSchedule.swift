import Foundation

/// Summer algebra block — BFN-A Ch 1–20 (weeks 1–2), then Math POT 6 from T152 (weeks 3–10).
enum BFNAlgebraSchedule {
    struct DayAssignment: Hashable {
        let chapterNumbers: [Int]
        let reviewLabel: String?
        let potCodes: [String]
        let topicLabel: String?
        let osaSectionKeys: [String]
        let larBackup: String

        var isReviewDay: Bool { reviewLabel != nil }

        var displayTitle: String {
            if let reviewLabel { return reviewLabel }
            if let topicLabel { return topicLabel }
            let bfn = BFNAlgebraCatalog.displayTitle(chapterNumbers: chapterNumbers, reviewLabel: nil)
            if potCodes.isEmpty { return bfn }
            let pot = potCodes.joined(separator: ", ")
            if chapterNumbers.isEmpty {
                return "POT 6 — \(pot)"
            }
            return "POT 6 — \(pot) · \(bfn)"
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
        3: ["Lar Ch 7", "Lar Ch 1", "Lar Ch 3", "Lar Ch 3", "Lar Ch 1–4"],
        4: ["Lar Ch 6", "Lar Ch 9", "Lar Ch 9", "Lar Ch 9", "Lar Ch 9"],
        5: ["Lar Ch 9", "Lar Ch 4", "Lar Ch 4–5", "Lar Ch 4", "Lar Ch 6–7"],
        6: ["Lar Ch 6", "Lar Ch 11", "Lar Ch 10", "Lar Ch 10", "Lar Ch 1"],
        7: ["Lar Ch 1", "Lar Ch 11", "Lar Ch 11", "Lar Ch 11", "Lar Ch 1–4"],
        8: ["Lar Ch 13", "Lar Ch 13", "Lar Ch 4", "Lar Ch 1–13", "Lar Ch 9"],
        9: ["Lar Ch 8", "Lar Ch 8", "Lar Ch 8", "Lar Ch 8", "Lar Ch 1–4"],
        10: ["Lar Ch 8", "Lar Ch 1–13", "Lar Ch 7", "Lar Ch 10", "Lar Ch 1–13"],
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

    private static func day(
        potCodes: [String] = [],
        chapters: [Int] = [],
        topicLabel: String? = nil,
        osa: [String],
        lar: String,
        review: String? = nil
    ) -> DayAssignment {
        DayAssignment(
            chapterNumbers: chapters,
            reviewLabel: review,
            potCodes: potCodes,
            topicLabel: topicLabel,
            osaSectionKeys: osa,
            larBackup: lar
        )
    }

    private static func foundationWeeks() -> [Int: [Weekday: DayAssignment]] {
        func legacyDay(week: Int, dayIndex: Int, chapters: [Int]) -> DayAssignment {
            let legacy = legacyTitlesByWeekDay[week]?[dayIndex] ?? ""
            let osa = osaByLegacyTitle[legacy] ?? ["1.1"]
            let lar = larByWeekDay[week]?[dayIndex] ?? "Lar Ch 1–13"
            return day(chapters: chapters, osa: osa, lar: lar)
        }

        return [
            1: [
                .monday: legacyDay(week: 1, dayIndex: 0, chapters: [1, 2]),
                .tuesday: legacyDay(week: 1, dayIndex: 1, chapters: [3, 4]),
                .wednesday: legacyDay(week: 1, dayIndex: 2, chapters: [5, 6]),
                .thursday: legacyDay(week: 1, dayIndex: 3, chapters: [7, 8]),
                .friday: legacyDay(week: 1, dayIndex: 4, chapters: [9, 10]),
            ],
            2: [
                .monday: legacyDay(week: 2, dayIndex: 0, chapters: [11, 12]),
                .tuesday: legacyDay(week: 2, dayIndex: 1, chapters: [13, 14]),
                .wednesday: legacyDay(week: 2, dayIndex: 2, chapters: [15, 16]),
                .thursday: legacyDay(week: 2, dayIndex: 3, chapters: [17, 18]),
                .friday: legacyDay(week: 2, dayIndex: 4, chapters: [19, 20]),
            ],
        ]
    }

    /// Weeks 3–10 follow Math POT 6 Jan–Jun topics from T152, with BFN bridge days for Ch 21–28.
    private static func pot6Weeks() -> [Int: [Weekday: DayAssignment]] {
        [
            3: [
                .monday: day(potCodes: ["T152"], chapters: [29, 30], osa: ["4.1", "5.8"], lar: "Lar Ch 7"),
                .tuesday: day(chapters: [21, 22], osa: ["2.3"], lar: "Lar Ch 1"),
                .wednesday: day(chapters: [23, 24], osa: ["2.3"], lar: "Lar Ch 3"),
                .thursday: day(chapters: [25, 26], osa: ["2.3"], lar: "Lar Ch 3"),
                .friday: day(osa: ["1.2", "5.8", "2.3"], lar: "Lar Ch 1–4", review: reviewLabels[3]),
            ],
            4: [
                .monday: day(chapters: [27, 28], osa: ["2.3"], lar: "Lar Ch 6"),
                .tuesday: day(potCodes: ["T225", "T226", "T227"], chapters: [47, 48], osa: ["6.1"], lar: "Lar Ch 9"),
                .wednesday: day(potCodes: ["T228", "T229"], chapters: [51], osa: ["6.1"], lar: "Lar Ch 9"),
                .thursday: day(potCodes: ["T230", "T231"], chapters: [51], osa: ["6.1"], lar: "Lar Ch 9"),
                .friday: day(potCodes: ["T239", "T240"], chapters: [52, 56], osa: ["6.1"], lar: "Lar Ch 9"),
            ],
            5: [
                .monday: day(potCodes: ["T241"], chapters: [54, 55], osa: ["6.1"], lar: "Lar Ch 9"),
                .tuesday: day(potCodes: ["T247"], chapters: [31], osa: ["2.1"], lar: "Lar Ch 4"),
                .wednesday: day(potCodes: ["T248", "T250", "T251"], chapters: [33, 34, 35, 36], osa: ["2.1", "4.1", "3.3"], lar: "Lar Ch 4–5"),
                .thursday: day(potCodes: ["T252", "T257"], chapters: [31, 26, 27], osa: ["2.1", "2.3"], lar: "Lar Ch 4"),
                .friday: day(potCodes: ["T258", "T259"], chapters: [37, 38, 29, 30, 36], osa: ["4.1", "5.8"], lar: "Lar Ch 6–7"),
            ],
            6: [
                .monday: day(potCodes: ["T264", "T265"], chapters: [26, 27], osa: ["2.3"], lar: "Lar Ch 6"),
                .tuesday: day(potCodes: ["T266", "T267"], chapters: [57, 58, 59, 60], osa: ["1.3"], lar: "Lar Ch 11"),
                .wednesday: day(potCodes: ["T261", "T262"], chapters: [61, 62, 64], osa: ["6.1"], lar: "Lar Ch 10"),
                .thursday: day(potCodes: ["T263", "T289"], chapters: [65, 66, 61, 62, 67, 68], osa: ["6.1"], lar: "Lar Ch 10"),
                .friday: day(potCodes: ["T282", "T283", "T284", "T155"], chapters: [45, 13, 14], osa: ["5.8", "6.1"], lar: "Lar Ch 1"),
            ],
            7: [
                .monday: day(potCodes: ["T285", "T286", "T287"], chapters: [46, 47, 45], osa: ["6.1"], lar: "Lar Ch 1"),
                .tuesday: day(potCodes: ["T310", "T311", "T312"], osa: ["2.1"], lar: "Lar Ch 11"),
                .wednesday: day(potCodes: ["T313", "T314", "T315"], osa: ["2.1"], lar: "Lar Ch 11"),
                .thursday: day(potCodes: ["T316", "T317"], osa: ["2.1"], lar: "Lar Ch 11"),
                .friday: day(osa: ["2.3"], lar: "Lar Ch 1–4", review: reviewLabels[7]),
            ],
            8: [
                .monday: day(potCodes: ["T270", "T271"], chapters: [40, 41], osa: ["13.7"], lar: "Lar Ch 13"),
                .tuesday: day(potCodes: ["T275", "T276", "T277"], chapters: [42, 43], osa: ["13.7"], lar: "Lar Ch 13"),
                .wednesday: day(chapters: [32, 38], osa: ["2.1", "3.3"], lar: "Lar Ch 4"),
                .thursday: day(potCodes: ["MIX1"], osa: ["1.2", "5.8", "2.3"], lar: "Lar Ch 1–13"),
                .friday: day(chapters: [50, 53, 63], osa: ["6.1"], lar: "Lar Ch 9"),
            ],
            9: [
                .monday: day(
                    chapters: [19, 49],
                    topicLabel: "RRISD · Exponential functions · OSA §6.1 · Ch 19, 49",
                    osa: ["6.1"],
                    lar: "Lar Ch 8"
                ),
                .tuesday: day(
                    topicLabel: "RRISD · Graphing exponentials · OSA §6.2",
                    osa: ["6.2"],
                    lar: "Lar Ch 8"
                ),
                .wednesday: day(
                    topicLabel: "RRISD · Logarithmic functions intro · OSA §6.3",
                    osa: ["6.3"],
                    lar: "Lar Ch 8"
                ),
                .thursday: day(
                    topicLabel: "RRISD · Log graphs & exp equations · OSA §6.4 · §6.6",
                    osa: ["6.4", "6.6"],
                    lar: "Lar Ch 8"
                ),
                .friday: day(osa: ["1.2", "5.8"], lar: "Lar Ch 1–4", review: reviewLabels[9]),
            ],
            10: [
                .monday: day(
                    topicLabel: "RRISD · Exponential models · OSA §6.7 · growth & decay",
                    osa: ["6.7"],
                    lar: "Lar Ch 8"
                ),
                .tuesday: day(potCodes: ["MIX2"], osa: ["1.2", "5.8", "2.3"], lar: "Lar Ch 1–13"),
                .wednesday: day(potCodes: ["T152", "T259"], chapters: [29, 30], osa: ["4.1", "5.8"], lar: "Lar Ch 7"),
                .thursday: day(potCodes: ["T289"], chapters: [61, 62, 67, 68], osa: ["6.1"], lar: "Lar Ch 10"),
                .friday: day(osa: ["home"], lar: "Lar Ch 1–13", review: reviewLabels[10]),
            ],
        ]
    }

    private static func buildPlan() -> [Int: [Weekday: DayAssignment]] {
        var result = foundationWeeks()
        for (week, days) in pot6Weeks() {
            result[week] = days
        }
        return result
    }
}
