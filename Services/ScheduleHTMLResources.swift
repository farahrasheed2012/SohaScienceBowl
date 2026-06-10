import Foundation
#if os(macOS)
import AppKit
#endif

/// Bundled summer schedule HTML (synced from SohaAli/Schedule via Scripts/sync_schedule_html.py).
enum ScheduleHTMLResources {
    enum Document: String, CaseIterable, Identifiable {
        case weeklyTimetable = "weekly-timetable"
        case summerWhiteboard = "summer-2026-whiteboard"
        case scienceBowlPrep = "science-bowl-prep"
        case periodicTableStudy = "periodic-table-study"
        case periodicTablePrint = "periodic-table-print"

        var id: String { rawValue }

        var title: String {
            switch self {
            case .weeklyTimetable: return "Weekly timetable"
            case .summerWhiteboard: return "Summer whiteboard (10 weeks)"
            case .scienceBowlPrep: return "Science Bowl prep guide"
            case .periodicTableStudy: return "Periodic table (study)"
            case .periodicTablePrint: return "Periodic table (print)"
            }
        }

        var subtitle: String {
            switch self {
            case .weeklyTimetable: return "When · 1 hr science + 1 hr algebra · Mon–Fri"
            case .summerWhiteboard: return "What to read each week · one summer pass"
            case .scienceBowlPrep: return "Books · chapters · study method"
            case .periodicTableStudy: return "First 20 elements + trends"
            case .periodicTablePrint: return "Printable reference sheet"
            }
        }

        var systemImage: String {
            switch self {
            case .weeklyTimetable: return "clock"
            case .summerWhiteboard: return "calendar"
            case .scienceBowlPrep: return "book"
            case .periodicTableStudy, .periodicTablePrint: return "tablecells"
            }
        }

        /// Documents with 10-week sections that support in-page jump.
        var supportsWeekNavigation: Bool {
            switch self {
            case .summerWhiteboard, .scienceBowlPrep: return true
            default: return false
            }
        }
    }

    static func url(for document: Document) -> URL? {
        Bundle.main.url(forResource: document.rawValue, withExtension: "html", subdirectory: "Schedule")
            ?? Bundle.main.url(forResource: document.rawValue, withExtension: "html")
    }

    #if os(macOS)
    static func openExternally(_ document: Document) {
        guard let url = url(for: document) else { return }
        NSWorkspace.shared.open(url)
    }
    #endif
}
