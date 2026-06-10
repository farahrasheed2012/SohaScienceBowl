import Foundation

enum ScheduleConstants {
    /// Target number of toss-ups for a single day's topic / block quiz.
    static let dayTopicQuizQuestionCount = 30

    /// Science Bowl study session length (matches summer timetable science block).
    static let scienceSessionMinutes = 60

    /// Algebra block length on the summer timetable (Mon–Fri).
    static let algebraSessionMinutes = 60

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
        case (.monday, .chemistry): return "10:00 – 11:00 AM"
        case (.tuesday, .biology): return "10:00 – 11:00 AM"
        case (.wednesday, .physics): return "3:00 – 4:00 PM"
        case (.thursday, .chemistry): return "11:00 AM – 12:00 PM"
        case (.friday, .biology): return "3:00 – 4:00 PM"
        default: return "1 hr block"
        }
    }

    static func mathBlockTimeLabel(day: Weekday) -> String {
        switch day {
        case .monday: return "11:15 AM – 12:15 PM"
        case .tuesday: return "11:15 AM – 12:15 PM"
        case .wednesday: return "1:15 – 2:15 PM"
        case .thursday: return "12:15 – 1:15 PM"
        case .friday: return "4:00 – 5:00 PM"
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

    static func weekStartDate(for week: Int, calendar: Calendar = .current) -> Date? {
        guard (1...10).contains(week) else { return nil }
        return calendar.date(byAdding: .day, value: (week - 1) * 7, to: studyStartDate)
    }

    static func weekDateRangeLabel(for week: Int, calendar: Calendar = .current) -> String {
        guard let start = weekStartDate(for: week, calendar: calendar),
              let end = calendar.date(byAdding: .day, value: 6, to: start)
        else { return "Week \(week)" }

        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMM d"

        let startText = formatter.string(from: start)
        let endText = formatter.string(from: end)
        if calendar.component(.month, from: start) == calendar.component(.month, from: end) {
            formatter.dateFormat = "d"
            return "\(startText) – \(formatter.string(from: end))"
        }
        return "\(startText) – \(endText)"
    }

    static func studyPass(forWeek week: Int, calendar: Calendar = .current) -> StudyPass { .pass1 }

    /// Single summer pass — one careful read through Mod + FLS/OSB + Expl across 10 weeks.
    static func studyPass(for date: Date, calendar: Calendar = .current) -> StudyPass { .pass1 }

    static func passLabel(for pass: StudyPass) -> String {
        "Summer · Modern Chemistry + Focus on Life Science + Explorations"
    }

    static func summerPlanLabel() -> String {
        "10-week summer plan · 50 science blocks · 1 hr each · Jun 8 – Aug 14"
    }

    /// Short topic label for each week (one linear summer pass — not “Pass 1/2 rotation”).
    static func weekThemeLabel(for week: Int) -> String {
        switch week {
        case 1: return "Atoms · cells · motion"
        case 2: return "Matter · genetics · Newton's"
        case 3: return "Acids · ecology · forces"
        case 4: return "Evolution · waves · periodic trends"
        case 5: return "Energy in life & physics"
        case 6: return "Ecology & solutions"
        case 7: return "Immunity & momentum"
        case 8: return "Plants & electricity"
        case 9: return "Circuits & body systems"
        case 10: return "Summer capstone"
        default: return "Week \(week)"
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
