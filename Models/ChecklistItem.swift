import Foundation

struct ChecklistItem: Identifiable, Codable, Hashable {
    var id: UUID
    var subject: Subject
    var category: String
    var description: String
    var isCompleted: Bool
}
