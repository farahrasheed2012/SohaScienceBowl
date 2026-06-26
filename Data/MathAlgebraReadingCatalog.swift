import Foundation

/// Alternate algebra reading options for POT 6 catch-up — Larson Algebra 1 + OpenStax Algebra & Trigonometry 2e.
enum MathAlgebraReadingCatalog {
    static let larsonTitle = "Holt McDougal Larson Algebra 1 (2011)"
    static let larsonISBN = "9780547315157"
    static let osaTitle = "OpenStax Algebra & Trigonometry 2e"
    static let osaBookHome = URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/1-introduction-to-prerequisites")!

    struct LarsonChapter: Hashable, Identifiable {
        let number: Int
        let title: String
        var id: Int { number }
        var label: String { "Lar Ch \(number) — \(title)" }
    }

    struct LarsonSection: Hashable, Identifiable {
        let key: String
        let chapterNumber: Int
        let sectionNumber: Int
        let title: String
        var id: String { key }
        var label: String { "Lar §\(key) — \(title)" }
    }

    struct OpenStaxSection: Hashable, Identifiable {
        let key: String
        let title: String
        let url: URL?
        var id: String { key }
        var label: String { "OSA §\(key) — \(title)" }

        var chapterNumber: Int {
            Int(key.split(separator: ".").first ?? "0") ?? 0
        }
    }

    struct OpenStaxChapterGroup: Hashable, Identifiable {
        let number: Int
        let title: String
        let sections: [OpenStaxSection]
        var id: Int { number }
    }

    struct ReadingOptions: Hashable {
        let larsonSections: [LarsonSection]
        let openStaxSections: [OpenStaxSection]

        var isEmpty: Bool { larsonSections.isEmpty && openStaxSections.isEmpty }

        var larsonChapters: [LarsonChapter] {
            var seen = Set<Int>()
            return larsonSections.compactMap { section in
                guard seen.insert(section.chapterNumber).inserted else { return nil }
                return larsonChapter(section.chapterNumber)
            }
        }
    }

    static let larsonChapters: [LarsonChapter] = [
        LarsonChapter(number: 1, title: "Expressions, Equations, and Functions"),
        LarsonChapter(number: 2, title: "Properties of Real Numbers"),
        LarsonChapter(number: 3, title: "Solving Linear Equations"),
        LarsonChapter(number: 4, title: "Graphing Linear Equations and Functions"),
        LarsonChapter(number: 5, title: "Writing Linear Equations"),
        LarsonChapter(number: 6, title: "Solving and Graphing Linear Inequalities"),
        LarsonChapter(number: 7, title: "Systems of Equations and Inequalities"),
        LarsonChapter(number: 8, title: "Exponents and Exponential Functions"),
        LarsonChapter(number: 9, title: "Polynomials and Factoring"),
        LarsonChapter(number: 10, title: "Quadratic Equations and Functions"),
        LarsonChapter(number: 11, title: "Radicals and Geometry Connections"),
        LarsonChapter(number: 12, title: "Rational Equations and Functions"),
        LarsonChapter(number: 13, title: "Probability and Data Analysis"),
    ]

    private static let larsonByNumber: [Int: LarsonChapter] = {
        Dictionary(uniqueKeysWithValues: larsonChapters.map { ($0.number, $0) })
    }()

    private static func lar(_ chapter: Int, _ section: Int, _ title: String) -> LarsonSection {
        LarsonSection(key: "\(chapter).\(section)", chapterNumber: chapter, sectionNumber: section, title: title)
    }

    /// Larson § catalog for POT 6–relevant chapters (2011 Florida / national edition section titles).
    static let larsonSections: [LarsonSection] = [
        // Ch 1 — Expressions, Equations, and Functions
        lar(1, 1, "Variables and Expressions"),
        lar(1, 2, "Evaluate Variable Expressions"),
        lar(1, 3, "Simplifying Variable Expressions"),
        lar(1, 4, "Write and Solve Addition Equations"),
        lar(1, 5, "Write and Solve Subtraction Equations"),
        lar(1, 6, "Write and Solve Multiplication Equations"),
        lar(1, 7, "Write and Solve Division Equations"),
        lar(1, 8, "Functions as Rules and Tables"),
        lar(1, 9, "Functions as Graphs"),
        // Ch 2 — Properties of Real Numbers
        lar(2, 1, "Real Numbers and the Number Line"),
        lar(2, 2, "Adding Real Numbers"),
        lar(2, 3, "Subtracting Real Numbers"),
        lar(2, 4, "Multiplying and Dividing Real Numbers"),
        lar(2, 5, "The Order of Operations and Square Roots"),
        lar(2, 6, "The Coordinate Plane"),
        lar(2, 7, "Represent Functions as Graphs"),
        // Ch 3 — Solving Linear Equations
        lar(3, 1, "Solving One-Step Equations"),
        lar(3, 2, "Solving Two-Step Equations"),
        lar(3, 3, "Solving Multi-Step Equations"),
        lar(3, 4, "Solving Equations with Variables on Both Sides"),
        lar(3, 5, "Linear Equations and Problem Solving"),
        lar(3, 6, "Solving Decimal Equations"),
        lar(3, 7, "Formulas and Functions"),
        // Ch 4 — Graphing Linear Equations and Functions
        lar(4, 1, "The Coordinate Plane"),
        lar(4, 2, "Relations and Functions"),
        lar(4, 3, "Graphing Linear Equations"),
        lar(4, 4, "The Slope of a Line"),
        lar(4, 5, "Direct Variation"),
        lar(4, 6, "Quick Graphs Using Slope-Intercept Form"),
        lar(4, 7, "Quick Graphs Using Intercepts"),
        lar(4, 8, "Parallel and Perpendicular Lines"),
        // Ch 5 — Writing Linear Equations
        lar(5, 1, "Writing Linear Equations in Slope-Intercept Form"),
        lar(5, 2, "Writing Linear Equations Using Point-Slope Form"),
        lar(5, 3, "Writing Linear Equations Given Two Points"),
        lar(5, 4, "Writing Linear Equations in Standard Form"),
        lar(5, 5, "Writing Equations of Parallel and Perpendicular Lines"),
        // Ch 6 — Solving and Graphing Linear Inequalities
        lar(6, 1, "Graphing Linear Inequalities"),
        lar(6, 2, "Solving Inequalities Using Addition or Subtraction"),
        lar(6, 3, "Solving Inequalities Using Multiplication or Division"),
        lar(6, 4, "Solving Multi-Step Inequalities"),
        lar(6, 5, "Solving Compound Inequalities"),
        lar(6, 6, "Solving Absolute Value Inequalities"),
        // Ch 7 — Systems of Equations and Inequalities
        lar(7, 1, "Solve Linear Systems by Graphing"),
        lar(7, 2, "Solve Linear Systems by Substitution"),
        lar(7, 3, "Solve Linear Systems by Adding or Subtracting"),
        lar(7, 4, "Solve Linear Systems by Multiplying First"),
        lar(7, 5, "Solve Special Types of Linear Systems"),
        lar(7, 6, "Solve Systems of Linear Inequalities"),
        // Ch 8 — Exponents and Exponential Functions
        lar(8, 1, "Apply Exponent Properties Involving Products"),
        lar(8, 2, "Apply Exponent Properties Involving Quotients"),
        lar(8, 3, "Define and Use Zero and Negative Exponents"),
        lar(8, 4, "Use Scientific Notation"),
        lar(8, 5, "Write and Graph Exponential Growth Functions"),
        lar(8, 6, "Write and Graph Exponential Decay Functions"),
        // Ch 9 — Polynomials and Factoring
        lar(9, 1, "Add and Subtract Polynomials"),
        lar(9, 2, "Multiply Polynomials"),
        lar(9, 3, "Find Special Products of Polynomials"),
        lar(9, 4, "Solve Polynomial Equations in Factored Form"),
        lar(9, 5, "Factor x² + bx + c"),
        lar(9, 6, "Factor ax² + bx + c"),
        lar(9, 7, "Factor Special Products"),
        lar(9, 8, "Factor Polynomials Completely"),
        // Ch 10 — Quadratic Equations and Functions
        lar(10, 1, "Graph y = ax² + c"),
        lar(10, 2, "Graph y = ax² + bx + c"),
        lar(10, 3, "Solve Quadratic Equations by Graphing"),
        lar(10, 4, "Use Square Roots to Solve Quadratic Equations"),
        lar(10, 5, "Solve Quadratic Equations by Completing the Square"),
        lar(10, 6, "Solve Quadratic Equations by the Quadratic Formula"),
        lar(10, 7, "Interpret the Discriminant"),
        lar(10, 8, "Compare Linear, Exponential, and Quadratic Models"),
        // Ch 11 — Radicals and Geometry Connections
        lar(11, 1, "Graph Square Root Functions"),
        lar(11, 2, "Simplify Radical Expressions"),
        lar(11, 3, "Solve Radical Equations"),
        lar(11, 4, "Apply the Pythagorean Theorem and Its Converse"),
        lar(11, 5, "Apply the Distance and Midpoint Formulas"),
        // Ch 13 — Probability and Data Analysis
        lar(13, 1, "Permutations and Combinations"),
        lar(13, 2, "Theoretical and Experimental Probability"),
        lar(13, 3, "Probability of Compound Events"),
        lar(13, 4, "Independent and Dependent Events"),
        lar(13, 5, "Misleading Statistics"),
    ]

    private static let larsonByKey: [String: LarsonSection] = {
        Dictionary(uniqueKeysWithValues: larsonSections.map { ($0.key, $0) })
    }()

    private static let osaBase = "https://openstax.org/books/algebra-and-trigonometry-2e/pages"

    private static func osa(_ key: String, _ title: String, slug: String) -> OpenStaxSection {
        OpenStaxSection(key: key, title: title, url: URL(string: "\(osaBase)/\(slug)"))
    }

    /// Prerequisite / probability sections outside the Ch 2–6 core map.
    private static let openStaxSupplementSections: [OpenStaxSection] = [
        osa("1.1", "Real Numbers: Algebra Essentials", slug: "1-1-real-numbers-algebra-essentials"),
        osa("1.2", "Exponents and Scientific Notation", slug: "1-2-exponents-and-scientific-notation"),
        osa("1.3", "Radicals and Rational Exponents", slug: "1-3-radicals-and-rational-exponents"),
        osa("13.7", "Probability", slug: "13-7-probability"),
    ]

    /// Every § in OpenStax Ch 2–6 (Equations → Exponential/Log).
    static let openStaxChapters2Through6: [OpenStaxChapterGroup] = [
        OpenStaxChapterGroup(number: 2, title: "Equations and Inequalities", sections: [
            osa("2.1", "The Rectangular Coordinate Systems and Graphs", slug: "2-1-the-rectangular-coordinate-systems-and-graphs"),
            osa("2.2", "Linear Equations in One Variable", slug: "2-2-linear-equations-in-one-variable"),
            osa("2.3", "Models and Applications", slug: "2-3-models-and-applications"),
            osa("2.4", "Complex Numbers", slug: "2-4-complex-numbers"),
            osa("2.5", "Quadratic Equations", slug: "2-5-quadratic-equations"),
            osa("2.6", "Other Types of Equations", slug: "2-6-other-types-of-equations"),
            osa("2.7", "Linear Inequalities and Absolute Value Inequalities", slug: "2-7-linear-inequalities-and-absolute-value-inequalities"),
        ]),
        OpenStaxChapterGroup(number: 3, title: "Functions", sections: [
            osa("3.1", "Functions and Function Notation", slug: "3-1-functions-and-function-notation"),
            osa("3.2", "Domain and Range", slug: "3-2-domain-and-range"),
            osa("3.3", "Rates of Change and Behavior of Graphs", slug: "3-3-rates-of-change-and-behavior-of-graphs"),
            osa("3.4", "Composition of Functions", slug: "3-4-composition-of-functions"),
            osa("3.5", "Transformation of Functions", slug: "3-5-transformation-of-functions"),
            osa("3.6", "Absolute Value Functions", slug: "3-6-absolute-value-functions"),
            osa("3.7", "Inverse Functions", slug: "3-7-inverse-functions"),
        ]),
        OpenStaxChapterGroup(number: 4, title: "Linear Functions", sections: [
            osa("4.1", "Linear Functions", slug: "4-1-linear-functions"),
            osa("4.2", "Modeling with Linear Functions", slug: "4-2-modeling-with-linear-functions"),
            osa("4.3", "Fitting Linear Models to Data", slug: "4-3-fitting-linear-models-to-data"),
        ]),
        OpenStaxChapterGroup(number: 5, title: "Polynomial and Rational Functions", sections: [
            osa("5.1", "Quadratic Functions", slug: "5-1-quadratic-functions"),
            osa("5.2", "Power Functions and Polynomial Functions", slug: "5-2-power-functions-and-polynomial-functions"),
            osa("5.3", "Graphs of Polynomial Functions", slug: "5-3-graphs-of-polynomial-functions"),
            osa("5.4", "Dividing Polynomials", slug: "5-4-dividing-polynomials"),
            osa("5.5", "Zeros of Polynomial Functions", slug: "5-5-zeros-of-polynomial-functions"),
            osa("5.6", "Rational Functions", slug: "5-6-rational-functions"),
            osa("5.7", "Inverses and Radical Functions", slug: "5-7-inverses-and-radical-functions"),
            osa("5.8", "Modeling Using Variation", slug: "5-8-modeling-using-variation"),
        ]),
        OpenStaxChapterGroup(number: 6, title: "Exponential and Logarithmic Functions", sections: [
            osa("6.1", "Exponential Functions", slug: "6-1-exponential-functions"),
            osa("6.2", "Graphs of Exponential Functions", slug: "6-2-graphs-of-exponential-functions"),
            osa("6.3", "Logarithmic Functions", slug: "6-3-logarithmic-functions"),
            osa("6.4", "Graphs of Logarithmic Functions", slug: "6-4-graphs-of-logarithmic-functions"),
            osa("6.5", "Logarithmic Properties", slug: "6-5-logarithmic-properties"),
            osa("6.6", "Exponential and Logarithmic Equations", slug: "6-6-exponential-and-logarithmic-equations"),
            osa("6.7", "Exponential and Logarithmic Models", slug: "6-7-exponential-and-logarithmic-models"),
            osa("6.8", "Fitting Exponential Models to Data", slug: "6-8-fitting-exponential-models-to-data"),
        ]),
    ]

    private static let openStaxSections: [OpenStaxSection] = {
        openStaxSupplementSections + openStaxChapters2Through6.flatMap(\.sections)
    }()

    private static let openStaxByKey: [String: OpenStaxSection] = {
        Dictionary(uniqueKeysWithValues: openStaxSections.map { ($0.key, $0) })
    }()

    /// BFN-A chapter → alternate Larson § + OpenStax § (same summer-schedule family of books).
    private static let byBFNChapter: [Int: (larson: [String], osa: [String])] = [
        11: (["3.2", "3.5"], ["5.8"]),
        12: (["3.2", "3.5"], ["5.8"]),
        13: (["3.2", "3.5"], ["5.8"]),
        14: (["3.2", "3.5"], ["5.8"]),
        19: (["8.1", "8.2", "8.3", "8.4"], ["1.2", "6.1"]),
        26: (["6.2", "6.3", "6.4"], ["2.7"]),
        27: (["6.2", "6.3", "6.4"], ["2.7"]),
        29: (["7.1", "7.2", "7.3"], ["2.2", "2.3", "2.6"]),
        30: (["7.1", "7.2", "7.3"], ["2.2", "2.3", "2.6"]),
        31: (["4.1", "2.6"], ["2.1", "3.1"]),
        33: (["4.3", "4.4", "4.5", "5.1"], ["4.1", "3.3", "4.2"]),
        34: (["4.3", "4.4", "5.1", "5.2"], ["4.1", "4.2"]),
        35: (["5.1", "5.2", "5.3"], ["4.1", "4.2"]),
        36: (["7.6"], ["4.1"]),
        37: (["6.4", "6.5"], ["2.7"]),
        38: (["6.4", "6.5", "6.6", "7.6"], ["2.7", "3.6"]),
        40: (["13.2", "13.3"], ["13.7"]),
        41: (["13.2", "13.3"], ["13.7"]),
        42: (["13.2", "13.4"], ["13.7"]),
        43: (["13.2", "13.4"], ["13.7"]),
        44: (["13.2", "13.3", "13.4"], ["13.7"]),
        45: (["1.8", "1.9", "4.2"], ["3.1", "3.2"]),
        46: (["1.8", "4.2"], ["3.1"]),
        47: (["1.8", "1.9", "4.2"], ["3.1", "3.2", "3.3"]),
        48: (["9.1"], ["5.2", "5.3"]),
        49: (["8.1", "8.2", "9.2"], ["1.2", "5.4"]),
        51: (["9.2", "9.4", "9.5"], ["5.3", "5.4", "5.5"]),
        52: (["9.5", "9.6"], ["5.5"]),
        54: (["9.5", "9.6"], ["5.5"]),
        55: (["9.6", "9.7"], ["5.5"]),
        56: (["9.7", "9.8"], ["5.5", "5.6"]),
        57: (["11.2", "11.3"], ["1.3", "5.7"]),
        58: (["11.2", "11.4"], ["1.3", "5.7"]),
        59: (["11.2", "11.5"], ["5.7"]),
        60: (["11.2", "11.5"], ["5.7"]),
        61: (["10.1", "10.2", "10.3"], ["2.5", "5.1"]),
        62: (["10.1", "10.2", "10.4"], ["2.5", "5.1"]),
        64: (["10.4", "10.5"], ["2.5", "5.1"]),
        65: (["10.5", "10.6"], ["2.5", "5.1"]),
        66: (["10.6", "10.7"], ["2.5", "5.1"]),
        67: (["10.1", "10.2"], ["5.1", "5.2"]),
        68: (["10.2", "10.3"], ["5.1"]),
    ]

    /// Topic-specific overrides when BFN chapters are empty (geometry) or need extra depth.
    private static let byPotCode: [String: (larson: [String], osa: [String])] = [
        "T152": (["7.1", "7.2", "7.3"], ["2.2", "2.3", "2.6"]),
        "T153": (["8.1", "8.2", "8.3"], ["1.2", "6.1"]),
        "T154": (["8.1", "8.2", "9.2"], ["1.2", "5.4"]),
        "T161": (["3.2", "3.5"], ["5.8"]),
        "T162": (["3.2", "3.5"], ["5.8"]),
        "T310": (["11.4", "11.5"], ["2.1"]),
        "T311": (["11.4"], ["2.1"]),
        "T312": (["11.4"], []),
        "T313": (["4.8", "11.4"], ["2.1"]),
        "T314": (["4.8", "11.4"], ["2.1"]),
        "T315": (["4.8", "11.4"], ["2.1"]),
        "T316": (["11.4"], []),
        "T317": (["11.4"], []),
        "T318": (["11.4"], []),
        "T319": (["11.4"], []),
        "T320": (["11.4"], []),
        "T321": (["11.4"], []),
        "T322": (["11.4"], []),
        "T323": (["11.4"], []),
        "T324": (["11.4"], []),
        "T325": (["11.4"], []),
        "T326": (["11.4"], []),
        "T331": (["11.4", "11.5"], []),
        "T332": (["11.4"], []),
        "T333": (["11.4"], []),
        "T334": (["11.4"], []),
        "T335": (["11.4"], []),
        "T336": (["11.4", "11.5"], []),
        "T337": (["11.4", "11.5"], []),
        "T338": (["11.4"], []),
        "T339": (["11.5"], ["2.1"]),
        "T340": (["11.5"], []),
        "T341": (["11.5"], []),
        "T344": (["11.4"], []),
        "T345": (["11.4"], []),
        "T347": (["11.4"], []),
        "T292": (["11.5", "10.1"], ["2.1", "2.5"]),
        "6HW37": (["11.4", "11.5"], []),
        "MIX1": (["7.2", "7.3", "9.5", "9.6", "10.5", "10.6"], ["2.5", "4.1", "5.5"]),
        "MIX2": (["1.8", "1.9", "10.1", "10.6", "11.2"], ["3.1", "5.1"]),
        "MIX3": (["7.2", "9.5", "9.6", "10.5", "10.6"], ["2.5", "4.1", "5.5", "3.1"]),
        "T257": (["2.7", "3.6"], ["2.3"]),
    ]

    static func larsonChapter(_ number: Int) -> LarsonChapter? {
        larsonByNumber[number]
    }

    static func larsonSection(_ key: String) -> LarsonSection? {
        larsonByKey[key]
    }

    static func larsonSections(inChapter chapter: Int) -> [LarsonSection] {
        larsonSections.filter { $0.chapterNumber == chapter }
    }

    static func openStaxSection(_ key: String) -> OpenStaxSection? {
        openStaxByKey[key]
    }

    static func openStaxSections(inChapter chapter: Int) -> [OpenStaxSection] {
        openStaxChapters2Through6.first { $0.number == chapter }?.sections ?? []
    }

    static func readingOptions(bfnChapterNumbers: [Int], potCode: String? = nil) -> ReadingOptions {
        var larsonKeys: [String] = []
        var osaKeys: [String] = []
        var seenLar = Set<String>()
        var seenOsa = Set<String>()

        if let potCode, let override = byPotCode[potCode] {
            for key in override.larson where seenLar.insert(key).inserted { larsonKeys.append(key) }
            for key in override.osa where seenOsa.insert(key).inserted { osaKeys.append(key) }
        }

        for chapter in bfnChapterNumbers {
            guard let mapping = byBFNChapter[chapter] else { continue }
            for key in mapping.larson where seenLar.insert(key).inserted { larsonKeys.append(key) }
            for key in mapping.osa where seenOsa.insert(key).inserted { osaKeys.append(key) }
        }

        return ReadingOptions(
            larsonSections: sortedLarsonKeys(larsonKeys),
            openStaxSections: sortedOsaKeys(osaKeys)
        )
    }

    static func mergedReadingOptions(bfnChapterNumbers: [Int], potCodes: [String]) -> ReadingOptions {
        var larsonKeys: [String] = []
        var osaKeys: [String] = []
        var seenLar = Set<String>()
        var seenOsa = Set<String>()

        for code in potCodes {
            let options = readingOptions(bfnChapterNumbers: bfnChapterNumbers, potCode: code)
            for section in options.larsonSections where seenLar.insert(section.key).inserted {
                larsonKeys.append(section.key)
            }
            for section in options.openStaxSections where seenOsa.insert(section.key).inserted {
                osaKeys.append(section.key)
            }
        }

        for chapter in bfnChapterNumbers {
            guard let mapping = byBFNChapter[chapter] else { continue }
            for key in mapping.larson where seenLar.insert(key).inserted { larsonKeys.append(key) }
            for key in mapping.osa where seenOsa.insert(key).inserted { osaKeys.append(key) }
        }

        return ReadingOptions(
            larsonSections: sortedLarsonKeys(larsonKeys),
            openStaxSections: sortedOsaKeys(osaKeys)
        )
    }

    private static func sortedLarsonKeys(_ keys: [String]) -> [LarsonSection] {
        keys.compactMap { larsonSection($0) }
            .sorted {
                if $0.chapterNumber != $1.chapterNumber { return $0.chapterNumber < $1.chapterNumber }
                return $0.sectionNumber < $1.sectionNumber
            }
    }

    private static func sortedOsaKeys(_ keys: [String]) -> [OpenStaxSection] {
        keys.compactMap { openStaxSection($0) }
            .sorted {
                if $0.chapterNumber != $1.chapterNumber { return $0.chapterNumber < $1.chapterNumber }
                let aSec = Int($0.key.split(separator: ".").last ?? "0") ?? 0
                let bSec = Int($1.key.split(separator: ".").last ?? "0") ?? 0
                return aSec < bSec
            }
    }
}
