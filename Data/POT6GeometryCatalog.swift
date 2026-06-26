import Foundation

/// POT 6 geometry track — school topics T310–T347, 6HW37, plus T292 (circles on the coordinate plane).
enum POT6GeometrySubgroup: String, CaseIterable, Identifiable, Codable {
    case fundamentals = "Angles & Lines"
    case triangles = "Triangles & Polygons"
    case proofs = "Proofs & Congruence"
    case areaVolume = "Area & 3D Figures"
    case circles = "Circles & Coordinate"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .fundamentals: return "angle"
        case .triangles: return "triangle"
        case .proofs: return "text.alignleft"
        case .areaVolume: return "cube"
        case .circles: return "circle"
        }
    }

    var topicCodes: [String] {
        switch self {
        case .fundamentals:
            return ["T310", "T311", "T312", "T313", "T314", "T315", "T316", "T317"]
        case .triangles:
            return ["T318", "T319", "T320", "T321", "T331", "T332", "T333", "T334", "T335"]
        case .proofs:
            return ["T322", "T323", "T324", "T325", "T326", "T347", "6HW37"]
        case .areaVolume:
            return ["T336", "T337", "T338", "T344", "T345"]
        case .circles:
            return ["T339", "T340", "T341", "T292"]
        }
    }
}

enum POT6GeometryCatalog {
    struct DayPlan: Identifiable {
        let day: Int
        let title: String
        let calendarHint: String
        let potCodes: [String]
        var id: Int { day }
    }

    /// All school geometry topics in the POT 6 track (includes T292).
    static let schoolCodes: [String] = {
        var seen = Set<String>()
        var codes: [String] = []
        for subgroup in POT6GeometrySubgroup.allCases {
            for code in subgroup.topicCodes where seen.insert(code).inserted {
                codes.append(code)
            }
        }
        return codes
    }()

    static let planTitle = "8-Day Geometry Plan"
    static let planSubtitle = "Self-paced in the POT 6 Geo tab · Larson Ch 11 § per topic · not on the summer algebra calendar"

    /// Eight-day geometry study plan aligned with the summer calendar.
    static let dayPlans: [DayPlan] = [
        DayPlan(
            day: 1,
            title: "Introduction — angles & parallel lines",
            calendarHint: "Day 1 · angles & parallel lines",
            potCodes: ["T310", "T311", "T312", "T313", "T314", "T315", "T316", "T317"]
        ),
        DayPlan(
            day: 2,
            title: "Classify triangles & quadrilaterals",
            calendarHint: "Day 2 · triangles & quadrilaterals",
            potCodes: ["T318", "T319", "T320", "T321"]
        ),
        DayPlan(day: 3, title: "Proofs & congruence", calendarHint: "Day 3", potCodes: ["T322", "T323", "T324"]),
        DayPlan(day: 4, title: "Similarity & triangle centers", calendarHint: "Day 4", potCodes: ["T325", "T326", "T331"]),
        DayPlan(day: 5, title: "Special triangles", calendarHint: "Day 5", potCodes: ["T332", "T333", "T334", "T335"]),
        DayPlan(day: 6, title: "Area, surface area & solids", calendarHint: "Day 6", potCodes: ["T336", "T337", "T338", "T344", "T345"]),
        DayPlan(day: 7, title: "Circles & equations of circles", calendarHint: "Day 7", potCodes: ["T339", "T340", "T341", "T292"]),
        DayPlan(day: 8, title: "Advanced triangles", calendarHint: "Day 8", potCodes: ["T347", "6HW37"]),
    ]

    static func subgroup(for code: String) -> POT6GeometrySubgroup? {
        POT6GeometrySubgroup.allCases.first { $0.topicCodes.contains(code) }
    }

    static func schoolTopics() -> [MathTopic] {
        schoolCodes.compactMap { POT6TopicRegistry.topic(for: $0) }
    }

    static func topics(in subgroup: POT6GeometrySubgroup) -> [MathTopic] {
        subgroup.topicCodes.compactMap { POT6TopicRegistry.topic(for: $0) }
    }

    static func dayPlan(forDay day: Int) -> DayPlan? {
        dayPlans.first { $0.day == day }
    }

    static func potCodes(forDay day: Int) -> [String] {
        dayPlan(forDay: day)?.potCodes ?? []
    }

    static func practiceTopicIds(forDay day: Int) -> [String] {
        ["math-geom-angles", "math-pythagorean"]
    }

    static func readingOptions(forCode code: String) -> MathAlgebraReadingCatalog.ReadingOptions {
        MathAlgebraReadingCatalog.readingOptions(bfnChapterNumbers: [], potCode: code)
    }

    static func readingOptions(forDay day: Int) -> MathAlgebraReadingCatalog.ReadingOptions {
        MathAlgebraReadingCatalog.mergedReadingOptions(bfnChapterNumbers: [], potCodes: potCodes(forDay: day))
    }
}
