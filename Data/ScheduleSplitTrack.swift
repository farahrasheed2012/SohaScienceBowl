import Foundation

/// Soha did chemistry only in calendar weeks 1–2 (Jun 8–19). Biology and physics are
/// right-shifted by 2 calendar weeks — same curriculum order, not skipped to August.
enum ScheduleSplitTrack {
  static let chemOnlyCalendarWeeks = 1...2
  static let bioPhysShiftWeeks = 2
  static let bioPhysStartCalendarWeek = 3

  /// Curriculum week for a subject on a calendar week (`nil` = no block that day/week).
  static func contentWeek(subject: Subject, calendarWeek: Int) -> Int? {
    switch subject {
    case .chemistry:
      guard (1...10).contains(calendarWeek) else { return nil }
      return calendarWeek
    case .biology, .physics:
      guard calendarWeek >= bioPhysStartCalendarWeek else { return nil }
      let week = calendarWeek - bioPhysShiftWeeks
      guard (1...10).contains(week) else { return nil }
      return week
    }
  }

  static func isChemOnlyWeek(calendarWeek: Int) -> Bool {
    chemOnlyCalendarWeeks.contains(calendarWeek)
  }

  /// Track week number shown in banners (Chem / Bio / Phys week N).
  static func trackWeek(subject: Subject, calendarWeek: Int) -> Int? {
    contentWeek(subject: subject, calendarWeek: calendarWeek)
  }

  static func topicLabel(subject: Subject, calendarWeek: Int) -> String? {
    guard isChemOnlyWeek(calendarWeek: calendarWeek) else { return nil }
    switch subject {
    case .biology, .physics:
      return "Starts calendar week 3 · \(subject.rawValue) Week 1 content"
    case .chemistry:
      return nil
    }
  }

  static func weekBanner(calendarWeek: Int) -> String {
    let chem = trackWeek(subject: .chemistry, calendarWeek: calendarWeek) ?? calendarWeek
    if isChemOnlyWeek(calendarWeek: calendarWeek) {
      return "Chem Week \(chem) · Bio shifts to week 3 · Phys shifts to week 3"
    }
    let bio = trackWeek(subject: .biology, calendarWeek: calendarWeek).map { "Bio Week \($0)" } ?? "Bio"
    let phys = trackWeek(subject: .physics, calendarWeek: calendarWeek).map { "Phys Week \($0)" } ?? "Phys"
    if calendarWeek == bioPhysStartCalendarWeek {
      return "Chem Week \(chem) · \(bio) · \(phys) — first bio/phys day"
    }
    return "Chem Week \(chem) · \(bio) · \(phys)"
  }
}
