import Foundation

/// Week + weekday for daily math reading (OpenStax + Lar + BFN-A).
struct MathTopicRef: Hashable {
    let week: Int
    let day: Weekday
}

/// Typed routes for Today-tab navigation (avoids multiple NavigationLinks in one List row).
enum StudyNavigationRoute: Hashable {
    case topicDetail(StudyBlock)
    case mathTopicDetail(MathTopicRef)
    case studyMaterial(StudyBlock)
    case fullSession(StudyBlock)
    case planDrill(PlanDrillRequest)
    case topicBrowser(initialWeek: Int?)
    case formulaReference
    case encyclopediaSubject(NSBSubject)
    case encyclopediaTopic(id: String)
    case encyclopediaPractice(EncyclopediaPracticeMode, topicIds: [String]?)
    case periodicTableDrill
    case periodicTableReference
    case periodicTableInteractive
    case periodicTablePrint
    case elementFlashCards
    case weakAreaReview
    case buzzerRemote
    case regionalSprint
    case regionalSprintPack(String)
    case regionalSprintMixed(RegionalSprintCatalog.Track?)
    case hewittChapter17
    case miniGamesHub
    case miniGame(MiniGameRoute)
}
