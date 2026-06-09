import Foundation

@MainActor
@Observable
final class TextbookReadingProgressStore {
    private static let chaptersKey = "textbook_completed_chapters"
    private static let sectionsKey = "textbook_completed_sections"

    var completedChapterIds: Set<String> = []
    var completedSectionIds: Set<String> = []

    init() {
        load()
    }

    func isChapterComplete(chapterId: String, sectionIds: [String] = []) -> Bool {
        if completedChapterIds.contains(chapterId) { return true }
        guard !sectionIds.isEmpty else { return false }
        return sectionIds.allSatisfy { completedSectionIds.contains($0) }
    }

    func completedSectionCount(chapterId: String, sectionIds: [String]) -> Int {
        if completedChapterIds.contains(chapterId) { return sectionIds.count }
        return sectionIds.filter { completedSectionIds.contains($0) }.count
    }

    func toggleChapter(chapterId: String, sectionIds: [String]) {
        let markComplete = !isChapterComplete(chapterId: chapterId, sectionIds: sectionIds)
        if markComplete {
            completedChapterIds.insert(chapterId)
            for sectionId in sectionIds {
                completedSectionIds.insert(sectionId)
            }
        } else {
            completedChapterIds.remove(chapterId)
            for sectionId in sectionIds {
                completedSectionIds.remove(sectionId)
            }
        }
        save()
    }

    func toggleSection(sectionId: String, chapterId: String, allSectionIds: [String]) {
        if completedSectionIds.contains(sectionId) {
            completedSectionIds.remove(sectionId)
            completedChapterIds.remove(chapterId)
        } else {
            completedSectionIds.insert(sectionId)
            if allSectionIds.allSatisfy({ completedSectionIds.contains($0) }) {
                completedChapterIds.insert(chapterId)
            }
        }
        save()
    }

    func toggleSimpleChapter(_ chapterId: String) {
        if completedChapterIds.contains(chapterId) {
            completedChapterIds.remove(chapterId)
        } else {
            completedChapterIds.insert(chapterId)
        }
        save()
    }

    func isSectionComplete(sectionId: String, chapterId: String, allSectionIds: [String]) -> Bool {
        if completedSectionIds.contains(sectionId) { return true }
        return isChapterComplete(chapterId: chapterId, sectionIds: allSectionIds)
    }

    func reset() {
        completedChapterIds = []
        completedSectionIds = []
        UserDefaults.standard.removeObject(forKey: Self.chaptersKey)
        UserDefaults.standard.removeObject(forKey: Self.sectionsKey)
    }

    func importSnapshot(chapters: [String], sections: [String]) {
        completedChapterIds = Set(chapters)
        completedSectionIds = Set(sections)
        save()
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: Self.chaptersKey),
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
            completedChapterIds = decoded
        }
        if let data = UserDefaults.standard.data(forKey: Self.sectionsKey),
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
            completedSectionIds = decoded
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(completedChapterIds) {
            UserDefaults.standard.set(data, forKey: Self.chaptersKey)
        }
        if let data = try? JSONEncoder().encode(completedSectionIds) {
            UserDefaults.standard.set(data, forKey: Self.sectionsKey)
        }
    }
}
