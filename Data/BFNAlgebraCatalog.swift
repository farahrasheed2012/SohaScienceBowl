import Foundation

/// Full table of contents — *Big Fat Notebook: Pre-Algebra & Algebra I* (ISBN 9781523504382).
enum BFNAlgebraCatalog {
    static let editionTitle = "Big Fat Notebook: Pre-Algebra & Algebra"
    static let bookCode = "BFN-A"
    static let isbn = "9781523504382"
    static let chapterCount = 68

    struct Unit: Hashable, Identifiable {
        let number: Int
        let name: String
        let startPage: Int

        var id: Int { number }
    }

    struct Chapter: Hashable, Identifiable {
        let number: Int
        let title: String
        let unitNumber: Int

        var id: Int { number }

        var trackableId: String { "BFN-A-ch-\(number)" }

        var label: String { "Ch \(number) — \(title)" }

        var shortTitle: String { title }
    }

    static let units: [Unit] = [
        Unit(number: 1, name: "Arithmetic Properties", startPage: 1),
        Unit(number: 2, name: "The Number System", startPage: 23),
        Unit(number: 3, name: "Ratios, Proportions, and Percent", startPage: 75),
        Unit(number: 4, name: "Exponents and Algebraic Expressions", startPage: 141),
        Unit(number: 5, name: "Linear Equations and Inequalities", startPage: 175),
        Unit(number: 6, name: "Graphing Linear Equations and Inequalities", startPage: 247),
        Unit(number: 7, name: "Statistics and Probability", startPage: 325),
        Unit(number: 8, name: "Functions", startPage: 395),
        Unit(number: 9, name: "Polynomial Operations", startPage: 427),
        Unit(number: 10, name: "Factoring Polynomials", startPage: 461),
        Unit(number: 11, name: "Radicals", startPage: 505),
        Unit(number: 12, name: "Quadratic Equations", startPage: 533),
        Unit(number: 13, name: "Quadratic Functions", startPage: 587),
    ]

    static let chapters: [Chapter] = [
        Chapter(number: 1, title: "Types of Numbers", unitNumber: 1),
        Chapter(number: 2, title: "Algebraic Properties", unitNumber: 1),
        Chapter(number: 3, title: "Order of Operations", unitNumber: 1),
        Chapter(number: 4, title: "Adding Positive and Negative Whole Numbers", unitNumber: 2),
        Chapter(number: 5, title: "Subtracting Positive and Negative Whole Numbers", unitNumber: 2),
        Chapter(number: 6, title: "Multiplying and Dividing Positive and Negative Whole Numbers", unitNumber: 2),
        Chapter(number: 7, title: "Multiplying and Dividing Positive and Negative Fractions", unitNumber: 2),
        Chapter(number: 8, title: "Adding and Subtracting Positive and Negative Fractions", unitNumber: 2),
        Chapter(number: 9, title: "Adding and Subtracting Decimals", unitNumber: 2),
        Chapter(number: 10, title: "Multiplying and Dividing Decimals", unitNumber: 2),
        Chapter(number: 11, title: "Ratio", unitNumber: 3),
        Chapter(number: 12, title: "Unit Rate", unitNumber: 3),
        Chapter(number: 13, title: "Proportion", unitNumber: 3),
        Chapter(number: 14, title: "Percent", unitNumber: 3),
        Chapter(number: 15, title: "Percent Applications", unitNumber: 3),
        Chapter(number: 16, title: "Simple Interest", unitNumber: 3),
        Chapter(number: 17, title: "Percent Rate of Change", unitNumber: 3),
        Chapter(number: 18, title: "Tables and Ratios", unitNumber: 3),
        Chapter(number: 19, title: "Exponents", unitNumber: 4),
        Chapter(number: 20, title: "Scientific Notation", unitNumber: 4),
        Chapter(number: 21, title: "Expressions", unitNumber: 4),
        Chapter(number: 22, title: "Evaluating Algebraic Expressions", unitNumber: 4),
        Chapter(number: 23, title: "Combining Like Terms", unitNumber: 4),
        Chapter(number: 24, title: "Introduction to Equations", unitNumber: 5),
        Chapter(number: 25, title: "Solving One-Variable Equations", unitNumber: 5),
        Chapter(number: 26, title: "Solving One-Variable Inequalities", unitNumber: 5),
        Chapter(number: 27, title: "Solving Compound Inequalities", unitNumber: 5),
        Chapter(number: 28, title: "Rewriting Formulas", unitNumber: 5),
        Chapter(number: 29, title: "Solving Systems of Linear Equations by Substitution", unitNumber: 5),
        Chapter(number: 30, title: "Solving Systems of Linear Equations by Elimination", unitNumber: 5),
        Chapter(number: 31, title: "Points and Lines", unitNumber: 6),
        Chapter(number: 32, title: "Graphing a Line from a Table of Values", unitNumber: 6),
        Chapter(number: 33, title: "Slope of a Line", unitNumber: 6),
        Chapter(number: 34, title: "Slope-Intercept Form", unitNumber: 6),
        Chapter(number: 35, title: "Point-Slope Form", unitNumber: 6),
        Chapter(number: 36, title: "Solving Systems of Linear Equations by Graphing", unitNumber: 6),
        Chapter(number: 37, title: "Graphing Linear Inequalities", unitNumber: 6),
        Chapter(number: 38, title: "Solving Systems of Linear Inequalities by Graphing", unitNumber: 6),
        Chapter(number: 39, title: "Introduction to Statistics", unitNumber: 7),
        Chapter(number: 40, title: "Measures of Central Tendency and Variation", unitNumber: 7),
        Chapter(number: 41, title: "Displaying Data", unitNumber: 7),
        Chapter(number: 42, title: "Probability", unitNumber: 7),
        Chapter(number: 43, title: "Compound Events", unitNumber: 7),
        Chapter(number: 44, title: "Permutations and Combinations", unitNumber: 7),
        Chapter(number: 45, title: "Relations and Functions", unitNumber: 8),
        Chapter(number: 46, title: "Function Notation", unitNumber: 8),
        Chapter(number: 47, title: "Application of Functions", unitNumber: 8),
        Chapter(number: 48, title: "Adding and Subtracting Polynomials", unitNumber: 9),
        Chapter(number: 49, title: "Multiplying and Dividing Exponents", unitNumber: 9),
        Chapter(number: 50, title: "Multiplying and Dividing Monomials", unitNumber: 9),
        Chapter(number: 51, title: "Multiplying and Dividing Polynomials", unitNumber: 9),
        Chapter(number: 52, title: "Factoring Polynomials Using GCF", unitNumber: 10),
        Chapter(number: 53, title: "Factoring Polynomials Using Grouping", unitNumber: 10),
        Chapter(number: 54, title: "Factoring Trinomials When a = 1", unitNumber: 10),
        Chapter(number: 55, title: "Factoring Trinomials When a ≠ 1", unitNumber: 10),
        Chapter(number: 56, title: "Factoring Using Special Formulas", unitNumber: 10),
        Chapter(number: 57, title: "Square Roots and Cube Roots", unitNumber: 11),
        Chapter(number: 58, title: "Simplifying Radicals", unitNumber: 11),
        Chapter(number: 59, title: "Adding and Subtracting Radicals", unitNumber: 11),
        Chapter(number: 60, title: "Multiplying and Dividing Radicals", unitNumber: 11),
        Chapter(number: 61, title: "Introduction to Quadratic Equations", unitNumber: 12),
        Chapter(number: 62, title: "Solving Quadratic Equations by Factoring", unitNumber: 12),
        Chapter(number: 63, title: "Solving Quadratic Equations by Taking Square Roots", unitNumber: 12),
        Chapter(number: 64, title: "Solving Quadratic Equations by Completing the Square", unitNumber: 12),
        Chapter(number: 65, title: "Solving Quadratic Equations with the Quadratic Formula", unitNumber: 12),
        Chapter(number: 66, title: "The Discriminant and the Number of Solutions", unitNumber: 12),
        Chapter(number: 67, title: "Graphing Quadratic Functions", unitNumber: 13),
        Chapter(number: 68, title: "Solving Quadratic Equations by Graphing", unitNumber: 13),
    ]

    private static let chaptersByNumber: [Int: Chapter] = {
        Dictionary(uniqueKeysWithValues: chapters.map { ($0.number, $0) })
    }()

    private static let unitsByNumber: [Int: Unit] = {
        Dictionary(uniqueKeysWithValues: units.map { ($0.number, $0) })
    }()

    static func chapter(_ number: Int) -> Chapter? {
        chaptersByNumber[number]
    }

    static func unit(_ number: Int) -> Unit? {
        unitsByNumber[number]
    }

    static func unit(forChapter number: Int) -> Unit? {
        chapter(number).flatMap { unit($0.unitNumber) }
    }

    static func pageLabel(forChapter number: Int) -> String {
        guard let unit = unit(forChapter: number) else { return "p1" }
        return "p\(unit.startPage)"
    }

    static func chaptersGroupedByUnit() -> [(unit: Unit, chapters: [Chapter])] {
        units.map { unit in
            (unit, chapters.filter { $0.unitNumber == unit.number })
        }
    }

    static func displayTitle(chapterNumbers: [Int], reviewLabel: String?) -> String {
        if let reviewLabel {
            return reviewLabel
        }
        guard !chapterNumbers.isEmpty else { return "BFN-A reading" }
        let titles = chapterNumbers.compactMap { chapter($0)?.shortTitle }
        if chapterNumbers.count == 1, let n = chapterNumbers.first {
            return "Ch \(n) — \(titles.first ?? "Reading")"
        }
        let range = chapterRangeLabel(chapterNumbers)
        let joined = titles.prefix(2).joined(separator: " · ")
        let suffix = titles.count > 2 ? " · …" : ""
        return "Ch \(range) — \(joined)\(suffix)"
    }

    static func citationLine(chapterNumbers: [Int], reviewLabel: String?) -> String {
        if let reviewLabel {
            return reviewLabel
        }
        guard let first = chapterNumbers.first else {
            return "See index · Match today's math topic"
        }
        let unit = unit(forChapter: first)!
        let chLabel = chapterNumbers.count == 1
            ? "Ch \(first) \(chapter(first)?.title ?? "")"
            : "Ch \(chapterRangeLabel(chapterNumbers))"
        return "Unit \(unit.number) · \(chLabel) · \(pageLabel(forChapter: first))"
    }

    static func optionText(chapterNumbers: [Int], reviewLabel: String?) -> String {
        "\(bookCode) — \(editionTitle) · \(citationLine(chapterNumbers: chapterNumbers, reviewLabel: reviewLabel))"
    }

    private static func chapterRangeLabel(_ numbers: [Int]) -> String {
        guard let first = numbers.first, let last = numbers.last else { return "" }
        if first == last { return "\(first)" }
        return "\(first)–\(last)"
    }
}
