import Foundation

/// Typed routes for Today-tab navigation (avoids multiple NavigationLinks in one List row).
enum StudyNavigationRoute: Hashable {
    case topicDetail(StudyBlock)
    case studyMaterial(StudyBlock)
    case fullSession(StudyBlock)
    case planDrill(PlanDrillRequest)
    case topicBrowser(initialWeek: Int?)
    case weekPlan
    case formulaReference
}
