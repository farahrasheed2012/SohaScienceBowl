import Foundation

/// Earth & Space and Energy blocks woven into the Thu/Fri rotation on even weeks (2 & 4 in each 4-week cycle).
enum ScheduleCrossCategory {
    struct Block: Identifiable, Hashable {
        let id: String
        let weekday: Weekday
        let nsbSubject: NSBSubject
        let title: String
        let subtitle: String
        let topicIds: [String]
        let encyclopediaTopicId: String

        var emoji: String { nsbSubject.emoji }
    }

    /// Even weeks in the 4-week cycle (weeks 2, 4, 6, 8, 10): Thu = Energy, Fri = Earth.
    static func isCrossCategoryWeek(_ week: Int) -> Bool {
        let index = ((week - 1) % 4) + 1
        return index == 2 || index == 4
    }

    static func blocks(for week: Int) -> [Block] {
        guard isCrossCategoryWeek(week) else { return [] }
        return [energyBlock(week: week), earthBlock(week: week)]
    }

    static func block(for week: Int, day: Weekday) -> Block? {
        blocks(for: week).first { $0.weekday == day }
    }

    static func saturdaySuggestion(for week: Int) -> Block? {
        guard isCrossCategoryWeek(week) else { return nil }
        let index = ((week - 1) % 4) + 1
        if index == 2 {
            return earthSaturday(week: week)
        }
        return energySaturday(week: week)
    }

    private static func energyBlock(week: Int) -> Block {
        let topics: [(String, String, [String], String)] = [
            ("Forms & conversions", "Kinetic vs potential · conservation", ["en-forms", "en-conservation"], "en-forms"),
            ("Electricity & grid", "Generation · transmission · efficiency", ["en-grid", "en-efficiency"], "en-grid"),
            ("Forms & conversions", "Review energy transfers", ["en-forms", "en-conservation"], "en-forms"),
            ("Renewable sources", "Solar · wind · hydro basics", ["en-solar", "en-wind", "en-hydro"], "en-solar"),
            ("Climate & energy", "Policy · emissions · efficiency", ["en-climate-energy", "en-efficiency"], "en-climate-energy"),
        ]
        let pick = topics[min((week - 1) / 2, topics.count - 1)]
        return Block(
            id: "energy-\(week)-thu",
            weekday: .thursday,
            nsbSubject: .energy,
            title: pick.0,
            subtitle: pick.1,
            topicIds: pick.2,
            encyclopediaTopicId: pick.3
        )
    }

    private static func earthBlock(week: Int) -> Block {
        let topics: [(String, String, [String], String)] = [
            ("Earth's layers", "Crust · mantle · core · plate tectonics", ["es-earths-layers", "es-plate-tectonics"], "es-earths-layers"),
            ("Weather & climate", "Atmosphere · water cycle · fronts", ["es-weather", "es-climate"], "es-weather"),
            ("Rocks & minerals", "Rock cycle · Mohs hardness", ["es-rock-cycle", "es-minerals"], "es-rock-cycle"),
            ("Solar system", "Planets · moon phases · orbits", ["es-solar-system", "es-sun"], "es-solar-system"),
            ("Oceans & water cycle", "Evaporation · currents · tides", ["es-oceans", "es-water-cycle"], "es-oceans"),
        ]
        let pick = topics[min((week - 1) / 2, topics.count - 1)]
        return Block(
            id: "earth-\(week)-fri",
            weekday: .friday,
            nsbSubject: .earthSpace,
            title: pick.0,
            subtitle: pick.1,
            topicIds: pick.2,
            encyclopediaTopicId: pick.3
        )
    }

    private static func earthSaturday(week: Int) -> Block {
        Block(
            id: "earth-sat-\(week)",
            weekday: .friday,
            nsbSubject: .earthSpace,
            title: "Saturday Earth focus",
            subtitle: "Optional 30 min · rocks, minerals, or solar system",
            topicIds: ["es-rock-cycle", "es-solar-system"],
            encyclopediaTopicId: "es-rock-cycle"
        )
    }

    private static func energySaturday(week: Int) -> Block {
        Block(
            id: "energy-sat-\(week)",
            weekday: .friday,
            nsbSubject: .energy,
            title: "Saturday Energy focus",
            subtitle: "Optional 30 min · renewable vs nonrenewable",
            topicIds: ["en-solar", "en-wind", "en-fossil"],
            encyclopediaTopicId: "en-solar"
        )
    }
}
