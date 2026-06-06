import Foundation

struct ReadingSection: Identifiable, Hashable {
    var id: String
    var title: String
    var body: String

    init(title: String, body: String) {
        self.id = title
        self.title = title
        self.body = body
    }
}
