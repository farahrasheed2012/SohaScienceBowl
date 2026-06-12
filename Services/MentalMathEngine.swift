import Foundation

enum MentalMathEngine {
    static let problemsPerSession = 20

    static func problems(operation: MentalMathOperation, level: Int, count: Int = problemsPerSession, seed: UInt64? = nil) -> [MentalMathProblem] {
        var rng = SeededRNG(seed: seed ?? UInt64(Date().timeIntervalSince1970))
        var batch = (0..<count).map { _ in makeProblem(operation: operation, level: level, rng: &rng) }
        batch.shuffle(using: &rng)
        return batch
    }

    private static func makeProblem(operation: MentalMathOperation, level: Int, rng: inout SeededRNG) -> MentalMathProblem {
        switch operation {
        case .addition: return addition(level: level, rng: &rng)
        case .subtraction: return subtraction(level: level, rng: &rng)
        case .multiplication: return multiplication(level: level, rng: &rng)
        case .division: return division(level: level, rng: &rng)
        case .squares: return square(level: level, rng: &rng)
        case .mixed:
            let ops: [MentalMathOperation] = [.addition, .subtraction, .multiplication, .division]
            let op = ops[rng.int(in: 0...(ops.count - 1))]
            return makeProblem(operation: op, level: min(level + 2, op.levelCount), rng: &rng)
        }
    }

    private static func addition(level: Int, rng: inout SeededRNG) -> MentalMathProblem {
        switch level {
        case 1:
            let a = rng.int(in: 1...9), b = rng.int(in: 1...max(1, 10 - a))
            return p("\(a) + \(b)", a + b)
        case 2:
            let a = rng.int(in: 1...19), b = rng.int(in: 1...max(1, 20 - a))
            return p("\(a) + \(b)", a + b)
        case 3:
            let a = rng.int(in: 5...49), b = rng.int(in: 1...max(1, 50 - a))
            return p("\(a) + \(b)", a + b)
        case 4:
            let a = rng.int(in: 10...99), b = rng.int(in: 1...9)
            return p("\(a) + \(b)", a + b)
        case 5:
            let a = rng.int(in: 10...99), b = rng.int(in: 10...99)
            return p("\(a) + \(b)", a + b)
        case 6:
            let a = rng.int(in: 100...999), b = rng.int(in: 10...99)
            return p("\(a) + \(b)", a + b)
        default:
            let a = rng.int(in: 15...85), b = rng.int(in: 5...15)
            return p("\(a) + \(b)", a + b)
        }
    }

    private static func subtraction(level: Int, rng: inout SeededRNG) -> MentalMathProblem {
        switch level {
        case 1:
            let a = rng.int(in: 2...10), b = rng.int(in: 1...(a - 1))
            return p("\(a) − \(b)", a - b)
        case 2:
            let a = rng.int(in: 5...20), b = rng.int(in: 1...(a - 1))
            return p("\(a) − \(b)", a - b)
        case 3:
            let a = rng.int(in: 10...50), b = rng.int(in: 1...(a - 1))
            return p("\(a) − \(b)", a - b)
        case 4:
            let a = rng.int(in: 20...99), b = rng.int(in: 1...9)
            return p("\(a) − \(b)", a - b)
        case 5:
            let a = rng.int(in: 30...99), b = rng.int(in: 10...29)
            return p("\(a) − \(b)", a - b)
        case 6:
            let a = rng.int(in: 40...99), b = rng.int(in: 11...39)
            return p("\(a) − \(b)", a - b)
        case 7:
            let a = rng.int(in: 200...999), b = rng.int(in: 10...99)
            return p("\(a) − \(b)", a - b)
        default:
            let a = rng.int(in: 50...199), b = rng.int(in: 10...49)
            return p("\(a) − \(b)", a - b)
        }
    }

    private static func multiplication(level: Int, rng: inout SeededRNG) -> MentalMathProblem {
        switch level {
        case 1: let a = rng.int(in: 1...12); return p("\(a) × 2", a * 2)
        case 2: let a = rng.int(in: 1...12), b = rng.int(in: 3...5); return p("\(a) × \(b)", a * b)
        case 3: let a = rng.int(in: 1...12), b = rng.int(in: 6...9); return p("\(a) × \(b)", a * b)
        case 4: let a = rng.int(in: 1...12), b = rng.int(in: 10...12); return p("\(a) × \(b)", a * b)
        case 5: let a = rng.int(in: 11...19), b = rng.int(in: 2...9); return p("\(a) × \(b)", a * b)
        case 6: let a = rng.int(in: 11...99), b = rng.int(in: 2...9); return p("\(a) × \(b)", a * b)
        case 7:
            if rng.int(in: 0...1) == 0 { let a = rng.int(in: 11...19); return p("\(a) × 11", a * 11) }
            let a = rng.int(in: 2...12); return p("\(a) × 25", a * 25)
        case 8: let a = rng.int(in: 2...20), b = rng.int(in: 2...20); return p("\(a) × \(b)", a * b)
        case 9: let a = rng.int(in: 2...9), b = rng.int(in: 2...9), c = rng.int(in: 2...5); return p("\(a) × \(b) × \(c)", a * b * c)
        default: let a = rng.int(in: 2...20), b = rng.int(in: 2...20); return p("\(a) × \(b)", a * b)
        }
    }

    private static func division(level: Int, rng: inout SeededRNG) -> MentalMathProblem {
        switch level {
        case 1:
            let d = rng.int(in: 0...1) == 0 ? 2 : 5, q = rng.int(in: 2...12)
            return p("\(d * q) ÷ \(d)", q)
        case 2:
            let d = rng.int(in: 3...9), q = rng.int(in: 2...12)
            return p("\(d * q) ÷ \(d)", q)
        case 3:
            let d = rng.int(in: 10...12), q = rng.int(in: 2...12)
            return p("\(d * q) ÷ \(d)", q)
        case 4:
            let d = rng.int(in: 2...9), q = rng.int(in: 11...19)
            return p("\(d * q) ÷ \(d)", q)
        case 5:
            let d = rng.int(in: 3...9), q = rng.int(in: 3...15), r = rng.int(in: 1...(d - 1))
            return p("\(d * q + r) ÷ \(d)", q)
        case 6:
            let d = rng.int(in: 2...9), q = rng.int(in: 20...99)
            return p("\(d * q) ÷ \(d)", q)
        case 7:
            let a = rng.int(in: 2...9), b = rng.int(in: 2...9)
            return p("\(a * b) ÷ \(a)", b)
        default:
            let d = rng.int(in: 2...12), q = rng.int(in: 2...20)
            return p("\(d * q) ÷ \(d)", q)
        }
    }

    private static func square(level: Int, rng: inout SeededRNG) -> MentalMathProblem {
        let range: ClosedRange<Int> = switch level {
        case 1: 1...10
        case 2: 11...15
        case 3: 16...20
        case 4: 21...25
        case 5: 26...30
        default: 10...30
        }
        let n = rng.int(in: range)
        return p("\(n)²", n * n)
    }

    private static func p(_ prompt: String, _ answer: Int) -> MentalMathProblem {
        MentalMathProblem(prompt: prompt, answer: answer)
    }
}

private struct SeededRNG: RandomNumberGenerator {
    private var state: UInt64
    init(seed: UInt64) { state = seed == 0 ? 1 : seed }
    mutating func int(in range: ClosedRange<Int>) -> Int {
        let span = UInt64(range.upperBound - range.lowerBound + 1)
        state = state &* 6_364_136_223_846_793_005 &+ 1_446_960_989_394_037_157
        return Int(state % span) + range.lowerBound
    }
    mutating func next() -> UInt64 {
        state = state &* 6_364_136_223_846_793_005 &+ 1_446_960_989_394_037_157
        return state
    }
}
