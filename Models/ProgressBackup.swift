import Foundation

/// Full progress snapshot for export/import via JSON file.
struct ProgressBackup: Codable {
    static let currentVersion = 3
    static let fileExtension = "json"
    static let contentTypeIdentifier = "public.json"

    var version: Int
    var exportedAt: Date
    var appName: String

    var settings: SettingsSnapshot
    var checklistItems: [ChecklistItem]
    var drillResults: [DrillResult]
    var notebookEntries: [NotebookEntry]
    var flashCards: [FlashCardItem]
    var topicStats: [TopicStats]
    var importedQuestions: [UnifiedQuestion]
    var duplicateStats: [DuplicateImportStats]
    var encyclopedia: EncyclopediaSnapshot
    var elementCorrectCounts: [String: Int]?
    var elementFlashCardsSeeded: Bool?
    var textbookCompletedChapterIds: [String]?
    var textbookCompletedSectionIds: [String]?

    struct SettingsSnapshot: Codable {
        var currentWeek: Int
        var currentPass: StudyPass
        var showSessionTimer: Bool
        var parentReadsAloud: Bool
        var autoSyncScheduleFromCalendar: Bool
        var weekManuallySet: Bool
        var passManuallySet: Bool
        var appAppearance: AppAppearance
    }

    struct EncyclopediaSnapshot: Codable {
        var reviewedTopicIds: [String]
        var sessionHistory: [EncyclopediaSessionRecord]
        var wrongCountPerTopicId: [String: Int]
        var currentStreak: Int
        var lastStudyDate: Date?
    }
}

enum ProgressBackupError: LocalizedError {
    case unsupportedVersion(Int)
    case invalidFormat
    case wrongApp(String)

    var errorDescription: String? {
        switch self {
        case .unsupportedVersion(let version):
            return "This backup file (version \(version)) is newer than the app supports."
        case .invalidFormat:
            return "Could not read the backup file. Make sure it is a Science Bowl Coach progress export."
        case .wrongApp(let name):
            return "This file looks like a backup from \"\(name)\", not Science Bowl Coach."
        }
    }
}
