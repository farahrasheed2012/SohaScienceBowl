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
        let isPrerequisite: Bool
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
        Item(potCode: "T152", title: "Solve systems of equations", catchUpDay: 1, bfnChapters: [29, 30], practiceTopicIds: ["math-systems"], isJanJune: true, isPrerequisite: true),
        Item(potCode: "T153", title: "Exponents", catchUpDay: 1, bfnChapters: [19], practiceTopicIds: ["math-exponents"], isJanJune: true, isPrerequisite: true),
        Item(potCode: "T154", title: "Laws of exponents", catchUpDay: 1, bfnChapters: [19, 49], practiceTopicIds: ["math-exponents"], isJanJune: true, isPrerequisite: true),
        Item(potCode: "T161", title: "Ratios", catchUpDay: 1, bfnChapters: [11, 12], practiceTopicIds: ["math-ratios"], isJanJune: true, isPrerequisite: true),
        Item(potCode: "T162", title: "Proportions", catchUpDay: 1, bfnChapters: [13], practiceTopicIds: ["math-ratios"], isJanJune: true, isPrerequisite: true),
        Item(potCode: "T225", title: "Introduction to polynomials", catchUpDay: 2, bfnChapters: [48, 49], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T226", title: "Evaluate polynomials", catchUpDay: 2, bfnChapters: [47, 48], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T227", title: "Add and subtract polynomials", catchUpDay: 2, bfnChapters: [48], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T228", title: "Multiply polynomials", catchUpDay: 2, bfnChapters: [51], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T229", title: "Divide polynomials", catchUpDay: 3, bfnChapters: [51], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T230", title: "Polynomial formulas — expand (easy)", catchUpDay: 3, bfnChapters: [51], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T231", title: "Polynomial formulas — expand (hard)", catchUpDay: 3, bfnChapters: [51], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T239", title: "Basics of factoring", catchUpDay: 4, bfnChapters: [52], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T240", title: "Factor — GCF and formulas", catchUpDay: 4, bfnChapters: [52, 56], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T241", title: "Factor quadratics", catchUpDay: 4, bfnChapters: [54, 55], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T247", title: "Rectangular coordinate system", catchUpDay: 5, bfnChapters: [31], practiceTopicIds: ["math-coordinate"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T248", title: "Equations of lines — all 5 forms", catchUpDay: 5, bfnChapters: [33, 34, 35], practiceTopicIds: ["math-linear-eq", "math-coordinate"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T250", title: "Slopes of parallel lines", catchUpDay: 5, bfnChapters: [36], practiceTopicIds: ["math-linear-eq"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T251", title: "Slopes of perpendicular lines", catchUpDay: 5, bfnChapters: [36], practiceTopicIds: ["math-linear-eq"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T252", title: "Midpoint and distance formulas", catchUpDay: 6, bfnChapters: [31], practiceTopicIds: ["math-coordinate", "math-pythagorean"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T257", title: "Graph inequalities on the number line", catchUpDay: 6, bfnChapters: [26, 27], practiceTopicIds: ["math-linear-eq"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T258", title: "Graph inequalities on the coordinate plane", catchUpDay: 6, bfnChapters: [37, 38], practiceTopicIds: ["math-linear-eq", "math-systems"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T259", title: "Number of solutions for systems", catchUpDay: 6, bfnChapters: [29, 30, 36], practiceTopicIds: ["math-systems"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T264", title: "Absolute values", catchUpDay: 7, bfnChapters: [26], practiceTopicIds: ["math-linear-eq"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T265", title: "Absolute value inequalities", catchUpDay: 7, bfnChapters: [27], practiceTopicIds: ["math-linear-eq"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T266", title: "Square roots", catchUpDay: 7, bfnChapters: [57], practiceTopicIds: ["math-roots"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T267", title: "Radicals", catchUpDay: 7, bfnChapters: [58, 59, 60], practiceTopicIds: ["math-roots"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T261", title: "Solve quadratic equations", catchUpDay: 8, bfnChapters: [61, 62], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T262", title: "Complete the square", catchUpDay: 8, bfnChapters: [64], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T263", title: "Vieta's formula", catchUpDay: 8, bfnChapters: [65, 66], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T289", title: "Complete review of quadratics", catchUpDay: 9, bfnChapters: [61, 62, 67, 68], practiceTopicIds: ["math-algebra-expressions"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T282", title: "Arithmetic sequences", catchUpDay: 10, bfnChapters: [45], practiceTopicIds: ["math-functions"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T283", title: "Direct and inverse proportion", catchUpDay: 10, bfnChapters: [13, 14], practiceTopicIds: ["math-ratios"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T284", title: "Relations and functions", catchUpDay: 10, bfnChapters: [45], practiceTopicIds: ["math-functions"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T285", title: "Evaluate functions", catchUpDay: 10, bfnChapters: [46, 47], practiceTopicIds: ["math-functions"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T286", title: "Undefined and unattainable values", catchUpDay: 10, bfnChapters: [46], practiceTopicIds: ["math-functions"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T287", title: "Geometric sequences", catchUpDay: 10, bfnChapters: [45], practiceTopicIds: ["math-functions"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T155", title: "Arithmetic sequences (intro)", catchUpDay: 10, bfnChapters: [45], practiceTopicIds: ["math-functions"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T223", title: "Geometric sequences (intro)", catchUpDay: 10, bfnChapters: [45], practiceTopicIds: ["math-functions"], isJanJune: true, isPrerequisite: true),
        Item(potCode: "T310", title: "Introduction to geometry", catchUpDay: 11, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T311", title: "Angles", catchUpDay: 11, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T312", title: "Angle and segment bisectors", catchUpDay: 11, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T313", title: "Angles with parallel lines", catchUpDay: 11, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T314", title: "Relationship between lines", catchUpDay: 11, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T315", title: "Test if lines are parallel", catchUpDay: 11, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T316", title: "Triangle inequalities", catchUpDay: 11, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T317", title: "Angle properties of triangles", catchUpDay: 11, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T270", title: "Box and whisker plots", catchUpDay: 12, bfnChapters: [40, 41], practiceTopicIds: ["math-data-graphs", "math-statistics"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T271", title: "Stem and leaf plots", catchUpDay: 12, bfnChapters: [41], practiceTopicIds: ["math-data-graphs"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T275", title: "Sets", catchUpDay: 12, bfnChapters: [42], practiceTopicIds: ["math-probability"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T276", title: "Events", catchUpDay: 12, bfnChapters: [43], practiceTopicIds: ["math-probability"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T277", title: "Compound probability events", catchUpDay: 12, bfnChapters: [43], practiceTopicIds: ["math-probability"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "MIX1", title: "Mixed review — Jan–Jun algebra topics", catchUpDay: 13, bfnChapters: [], practiceTopicIds: ["math-linear-eq", "math-systems", "math-algebra-expressions"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "MIX2", title: "Mixed review — functions, geometry, weak spots", catchUpDay: 14, bfnChapters: [], practiceTopicIds: ["math-functions", "math-geom-angles", "math-word-problems"], isJanJune: true, isPrerequisite: false),
        Item(potCode: "T254", title: "Determine if three points are collinear", catchUpDay: 0, bfnChapters: [31], practiceTopicIds: ["math-coordinate"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T272", title: "Counting — 7 methods", catchUpDay: 0, bfnChapters: [44], practiceTopicIds: ["math-probability"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T274", title: "Probability using counting", catchUpDay: 0, bfnChapters: [44], practiceTopicIds: ["math-probability"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T278", title: "Practice compound probability", catchUpDay: 0, bfnChapters: [43], practiceTopicIds: ["math-probability"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T279", title: "Probability tree diagrams", catchUpDay: 0, bfnChapters: [43], practiceTopicIds: ["math-probability"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T280", title: "Expected value in probability", catchUpDay: 0, bfnChapters: [43], practiceTopicIds: ["math-probability"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T281", title: "Reflection points", catchUpDay: 0, bfnChapters: [45], practiceTopicIds: ["math-functions"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T290", title: "Binomial theorem", catchUpDay: 0, bfnChapters: [51], practiceTopicIds: ["math-algebra-expressions"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T292", title: "Equations of circles", catchUpDay: 0, bfnChapters: [31], practiceTopicIds: ["math-coordinate"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T318", title: "Classify triangles", catchUpDay: 0, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T319", title: "Polygons", catchUpDay: 0, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T320", title: "Isosceles triangles", catchUpDay: 0, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T321", title: "Quadrilateral properties", catchUpDay: 0, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T322", title: "Logical reasoning", catchUpDay: 0, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T323", title: "Two-column proofs", catchUpDay: 0, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T324", title: "Congruent triangles", catchUpDay: 0, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T325", title: "Similar triangles", catchUpDay: 0, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T326", title: "Angle bisector theorem", catchUpDay: 0, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T331", title: "Centroid of a triangle", catchUpDay: 0, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T332", title: "Special triangles and trapezoids", catchUpDay: 0, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T333", title: "Right and special triangles (1)", catchUpDay: 0, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T334", title: "Right and special triangles (2)", catchUpDay: 0, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T335", title: "Determine triangle type", catchUpDay: 0, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T336", title: "Areas of 2D figures", catchUpDay: 0, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T337", title: "Methods for finding areas", catchUpDay: 0, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T338", title: "Surface area and volume of 3D figures", catchUpDay: 0, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T339", title: "Circle definitions", catchUpDay: 0, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T340", title: "Angles and segments in circles", catchUpDay: 0, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T341", title: "More circle properties", catchUpDay: 0, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T344", title: "Polyhedrons", catchUpDay: 0, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T345", title: "Common solid figures", catchUpDay: 0, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: false, isPrerequisite: false),
        Item(potCode: "T347", title: "Formulas for equilateral triangles", catchUpDay: 0, bfnChapters: [], practiceTopicIds: ["math-geom-angles", "math-pythagorean"], isJanJune: false, isPrerequisite: false),
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
        allItems.filter { !$0.isReviewMarker }.map(\.potCode)
    }

    static var dayPlans: [DayPlan] {
        (1...14).map { day in
            DayPlan(day: day, title: dayTitle(day), items: allItems.filter { $0.catchUpDay == day })
        }
    }

    static var masterListItems: [Item] {
        allItems.filter { !$0.isReviewMarker }.sorted { $0.potCode < $1.potCode }
    }

    static func dayTitle(_ day: Int) -> String {
        switch day {
        case 1: return "Day 1 · Algebra review (systems, exponents, ratios)"
        case 2: return "Day 2 · Polynomials — intro"
        case 3: return "Day 3 · Polynomials — divide & expand"
        case 4: return "Day 4 · Factoring"
        case 5: return "Day 5 · Lines & coordinate geometry"
        case 6: return "Day 6 · Inequalities & systems"
        case 7: return "Day 7 · Absolute value & radicals"
        case 8: return "Day 8 · Quadratic equations"
        case 9: return "Day 9 · Quadratic review"
        case 10: return "Day 10 · Functions & sequences"
        case 11: return "Day 11 · Geometry — angles & triangles"
        case 12: return "Day 12 · Statistics & probability (optional)"
        case 13: return "Day 13 · Mixed review — algebra"
        case 14: return "Day 14 · Mixed review — full"
        default: return "Day \(day)"
        }
    }

    static func practiceTopicIds(forDay day: Int) -> [String] {
        var seen = Set<String>()
        return allItems.filter { $0.catchUpDay == day }.flatMap(\.practiceTopicIds).filter { seen.insert($0).inserted }
    }

    static func bfnChapterNumbers(forDay day: Int) -> [Int] {
        var seen = Set<Int>()
        return allItems.filter { $0.catchUpDay == day }
            .flatMap(\.bfnChapters)
            .filter { seen.insert($0).inserted }
            .sorted()
    }

    static func readingOptions(forDay day: Int) -> MathAlgebraReadingCatalog.ReadingOptions {
        var larsonNumbers: [Int] = []
        var osaKeys: [String] = []
        var seenLar = Set<Int>()
        var seenOsa = Set<String>()

        for item in allItems where item.catchUpDay == day {
            let options = MathAlgebraReadingCatalog.readingOptions(
                bfnChapterNumbers: item.bfnChapters,
                potCode: item.potCode
            )
            for ch in options.larsonChapters where seenLar.insert(ch.number).inserted {
                larsonNumbers.append(ch.number)
            }
            for sec in options.openStaxSections where seenOsa.insert(sec.key).inserted {
                osaKeys.append(sec.key)
            }
        }

        return MathAlgebraReadingCatalog.ReadingOptions(
            larsonChapters: larsonNumbers.sorted().compactMap { MathAlgebraReadingCatalog.larsonChapter($0) },
            openStaxSections: osaKeys.compactMap { MathAlgebraReadingCatalog.openStaxSection($0) }
        )
    }
}
