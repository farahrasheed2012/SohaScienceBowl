import Foundation

/// Soha missed BFN-C weeks 1–2 (Jun 8–19). **All** science — chem, bio, phys — is
/// right-shifted by 2 calendar weeks. Calendar week 3 (Jun 22) = Week 1 content for every subject.
enum ScheduleSplitTrack {
  static let preStartCalendarWeeks = 1...2
  static let contentShiftWeeks = 2
  static let scienceStartCalendarWeek = 3

  /// Curriculum week for a subject on a calendar week (`nil` = no block that day/week).
  static func contentWeek(subject: Subject, calendarWeek: Int) -> Int? {
    guard calendarWeek >= scienceStartCalendarWeek else { return nil }
    let week = calendarWeek - contentShiftWeeks
    guard (1...10).contains(week) else { return nil }
    return week
  }

  static func isPreStartWeek(calendarWeek: Int) -> Bool {
    preStartCalendarWeeks.contains(calendarWeek)
  }

  /// Backward-compatible name used in views.
  static func isChemOnlyWeek(calendarWeek: Int) -> Bool {
    isPreStartWeek(calendarWeek: calendarWeek)
  }

  static var bioPhysStartCalendarWeek: Int { scienceStartCalendarWeek }
  static var bioPhysShiftWeeks: Int { contentShiftWeeks }

  /// Track week number shown in banners (content week N).
  static func trackWeek(subject: Subject, calendarWeek: Int) -> Int? {
    contentWeek(subject: subject, calendarWeek: calendarWeek)
  }

  static func topicLabel(subject: Subject, calendarWeek: Int) -> String? {
    guard isPreStartWeek(calendarWeek: calendarWeek) else { return nil }
    return "Starts calendar week 3 · \(subject.rawValue) Week 1 content"
  }

  static func weekBanner(calendarWeek: Int) -> String {
    if isPreStartWeek(calendarWeek: calendarWeek) {
      return "Catch-up weeks — Chem/Bio/Phys Week 1 starts Jun 22"
    }
    guard let cw = trackWeek(subject: .chemistry, calendarWeek: calendarWeek) else {
      return "After summer science blocks"
    }
    if calendarWeek == scienceStartCalendarWeek {
      return "Week \(cw) · Chem · Bio · Phys — first science day"
    }
    if calendarWeek > 10 {
      return "Week \(cw) · Chem · Bio · Phys — after Aug 14"
    }
    return "Week \(cw) · Chem · Bio · Phys"
  }
}
