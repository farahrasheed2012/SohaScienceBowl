import Foundation

enum MathCountsQuestionBank {
    static func dailySession(level: MathCountsDifficulty, seed: UInt64 = UInt64(Date().timeIntervalSince1970)) -> [MathCountsQuestion] {
        var rng = SeededRNG(seed: seed ^ UInt64(level.rawValue * 9_001))
        var questions: [MathCountsQuestion] = []

        for section in MathCountsSection.allCases {
            let count = section.questionCount
            for index in 0..<count {
                let q = makeQuestion(section: section, level: level, index: index, rng: &rng)
                questions.append(q)
            }
        }
        return questions
    }

    static func topicDrill(topic: MathCountsTopicArea, level: MathCountsDifficulty, count: Int = 10, seed: UInt64 = UInt64(Date().timeIntervalSince1970)) -> [MathCountsQuestion] {
        let topicSeed = UInt64(bitPattern: Int64(topic.rawValue.hashValue))
        var rng = SeededRNG(seed: seed ^ topicSeed)
        return (0..<count).map { index in
            makeTopicQuestion(topic: topic, level: level, index: index, rng: &rng)
        }
    }

    // MARK: - Session builders

    private static func makeQuestion(section: MathCountsSection, level: MathCountsDifficulty, index: Int, rng: inout SeededRNG) -> MathCountsQuestion {
        switch section {
        case .mentalMathWarmup:
            return mentalWarmup(level: level, index: index, rng: &rng)
        case .numberSenseDrill:
            return numberSense(level: level, index: index, rng: &rng)
        case .challenge:
            return challenge(level: level, index: index, rng: &rng)
        case .stretch:
            return stretch(level: level, rng: &rng)
        }
    }

    private static func makeTopicQuestion(topic: MathCountsTopicArea, level: MathCountsDifficulty, index: Int, rng: inout SeededRNG) -> MathCountsQuestion {
        switch topic {
        case .mentalMath:
            return mentalWarmup(level: level, index: index, rng: &rng)
        case .numberTheory:
            return numberTheory(level: level, index: index, rng: &rng)
        case .algebra:
            return algebra(level: level, index: index, rng: &rng)
        case .geometry:
            return geometry(level: level, index: index, rng: &rng)
        case .ratios:
            return ratio(level: level, index: index, rng: &rng)
        case .sequences:
            return sequence(level: level, index: index, rng: &rng)
        case .countingProbability:
            return counting(level: level, index: index, rng: &rng)
        case .logic:
            return logic(level: level, index: index, rng: &rng)
        }
    }

    // MARK: - Mental math

    private static func mentalWarmup(level: MathCountsDifficulty, index: Int, rng: inout SeededRNG) -> MathCountsQuestion {
        switch level {
        case .level1:
            let a = rng.int(in: 4...12)
            let b = rng.int(in: 3...12)
            let op = index % 3
            if op == 0 {
                return q(
                    section: .mentalMathWarmup, level: level, topic: "Mental Math",
                    prompt: "What is \(a) + \(b)?",
                    guiding: "Can you make a friendly ten or round number first?",
                    answer: "\(a + b)",
                    hint: "Try \(a) + \(b): break \(b) into tens and ones.",
                    simpler: "What is \(a) + \(a)?",
                    explanation: "\(a) + \(b) = \(a + b).",
                    strategy: "Breaking apart addends"
                )
            }
            if op == 1 {
                let sum = a + b
                return q(
                    section: .mentalMathWarmup, level: level, topic: "Mental Math",
                    prompt: "What is \(sum) − \(b)?",
                    guiding: "Addition and subtraction are inverse — what plus \(b) gives \(sum)?",
                    answer: "\(a)",
                    hint: "Think: ? + \(b) = \(sum).",
                    simpler: "What is \(sum) − \(sum - 2)?",
                    explanation: "\(sum) − \(b) = \(a).",
                    strategy: "Inverse operations"
                )
            }
            let product = a * b
            return q(
                section: .mentalMathWarmup, level: level, topic: "Mental Math",
                prompt: "What is \(a) × \(b)?",
                guiding: "Can you use a double or half to make this easier?",
                answer: "\(product)",
                hint: "Try \(a) × \(b) as repeated addition or use a fact you know.",
                simpler: "What is \(a) × 2?",
                explanation: "\(a) × \(b) = \(product).",
                strategy: "Multiplication facts"
            )

        case .level2:
            let n = rng.int(in: 11...19)
            let m = rng.int(in: 11...19)
            let square = rng.int(in: 11...20)
            let kind = index % 3
            if kind == 0 {
                let ans = n * m
                return q(
                    section: .mentalMathWarmup, level: level, topic: "Mental Math",
                    prompt: "Compute \(n) × \(m) mentally.",
                    guiding: "Can you use \((n/10)*10) or compensation — e.g. \(n) × \(m) = \(n) × (\(m-1)) + \(n)?",
                    answer: "\(ans)",
                    hint: "Break \(m) into \(m - 10) + 10: \(n)×10 + \(n)×\(m - 10).",
                    simpler: "What is \(n) × 10?",
                    explanation: "\(n) × \(m) = \(ans).",
                    strategy: "Distributive property"
                )
            }
            if kind == 1 {
                let sq = square * square
                return q(
                    section: .mentalMathWarmup, level: level, topic: "Mental Math",
                    prompt: "What is \(square)²?",
                    guiding: "Near-square: \((square-1))² + 2×\(square) − 1 or \(square)×\(square)?",
                    answer: "\(sq)",
                    hint: "\(square)² means \(square) × \(square).",
                    simpler: "What is \(square) × 2?",
                    explanation: "\(square)² = \(sq).",
                    strategy: "Perfect squares"
                )
            }
            let pct = [10, 20, 25, 50][rng.int(in: 0...3)]
            let base = rng.int(in: 20...80) * 4
            let ans = base * pct / 100
            return q(
                section: .mentalMathWarmup, level: level, topic: "Mental Math",
                prompt: "What is \(pct)% of \(base)?",
                guiding: "What does \(pct)% mean as a fraction of 100?",
                answer: "\(ans)",
                hint: "\(pct)% = \(pct)/100 of \(base).",
                simpler: "What is 10% of \(base)?",
                explanation: "\(pct)% of \(base) = \(ans).",
                strategy: "Percent reasoning"
            )

        case .level3, .level4, .level5:
            let n = rng.int(in: 12...25)
            let cube = n <= 12 ? n : 10
            let kind = index % 3
            if kind == 0 {
                let sq = n * n
                return q(
                    section: .mentalMathWarmup, level: level, topic: "Mental Math",
                    prompt: "What is \(n)²?",
                    guiding: "Use \((n-1))² + 2n − 1 or break into \((n/10)*10)?",
                    answer: "\(sq)",
                    hint: "\(n)² = \(n) × \(n).",
                    simpler: "What is \(n) × 10?",
                    explanation: "\(n)² = \(sq).",
                    strategy: "Squares up to 25²"
                )
            }
            if kind == 1, cube <= 12 {
                let c = cube * cube * cube
                return q(
                    section: .mentalMathWarmup, level: level, topic: "Mental Math",
                    prompt: "What is \(cube)³?",
                    guiding: "Cube = number × itself × itself.",
                    answer: "\(c)",
                    hint: "\(cube)³ = \(cube) × \(cube) × \(cube).",
                    simpler: "What is \(cube)²?",
                    explanation: "\(cube)³ = \(c).",
                    strategy: "Perfect cubes"
                )
            }
            let a = rng.int(in: 15...35)
            let b = rng.int(in: 5...15)
            let diff = a - b
            let prod = diff * (a + b)
            return q(
                section: .mentalMathWarmup, level: level, topic: "Mental Math",
                prompt: "Use difference of squares: \(a)² − \(b)² = ?",
                guiding: "Factor as (a−b)(a+b). What are a and b here?",
                answer: "\(prod)",
                hint: "(\(a)−\(b))(\(a)+\(b)) = \(diff) × \(a + b).",
                simpler: "What is \(a) + \(b)?",
                explanation: "\(a)² − \(b)² = (\(a)-\(b))(\(a)+\(b)) = \(diff) × \(a + b) = \(prod).",
                strategy: "Difference of squares"
            )
        }
    }

    // MARK: - Number sense

    private static func numberSense(level: MathCountsDifficulty, index: Int, rng: inout SeededRNG) -> MathCountsQuestion {
        switch level {
        case .level1:
            let n = rng.int(in: 12...99)
            let digit = n % 10
            return q(
                section: .numberSenseDrill, level: level, topic: "Number Theory",
                prompt: "Is \(n) even or odd?",
                guiding: "Look only at the ones digit.",
                answer: digit % 2 == 0 ? "even" : "odd",
                acceptable: digit % 2 == 0 ? ["even", "e"] : ["odd", "o"],
                hint: "Ones digit of \(n) is \(digit).",
                simpler: "Is \(digit) even or odd?",
                explanation: "\(n) ends in \(digit), so it is \(digit % 2 == 0 ? "even" : "odd").",
                strategy: "Ones-digit test"
            )

        case .level2:
            let pairs: [(Int, Int)] = [(12, 18), (15, 25), (8, 28), (9, 24)]
            let (a, b) = pairs[index % pairs.count]
            let g = gcd(a, b)
            return q(
                section: .numberSenseDrill, level: level, topic: "Number Theory",
                prompt: "What is the GCF of \(a) and \(b)?",
                guiding: "List factors of each — what's the largest shared?",
                answer: "\(g)",
                hint: "Factors of \(a): … Factors of \(b): …",
                simpler: "What is the GCF of \(a/2) and \(b/2) if both even?",
                explanation: "GCF(\(a), \(b)) = \(g).",
                strategy: "Factor listing"
            )

        case .level3, .level4, .level5:
            let sets: [(Int, Int, Int)] = [(4, 6, 12), (5, 10, 20), (6, 8, 24), (3, 9, 18)]
            let (a, b, l) = sets[index % sets.count]
            return q(
                section: .numberSenseDrill, level: level, topic: "Number Theory",
                prompt: "What is the LCM of \(a), \(b), and \(l)?",
                guiding: "Prime-factor each number — take the highest power of each prime.",
                answer: "\(lcm(a, b, l))",
                hint: "Multiples of \(a): … Which is smallest shared by all three?",
                simpler: "What is the LCM of \(a) and \(b)?",
                explanation: "LCM(\(a), \(b), \(l)) = \(lcm(a, b, l)).",
                strategy: "Prime factorization / listing multiples"
            )
        }
    }

    // MARK: - Challenge

    private static func challenge(level: MathCountsDifficulty, index: Int, rng: inout SeededRNG) -> MathCountsQuestion {
        switch level {
        case .level1:
            return ratio(level: .level1, index: index, rng: &rng, section: .challenge)
        case .level2:
            return algebra(level: .level2, index: index, rng: &rng, section: .challenge)
        case .level3:
            return geometry(level: .level3, index: index, rng: &rng, section: .challenge)
        case .level4:
            return counting(level: .level4, index: index, rng: &rng, section: .challenge)
        case .level5:
            return sequence(level: .level5, index: index, rng: &rng, section: .challenge)
        }
    }

    private static func stretch(level: MathCountsDifficulty, rng: inout SeededRNG) -> MathCountsQuestion {
        switch level {
        case .level1, .level2:
            let a = rng.int(in: 5...12)
            let b = rng.int(in: 3...9)
            let c = rng.int(in: 2...6)
            let ans = a * b + c
            return q(
                section: .stretch, level: level, topic: "Logic",
                prompt: "A number is multiplied by \(b), then \(c) is added. The result is \(ans). What was the original number?",
                guiding: "Work backwards — undo the last step first.",
                answer: "\(a)",
                hint: "Subtract \(c) first, then divide by \(b).",
                simpler: "If you add \(c) to a number and get \(ans), what was the number before adding?",
                explanation: "(\(ans) − \(c)) ÷ \(b) = \(a).",
                strategy: "Inverse operations"
            )
        case .level3:
            return q(
                section: .stretch, level: level, topic: "Ratios & Proportions",
                prompt: "The ratio of cats to dogs in a shelter is 3:5. If there are 24 cats, how many dogs are there?",
                guiding: "3 parts = 24 — how big is one part?",
                answer: "40",
                hint: "One part = 24 ÷ 3 = 8. Dogs = 5 parts.",
                simpler: "If 3 parts = 24, one part = ?",
                explanation: "One part = 8. Dogs = 5 × 8 = 40.",
                strategy: "Part-to-whole ratios"
            )
        case .level4:
            return q(
                section: .stretch, level: level, topic: "Geometry",
                prompt: "A right triangle has legs 9 and 12. What is the length of the hypotenuse?",
                guiding: "Pythagorean theorem: a² + b² = c².",
                answer: "15",
                hint: "9² + 12² = 81 + 144 = 225. √225 = ?",
                simpler: "What is 9² + 12²?",
                explanation: "c² = 81 + 144 = 225, so c = 15.",
                strategy: "Pythagorean triple 9-12-15"
            )
        case .level5:
            return q(
                section: .stretch, level: level, topic: "Counting & Probability",
                prompt: "How many 3-letter arrangements can be made from the letters A, B, C with no repeats?",
                guiding: "How many choices for first letter? Second? Third?",
                answer: "6",
                hint: "3 × 2 × 1 = ?",
                simpler: "How many arrangements of 2 letters from A, B, C?",
                explanation: "3! = 6 permutations.",
                strategy: "Fundamental counting principle"
            )
        }
    }

    // MARK: - Topic generators

    private static func numberTheory(level: MathCountsDifficulty, index: Int, rng: inout SeededRNG, section: MathCountsSection = .challenge) -> MathCountsQuestion {
        let n = [24, 36, 48, 60][index % 4]
        let count = countDivisors(n)
        return q(
            section: section, level: level, topic: "Number Theory",
            prompt: "How many positive divisors does \(n) have?",
            guiding: "Prime-factor \(n), then use (e₁+1)(e₂+1)…",
            answer: "\(count)",
            hint: "List factor pairs of \(n).",
            simpler: "Is 2 a factor of \(n)?",
            explanation: "\(n) has \(count) positive divisors.",
            strategy: "Divisor counting"
        )
    }

    private static func algebra(level: MathCountsDifficulty, index: Int, rng: inout SeededRNG, section: MathCountsSection = .challenge) -> MathCountsQuestion {
        let x = rng.int(in: 3...12)
        let c = rng.int(in: 2...9)
        let sum = x + c
        return q(
            section: section, level: level, topic: "Algebra",
            prompt: "Solve for x: x + \(c) = \(sum)",
            guiding: "What number plus \(c) equals \(sum)?",
            answer: "\(x)",
            hint: "Subtract \(c) from both sides.",
            simpler: "If x + 2 = 7, what is x?",
            explanation: "x = \(sum) − \(c) = \(x).",
            strategy: "Isolation"
        )
    }

    private static func geometry(level: MathCountsDifficulty, index: Int, rng: inout SeededRNG, section: MathCountsSection = .challenge) -> MathCountsQuestion {
        let w = rng.int(in: 4...12)
        let h = rng.int(in: 3...10)
        let area = w * h
        return q(
            section: section, level: level, topic: "Geometry",
            prompt: "A rectangle has width \(w) and height \(h). What is its area?",
            guiding: "Area of rectangle = ?",
            answer: "\(area)",
            hint: "Multiply length × width.",
            simpler: "What is \(w) × \(h)?",
            explanation: "Area = \(w) × \(h) = \(area) square units.",
            strategy: "A = ℓw"
        )
    }

    private static func ratio(level: MathCountsDifficulty, index: Int, rng: inout SeededRNG, section: MathCountsSection = .challenge) -> MathCountsQuestion {
        let a = rng.int(in: 2...5)
        let b = rng.int(in: 3...7)
        let scale = rng.int(in: 3...6)
        let ans = b * scale
        return q(
            section: section, level: level, topic: "Ratios & Proportions",
            prompt: "\(a) : \(b) = \(a * scale) : ?",
            guiding: "Both parts were multiplied by the same number — what factor?",
            answer: "\(ans)",
            hint: "From \(a) to \(a * scale) is ×\(scale).",
            simpler: "2 : 3 = 4 : ?",
            explanation: "Scale factor \(scale), so ? = \(b) × \(scale) = \(ans).",
            strategy: "Scale ratios"
        )
    }

    private static func sequence(level: MathCountsDifficulty, index: Int, rng: inout SeededRNG, section: MathCountsSection = .challenge) -> MathCountsQuestion {
        let start = rng.int(in: 2...8)
        let diff = rng.int(in: 2...5)
        let term5 = start + 4 * diff
        return q(
            section: section, level: level, topic: "Sequences & Patterns",
            prompt: "An arithmetic sequence starts \(start), \(start + diff), \(start + 2 * diff), … What is the 5th term?",
            guiding: "How much do you add each time?",
            answer: "\(term5)",
            hint: "Common difference = \(diff).",
            simpler: "What is the 3rd term?",
            explanation: "5th term = \(start) + 4×\(diff) = \(term5).",
            strategy: "Arithmetic sequences"
        )
    }

    private static func counting(level: MathCountsDifficulty, index: Int, rng: inout SeededRNG, section: MathCountsSection = .challenge) -> MathCountsQuestion {
        return q(
            section: section, level: level, topic: "Counting & Probability",
            prompt: "A fair coin is flipped twice. How many possible outcomes are there?",
            guiding: "List them — or use 2 × 2.",
            answer: "4",
            hint: "HH, HT, TH, TT.",
            simpler: "One flip — how many outcomes?",
            explanation: "2 × 2 = 4 outcomes.",
            strategy: "Sample space"
        )
    }

    private static func logic(level: MathCountsDifficulty, index: Int, rng: inout SeededRNG, section: MathCountsSection = .challenge) -> MathCountsQuestion {
        let n = rng.int(in: 10...30)
        return q(
            section: section, level: level, topic: "Logic",
            prompt: "I think of a number, double it, add 6, and get \(n * 2 + 6). What was my number?",
            guiding: "Undo: subtract 6, then halve.",
            answer: "\(n)",
            hint: "(\(n * 2 + 6) − 6) ÷ 2.",
            simpler: "Double what number gives \(n * 2)?",
            explanation: "Working backwards: (\(n * 2 + 6) − 6 = \(n * 2), ÷2 = \(n).",
            strategy: "Working backwards"
        )
    }

    // MARK: - Helpers

    private static func q(
        section: MathCountsSection,
        level: MathCountsDifficulty,
        topic: String,
        prompt: String,
        guiding: String?,
        answer: String,
        acceptable: [String] = [],
        hint: String,
        simpler: String?,
        explanation: String,
        strategy: String?
    ) -> MathCountsQuestion {
        MathCountsQuestion(
            id: UUID().uuidString,
            section: section,
            level: level.rawValue,
            topic: topic,
            prompt: prompt,
            guidingQuestion: guiding,
            answer: answer,
            acceptableAnswers: acceptable,
            hint: hint,
            simplerExample: simpler,
            explanation: explanation,
            strategy: strategy
        )
    }

    private static func gcd(_ a: Int, _ b: Int) -> Int {
        var x = a, y = b
        while y != 0 { (x, y) = (y, x % y) }
        return x
    }

    private static func lcm(_ a: Int, _ b: Int, _ c: Int) -> Int {
        func lcm2(_ x: Int, _ y: Int) -> Int { abs(x * y) / gcd(x, y) }
        return lcm2(lcm2(a, b), c)
    }

    private static func countDivisors(_ n: Int) -> Int {
        var count = 0
        var i = 1
        while i * i <= n {
            if n % i == 0 {
                count += 1
                if i != n / i { count += 1 }
            }
            i += 1
        }
        return count
    }
}

// MARK: - Seeded RNG

private struct SeededRNG {
    private var state: UInt64

    init(seed: UInt64) {
        state = seed == 0 ? 1 : seed
    }

    mutating func int(in range: ClosedRange<Int>) -> Int {
        let span = UInt64(range.upperBound - range.lowerBound + 1)
        state = state &* 6_364_136_223_846_793_005 &+ 1_446_960_989_394_037_157
        let value = Int(state % span) + range.lowerBound
        return value
    }
}
