import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct ProgressBackupFileDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }

    var data: Data

    init(data: Data) {
        self.data = data
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw ProgressBackupError.invalidFormat
        }
        self.data = data
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: data)
    }
}

enum ProgressBackupService {
    @MainActor
    static func makeBackup(from appState: AppState) -> ProgressBackup {
        let encyclopedia = appState.encyclopedia
        return ProgressBackup(
            version: ProgressBackup.currentVersion,
            exportedAt: Date(),
            appName: "ScienceBowlCoach",
            settings: ProgressBackup.SettingsSnapshot(
                currentWeek: appState.currentWeek,
                currentPass: appState.currentPass,
                showSessionTimer: appState.showSessionTimer,
                parentReadsAloud: appState.parentReadsAloud,
                autoSyncScheduleFromCalendar: appState.autoSyncScheduleFromCalendar,
                weekManuallySet: appState.weekManuallySet,
                passManuallySet: appState.passManuallySet,
                appAppearance: appState.appAppearance
            ),
            checklistItems: appState.checklistItems,
            drillResults: appState.drillResults,
            notebookEntries: appState.notebookEntries,
            flashCards: appState.flashCards,
            topicStats: appState.topicStats,
            importedQuestions: appState.importedQuestions,
            duplicateStats: appState.duplicateStats,
            encyclopedia: ProgressBackup.EncyclopediaSnapshot(
                reviewedTopicIds: Array(encyclopedia.reviewedTopicIds),
                sessionHistory: encyclopedia.sessionHistory,
                wrongCountPerTopicId: encyclopedia.wrongCountPerTopicId,
                currentStreak: encyclopedia.currentStreak,
                lastStudyDate: encyclopedia.lastStudyDate
            ),
            elementCorrectCounts: ElementProgressStore.correctCounts,
            elementFlashCardsSeeded: ElementProgressStore.flashCardsSeeded,
            textbookCompletedChapterIds: Array(appState.textbookReading.completedChapterIds),
            textbookCompletedSectionIds: Array(appState.textbookReading.completedSectionIds)
        )
    }

    static func encode(_ backup: ProgressBackup) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(backup)
    }

    static func decode(_ data: Data) throws -> ProgressBackup {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard let backup = try? decoder.decode(ProgressBackup.self, from: data) else {
            throw ProgressBackupError.invalidFormat
        }
        if backup.version > ProgressBackup.currentVersion {
            throw ProgressBackupError.unsupportedVersion(backup.version)
        }
        if backup.appName != "ScienceBowlCoach" {
            throw ProgressBackupError.wrongApp(backup.appName)
        }
        return backup
    }

    static func defaultFilename(for date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return "ScienceBowlCoach-Progress-\(formatter.string(from: date)).json"
    }

    @MainActor
    static func writeTemporaryExport(from appState: AppState) throws -> URL {
        let backup = makeBackup(from: appState)
        let data = try encode(backup)
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(defaultFilename(for: backup.exportedAt))
        try data.write(to: url, options: .atomic)
        return url
    }

    @MainActor
    static func apply(_ backup: ProgressBackup, to appState: AppState) {
        let settings = backup.settings
        appState.currentWeek = settings.currentWeek
        appState.currentPass = settings.currentPass
        appState.showSessionTimer = settings.showSessionTimer
        appState.parentReadsAloud = settings.parentReadsAloud
        appState.autoSyncScheduleFromCalendar = settings.autoSyncScheduleFromCalendar
        appState.weekManuallySet = settings.weekManuallySet
        appState.passManuallySet = settings.passManuallySet
        appState.appAppearance = settings.appAppearance

        appState.checklistItems = backup.checklistItems
        appState.drillResults = backup.drillResults
        appState.notebookEntries = backup.notebookEntries
        appState.flashCards = backup.flashCards
        appState.topicStats = backup.topicStats
        appState.importedQuestions = backup.importedQuestions
        appState.duplicateStats = backup.duplicateStats

        appState.encyclopedia.importSnapshot(backup.encyclopedia)

        if let counts = backup.elementCorrectCounts {
            ElementProgressStore.importCounts(counts)
        }
        if let seeded = backup.elementFlashCardsSeeded {
            ElementProgressStore.flashCardsSeeded = seeded
        }
        if let chapters = backup.textbookCompletedChapterIds,
           let sections = backup.textbookCompletedSectionIds {
            appState.textbookReading.importSnapshot(chapters: chapters, sections: sections)
        } else if let chapters = backup.textbookCompletedChapterIds {
            appState.textbookReading.importSnapshot(chapters: chapters, sections: [])
        }

        PersistenceService.saveChecklist(appState.checklistItems)
        PersistenceService.saveDrillResults(appState.drillResults)
        PersistenceService.saveNotebook(appState.notebookEntries)
        PersistenceService.saveFlashCards(appState.flashCards)
        PersistenceService.saveTopicStats(appState.topicStats)
        PersistenceService.saveImportedQuestions(appState.importedQuestions)
        PersistenceService.saveDuplicateStats(appState.duplicateStats)
    }

    static func summary(for backup: ProgressBackup) -> String {
        let reviewed = backup.encyclopedia.reviewedTopicIds.count
        let drills = backup.drillResults.count
        let sessions = backup.encyclopedia.sessionHistory.count
        let cards = backup.flashCards.count
        let elements = backup.elementCorrectCounts?.count ?? 0
        let textbookChapters = backup.textbookCompletedChapterIds?.count ?? 0
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        var parts = [
            "Exported \(formatter.string(from: backup.exportedAt))",
            "\(drills) drills",
            "\(sessions) encyclopedia sessions",
            "\(reviewed) topics reviewed",
            "\(cards) flash cards"
        ]
        if elements > 0 {
            parts.append("\(elements) element drill scores")
        }
        if textbookChapters > 0 {
            parts.append("\(textbookChapters) textbook chapters checked")
        }
        return parts.joined(separator: " · ")
    }
}
