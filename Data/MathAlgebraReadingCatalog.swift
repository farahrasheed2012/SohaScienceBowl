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

    struct OpenStaxSection: Hashable, Identifiable {
        let key: String
        let title: String
        let url: URL?
        var id: String { key }
        var label: String { "OSA §\(key) — \(title)" }
    }

    struct ReadingOptions: Hashable {
        let larsonChapters: [LarsonChapter]
        let openStaxSections: [OpenStaxSection]

        var isEmpty: Bool { larsonChapters.isEmpty && openStaxSections.isEmpty }
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

    private static let openStaxSections: [OpenStaxSection] = [
        OpenStaxSection(key: "1.1", title: "Real Numbers: Algebra Essentials", url: URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/1-1-real-numbers-algebra-essentials")),
        OpenStaxSection(key: "1.2", title: "Exponents and Scientific Notation", url: URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/1-2-exponents-and-scientific-notation")),
        OpenStaxSection(key: "1.3", title: "Radicals and Rational Exponents", url: URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/1-3-radicals-and-rational-exponents")),
        OpenStaxSection(key: "2.1", title: "The Rectangular Coordinate Systems and Graphs", url: URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/2-1-the-rectangular-coordinate-systems-and-graphs")),
        OpenStaxSection(key: "2.2", title: "Linear Equations in One Variable", url: URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/2-2-linear-equations-in-one-variable")),
        OpenStaxSection(key: "2.3", title: "Models and Applications", url: URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/2-3-models-and-applications")),
        OpenStaxSection(key: "2.5", title: "Quadratic Equations", url: URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/2-5-quadratic-equations")),
        OpenStaxSection(key: "2.7", title: "Linear Inequalities and Absolute Value Inequalities", url: URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/2-7-linear-inequalities-and-absolute-value-inequalities")),
        OpenStaxSection(key: "3.1", title: "Functions and Function Notation", url: URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/3-1-functions-and-function-notation")),
        OpenStaxSection(key: "3.2", title: "Domain and Range", url: URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/3-2-domain-and-range")),
        OpenStaxSection(key: "3.3", title: "Rates of Change and Behavior of Graphs", url: URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/3-3-rates-of-change-and-behavior-of-graphs")),
        OpenStaxSection(key: "4.1", title: "Linear Functions", url: URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/4-1-linear-functions")),
        OpenStaxSection(key: "5.1", title: "Quadratic Functions", url: URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/5-1-quadratic-functions")),
        OpenStaxSection(key: "5.3", title: "Graphs of Polynomial Functions", url: URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/5-3-graphs-of-polynomial-functions")),
        OpenStaxSection(key: "5.4", title: "Dividing Polynomials", url: URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/5-4-dividing-polynomials")),
        OpenStaxSection(key: "5.5", title: "Zeros of Polynomial Functions", url: URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/5-5-zeros-of-polynomial-functions")),
        OpenStaxSection(key: "5.7", title: "Inverses and Radical Functions", url: URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/5-7-inverses-and-radical-functions")),
        OpenStaxSection(key: "5.8", title: "Modeling Using Variation", url: URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/5-8-modeling-using-variation")),
        OpenStaxSection(key: "6.1", title: "Exponential Functions", url: URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/6-1-exponential-functions")),
        OpenStaxSection(key: "13.7", title: "Probability", url: URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/13-7-probability")),
    ]

    private static let openStaxByKey: [String: OpenStaxSection] = {
        Dictionary(uniqueKeysWithValues: openStaxSections.map { ($0.key, $0) })
    }()

    /// BFN-A chapter → alternate Larson + OpenStax sections (same summer-schedule family of books).
    private static let byBFNChapter: [Int: (larson: [Int], osa: [String])] = [
        11: ([3], ["5.8"]),
        12: ([3], ["5.8"]),
        13: ([3], ["5.8"]),
        14: ([3], ["5.8"]),
        19: ([8], ["1.2"]),
        26: ([6], ["2.7"]),
        27: ([6], ["2.7"]),
        29: ([7], ["2.2", "2.3"]),
        30: ([7], ["2.2", "2.3"]),
        31: ([4], ["2.1"]),
        33: ([4, 5], ["4.1", "3.3"]),
        34: ([4, 5], ["4.1"]),
        35: ([5], ["4.1"]),
        36: ([7], ["4.1"]),
        37: ([6], ["2.7"]),
        38: ([6, 7], ["2.7"]),
        40: ([13], ["13.7"]),
        41: ([13], ["13.7"]),
        42: ([13], ["13.7"]),
        43: ([13], ["13.7"]),
        44: ([13], ["13.7"]),
        45: ([1, 3], ["3.1", "3.2"]),
        46: ([1, 3], ["3.1"]),
        47: ([1, 3], ["3.1", "3.2"]),
        48: ([9], ["5.3"]),
        49: ([8, 9], ["1.2", "5.4"]),
        51: ([9], ["5.3", "5.4"]),
        52: ([9], ["5.5"]),
        54: ([9], ["5.5"]),
        55: ([9], ["5.5"]),
        56: ([9], ["5.5"]),
        57: ([11], ["1.3", "5.7"]),
        58: ([11], ["1.3", "5.7"]),
        59: ([11], ["5.7"]),
        60: ([11], ["5.7"]),
        61: ([10], ["2.5", "5.1"]),
        62: ([10], ["2.5", "5.1"]),
        64: ([10], ["2.5", "5.1"]),
        65: ([10], ["2.5", "5.1"]),
        66: ([10], ["2.5", "5.1"]),
        67: ([10], ["5.1"]),
        68: ([10], ["5.1"]),
    ]

    /// Topic-specific overrides when BFN chapters are empty (geometry) or need extra depth.
    private static let byPotCode: [String: (larson: [Int], osa: [String])] = [
        "T152": ([7], ["2.2", "2.3"]),
        "T153": ([8], ["1.2"]),
        "T154": ([8, 9], ["1.2", "5.4"]),
        "T161": ([3], ["5.8"]),
        "T162": ([3], ["5.8"]),
        "T310": ([11], ["2.1"]),
        "T311": ([11], []),
        "T312": ([11], []),
        "T313": ([11], []),
        "T314": ([11], []),
        "T315": ([11], []),
        "T316": ([11], []),
        "T317": ([11], []),
        "MIX1": ([7, 9, 10], ["2.5", "4.1", "5.5"]),
        "MIX2": ([1, 10, 11], ["3.1", "5.1"]),
    ]

    static func larsonChapter(_ number: Int) -> LarsonChapter? {
        larsonByNumber[number]
    }

    static func openStaxSection(_ key: String) -> OpenStaxSection? {
        openStaxByKey[key]
    }

    static func readingOptions(bfnChapterNumbers: [Int], potCode: String? = nil) -> ReadingOptions {
        var larsonNumbers: [Int] = []
        var osaKeys: [String] = []
        var seenLar = Set<Int>()
        var seenOsa = Set<String>()

        if let potCode, let override = byPotCode[potCode] {
            for n in override.larson where seenLar.insert(n).inserted { larsonNumbers.append(n) }
            for k in override.osa where seenOsa.insert(k).inserted { osaKeys.append(k) }
        }

        for chapter in bfnChapterNumbers {
            guard let mapping = byBFNChapter[chapter] else { continue }
            for n in mapping.larson where seenLar.insert(n).inserted { larsonNumbers.append(n) }
            for k in mapping.osa where seenOsa.insert(k).inserted { osaKeys.append(k) }
        }

        return ReadingOptions(
            larsonChapters: larsonNumbers.compactMap { larsonChapter($0) },
            openStaxSections: osaKeys.compactMap { openStaxSection($0) }
        )
    }

    static func mergedReadingOptions(bfnChapterNumbers: [Int], potCodes: [String]) -> ReadingOptions {
        var larsonNumbers: [Int] = []
        var osaKeys: [String] = []
        var seenLar = Set<Int>()
        var seenOsa = Set<String>()

        for code in potCodes {
            let options = readingOptions(bfnChapterNumbers: bfnChapterNumbers, potCode: code)
            for ch in options.larsonChapters where seenLar.insert(ch.number).inserted {
                larsonNumbers.append(ch.number)
            }
            for sec in options.openStaxSections where seenOsa.insert(sec.key).inserted {
                osaKeys.append(sec.key)
            }
        }

        for chapter in bfnChapterNumbers {
            guard let mapping = byBFNChapter[chapter] else { continue }
            for n in mapping.larson where seenLar.insert(n).inserted { larsonNumbers.append(n) }
            for k in mapping.osa where seenOsa.insert(k).inserted { osaKeys.append(k) }
        }

        return ReadingOptions(
            larsonChapters: larsonNumbers.sorted().compactMap { larsonChapter($0) },
            openStaxSections: osaKeys.compactMap { openStaxSection($0) }
        )
    }
}
