import Foundation

/// Typed routes for Today-tab navigation (avoids multiple NavigationLinks in one List row).
enum StudyNavigationRoute: Hashable {
    case topicDetail(StudyBlock)
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
    case elementFlashCards
}
