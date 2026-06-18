import Foundation

extension AppState {
    func hewittChapter17Questions(limit: Int = 30) -> [UnifiedQuestion] {
        encyclopedia.questions(
            forTopicIds: [HewittChapter17Catalog.topicId],
            limit: limit,
            type: nil
        ).map { $0.toUnified() }
    }
}
