import Foundation

enum ScheduleConstants {
    static let studyStartDate: Date = {
        var c = DateComponents()
        c.year = 2026
        c.month = 6
        c.day = 8
        return Calendar.current.date(from: c) ?? Date()
    }()

    struct BuzzerSlot: Identifiable {
        var id: String { label }
        var weekday: Weekday
        var label: String
        var subject: Subject
        var duration: String
        var subjects: [Subject]
        var isMixed: Bool { subjects.count > 1 }

        init(weekday: Weekday, label: String, subject: Subject, duration: String, subjects: [Subject]? = nil) {
            self.weekday = weekday
            self.label = label
            self.subject = subject
            self.duration = duration
            self.subjects = subjects ?? [subject]
        }
    }

    static let buzzerSlots: [BuzzerSlot] = [
        BuzzerSlot(weekday: .monday, label: "Mon free 12:40 – 1:30", subject: .chemistry, duration: "10 min"),
        BuzzerSlot(weekday: .tuesday, label: "Tue free 3:00 PM+", subject: .biology, duration: "15 min"),
        BuzzerSlot(weekday: .wednesday, label: "Wed free 3:55 PM+", subject: .physics, duration: "10 min"),
        BuzzerSlot(weekday: .thursday, label: "Thu free 1:10 – 2:00", subject: .biology, duration: "15 min mixed", subjects: [.chemistry, .biology, .physics]),
        BuzzerSlot(weekday: .friday, label: "7:30 – 8:00 PM (optional)", subject: .biology, duration: "15 min")
    ]

    static func blockTimeLabel(day: Weekday, subject: Subject) -> String {
        switch (day, subject) {
        case (.monday, .chemistry): return "10:00 – 10:30 AM"
        case (.tuesday, .biology): return "10:00 – 10:30 AM"
        case (.wednesday, .physics): return "3:00 – 3:30 PM"
        case (.thursday, .chemistry): return "11:00 – 11:30 AM"
        case (.friday, .biology): return "3:00 – 3:30 PM"
        default: return "30 min block"
        }
    }

    static func weekNumber(for date: Date, calendar: Calendar = .current) -> Int {
        let start = calendar.startOfDay(for: studyStartDate)
        let target = calendar.startOfDay(for: date)
        let days = calendar.dateComponents([.day], from: start, to: target).day ?? 0
        if days < 0 { return 1 }
        if days > 69 { return 10 } // after Aug 14 summer review
        return min(10, max(1, (days / 7) + 1))
    }

    /// Pass 1: Jun 8 – Jul 3 · Pass 2: Jul 6 – Jul 31 · Pass 3: Aug 3 – Aug 14
    static func studyPass(for date: Date, calendar: Calendar = .current) -> StudyPass {
        func make(_ y: Int, _ m: Int, _ d: Int) -> Date {
            calendar.date(from: DateComponents(year: y, month: m, day: d)) ?? date
        }
        let pass2Start = make(2026, 7, 6)
        let pass3Start = make(2026, 8, 3)
        let day = calendar.startOfDay(for: date)
        if day >= pass3Start { return .pass3 }
        if day >= pass2Start { return .pass2 }
        return .pass1
    }

    static func passLabel(for pass: StudyPass) -> String {
        switch pass {
        case .pass1: return "Pass 1 · Mod + FLS"
        case .pass2: return "Pass 2 · Tro + CB"
        case .pass3: return "Pass 3 · Flash cards"
        }
    }
}

enum FormulaReference {
    struct FormulaItem: Identifiable {
        var id: String { text }
        var text: String
        var use: String
    }

    static let physics: [FormulaItem] = [
        FormulaItem(text: "v = d/t", use: "Speed from distance and time"),
        FormulaItem(text: "F = ma", use: "Force, mass, acceleration"),
        FormulaItem(text: "W = Fd", use: "Work"),
        FormulaItem(text: "P = W/t", use: "Power"),
        FormulaItem(text: "V = IR", use: "Ohm's law"),
        FormulaItem(text: "v = fλ", use: "Wave speed, frequency, wavelength"),
        FormulaItem(text: "PE = mgh", use: "Gravitational potential energy"),
        FormulaItem(text: "KE = ½mv²", use: "Kinetic energy")
    ]

    static let chemistry: [FormulaItem] = [
        FormulaItem(text: "Z = # protons", use: "Atomic number defines the element"),
        FormulaItem(text: "A = p + n", use: "Mass number"),
        FormulaItem(text: "M = mol/L", use: "Molarity"),
        FormulaItem(text: "d = m/V", use: "Density")
    ]

    static let biology: [FormulaItem] = [
        FormulaItem(text: "Photosynthesis", use: "Chloroplast · CO₂ + H₂O + light → glucose + O₂"),
        FormulaItem(text: "Cellular respiration", use: "Mitochondria · glucose + O₂ → CO₂ + H₂O + ATP")
    ]

    static let elements: [String] = [
        "H", "He", "Li", "Be", "B", "C", "N", "O", "F", "Ne",
        "Na", "Mg", "Al", "Si", "P", "S", "Cl", "Ar", "K", "Ca"
    ]
}
