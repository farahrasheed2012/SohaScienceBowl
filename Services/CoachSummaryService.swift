import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct CoachSummaryFileDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.plainText] }

    var data: Data

    init(text: String) {
        self.data = Data(text.utf8)
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.data = data
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: data)
    }
}

/// Plain-text coach summary for parents — week theme, accuracy, checklist, weak spots.
enum CoachSummaryService {
    @MainActor
    static func generate(from appState: AppState) -> String {
        let week = appState.currentWeek
        let pass = ScheduleConstants.passLabel(for: appState.currentPass)
        let theme = appState.weekTheme(for: week)
        let date = formattedDate(Date())

        var lines: [String] = [
            "Science Bowl Coach — Coach Summary",
            "Generated: \(date)",
            "",
            "Study plan",
            "· Week \(week) · \(theme)",
            "· \(pass)",
            "· Study streak: \(appState.studyStreakDays) day\(appState.studyStreakDays == 1 ? "" : "s")",
            "",
            "This week by subject",
        ]

        for subject in Subject.allCases {
            let pct = Int(appState.weekAccuracy(subject: subject) * 100)
            let answered = appState.drillResults
                .filter {
                    Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .weekOfYear)
                        && $0.subject == subject
                }
                .reduce(0) { $0 + $1.total }
            lines.append("· \(subject.rawValue): \(pct)% correct (\(answered) questions this week)")
        }

        let checklistDone = appState.checklistItems.filter(\.isCompleted).count
        let checklistTotal = appState.checklistItems.count
        lines.append("")
        lines.append("Checklist: \(checklistDone)/\(checklistTotal) (\(percent(checklistDone, checklistTotal))%)")
        lines.append("Elements mastered: \(appState.elementMasteredCount)/\(ElementData.first20.count)")
        lines.append("Flash cards due today: \(appState.flashCardsDueToday.count)")
        lines.append("Lifetime questions: \(appState.lifetimeQuestionsAnswered())")

        let weak = appState.weakTopics.prefix(5).map(\.topic)
        if !weak.isEmpty {
            lines.append("")
            lines.append("Weakest topics")
            for topic in weak {
                lines.append("· \(topic)")
            }
        }

        let summary = appState.fridaySummary()
        if !summary.commonMisses.isEmpty {
            lines.append("")
            lines.append("Common notebook misses")
            for miss in summary.commonMisses {
                lines.append("· \(miss)")
            }
        }

        let badges = appState.earnedBadges()
        if !badges.isEmpty {
            lines.append("")
            lines.append("Badges earned")
            for badge in badges {
                lines.append("· \(badge.title)")
            }
        }

        lines.append("")
        lines.append("DOE question bank: \(appState.doeStore.doeQuestions.count) questions")
        if appState.doeStore.usesBundledStarter {
            lines.append("· Using bundled starter cache — download full PDFs in Settings for more.")
        }
        lines.append(appState.doeStore.drillReadinessLabel)

        lines.append("")
        lines.append("— Exported from Science Bowl Coach for Soha · NSB Middle School")

        return lines.joined(separator: "\n")
    }

    static func defaultFilename() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return "science-bowl-coach-summary-\(formatter.string(from: Date())).txt"
    }

    private static func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private static func percent(_ part: Int, _ total: Int) -> Int {
        guard total > 0 else { return 0 }
        return Int((Double(part) / Double(total)) * 100)
    }
}
