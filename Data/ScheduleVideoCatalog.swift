import Foundation

struct ScheduleVideoLink: Identifiable, Hashable {
    var id: String { url.absoluteString }
    let title: String
    let url: URL
    let note: String
}

enum ScheduleVideoKind: String {
    case chemistry
    case biology
    case physics
    case math

    var label: String {
        switch self {
        case .chemistry: return "Chemistry"
        case .biology: return "Biology"
        case .physics: return "Physics"
        case .math: return "Math"
        }
    }
}

enum ScheduleVideoCatalog {
    static func links(
        week: Int,
        day: Weekday,
        kind: ScheduleVideoKind
    ) -> [ScheduleVideoLink] {
        guard let dayBlocks = schedule[week]?[day] else { return [] }
        let prefix: String
        switch kind {
        case .chemistry: prefix = "Chem"
        case .biology: prefix = "Bio"
        case .physics: prefix = "Phys"
        case .math: prefix = "Math"
        }
        return dayBlocks
            .filter { $0.label.hasPrefix(prefix) }
            .flatMap { $0.links }
    }

    static func allLinks(week: Int, day: Weekday) -> [ScheduleVideoLink] {
        guard let dayBlocks = schedule[week]?[day] else { return [] }
        return dayBlocks.flatMap(\.links)
    }

    static func scienceLinks(for block: StudyBlock) -> [ScheduleVideoLink] {
        let kind: ScheduleVideoKind
        switch block.subject {
        case .chemistry: kind = .chemistry
        case .biology: kind = .biology
        case .physics: kind = .physics
        case .math: return mathLinks(week: block.week, day: block.day)
        }
        return links(week: block.week, day: block.day, kind: kind)
    }

    static func mathLinks(week: Int, day: Weekday) -> [ScheduleVideoLink] {
        links(week: week, day: day, kind: .math)
    }

    struct DayBlockVideos: Identifiable, Hashable {
        let week: Int
        let day: Weekday
        let label: String
        let links: [ScheduleVideoLink]

        var id: String { "\(week)-\(day.shortName)-\(label)" }
    }

    static func dayBlocks(for week: Int) -> [DayBlockVideos] {
        guard let weekSchedule = schedule[week] else { return [] }
        let orderedDays: [Weekday] = [.monday, .tuesday, .wednesday, .thursday, .friday]
        return orderedDays.flatMap { day in
            (weekSchedule[day] ?? []).map { block in
                DayBlockVideos(week: week, day: day, label: block.label, links: block.links)
            }
        }
    }

    static func scienceSubject(for label: String) -> Subject? {
        if label.hasPrefix("Chem") { return .chemistry }
        if label.hasPrefix("Bio") { return .biology }
        if label.hasPrefix("Phys") { return .physics }
        return nil
    }

    static func isMathBlock(_ label: String) -> Bool {
        label.hasPrefix("Math")
    }

    static func scienceAndMathLinks(for week: Int, day: Weekday) -> [ScheduleVideoLink] {
        allLinks(week: week, day: day)
    }

    private struct DayBlock {
        let label: String
        let links: [ScheduleVideoLink]
    }

    /// Keep labels aligned with `SeedDataWeeks1_4` / `SeedDataWeeks5_10` topics and
    /// `ScheduleOpenStaxCatalog.mathByWeekDay` titles.
    private static func yt(_ title: String, _ id: String, _ note: String) -> ScheduleVideoLink {
        ScheduleVideoLink(
            title: title,
            url: URL(string: "https://www.youtube.com/watch?v=\(id)")!,
            note: note
        )
    }

    private static let schedule: [Int: [Weekday: [DayBlock]]] = [
        1: [
            .monday: [
                DayBlock(label: "Chem · atoms", links: [
                    yt("What's Inside an Atom?", "e9GuJUaX0UM", "Tyler DeWitt — What's Inside an Atom?"),
                    yt("What are Isotopes?", "EboWeWmh5Pg", "Tyler DeWitt — What are Isotopes?"),
                    yt("Crash Course: The Periodic Table", "0RRVV4Diomg", "Crash Course Chemistry #4")
                ]),
                DayBlock(label: "Math · sci notation", links: [
                    yt("Scientific notation intro", "ClYdw4d4OmA", "Khan Academy — Scientific notation intro"),
                    yt("Scientific notation examples", "i6lfVUp5RW8", "Khan Academy — Scientific notation examples")
                ]),
            ],
            .tuesday: [
                DayBlock(label: "Bio · cells", links: [
                    yt("Introduction to Cells", "8IlzKri08kk", "Amoeba Sisters — Introduction to Cells"),
                    yt("Prokaryotes vs. Eukaryotes", "Pxujitlv8wc", "Amoeba Sisters — Prokaryotes vs. Eukaryotes"),
                    yt("A Tour of the Cell", "1Z9pqST72is", "Bozeman Science — A Tour of the Cell")
                ]),
                DayBlock(label: "Math · ratios", links: [
                    yt("Unit rates", "Zm0KaIw-35k", "Khan Academy — Unit rates"),
                    yt("Proportions intro", "USMQhO0La7Y", "Khan Academy — Proportions")
                ]),
            ],
            .wednesday: [
                DayBlock(label: "Phys · motion", links: [
                    yt("Speed and velocity", "W6Ar0ls6tVA", "Khan Academy — Speed and velocity"),
                    yt("Theory vs. law", "P30QlwSsUic", "Amoeba Sisters — Theory vs. law")
                ]),
                DayBlock(label: "Math · graphs & slope", links: [
                    yt("Slope from a graph", "R948Tsyq4vA", "Khan Academy — Slope from a graph"),
                    yt("Slope from two points", "WkspBxrzuZo", "Khan Academy — Slope from two ordered pairs")
                ]),
            ],
            .thursday: [
                DayBlock(label: "Chem · periodic law", links: [
                    yt("Periodic table basics", "84780SzjGt0", "Periodic table basics"),
                    yt("Crash Course Chemistry #4", "0RRVV4Diomg", "Crash Course Chemistry #4 — The Periodic Table"),
                    yt("Writing ionic formulas", "URc75hoKGLY", "Tyler DeWitt — Writing ionic formulas")
                ]),
                DayBlock(label: "Math · unit conversion", links: [
                    yt("Metric unit conversion", "w0nqd_HXHPQ", "Khan Academy — Metric unit conversion"),
                    yt("Scientific notation", "ClYdw4d4OmA", "Khan Academy — Scientific notation intro")
                ]),
            ],
            .friday: [
                DayBlock(label: "Bio · levels of organization", links: [
                    yt("Biological levels", "EtWknf1gzKo", "Amoeba Sisters — Biological levels"),
                    yt("Human body systems overview", "0JDCViWGn-0", "Amoeba Sisters — Human body systems overview")
                ]),
                DayBlock(label: "Math · PEMDAS", links: [
                    yt("Order of operations", "dAgfnK528RA", "Khan Academy — Order of operations"),
                    yt("Scientific notation examples", "i6lfVUp5RW8", "Khan Academy — Scientific notation examples")
                ]),
            ],
        ],
        2: [
            .monday: [
                DayBlock(label: "Chem · the atom", links: [
                    yt("What's Inside an Atom?", "e9GuJUaX0UM", "Tyler DeWitt — What's Inside an Atom?"),
                    yt("What are Isotopes?", "EboWeWmh5Pg", "Tyler DeWitt — What are Isotopes?"),
                    yt("Periodic table basics", "84780SzjGt0", "Periodic table basics")
                ]),
                DayBlock(label: "Math · percent", links: [
                    yt("Percent of a number", "JeVSmq1Nrpw", "Khan Academy — Percent of a number"),
                    yt("Proportions", "USMQhO0La7Y", "Khan Academy — Proportions")
                ]),
            ],
            .tuesday: [
                DayBlock(label: "Bio · genetics", links: [
                    yt("DNA and genes", "CBezq1fFoiA", "Amoeba Sisters — DNA and genes"),
                    yt("Punnett squares", "prkHKjf_oHE", "Amoeba Sisters — Punnett squares")
                ]),
                DayBlock(label: "Math · proportions", links: [
                    yt("Proportions", "USMQhO0La7Y", "Khan Academy — Proportions"),
                    yt("Unit rates", "Zm0KaIw-35k", "Khan Academy — Unit rates")
                ]),
            ],
            .wednesday: [
                DayBlock(label: "Phys · Newton's laws", links: [
                    yt("Newton's laws", "kKKM3q0qX10", "Crash Course — Newton's laws"),
                    yt("Newton's second law (F = ma)", "FO-It-ig4Qo", "Khan Academy — Newton's second law (F = ma)")
                ]),
                DayBlock(label: "Math · F = ma", links: [
                    yt("Newton's second law (F = ma)", "FO-It-ig4Qo", "Khan Academy — Newton's second law (F = ma)"),
                    yt("Momentum review", "UoIIwzHug9M", "Khan Academy — Momentum (F = ma connection)")
                ]),
            ],
            .thursday: [
                DayBlock(label: "Chem · chemical bonding", links: [
                    yt("Ionic vs. molecular", "PKA4CZwbZWU", "Tyler DeWitt — Ionic vs. molecular"),
                    yt("Ionic bonding", "5EwmedLuRmw", "Tyler DeWitt — Ionic bonding"),
                    yt("Writing ionic formulas", "URc75hoKGLY", "Tyler DeWitt — Writing ionic formulas")
                ]),
                DayBlock(label: "Math · exponents", links: [
                    yt("Exponent rules", "Z5myJ8DgbsE", "Khan Academy — Exponent rules"),
                    yt("Scientific notation intro", "ClYdw4d4OmA", "Khan Academy — Scientific notation intro")
                ]),
            ],
            .friday: [
                DayBlock(label: "Bio · genetics", links: [
                    yt("Punnett squares", "prkHKjf_oHE", "Amoeba Sisters — Punnett squares"),
                    yt("DNA and genes", "CBezq1fFoiA", "Amoeba Sisters — DNA and genes")
                ]),
                DayBlock(label: "Math · body-scale ratios", links: [
                    yt("Proportions", "USMQhO0La7Y", "Khan Academy — Proportions"),
                    yt("Unit rates", "Zm0KaIw-35k", "Khan Academy — Unit rates")
                ]),
            ],
        ],
        3: [
            .monday: [
                DayBlock(label: "Chem · solutions", links: [
                    yt("Solutions", "QWabcX1P1zI", "Tyler DeWitt — Solutions"),
                    yt("Molarity practice", "SXf9rDnVFao", "Tyler DeWitt — Molarity practice")
                ]),
                DayBlock(label: "Math · formula substitution", links: [
                    yt("v = d/t (formula plug-in)", "W6Ar0ls6tVA", "Khan Academy — v = d/t (formula plug-in)"),
                    yt("Work W = Fd", "2WS1s2DHR_c", "Khan Academy — Work W = Fd")
                ]),
            ],
            .tuesday: [
                DayBlock(label: "Bio · ecology", links: [
                    yt("Food chains & webs", "SyGM_Rd5XV4", "Amoeba Sisters — Food chains & webs"),
                    yt("Ecological relationships", "rNjPI84sApQ", "Amoeba Sisters — Ecological relationships"),
                    yt("Food webs & energy pyramids", "-oVavgmveyY", "Amoeba Sisters — Food webs & energy pyramids")
                ]),
                DayBlock(label: "Math · graph reading", links: [
                    yt("Read slope from graphs", "R948Tsyq4vA", "Khan Academy — Read slope from graphs"),
                    yt("Average rate of change", "TEXSW-o8674", "Khan Academy — Average rate of change from a graph")
                ]),
            ],
            .wednesday: [
                DayBlock(label: "Phys · Newton's 3rd law", links: [
                    yt("Newton's third law", "kKKM3q0qX10", "Crash Course — Newton's laws (3rd law)"),
                    yt("Newton's second law (F = ma)", "FO-It-ig4Qo", "Khan Academy — Newton's second law (F = ma)"),
                    yt("Momentum review", "qMc6KOkmjTU", "Khan Academy — Momentum and impulse review")
                ]),
                DayBlock(label: "Math · W = Fd", links: [
                    yt("Work W = Fd", "2WS1s2DHR_c", "Khan Academy — Work W = Fd"),
                    yt("Kinetic & potential energy", "7K4V0NvUxr4", "Khan Academy — Kinetic & potential energy")
                ]),
            ],
            .thursday: [
                DayBlock(label: "Chem · chemical reactions", links: [
                    yt("Balancing equations", "1jL9LTU1sE8", "Tyler DeWitt — Balancing equations"),
                    yt("Types of chemical reactions", "aMU1RaRulSo", "Tyler DeWitt — Types of chemical reactions"),
                    yt("Reaction types practice", "2qX9MOQOmAM", "Tyler DeWitt — Classifying reaction types")
                ]),
                DayBlock(label: "Math · concentration ratios", links: [
                    yt("Proportions (concentration)", "USMQhO0La7Y", "Khan Academy — Proportions (concentration)"),
                    yt("Unit rates", "Zm0KaIw-35k", "Khan Academy — Unit rates")
                ]),
            ],
            .friday: [
                DayBlock(label: "Bio · body systems", links: [
                    yt("Circulatory system", "H04aZjcf4Zo", "Amoeba Sisters — Circulatory system"),
                    yt("Muscular system", "dpxalWACO7k", "Amoeba Sisters — Muscle tissue"),
                    yt("Human body systems overview", "0JDCViWGn-0", "Amoeba Sisters — Human body systems overview")
                ]),
                DayBlock(label: "Math · mixed review", links: [
                    yt("Mixed algebra review", "i6lfVUp5RW8", "Khan Academy — Mixed algebra review"),
                    yt("Proportions", "USMQhO0La7Y", "Khan Academy — Proportions")
                ]),
            ],
        ],
        4: [
            .monday: [
                DayBlock(label: "Chem · states of matter", links: [
                    yt("States of matter", "wclY8F-UoHE", "Amoeba Sisters — States of matter"),
                    yt("Heat transfer & phases", "FPPv1mkRpKw", "Khan Academy — Heat transfer & phase changes")
                ]),
                DayBlock(label: "Math · number review", links: [
                    yt("Comparing rational numbers", "kQ3K_H9QOGA", "Khan Academy — Comparing rational numbers"),
                    yt("Scientific notation intro", "ClYdw4d4OmA", "Khan Academy — Scientific notation intro")
                ]),
            ],
            .tuesday: [
                DayBlock(label: "Bio · evolution", links: [
                    yt("Natural selection", "GhHOjCpK0SE", "Amoeba Sisters — Natural selection"),
                    yt("Classification", "DVouQRAKxYo", "Amoeba Sisters — Classification"),
                    yt("Ecological relationships", "rNjPI84sApQ", "Amoeba Sisters — Ecological relationships")
                ]),
                DayBlock(label: "Math · logic & probability", links: [
                    yt("Basic probability", "uzkc-q4Q-Z0", "Khan Academy — Basic probability"),
                    yt("Compound probability", "xSc4oLA9e8o", "Khan Academy — Compound probability of independent events")
                ]),
            ],
            .wednesday: [
                DayBlock(label: "Phys · momentum", links: [
                    yt("Introduction to momentum", "UoIIwzHug9M", "Khan Academy — Introduction to momentum"),
                    yt("Newton's second law (F = ma)", "FO-It-ig4Qo", "Khan Academy — Newton's second law (F = ma)"),
                    yt("Momentum and impulse", "qMc6KOkmjTU", "Khan Academy — Momentum and impulse review")
                ]),
                DayBlock(label: "Math · v = fλ", links: [
                    yt("v = fλ intro", "TIGG17A9QFI", "Khan Academy — v = fλ intro"),
                    yt("Wavelength & frequency", "WkspBxrzuZo", "Khan Academy — Rate of change (slope analogy)")
                ]),
            ],
            .thursday: [
                DayBlock(label: "Chem · lab measurement", links: [
                    yt("Significant figures", "hsSwf2_onlI", "Tyler DeWitt — Significant figures"),
                    yt("Density practice", "7tVebi3TSsg", "Tyler DeWitt — Density practice")
                ]),
                DayBlock(label: "Math · unit conversion review", links: [
                    yt("Metric unit conversion", "w0nqd_HXHPQ", "Khan Academy — Metric unit conversion"),
                    yt("Scientific notation examples", "i6lfVUp5RW8", "Khan Academy — Scientific notation examples")
                ]),
            ],
            .friday: [
                DayBlock(label: "Bio · classification", links: [
                    yt("Classification", "DVouQRAKxYo", "Amoeba Sisters — Classification"),
                    yt("Natural selection", "GhHOjCpK0SE", "Amoeba Sisters — Natural selection")
                ]),
                DayBlock(label: "Math · formula plug-in", links: [
                    yt("v = d/t (formula plug-in)", "W6Ar0ls6tVA", "Khan Academy — v = d/t (formula plug-in)"),
                    yt("Slope from a graph", "R948Tsyq4vA", "Khan Academy — Slope from a graph")
                ]),
            ],
        ],
        5: [
            .monday: [
                DayBlock(label: "Chem · covalent bonding", links: [
                    yt("Covalent bonding", "DejkvR4pvRw", "Tyler DeWitt — Naming covalent compounds"),
                    yt("Ionic vs. molecular", "PKA4CZwbZWU", "Tyler DeWitt — Ionic vs. molecular"),
                    yt("Ionic bonding", "5EwmedLuRmw", "Tyler DeWitt — Ionic bonding")
                ]),
                DayBlock(label: "Math · sci notation", links: [
                    yt("Scientific notation intro", "ClYdw4d4OmA", "Khan Academy — Scientific notation intro"),
                    yt("Scientific notation examples", "i6lfVUp5RW8", "Khan Academy — Scientific notation examples")
                ]),
            ],
            .tuesday: [
                DayBlock(label: "Bio · photosynthesis", links: [
                    yt("Photosynthesis", "fm-I_SShF7I", "Amoeba Sisters — Photosynthesis"),
                    yt("Photosynthesis & respiration", "OEO28tu_kJU", "Amoeba Sisters — Photosynthesis & respiration"),
                    yt("Cellular respiration", "eJ9Zjc-jdys", "Amoeba Sisters — Cellular respiration")
                ]),
                DayBlock(label: "Math · ratios", links: [
                    yt("Unit rates", "Zm0KaIw-35k", "Khan Academy — Unit rates"),
                    yt("Proportions intro", "USMQhO0La7Y", "Khan Academy — Proportions")
                ]),
            ],
            .wednesday: [
                DayBlock(label: "Phys · work & energy", links: [
                    yt("Work and energy", "2WS1s2DHR_c", "Khan Academy — Work and energy"),
                    yt("Kinetic & potential energy", "7K4V0NvUxr4", "Khan Academy — Kinetic & potential energy")
                ]),
                DayBlock(label: "Math · graphs & slope", links: [
                    yt("Slope from a graph", "R948Tsyq4vA", "Khan Academy — Slope from a graph"),
                    yt("Slope from two points", "WkspBxrzuZo", "Khan Academy — Slope from two ordered pairs")
                ]),
            ],
            .thursday: [
                DayBlock(label: "Chem · stoichiometry", links: [
                    yt("The mole", "wI56mHUDJgQ", "Tyler DeWitt — Introduction to moles"),
                    yt("Molar mass", "CMnkSb2YsXI", "Tyler DeWitt — Converting grams and moles"),
                    yt("Molarity: deeper understanding", "mqRPLaOAoEU", "Tyler DeWitt — Molarity: a deeper understanding")
                ]),
                DayBlock(label: "Math · unit conversion", links: [
                    yt("Metric unit conversion", "w0nqd_HXHPQ", "Khan Academy — Metric unit conversion"),
                    yt("Scientific notation", "ClYdw4d4OmA", "Khan Academy — Scientific notation intro")
                ]),
            ],
            .friday: [
                DayBlock(label: "Bio · cellular respiration", links: [
                    yt("Cellular respiration", "eJ9Zjc-jdys", "Amoeba Sisters — Cellular respiration"),
                    yt("Photosynthesis & respiration", "OEO28tu_kJU", "Amoeba Sisters — Photosynthesis & respiration"),
                    yt("Photosynthesis", "fm-I_SShF7I", "Amoeba Sisters — Photosynthesis")
                ]),
                DayBlock(label: "Math · PEMDAS", links: [
                    yt("Order of operations", "dAgfnK528RA", "Khan Academy — Order of operations"),
                    yt("Scientific notation examples", "i6lfVUp5RW8", "Khan Academy — Scientific notation examples")
                ]),
            ],
        ],
        6: [
            .monday: [
                DayBlock(label: "Chem · molarity", links: [
                    yt("Molarity", "SXf9rDnVFao", "Tyler DeWitt — Molarity practice"),
                    yt("Solutions", "QWabcX1P1zI", "Tyler DeWitt — Solutions"),
                    yt("Molarity: deeper understanding", "mqRPLaOAoEU", "Tyler DeWitt — Molarity: a deeper understanding")
                ]),
                DayBlock(label: "Math · percent", links: [
                    yt("Percent of a number", "JeVSmq1Nrpw", "Khan Academy — Percent of a number"),
                    yt("Proportions", "USMQhO0La7Y", "Khan Academy — Proportions")
                ]),
            ],
            .tuesday: [
                DayBlock(label: "Bio · ecology", links: [
                    yt("Food webs & energy pyramids", "-oVavgmveyY", "Amoeba Sisters — Food webs & energy pyramids"),
                    yt("Food chains & webs", "SyGM_Rd5XV4", "Amoeba Sisters — Food chains & webs"),
                    yt("Ecological relationships", "rNjPI84sApQ", "Amoeba Sisters — Ecological relationships")
                ]),
                DayBlock(label: "Math · proportions", links: [
                    yt("Proportions", "USMQhO0La7Y", "Khan Academy — Proportions"),
                    yt("Unit rates", "Zm0KaIw-35k", "Khan Academy — Unit rates")
                ]),
            ],
            .wednesday: [
                DayBlock(label: "Phys · gravity", links: [
                    yt("Introduction to gravity", "Xcel427Ezl0", "Khan Academy — Introduction to gravity"),
                    yt("Kinetic & potential energy", "7K4V0NvUxr4", "Khan Academy — Kinetic & potential energy")
                ]),
                DayBlock(label: "Math · F = ma", links: [
                    yt("Newton's second law (F = ma)", "FO-It-ig4Qo", "Khan Academy — Newton's second law (F = ma)"),
                    yt("Momentum review", "UoIIwzHug9M", "Khan Academy — Momentum (F = ma connection)")
                ]),
            ],
            .thursday: [
                DayBlock(label: "Chem · acids & bases", links: [
                    yt("Acids and bases", "rdB9QwA0S5k", "Amoeba Sisters — Acids and bases"),
                    yt("pH scale", "J7-GewgqWUQ", "Khan Academy — Definition of pH"),
                    yt("Vaccines & immunity basics", "uVUf_pt7Sh0", "Amoeba Sisters — Antibiotics, antivirals & vaccines")
                ]),
                DayBlock(label: "Math · exponents", links: [
                    yt("Exponent rules", "Z5myJ8DgbsE", "Khan Academy — Exponent rules"),
                    yt("Scientific notation intro", "ClYdw4d4OmA", "Khan Academy — Scientific notation intro")
                ]),
            ],
            .friday: [
                DayBlock(label: "Bio · microbes", links: [
                    yt("Bacteria", "TDoGrbpJJ14", "Amoeba Sisters — Bacteria"),
                    yt("Viruses", "cRcaqUoT3S8", "Amoeba Sisters — Viruses"),
                    yt("Immune system", "fSEFXl2XQpc", "Amoeba Sisters — Immune system")
                ]),
                DayBlock(label: "Math · body-scale ratios", links: [
                    yt("Proportions", "USMQhO0La7Y", "Khan Academy — Proportions"),
                    yt("Unit rates", "Zm0KaIw-35k", "Khan Academy — Unit rates")
                ]),
            ],
        ],
        7: [
            .monday: [
                DayBlock(label: "Chem · chemical reactions", links: [
                    yt("Balancing equations", "1jL9LTU1sE8", "Tyler DeWitt — Balancing equations"),
                    yt("Types of chemical reactions", "aMU1RaRulSo", "Tyler DeWitt — Types of chemical reactions"),
                    yt("Reaction types practice", "2qX9MOQOmAM", "Tyler DeWitt — Classifying reaction types")
                ]),
                DayBlock(label: "Math · formula substitution", links: [
                    yt("v = d/t (formula plug-in)", "W6Ar0ls6tVA", "Khan Academy — v = d/t (formula plug-in)"),
                    yt("Work W = Fd", "2WS1s2DHR_c", "Khan Academy — Work W = Fd")
                ]),
            ],
            .tuesday: [
                DayBlock(label: "Bio · immune system", links: [
                    yt("Immune system", "fSEFXl2XQpc", "Amoeba Sisters — Immune system"),
                    yt("Viruses", "cRcaqUoT3S8", "Amoeba Sisters — Viruses"),
                    yt("Antibiotics & vaccines", "uVUf_pt7Sh0", "Amoeba Sisters — Antibiotics, antivirals & vaccines")
                ]),
                DayBlock(label: "Math · graph reading", links: [
                    yt("Read slope from graphs", "R948Tsyq4vA", "Khan Academy — Read slope from graphs"),
                    yt("Average rate of change", "TEXSW-o8674", "Khan Academy — Average rate of change from a graph")
                ]),
            ],
            .wednesday: [
                DayBlock(label: "Phys · heat", links: [
                    yt("Heat and temperature", "-7Gl-yKF6Y4", "Khan Academy — Heat and temperature"),
                    yt("Specific heat", "GNelfJ6IAJw", "Khan Academy — Specific heat"),
                    yt("Heat transfer", "FPPv1mkRpKw", "Khan Academy — Heat transfer")
                ]),
                DayBlock(label: "Math · W = Fd", links: [
                    yt("Work W = Fd", "2WS1s2DHR_c", "Khan Academy — Work W = Fd"),
                    yt("Kinetic & potential energy", "7K4V0NvUxr4", "Khan Academy — Kinetic & potential energy")
                ]),
            ],
            .thursday: [
                DayBlock(label: "Chem · periodic trends", links: [
                    yt("Periodic trends", "0x_ei7LCNR4", "Tyler DeWitt — Periodic trends"),
                    yt("Periodic table basics", "84780SzjGt0", "Periodic table basics"),
                    yt("Crash Course: Periodic Table", "0RRVV4Diomg", "Crash Course Chemistry #4")
                ]),
                DayBlock(label: "Math · concentration ratios", links: [
                    yt("Proportions (concentration)", "USMQhO0La7Y", "Khan Academy — Proportions (concentration)"),
                    yt("Unit rates", "Zm0KaIw-35k", "Khan Academy — Unit rates")
                ]),
            ],
            .friday: [
                DayBlock(label: "Bio · plants", links: [
                    yt("Plant structure", "EAtt7iR9qDc", "Amoeba Sisters — Plant structure"),
                    yt("Plant structure & transport", "A_DF246uVlU", "Amoeba Sisters — Plant structure & transport")
                ]),
                DayBlock(label: "Math · mixed review", links: [
                    yt("Mixed algebra review", "i6lfVUp5RW8", "Khan Academy — Mixed algebra review"),
                    yt("Proportions", "USMQhO0La7Y", "Khan Academy — Proportions")
                ]),
            ],
        ],
        8: [
            .monday: [
                DayBlock(label: "Chem · lab skills", links: [
                    yt("Significant figures", "hsSwf2_onlI", "Tyler DeWitt — Significant figures"),
                    yt("Density", "7tVebi3TSsg", "Tyler DeWitt — Density practice")
                ]),
                DayBlock(label: "Math · number review", links: [
                    yt("Comparing rational numbers", "kQ3K_H9QOGA", "Khan Academy — Comparing rational numbers"),
                    yt("Scientific notation intro", "ClYdw4d4OmA", "Khan Academy — Scientific notation intro")
                ]),
            ],
            .tuesday: [
                DayBlock(label: "Bio · plant transport", links: [
                    yt("Plant structure", "EAtt7iR9qDc", "Amoeba Sisters — Plant structure"),
                    yt("Plant transport", "A_DF246uVlU", "Amoeba Sisters — Plant structure & transport"),
                ]),
                DayBlock(label: "Math · logic & probability", links: [
                    yt("Basic probability", "uzkc-q4Q-Z0", "Khan Academy — Basic probability"),
                    yt("Compound probability", "xSc4oLA9e8o", "Khan Academy — Compound probability of independent events")
                ]),
            ],
            .wednesday: [
                DayBlock(label: "Phys · electricity", links: [
                    yt("Ohm's law", "mF1Vuii0rFY", "Khan Academy — Ohm's law"),
                    yt("Electric current", "6K1Bl0cqecE", "Khan Academy — Electric current"),
                    yt("Circuits & Ohm's law intro", "F_vLWkkOETI", "Khan Academy — Circuits and Ohm's law")
                ]),
                DayBlock(label: "Math · v = fλ", links: [
                    yt("v = fλ intro", "TIGG17A9QFI", "Khan Academy — v = fλ intro"),
                    yt("Wavelength & frequency", "WkspBxrzuZo", "Khan Academy — Rate of change (slope analogy)")
                ]),
            ],
            .thursday: [
                DayBlock(label: "Chem · states of matter", links: [
                    yt("States of matter", "wclY8F-UoHE", "Amoeba Sisters — States of matter"),
                    yt("Phase changes", "FPPv1mkRpKw", "Khan Academy — Heat transfer & phase changes")
                ]),
                DayBlock(label: "Math · unit conversion review", links: [
                    yt("Metric unit conversion", "w0nqd_HXHPQ", "Khan Academy — Metric unit conversion"),
                    yt("Scientific notation examples", "i6lfVUp5RW8", "Khan Academy — Scientific notation examples")
                ]),
            ],
            .friday: [
                DayBlock(label: "Bio · animal tissues", links: [
                    yt("Body tissues", "5j8j7BhCCEg", "Amoeba Sisters — Body tissues"),
                    yt("Muscle tissue", "dpxalWACO7k", "Amoeba Sisters — Muscle tissue")
                ]),
                DayBlock(label: "Math · formula plug-in", links: [
                    yt("v = d/t (formula plug-in)", "W6Ar0ls6tVA", "Khan Academy — v = d/t (formula plug-in)"),
                    yt("Slope from a graph", "R948Tsyq4vA", "Khan Academy — Slope from a graph")
                ]),
            ],
        ],
        9: [
            .monday: [
                DayBlock(label: "Chem · isotopes review", links: [
                    yt("What are Isotopes?", "EboWeWmh5Pg", "Tyler DeWitt — What are Isotopes?"),
                    yt("What's Inside an Atom?", "e9GuJUaX0UM", "Tyler DeWitt — What's Inside an Atom?"),
                    yt("Periodic table basics", "84780SzjGt0", "Periodic table basics")
                ]),
                DayBlock(label: "Math · sci notation", links: [
                    yt("Scientific notation intro", "ClYdw4d4OmA", "Khan Academy — Scientific notation intro"),
                    yt("Scientific notation examples", "i6lfVUp5RW8", "Khan Academy — Scientific notation examples")
                ]),
            ],
            .tuesday: [
                DayBlock(label: "Bio · cell reproduction", links: [
                    yt("Mitosis", "f-ldPgEfAHI", "Amoeba Sisters — Mitosis"),
                    yt("Introduction to Cells", "8IlzKri08kk", "Amoeba Sisters — Introduction to Cells"),
                    yt("Prokaryotes vs. Eukaryotes", "Pxujitlv8wc", "Amoeba Sisters — Prokaryotes vs. Eukaryotes")
                ]),
                DayBlock(label: "Math · ratios", links: [
                    yt("Unit rates", "Zm0KaIw-35k", "Khan Academy — Unit rates"),
                    yt("Proportions intro", "USMQhO0La7Y", "Khan Academy — Proportions")
                ]),
            ],
            .wednesday: [
                DayBlock(label: "Phys · magnetism & waves", links: [
                    yt("Introduction to waves", "TIGG17A9QFI", "Khan Academy — Introduction to waves"),
                    yt("Introduction to magnetism", "u-3cEw0uDC0", "Khan Academy — Magnetic force"),
                    yt("Reflection", "sd0BOnN6aNY", "Khan Academy — Reflection")
                ]),
                DayBlock(label: "Math · graphs", links: [
                    yt("Slope from a graph", "R948Tsyq4vA", "Khan Academy — Slope from a graph"),
                    yt("Average rate of change", "TEXSW-o8674", "Khan Academy — Average rate of change from a graph")
                ]),
            ],
            .thursday: [
                DayBlock(label: "Chem · ions & compounds", links: [
                    yt("Writing ionic formulas", "URc75hoKGLY", "Tyler DeWitt — Writing ionic formulas"),
                    yt("Periodic table basics", "84780SzjGt0", "Periodic table basics"),
                    yt("Ionic bonding", "5EwmedLuRmw", "Tyler DeWitt — Ionic bonding")
                ]),
                DayBlock(label: "Math · unit conversion", links: [
                    yt("Metric unit conversion", "w0nqd_HXHPQ", "Khan Academy — Metric unit conversion"),
                    yt("Scientific notation", "ClYdw4d4OmA", "Khan Academy — Scientific notation intro")
                ]),
            ],
            .friday: [
                DayBlock(label: "Bio · body systems", links: [
                    yt("Circulatory system", "H04aZjcf4Zo", "Amoeba Sisters — Circulatory system"),
                    yt("Digestive system", "1UvuBYUbFk0", "Amoeba Sisters — Digestive system"),
                    yt("Human body systems overview", "0JDCViWGn-0", "Amoeba Sisters — Human body systems overview")
                ]),
                DayBlock(label: "Math · flash review", links: [
                    yt("Ratios flash review", "Zm0KaIw-35k", "Khan Academy — Ratios flash review"),
                    yt("Mixed algebra review", "i6lfVUp5RW8", "Khan Academy — Mixed algebra review")
                ]),
            ],
        ],
        10: [
            .monday: [
                DayBlock(label: "Chem · chemistry review", links: [
                    yt("What's Inside an Atom?", "e9GuJUaX0UM", "Tyler DeWitt — What's Inside an Atom?"),
                    yt("Balancing equations", "1jL9LTU1sE8", "Tyler DeWitt — Balancing equations"),
                    yt("Acids and bases", "rdB9QwA0S5k", "Amoeba Sisters — Acids and bases")
                ]),
                DayBlock(label: "Math · formula substitution", links: [
                    yt("v = d/t (formula plug-in)", "W6Ar0ls6tVA", "Khan Academy — v = d/t (formula plug-in)"),
                    yt("Work W = Fd", "2WS1s2DHR_c", "Khan Academy — Work W = Fd")
                ]),
            ],
            .tuesday: [
                DayBlock(label: "Bio · biology review", links: [
                    yt("Introduction to Cells", "8IlzKri08kk", "Amoeba Sisters — Introduction to Cells"),
                    yt("Punnett squares", "prkHKjf_oHE", "Amoeba Sisters — Punnett squares"),
                    yt("Food chains & webs", "SyGM_Rd5XV4", "Amoeba Sisters — Food chains & webs")
                ]),
                DayBlock(label: "Math · graph reading", links: [
                    yt("Read slope from graphs", "R948Tsyq4vA", "Khan Academy — Read slope from graphs"),
                    yt("Average rate of change", "TEXSW-o8674", "Khan Academy — Average rate of change from a graph")
                ]),
            ],
            .wednesday: [
                DayBlock(label: "Phys · light", links: [
                    yt("Reflection", "sd0BOnN6aNY", "Khan Academy — Reflection"),
                    yt("Refraction", "LKI1UmFbfaA", "Khan Academy — Refraction"),
                    yt("Introduction to waves", "TIGG17A9QFI", "Khan Academy — Introduction to waves")
                ]),
                DayBlock(label: "Math · W = Fd", links: [
                    yt("Work W = Fd", "2WS1s2DHR_c", "Khan Academy — Work W = Fd"),
                    yt("Kinetic & potential energy", "7K4V0NvUxr4", "Khan Academy — Kinetic & potential energy")
                ]),
            ],
            .thursday: [
                DayBlock(label: "Chem · lab skills review", links: [
                    yt("Significant figures", "hsSwf2_onlI", "Tyler DeWitt — Significant figures"),
                    yt("Periodic table basics", "84780SzjGt0", "Periodic table basics"),
                    yt("Density practice", "7tVebi3TSsg", "Tyler DeWitt — Density practice")
                ]),
                DayBlock(label: "Math · concentration ratios", links: [
                    yt("Proportions (concentration)", "USMQhO0La7Y", "Khan Academy — Proportions (concentration)"),
                    yt("Unit rates", "Zm0KaIw-35k", "Khan Academy — Unit rates")
                ]),
            ],
            .friday: [
                DayBlock(label: "Bio · final bio review", links: [
                    yt("Photosynthesis", "fm-I_SShF7I", "Amoeba Sisters — Photosynthesis"),
                    yt("Food chains & webs", "SyGM_Rd5XV4", "Amoeba Sisters — Food chains & webs"),
                    yt("Immune system", "fSEFXl2XQpc", "Amoeba Sisters — Immune system")
                ]),
                DayBlock(label: "Math · final review", links: [
                    yt("Sci notation + formulas review", "ClYdw4d4OmA", "Khan Academy — Sci notation + formulas review"),
                    yt("Unit rates", "Zm0KaIw-35k", "Khan Academy — Unit rates")
                ]),
            ],
        ],
    ]
}
