import SwiftUI

extension View {
    func studyNavigationDestinations() -> some View {
        navigationDestination(for: StudyNavigationRoute.self) { route in
            switch route {
            case .topicDetail(let block):
                TopicDetailView(block: block)
            case .studyMaterial(let block):
                BlockStudyMaterialView(block: block)
            case .fullSession(let block):
                StudySessionView(block: block, initialStage: .read)
            case .planDrill(let request):
                PlanDrillView(request: request)
            case .topicBrowser(let initialWeek):
                TopicBrowserView(initialWeek: initialWeek)
            case .weekPlan:
                TopicBrowserView(initialWeek: nil)
            case .formulaReference:
                FormulaReferenceView()
            }
        }
    }
}
