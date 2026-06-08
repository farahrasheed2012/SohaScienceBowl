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

    static func scienceAndMathLinks(for week: Int, day: Weekday) -> [ScheduleVideoLink] {
        allLinks(week: week, day: day)
    }

    private struct DayBlock {
        let label: String
        let links: [ScheduleVideoLink]
    }

    private static let schedule: [Int: [Weekday: [DayBlock]]] = [
        1: [
            .monday: [
                DayBlock(label: "Chem · atoms", links: [
                    ScheduleVideoLink(title: "What's Inside an Atom?", url: URL(string: "https://www.youtube.com/watch?v=e9GuJUaX0UM")!, note: "Tyler DeWitt — What's Inside an Atom?"),
                    ScheduleVideoLink(title: "What are Isotopes?", url: URL(string: "https://www.youtube.com/watch?v=EboWeWmh5Pg")!, note: "Tyler DeWitt — What are Isotopes?")
                ]),
                DayBlock(label: "Math · sci notation", links: [
                    ScheduleVideoLink(title: "Scientific notation intro", url: URL(string: "https://www.youtube.com/watch?v=ClYdw4d4OmA")!, note: "Khan Academy — Scientific notation intro"),
                    ScheduleVideoLink(title: "Scientific notation examples", url: URL(string: "https://www.youtube.com/watch?v=i6lfVUp5RW8")!, note: "Khan Academy — Scientific notation examples")
                ]),
            ],
            .tuesday: [
                DayBlock(label: "Bio · cells", links: [
                    ScheduleVideoLink(title: "Introduction to Cells", url: URL(string: "https://www.youtube.com/watch?v=8IlzKri08kk")!, note: "Amoeba Sisters — Introduction to Cells")
                ]),
                DayBlock(label: "Math · ratios", links: [
                    ScheduleVideoLink(title: "Unit rates", url: URL(string: "https://www.youtube.com/watch?v=Zm0KaIw-35k")!, note: "Khan Academy — Unit rates")
                ]),
            ],
            .wednesday: [
                DayBlock(label: "Phys · motion", links: [
                    ScheduleVideoLink(title: "Speed and velocity", url: URL(string: "https://www.youtube.com/watch?v=W6Ar0ls6tVA")!, note: "Khan Academy — Speed and velocity"),
                    ScheduleVideoLink(title: "Theory vs. law", url: URL(string: "https://www.youtube.com/watch?v=P30QlwSsUic")!, note: "Amoeba Sisters — Theory vs. law")
                ]),
                DayBlock(label: "Math · graphs & slope", links: [
                    ScheduleVideoLink(title: "Slope from a graph", url: URL(string: "https://www.youtube.com/watch?v=R948Tsyq4vA")!, note: "Khan Academy — Slope from a graph")
                ]),
            ],
            .thursday: [
                DayBlock(label: "Chem · periodic table", links: [
                    ScheduleVideoLink(title: "Periodic table basics", url: URL(string: "https://www.youtube.com/watch?v=84780SzjGt0")!, note: "Periodic table basics"),
                    ScheduleVideoLink(title: "Crash Course Chemistry #4", url: URL(string: "https://www.youtube.com/watch?v=0RRVV4Diomg")!, note: "Crash Course Chemistry #4")
                ]),
                DayBlock(label: "Chem · ionic formulas", links: [
                    ScheduleVideoLink(title: "Writing ionic formulas", url: URL(string: "https://www.youtube.com/watch?v=URc75hoKGLY")!, note: "Tyler DeWitt — Writing ionic formulas")
                ]),
                DayBlock(label: "Math · unit conversion", links: [
                    ScheduleVideoLink(title: "Metric unit conversion", url: URL(string: "https://www.youtube.com/watch?v=w0nqd_HXHPQ")!, note: "Khan Academy — Metric unit conversion")
                ]),
            ],
            .friday: [
                DayBlock(label: "Bio · levels of organization", links: [
                    ScheduleVideoLink(title: "Biological levels", url: URL(string: "https://www.youtube.com/watch?v=EtWknf1gzKo")!, note: "Amoeba Sisters — Biological levels")
                ]),
                DayBlock(label: "Math · PEMDAS", links: [
                    ScheduleVideoLink(title: "Order of operations", url: URL(string: "https://www.youtube.com/watch?v=dAgfnK528RA")!, note: "Khan Academy — Order of operations")
                ]),
            ],
        ],
        2: [
            .monday: [
                DayBlock(label: "Chem · states of matter", links: [
                    ScheduleVideoLink(title: "States of matter", url: URL(string: "https://www.youtube.com/watch?v=wclY8F-UoHE")!, note: "Amoeba Sisters — States of matter")
                ]),
                DayBlock(label: "Math · percent", links: [
                    ScheduleVideoLink(title: "Percent of a number", url: URL(string: "https://www.youtube.com/watch?v=JeVSmq1Nrpw")!, note: "Khan Academy — Percent of a number")
                ]),
            ],
            .tuesday: [
                DayBlock(label: "Bio · genetics", links: [
                    ScheduleVideoLink(title: "Punnett squares", url: URL(string: "https://www.youtube.com/watch?v=prkHKjf_oHE")!, note: "Amoeba Sisters — Punnett squares"),
                    ScheduleVideoLink(title: "DNA and genes", url: URL(string: "https://www.youtube.com/watch?v=CBezq1fFoiA")!, note: "Amoeba Sisters — DNA and genes")
                ]),
                DayBlock(label: "Math · proportions", links: [
                    ScheduleVideoLink(title: "Proportions", url: URL(string: "https://www.youtube.com/watch?v=USMQhO0La7Y")!, note: "Khan Academy — Proportions")
                ]),
            ],
            .wednesday: [
                DayBlock(label: "Phys · Newton's laws", links: [
                    ScheduleVideoLink(title: "Newton's laws", url: URL(string: "https://www.youtube.com/watch?v=kKKM3q0qX10")!, note: "Crash Course — Newton's laws"),
                    ScheduleVideoLink(title: "Newton's second law (F = ma)", url: URL(string: "https://www.youtube.com/watch?v=FO-It-ig4Qo")!, note: "Khan Academy — Newton's second law (F = ma)")
                ]),
                DayBlock(label: "Math · F = ma", links: [
                    ScheduleVideoLink(title: "Newton's second law (F = ma)", url: URL(string: "https://www.youtube.com/watch?v=FO-It-ig4Qo")!, note: "Khan Academy — Newton's second law (F = ma)")
                ]),
            ],
            .thursday: [
                DayBlock(label: "Chem · chemical reactions", links: [
                    ScheduleVideoLink(title: "Balancing equations", url: URL(string: "https://www.youtube.com/watch?v=1jL9LTU1sE8")!, note: "Tyler DeWitt — Balancing equations")
                ]),
                DayBlock(label: "Math · exponents", links: [
                    ScheduleVideoLink(title: "Exponent rules", url: URL(string: "https://www.youtube.com/watch?v=Z5myJ8DgbsE")!, note: "Khan Academy — Exponent rules")
                ]),
            ],
            .friday: [
                DayBlock(label: "Bio · body systems", links: [
                    ScheduleVideoLink(title: "Circulatory system", url: URL(string: "https://www.youtube.com/watch?v=H04aZjcf4Zo")!, note: "Amoeba Sisters — Circulatory system")
                ]),
                DayBlock(label: "Math · body-scale ratios", links: [
                    ScheduleVideoLink(title: "Proportions", url: URL(string: "https://www.youtube.com/watch?v=USMQhO0La7Y")!, note: "Khan Academy — Proportions")
                ]),
            ],
        ],
        3: [
            .monday: [
                DayBlock(label: "Chem · acids & bases", links: [
                    ScheduleVideoLink(title: "Acids and bases", url: URL(string: "https://www.youtube.com/watch?v=rdB9QwA0S5k")!, note: "Amoeba Sisters — Acids and bases")
                ]),
                DayBlock(label: "Math · formula substitution", links: [
                    ScheduleVideoLink(title: "v = d/t (formula plug-in)", url: URL(string: "https://www.youtube.com/watch?v=W6Ar0ls6tVA")!, note: "Khan Academy — v = d/t (formula plug-in)")
                ]),
            ],
            .tuesday: [
                DayBlock(label: "Bio · ecology", links: [
                    ScheduleVideoLink(title: "Food chains & webs", url: URL(string: "https://www.youtube.com/watch?v=SyGM_Rd5XV4")!, note: "Amoeba Sisters — Food chains & webs")
                ]),
                DayBlock(label: "Math · graph reading", links: [
                    ScheduleVideoLink(title: "Read slope from graphs", url: URL(string: "https://www.youtube.com/watch?v=R948Tsyq4vA")!, note: "Khan Academy — Read slope from graphs")
                ]),
            ],
            .wednesday: [
                DayBlock(label: "Phys · work & energy", links: [
                    ScheduleVideoLink(title: "Work and energy", url: URL(string: "https://www.youtube.com/watch?v=2WS1s2DHR_c")!, note: "Khan Academy — Work and energy"),
                    ScheduleVideoLink(title: "Kinetic & potential energy", url: URL(string: "https://www.youtube.com/watch?v=7K4V0NvUxr4")!, note: "Khan Academy — Kinetic & potential energy")
                ]),
                DayBlock(label: "Math · W = Fd", links: [
                    ScheduleVideoLink(title: "Work W = Fd", url: URL(string: "https://www.youtube.com/watch?v=2WS1s2DHR_c")!, note: "Khan Academy — Work W = Fd")
                ]),
            ],
            .thursday: [
                DayBlock(label: "Chem · solutions", links: [
                    ScheduleVideoLink(title: "Solutions", url: URL(string: "https://www.youtube.com/watch?v=QWabcX1P1zI")!, note: "Tyler DeWitt — Solutions")
                ]),
                DayBlock(label: "Math · concentration ratios", links: [
                    ScheduleVideoLink(title: "Proportions (concentration)", url: URL(string: "https://www.youtube.com/watch?v=USMQhO0La7Y")!, note: "Khan Academy — Proportions (concentration)")
                ]),
            ],
            .friday: [
                DayBlock(label: "Bio · microbes & immunity", links: [
                    ScheduleVideoLink(title: "Viruses", url: URL(string: "https://www.youtube.com/watch?v=cRcaqUoT3S8")!, note: "Amoeba Sisters — Viruses")
                ]),
                DayBlock(label: "Math · mixed review", links: [
                    ScheduleVideoLink(title: "Mixed algebra review", url: URL(string: "https://www.youtube.com/watch?v=i6lfVUp5RW8")!, note: "Khan Academy — Mixed algebra review")
                ]),
            ],
        ],
        4: [
            .monday: [
                DayBlock(label: "Chem · periodic trends", links: [
                    ScheduleVideoLink(title: "Periodic trends", url: URL(string: "https://www.youtube.com/watch?v=0x_ei7LCNR4")!, note: "Tyler DeWitt — Periodic trends")
                ]),
                DayBlock(label: "Math · number review", links: [
                    ScheduleVideoLink(title: "Comparing rational numbers", url: URL(string: "https://www.youtube.com/watch?v=kQ3K_H9QOGA")!, note: "Khan Academy — Comparing rational numbers")
                ]),
            ],
            .tuesday: [
                DayBlock(label: "Bio · evolution", links: [
                    ScheduleVideoLink(title: "Natural selection", url: URL(string: "https://www.youtube.com/watch?v=GhHOjCpK0SE")!, note: "Amoeba Sisters — Natural selection")
                ]),
                DayBlock(label: "Math · logic & probability", links: [
                    ScheduleVideoLink(title: "Basic probability", url: URL(string: "https://www.youtube.com/watch?v=uzkc-q4Q-Z0")!, note: "Khan Academy — Basic probability")
                ]),
            ],
            .wednesday: [
                DayBlock(label: "Phys · waves & electricity", links: [
                    ScheduleVideoLink(title: "Introduction to waves", url: URL(string: "https://www.youtube.com/watch?v=TIGG17A9QFI")!, note: "Khan Academy — Introduction to waves"),
                    ScheduleVideoLink(title: "Ohm's law", url: URL(string: "https://www.youtube.com/watch?v=mF1Vuii0rFY")!, note: "Khan Academy — Ohm's law")
                ]),
                DayBlock(label: "Math · v = fλ", links: [
                    ScheduleVideoLink(title: "v = fλ intro", url: URL(string: "https://www.youtube.com/watch?v=TIGG17A9QFI")!, note: "Khan Academy — v = fλ intro")
                ]),
            ],
            .thursday: [
                DayBlock(label: "Chem · lab measurement", links: [
                    ScheduleVideoLink(title: "Significant figures", url: URL(string: "https://www.youtube.com/watch?v=hsSwf2_onlI")!, note: "Tyler DeWitt — Significant figures")
                ]),
                DayBlock(label: "Math · unit conversion review", links: [
                    ScheduleVideoLink(title: "Metric unit conversion", url: URL(string: "https://www.youtube.com/watch?v=w0nqd_HXHPQ")!, note: "Khan Academy — Metric unit conversion")
                ]),
            ],
            .friday: [
                DayBlock(label: "Bio · plants", links: [
                    ScheduleVideoLink(title: "Plant structure", url: URL(string: "https://www.youtube.com/watch?v=EAtt7iR9qDc")!, note: "Amoeba Sisters — Plant structure")
                ]),
                DayBlock(label: "Math · formula plug-in", links: [
                    ScheduleVideoLink(title: "v = d/t (formula plug-in)", url: URL(string: "https://www.youtube.com/watch?v=W6Ar0ls6tVA")!, note: "Khan Academy — v = d/t (formula plug-in)")
                ]),
            ],
        ],
        5: [
            .monday: [
                DayBlock(label: "Chem · atoms", links: [
                    ScheduleVideoLink(title: "What's Inside an Atom?", url: URL(string: "https://www.youtube.com/watch?v=e9GuJUaX0UM")!, note: "Tyler DeWitt — What's Inside an Atom?"),
                    ScheduleVideoLink(title: "What are Isotopes?", url: URL(string: "https://www.youtube.com/watch?v=EboWeWmh5Pg")!, note: "Tyler DeWitt — What are Isotopes?")
                ]),
                DayBlock(label: "Math · sci notation", links: [
                    ScheduleVideoLink(title: "Scientific notation intro", url: URL(string: "https://www.youtube.com/watch?v=ClYdw4d4OmA")!, note: "Khan Academy — Scientific notation intro"),
                    ScheduleVideoLink(title: "Scientific notation examples", url: URL(string: "https://www.youtube.com/watch?v=i6lfVUp5RW8")!, note: "Khan Academy — Scientific notation examples")
                ]),
            ],
            .tuesday: [
                DayBlock(label: "Bio · cells", links: [
                    ScheduleVideoLink(title: "Introduction to Cells", url: URL(string: "https://www.youtube.com/watch?v=8IlzKri08kk")!, note: "Amoeba Sisters — Introduction to Cells")
                ]),
                DayBlock(label: "Math · ratios", links: [
                    ScheduleVideoLink(title: "Unit rates", url: URL(string: "https://www.youtube.com/watch?v=Zm0KaIw-35k")!, note: "Khan Academy — Unit rates")
                ]),
            ],
            .wednesday: [
                DayBlock(label: "Phys · motion", links: [
                    ScheduleVideoLink(title: "Speed and velocity", url: URL(string: "https://www.youtube.com/watch?v=W6Ar0ls6tVA")!, note: "Khan Academy — Speed and velocity"),
                    ScheduleVideoLink(title: "Theory vs. law", url: URL(string: "https://www.youtube.com/watch?v=P30QlwSsUic")!, note: "Amoeba Sisters — Theory vs. law")
                ]),
                DayBlock(label: "Math · graphs & slope", links: [
                    ScheduleVideoLink(title: "Slope from a graph", url: URL(string: "https://www.youtube.com/watch?v=R948Tsyq4vA")!, note: "Khan Academy — Slope from a graph")
                ]),
            ],
            .thursday: [
                DayBlock(label: "Chem · periodic table", links: [
                    ScheduleVideoLink(title: "Periodic table basics", url: URL(string: "https://www.youtube.com/watch?v=84780SzjGt0")!, note: "Periodic table basics"),
                    ScheduleVideoLink(title: "Crash Course Chemistry #4", url: URL(string: "https://www.youtube.com/watch?v=0RRVV4Diomg")!, note: "Crash Course Chemistry #4")
                ]),
                DayBlock(label: "Chem · ionic formulas", links: [
                    ScheduleVideoLink(title: "Writing ionic formulas", url: URL(string: "https://www.youtube.com/watch?v=URc75hoKGLY")!, note: "Tyler DeWitt — Writing ionic formulas")
                ]),
                DayBlock(label: "Math · unit conversion", links: [
                    ScheduleVideoLink(title: "Metric unit conversion", url: URL(string: "https://www.youtube.com/watch?v=w0nqd_HXHPQ")!, note: "Khan Academy — Metric unit conversion")
                ]),
            ],
            .friday: [
                DayBlock(label: "Bio · levels of organization", links: [
                    ScheduleVideoLink(title: "Biological levels", url: URL(string: "https://www.youtube.com/watch?v=EtWknf1gzKo")!, note: "Amoeba Sisters — Biological levels")
                ]),
                DayBlock(label: "Math · PEMDAS", links: [
                    ScheduleVideoLink(title: "Order of operations", url: URL(string: "https://www.youtube.com/watch?v=dAgfnK528RA")!, note: "Khan Academy — Order of operations")
                ]),
            ],
        ],
        6: [
            .monday: [
                DayBlock(label: "Chem · states of matter", links: [
                    ScheduleVideoLink(title: "States of matter", url: URL(string: "https://www.youtube.com/watch?v=wclY8F-UoHE")!, note: "Amoeba Sisters — States of matter")
                ]),
                DayBlock(label: "Math · percent", links: [
                    ScheduleVideoLink(title: "Percent of a number", url: URL(string: "https://www.youtube.com/watch?v=JeVSmq1Nrpw")!, note: "Khan Academy — Percent of a number")
                ]),
            ],
            .tuesday: [
                DayBlock(label: "Bio · genetics", links: [
                    ScheduleVideoLink(title: "Punnett squares", url: URL(string: "https://www.youtube.com/watch?v=prkHKjf_oHE")!, note: "Amoeba Sisters — Punnett squares"),
                    ScheduleVideoLink(title: "DNA and genes", url: URL(string: "https://www.youtube.com/watch?v=CBezq1fFoiA")!, note: "Amoeba Sisters — DNA and genes")
                ]),
                DayBlock(label: "Math · proportions", links: [
                    ScheduleVideoLink(title: "Proportions", url: URL(string: "https://www.youtube.com/watch?v=USMQhO0La7Y")!, note: "Khan Academy — Proportions")
                ]),
            ],
            .wednesday: [
                DayBlock(label: "Phys · Newton's laws", links: [
                    ScheduleVideoLink(title: "Newton's laws", url: URL(string: "https://www.youtube.com/watch?v=kKKM3q0qX10")!, note: "Crash Course — Newton's laws"),
                    ScheduleVideoLink(title: "Newton's second law (F = ma)", url: URL(string: "https://www.youtube.com/watch?v=FO-It-ig4Qo")!, note: "Khan Academy — Newton's second law (F = ma)")
                ]),
                DayBlock(label: "Math · F = ma", links: [
                    ScheduleVideoLink(title: "Newton's second law (F = ma)", url: URL(string: "https://www.youtube.com/watch?v=FO-It-ig4Qo")!, note: "Khan Academy — Newton's second law (F = ma)")
                ]),
            ],
            .thursday: [
                DayBlock(label: "Chem · chemical reactions", links: [
                    ScheduleVideoLink(title: "Balancing equations", url: URL(string: "https://www.youtube.com/watch?v=1jL9LTU1sE8")!, note: "Tyler DeWitt — Balancing equations")
                ]),
                DayBlock(label: "Math · exponents", links: [
                    ScheduleVideoLink(title: "Exponent rules", url: URL(string: "https://www.youtube.com/watch?v=Z5myJ8DgbsE")!, note: "Khan Academy — Exponent rules")
                ]),
            ],
            .friday: [
                DayBlock(label: "Bio · body systems", links: [
                    ScheduleVideoLink(title: "Circulatory system", url: URL(string: "https://www.youtube.com/watch?v=H04aZjcf4Zo")!, note: "Amoeba Sisters — Circulatory system")
                ]),
                DayBlock(label: "Math · body-scale ratios", links: [
                    ScheduleVideoLink(title: "Proportions", url: URL(string: "https://www.youtube.com/watch?v=USMQhO0La7Y")!, note: "Khan Academy — Proportions")
                ]),
            ],
        ],
        7: [
            .monday: [
                DayBlock(label: "Chem · acids & bases", links: [
                    ScheduleVideoLink(title: "Acids and bases", url: URL(string: "https://www.youtube.com/watch?v=rdB9QwA0S5k")!, note: "Amoeba Sisters — Acids and bases")
                ]),
                DayBlock(label: "Math · formula substitution", links: [
                    ScheduleVideoLink(title: "v = d/t (formula plug-in)", url: URL(string: "https://www.youtube.com/watch?v=W6Ar0ls6tVA")!, note: "Khan Academy — v = d/t (formula plug-in)")
                ]),
            ],
            .tuesday: [
                DayBlock(label: "Bio · ecology", links: [
                    ScheduleVideoLink(title: "Food chains & webs", url: URL(string: "https://www.youtube.com/watch?v=SyGM_Rd5XV4")!, note: "Amoeba Sisters — Food chains & webs")
                ]),
                DayBlock(label: "Math · graph reading", links: [
                    ScheduleVideoLink(title: "Read slope from graphs", url: URL(string: "https://www.youtube.com/watch?v=R948Tsyq4vA")!, note: "Khan Academy — Read slope from graphs")
                ]),
            ],
            .wednesday: [
                DayBlock(label: "Phys · work & energy", links: [
                    ScheduleVideoLink(title: "Work and energy", url: URL(string: "https://www.youtube.com/watch?v=2WS1s2DHR_c")!, note: "Khan Academy — Work and energy"),
                    ScheduleVideoLink(title: "Kinetic & potential energy", url: URL(string: "https://www.youtube.com/watch?v=7K4V0NvUxr4")!, note: "Khan Academy — Kinetic & potential energy")
                ]),
                DayBlock(label: "Math · W = Fd", links: [
                    ScheduleVideoLink(title: "Work W = Fd", url: URL(string: "https://www.youtube.com/watch?v=2WS1s2DHR_c")!, note: "Khan Academy — Work W = Fd")
                ]),
            ],
            .thursday: [
                DayBlock(label: "Chem · solutions", links: [
                    ScheduleVideoLink(title: "Solutions", url: URL(string: "https://www.youtube.com/watch?v=QWabcX1P1zI")!, note: "Tyler DeWitt — Solutions")
                ]),
                DayBlock(label: "Math · concentration ratios", links: [
                    ScheduleVideoLink(title: "Proportions (concentration)", url: URL(string: "https://www.youtube.com/watch?v=USMQhO0La7Y")!, note: "Khan Academy — Proportions (concentration)")
                ]),
            ],
            .friday: [
                DayBlock(label: "Bio · microbes & immunity", links: [
                    ScheduleVideoLink(title: "Viruses", url: URL(string: "https://www.youtube.com/watch?v=cRcaqUoT3S8")!, note: "Amoeba Sisters — Viruses")
                ]),
                DayBlock(label: "Math · mixed review", links: [
                    ScheduleVideoLink(title: "Mixed algebra review", url: URL(string: "https://www.youtube.com/watch?v=i6lfVUp5RW8")!, note: "Khan Academy — Mixed algebra review")
                ]),
            ],
        ],
        8: [
            .monday: [
                DayBlock(label: "Chem · periodic trends", links: [
                    ScheduleVideoLink(title: "Periodic trends", url: URL(string: "https://www.youtube.com/watch?v=0x_ei7LCNR4")!, note: "Tyler DeWitt — Periodic trends")
                ]),
                DayBlock(label: "Math · number review", links: [
                    ScheduleVideoLink(title: "Comparing rational numbers", url: URL(string: "https://www.youtube.com/watch?v=kQ3K_H9QOGA")!, note: "Khan Academy — Comparing rational numbers")
                ]),
            ],
            .tuesday: [
                DayBlock(label: "Bio · evolution", links: [
                    ScheduleVideoLink(title: "Natural selection", url: URL(string: "https://www.youtube.com/watch?v=GhHOjCpK0SE")!, note: "Amoeba Sisters — Natural selection")
                ]),
                DayBlock(label: "Math · logic & probability", links: [
                    ScheduleVideoLink(title: "Basic probability", url: URL(string: "https://www.youtube.com/watch?v=uzkc-q4Q-Z0")!, note: "Khan Academy — Basic probability")
                ]),
            ],
            .wednesday: [
                DayBlock(label: "Phys · waves & electricity", links: [
                    ScheduleVideoLink(title: "Introduction to waves", url: URL(string: "https://www.youtube.com/watch?v=TIGG17A9QFI")!, note: "Khan Academy — Introduction to waves"),
                    ScheduleVideoLink(title: "Ohm's law", url: URL(string: "https://www.youtube.com/watch?v=mF1Vuii0rFY")!, note: "Khan Academy — Ohm's law")
                ]),
                DayBlock(label: "Math · v = fλ", links: [
                    ScheduleVideoLink(title: "v = fλ intro", url: URL(string: "https://www.youtube.com/watch?v=TIGG17A9QFI")!, note: "Khan Academy — v = fλ intro")
                ]),
            ],
            .thursday: [
                DayBlock(label: "Chem · lab measurement", links: [
                    ScheduleVideoLink(title: "Significant figures", url: URL(string: "https://www.youtube.com/watch?v=hsSwf2_onlI")!, note: "Tyler DeWitt — Significant figures")
                ]),
                DayBlock(label: "Math · unit conversion review", links: [
                    ScheduleVideoLink(title: "Metric unit conversion", url: URL(string: "https://www.youtube.com/watch?v=w0nqd_HXHPQ")!, note: "Khan Academy — Metric unit conversion")
                ]),
            ],
            .friday: [
                DayBlock(label: "Bio · plants", links: [
                    ScheduleVideoLink(title: "Plant structure", url: URL(string: "https://www.youtube.com/watch?v=EAtt7iR9qDc")!, note: "Amoeba Sisters — Plant structure")
                ]),
                DayBlock(label: "Math · formula plug-in", links: [
                    ScheduleVideoLink(title: "v = d/t (formula plug-in)", url: URL(string: "https://www.youtube.com/watch?v=W6Ar0ls6tVA")!, note: "Khan Academy — v = d/t (formula plug-in)")
                ]),
            ],
        ],
        9: [
            .monday: [
                DayBlock(label: "Chem · atoms review", links: [
                    ScheduleVideoLink(title: "What's Inside an Atom?", url: URL(string: "https://www.youtube.com/watch?v=e9GuJUaX0UM")!, note: "Tyler DeWitt — What's Inside an Atom?"),
                    ScheduleVideoLink(title: "What are Isotopes?", url: URL(string: "https://www.youtube.com/watch?v=EboWeWmh5Pg")!, note: "Tyler DeWitt — What are Isotopes?")
                ]),
                DayBlock(label: "Phys · motion review", links: [
                    ScheduleVideoLink(title: "Speed and velocity", url: URL(string: "https://www.youtube.com/watch?v=W6Ar0ls6tVA")!, note: "Khan Academy — Speed and velocity")
                ]),
                DayBlock(label: "Math · sci notation", links: [
                    ScheduleVideoLink(title: "Scientific notation intro", url: URL(string: "https://www.youtube.com/watch?v=ClYdw4d4OmA")!, note: "Khan Academy — Scientific notation intro"),
                    ScheduleVideoLink(title: "Scientific notation examples", url: URL(string: "https://www.youtube.com/watch?v=i6lfVUp5RW8")!, note: "Khan Academy — Scientific notation examples")
                ]),
            ],
            .tuesday: [
                DayBlock(label: "Bio · cell review", links: [
                    ScheduleVideoLink(title: "Introduction to Cells", url: URL(string: "https://www.youtube.com/watch?v=8IlzKri08kk")!, note: "Amoeba Sisters — Introduction to Cells")
                ]),
                DayBlock(label: "Math · ratios", links: [
                    ScheduleVideoLink(title: "Unit rates", url: URL(string: "https://www.youtube.com/watch?v=Zm0KaIw-35k")!, note: "Khan Academy — Unit rates")
                ]),
            ],
            .wednesday: [
                DayBlock(label: "Phys · motion drill", links: [
                    ScheduleVideoLink(title: "Speed and velocity", url: URL(string: "https://www.youtube.com/watch?v=W6Ar0ls6tVA")!, note: "Khan Academy — Speed and velocity"),
                    ScheduleVideoLink(title: "Theory vs. law", url: URL(string: "https://www.youtube.com/watch?v=P30QlwSsUic")!, note: "Amoeba Sisters — Theory vs. law")
                ]),
                DayBlock(label: "Math · graphs", links: [
                    ScheduleVideoLink(title: "Slope from a graph", url: URL(string: "https://www.youtube.com/watch?v=R948Tsyq4vA")!, note: "Khan Academy — Slope from a graph")
                ]),
            ],
            .thursday: [
                DayBlock(label: "Chem · periodic table & compounds", links: [
                    ScheduleVideoLink(title: "Periodic table basics", url: URL(string: "https://www.youtube.com/watch?v=84780SzjGt0")!, note: "Periodic table basics"),
                    ScheduleVideoLink(title: "Writing ionic formulas", url: URL(string: "https://www.youtube.com/watch?v=URc75hoKGLY")!, note: "Tyler DeWitt — Writing ionic formulas")
                ]),
                DayBlock(label: "Math · unit conversion", links: [
                    ScheduleVideoLink(title: "Metric unit conversion", url: URL(string: "https://www.youtube.com/watch?v=w0nqd_HXHPQ")!, note: "Khan Academy — Metric unit conversion")
                ]),
            ],
            .friday: [
                DayBlock(label: "Bio · energy & organization", links: [
                    ScheduleVideoLink(title: "Photosynthesis & respiration", url: URL(string: "https://www.youtube.com/watch?v=OEO28tu_kJU")!, note: "Amoeba Sisters — Photosynthesis & respiration"),
                    ScheduleVideoLink(title: "Biological levels", url: URL(string: "https://www.youtube.com/watch?v=EtWknf1gzKo")!, note: "Amoeba Sisters — Biological levels")
                ]),
                DayBlock(label: "Math · flash review", links: [
                    ScheduleVideoLink(title: "Ratios flash review", url: URL(string: "https://www.youtube.com/watch?v=Zm0KaIw-35k")!, note: "Khan Academy — Ratios flash review"),
                    ScheduleVideoLink(title: "Mixed algebra review", url: URL(string: "https://www.youtube.com/watch?v=i6lfVUp5RW8")!, note: "Khan Academy — Mixed algebra review")
                ]),
            ],
        ],
        10: [
            .monday: [
                DayBlock(label: "Chem · acids & bases review", links: [
                    ScheduleVideoLink(title: "Acids and bases", url: URL(string: "https://www.youtube.com/watch?v=rdB9QwA0S5k")!, note: "Amoeba Sisters — Acids and bases")
                ]),
                DayBlock(label: "Math · formula substitution", links: [
                    ScheduleVideoLink(title: "v = d/t (formula plug-in)", url: URL(string: "https://www.youtube.com/watch?v=W6Ar0ls6tVA")!, note: "Khan Academy — v = d/t (formula plug-in)")
                ]),
            ],
            .tuesday: [
                DayBlock(label: "Bio · ecology review", links: [
                    ScheduleVideoLink(title: "Food chains & webs", url: URL(string: "https://www.youtube.com/watch?v=SyGM_Rd5XV4")!, note: "Amoeba Sisters — Food chains & webs")
                ]),
                DayBlock(label: "Math · graph reading", links: [
                    ScheduleVideoLink(title: "Read slope from graphs", url: URL(string: "https://www.youtube.com/watch?v=R948Tsyq4vA")!, note: "Khan Academy — Read slope from graphs")
                ]),
            ],
            .wednesday: [
                DayBlock(label: "Phys · energy & gravity review", links: [
                    ScheduleVideoLink(title: "Work and energy", url: URL(string: "https://www.youtube.com/watch?v=2WS1s2DHR_c")!, note: "Khan Academy — Work and energy"),
                    ScheduleVideoLink(title: "Kinetic & potential energy", url: URL(string: "https://www.youtube.com/watch?v=7K4V0NvUxr4")!, note: "Khan Academy — Kinetic & potential energy")
                ]),
                DayBlock(label: "Math · W = Fd", links: [
                    ScheduleVideoLink(title: "Work W = Fd", url: URL(string: "https://www.youtube.com/watch?v=2WS1s2DHR_c")!, note: "Khan Academy — Work W = Fd")
                ]),
            ],
            .thursday: [
                DayBlock(label: "Chem · solutions review", links: [
                    ScheduleVideoLink(title: "Solutions", url: URL(string: "https://www.youtube.com/watch?v=QWabcX1P1zI")!, note: "Tyler DeWitt — Solutions")
                ]),
                DayBlock(label: "Math · concentration ratios", links: [
                    ScheduleVideoLink(title: "Proportions (concentration)", url: URL(string: "https://www.youtube.com/watch?v=USMQhO0La7Y")!, note: "Khan Academy — Proportions (concentration)")
                ]),
            ],
            .friday: [
                DayBlock(label: "Bio · genetics · microbes · immunity", links: [
                    ScheduleVideoLink(title: "Punnett squares", url: URL(string: "https://www.youtube.com/watch?v=prkHKjf_oHE")!, note: "Amoeba Sisters — Punnett squares"),
                    ScheduleVideoLink(title: "Viruses", url: URL(string: "https://www.youtube.com/watch?v=cRcaqUoT3S8")!, note: "Amoeba Sisters — Viruses")
                ]),
                DayBlock(label: "Math · final review", links: [
                    ScheduleVideoLink(title: "Sci notation + formulas review", url: URL(string: "https://www.youtube.com/watch?v=ClYdw4d4OmA")!, note: "Khan Academy — Sci notation + formulas review"),
                    ScheduleVideoLink(title: "Unit rates", url: URL(string: "https://www.youtube.com/watch?v=Zm0KaIw-35k")!, note: "Khan Academy — Unit rates")
                ]),
            ],
        ],
    ]
}
