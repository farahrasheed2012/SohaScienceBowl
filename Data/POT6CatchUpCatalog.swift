import Foundation

/// Math POT 6 school topics (POT 6 BASIC) for Soha — Jan–Jun 2026 catch-up before joining class.
enum POT6CatchUpCatalog {
    struct Item: Identifiable, Hashable {
        let potCode: String
        let title: String
        let catchUpDay: Int
        let bfnChapters: [Int]
        let practiceTopicIds: [String]
        let isJanJune: Bool
        var id: String { potCode }
        var isReviewMarker: Bool { potCode.hasPrefix("MIX") }
    }

    struct DayPlan: Identifiable {
        let day: Int
        let title: String
        let items: [Item]
        var id: Int { day }
    }

    static let classSchedule = "Sat 10:30–11:45 (BASIC) or Sun 2:30–3:45 (full POT 6)"
    static let missedWindow = "Jan 7 – Jun 28, 2026 (24 Sunday sessions)"

    static let allItems: [Item] = [
        Item(potCode: "T225", title: "Introduction to polynomials", catchUpDay: 1, bfnChapters: [48, 49], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true),
        Item(potCode: "T226", title: "Evaluate polynomials", catchUpDay: 1, bfnChapters: [47, 48], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true),
        Item(potCode: "T227", title: "Add and subtract polynomials", catchUpDay: 1, bfnChapters: [48], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true),
        Item(potCode: "T228", title: "Multiply polynomials", catchUpDay: 1, bfnChapters: [51], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true),
        Item(potCode: "T229", title: "Divide polynomials", catchUpDay: 2, bfnChapters: [51], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true),
        Item(potCode: "T230", title: "Polynomial formulas — expand (easy)", catchUpDay: 2, bfnChapters: [51], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true),
        Item(potCode: "T231", title: "Polynomial formulas — expand (hard)", catchUpDay: 2, bfnChapters: [51], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true),
        Item(potCode: "T239", title: "Basics of factoring", catchUpDay: 3, bfnChapters: [52], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true),
        Item(potCode: "T240", title: "Factor — GCF and formulas", catchUpDay: 3, bfnChapters: [52, 56], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true),
        Item(potCode: "T241", title: "Factor quadratics", catchUpDay: 3, bfnChapters: [54, 55], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true),
        Item(potCode: "T247", title: "Rectangular coordinate system", catchUpDay: 4, bfnChapters: [31], practiceTopicIds: ["math-coordinate"], isJanJune: true),
        Item(potCode: "T248", title: "Equations of lines — all 5 forms", catchUpDay: 4, bfnChapters: [33, 34, 35], practiceTopicIds: ["math-linear-eq", "math-coordinate"], isJanJune: true),
        Item(potCode: "T250", title: "Slopes of parallel lines", catchUpDay: 4, bfnChapters: [36], practiceTopicIds: ["math-linear-eq"], isJanJune: true),
        Item(potCode: "T251", title: "Slopes of perpendicular lines", catchUpDay: 4, bfnChapters: [36], practiceTopicIds: ["math-linear-eq"], isJanJune: true),
        Item(potCode: "T252", title: "Midpoint and distance formulas", catchUpDay: 5, bfnChapters: [31], practiceTopicIds: ["math-coordinate", "math-pythagorean"], isJanJune: true),
        Item(potCode: "T257", title: "Graph inequalities on the number line", catchUpDay: 5, bfnChapters: [26, 27], practiceTopicIds: ["math-linear-eq"], isJanJune: true),
        Item(potCode: "T258", title: "Graph inequalities on the coordinate plane", catchUpDay: 5, bfnChapters: [37, 38], practiceTopicIds: ["math-linear-eq", "math-systems"], isJanJune: true),
        Item(potCode: "T259", title: "Number of solutions for systems", catchUpDay: 5, bfnChapters: [29, 30, 36], practiceTopicIds: ["math-systems"], isJanJune: true),
        Item(potCode: "T264", title: "Absolute values", catchUpDay: 6, bfnChapters: [26], practiceTopicIds: ["math-linear-eq"], isJanJune: true),
        Item(potCode: "T265", title: "Absolute value inequalities", catchUpDay: 6, bfnChapters: [27], practiceTopicIds: ["math-linear-eq"], isJanJune: true),
        Item(potCode: "T266", title: "Square roots", catchUpDay: 6, bfnChapters: [57], practiceTopicIds: ["math-roots"], isJanJune: true),
        Item(potCode: "T267", title: "Radicals", catchUpDay: 6, bfnChapters: [58, 59, 60], practiceTopicIds: ["math-roots"], isJanJune: true),
        Item(potCode: "T261", title: "Solve quadratic equations", catchUpDay: 7, bfnChapters: [61, 62], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true),
        Item(potCode: "T262", title: "Complete the square", catchUpDay: 7, bfnChapters: [64], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true),
        Item(potCode: "T263", title: "Vieta's formula", catchUpDay: 7, bfnChapters: [65, 66], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true),
        Item(potCode: "T289", title: "Complete review of quadratics", catchUpDay: 8, bfnChapters: [61, 62, 67, 68], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true),
        Item(potCode: "T282", title: "Arithmetic sequences", catchUpDay: 9, bfnChapters: [45], practiceTopicIds: ["math-functions"], isJanJune: true),
        Item(potCode: "T283", title: "Direct and inverse proportion", catchUpDay: 9, bfnChapters: [13, 14], practiceTopicIds: ["math-ratios"], isJanJune: true),
        Item(potCode: "T284", title: "Relations and functions", catchUpDay: 9, bfnChapters: [45], practiceTopicIds: ["math-functions"], isJanJune: true),
        Item(potCode: "T285", title: "Evaluate functions", catchUpDay: 9, bfnChapters: [46, 47], practiceTopicIds: ["math-functions"], isJanJune: true),
        Item(potCode: "T286", title: "Undefined and unattainable values", catchUpDay: 9, bfnChapters: [46], practiceTopicIds: ["math-functions"], isJanJune: true),
        Item(potCode: "T287", title: "Geometric sequences", catchUpDay: 9, bfnChapters: [45], practiceTopicIds: ["math-functions"], isJanJune: true),
        Item(potCode: "MIX3", title: "Mixed review — algebra before stats", catchUpDay: 10, bfnChapters: [], practiceTopicIds: ["math-algebra-expressions", "math-linear-eq", "math-functions"], isJanJune: true),
        Item(potCode: "T270", title: "Box and whisker plots", catchUpDay: 11, bfnChapters: [40, 41], practiceTopicIds: ["math-data-graphs", "math-statistics"], isJanJune: false),
        Item(potCode: "T271", title: "Stem and leaf plots", catchUpDay: 11, bfnChapters: [41], practiceTopicIds: ["math-data-graphs"], isJanJune: false),
        Item(potCode: "T275", title: "Sets", catchUpDay: 11, bfnChapters: [42], practiceTopicIds: ["math-probability"], isJanJune: false),
        Item(potCode: "T276", title: "Events", catchUpDay: 11, bfnChapters: [43], practiceTopicIds: ["math-probability"], isJanJune: false),
        Item(potCode: "T277", title: "Compound probability events", catchUpDay: 11, bfnChapters: [43], practiceTopicIds: ["math-probability"], isJanJune: false),
        Item(potCode: "MIX1", title: "Mixed review — Jan–Jun algebra topics", catchUpDay: 12, bfnChapters: [], practiceTopicIds: ["math-linear-eq", "math-systems", "math-algebra-expressions"], isJanJune: true),
        Item(potCode: "MIX2", title: "Mixed review — stats, probability & weak spots", catchUpDay: 13, bfnChapters: [], practiceTopicIds: ["math-functions", "math-probability", "math-word-problems"], isJanJune: true),
        Item(potCode: "T254", title: "Determine if three points are collinear", catchUpDay: 5, bfnChapters: [31], practiceTopicIds: ["math-coordinate"], isJanJune: false),
        Item(potCode: "T272", title: "Counting — 7 methods", catchUpDay: 11, bfnChapters: [44], practiceTopicIds: ["math-probability"], isJanJune: false),
        Item(potCode: "T274", title: "Probability using counting", catchUpDay: 11, bfnChapters: [44], practiceTopicIds: ["math-probability"], isJanJune: false),
        Item(potCode: "T278", title: "Practice compound probability", catchUpDay: 11, bfnChapters: [43], practiceTopicIds: ["math-probability"], isJanJune: false),
        Item(potCode: "T279", title: "Probability tree diagrams", catchUpDay: 11, bfnChapters: [43], practiceTopicIds: ["math-probability"], isJanJune: false),
        Item(potCode: "T280", title: "Expected value in probability", catchUpDay: 11, bfnChapters: [43], practiceTopicIds: ["math-probability"], isJanJune: false),
        Item(potCode: "T281", title: "Reflection points", catchUpDay: 9, bfnChapters: [45], practiceTopicIds: ["math-functions"], isJanJune: false),
        Item(potCode: "T290", title: "Binomial theorem", catchUpDay: 13, bfnChapters: [51], practiceTopicIds: ["math-algebra-expressions"], isJanJune: false),
    ]

    static let competitionOnlyCodes: [String] = [
        "T224",
        "T232",
        "T233",
        "T234",
        "T235",
        "T236",
        "T237",
        "T238",
        "T242",
        "T243",
        "T244",
        "T245",
        "T246",
        "T249",
        "T253",
        "T255",
        "T256",
        "T260",
        "T268",
        "T269",
        "T273",
        "T288",
        "T291",
        "T327",
        "T328",
        "T329",
        "T330",
        "T342",
        "T343",
        "T346",
        "T348",
        "T349",
        "T350",
        "T351",
        "T352",
        "T353",
    ]

    static var janJuneSchoolCodes: [String] {
        allItems.filter { $0.isJanJune && !$0.isReviewMarker }.map(\.potCode)
    }

    static var allSchoolCodes: [String] {
        POT6AlgebraCatalog.schoolCodes
    }

    static var dayPlans: [DayPlan] {
        (1...13).compactMap { day in
            let items = allItems.filter { $0.catchUpDay == day }
            guard !items.isEmpty else { return nil }
            return DayPlan(day: day, title: dayTitle(day), items: items)
        }
    }

    static var masterListItems: [Item] {
        allItems.filter { !$0.isReviewMarker }.sorted { $0.potCode < $1.potCode }
    }

    static func dayTitle(_ day: Int) -> String {
        switch day {
        case 1: return "Polynomials — intro"
        case 2: return "Polynomials — divide & expand"
        case 3: return "Factoring"
        case 4: return "Lines & coordinate geometry"
        case 5: return "Inequalities & systems"
        case 6: return "Absolute value & radicals"
        case 7: return "Quadratic equations"
        case 8: return "Quadratic review"
        case 9: return "Functions & sequences"
        case 10: return "Algebra review — before stats"
        case 11: return "Statistics & probability (optional)"
        case 12: return "Mixed review — algebra"
        case 13: return "Mixed review — full algebra"
        default: return "Day \(day)"
        }
    }

    static func practiceTopicIds(forDay day: Int) -> [String] {
        var seen = Set<String>()
        return allItems.filter { $0.catchUpDay == day }
            .flatMap(\.practiceTopicIds)
            .filter { seen.insert($0).inserted }
    }

    static func bfnChapterNumbers(forDay day: Int) -> [Int] {
        var seen = Set<Int>()
        return allItems.filter { $0.catchUpDay == day }
            .flatMap(\.bfnChapters)
            .filter { seen.insert($0).inserted }
            .sorted()
    }

    static func readingOptions(forDay day: Int) -> MathAlgebraReadingCatalog.ReadingOptions {
        MathAlgebraReadingCatalog.mergedReadingOptions(
            bfnChapterNumbers: bfnChapterNumbers(forDay: day),
            potCodes: allItems.filter { $0.catchUpDay == day }.map(\.potCode)
        )
    }
}
