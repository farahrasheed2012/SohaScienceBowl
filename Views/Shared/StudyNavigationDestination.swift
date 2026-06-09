import SwiftUI

extension View {
    func studyNavigationDestinations() -> some View {
        navigationDestination(for: StudyNavigationRoute.self) { route in
            switch route {
            case .topicDetail(let block):
                TopicDetailView(block: block)
            case .mathTopicDetail(let ref):
                MathTopicDetailView(week: ref.week, day: ref.day)
            case .studyMaterial(let block):
                BlockStudyMaterialView(block: block)
            case .fullSession(let block):
                StudySessionView(block: block, initialStage: .read)
            case .planDrill(let request):
                PlanDrillView(request: request)
            case .topicBrowser(let initialWeek):
                TopicBrowserView(initialWeek: initialWeek)
            case .formulaReference:
                FormulaReferenceView()
            case .encyclopediaSubject(let subject):
                EncyclopediaTopicListView(subject: subject)
            case .encyclopediaTopic(let id):
                EncyclopediaTopicDetailView(topicId: id)
            case .encyclopediaPractice(let mode, let topicIds):
                EncyclopediaPracticeSetupView(mode: mode, preferredTopicIds: topicIds)
            case .periodicTableDrill:
                PeriodicTableDrillSetupView()
            case .periodicTableReference:
                PeriodicTableReferenceView()
            case .elementFlashCards:
                ElementFlashCardDeckView()
            case .weakAreaReview:
                PlanDrillView(request: .weakAreaReview())
            case .buzzerRemote:
                BuzzerRemoteView()
            case .regionalSprint:
                RegionalSprintRootView()
            case .regionalSprintPack(let packId):
                RegionalSprintPackDetailView(packId: packId)
            case .regionalSprintMixed(let track):
                PlanDrillView(request: track.map { .regionalSprint(track: $0) } ?? .regionalSprintMixed())
            }
        }
    }
}
