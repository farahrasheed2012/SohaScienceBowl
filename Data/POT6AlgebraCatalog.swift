import Foundation

/// POT 6 algebra / stats track — all school topics except the geometry track (see `POT6GeometryCatalog`).
enum POT6AlgebraCatalog {
    static let schoolCodes: [String] = {
        let geometry = Set(POT6GeometryCatalog.schoolCodes)
        return POT6TopicRegistry.schoolTopics
            .map(\.code)
            .filter { !geometry.contains($0) }
    }()

    static func schoolTopics() -> [MathTopic] {
        schoolCodes.compactMap { POT6TopicRegistry.topic(for: $0) }
    }

    static func contains(code: String) -> Bool {
        schoolCodes.contains(code)
    }
}
