import Foundation

struct RecentQuestionRecord: Codable, Hashable {
    var normalizedKey: String
    var lastSeen: Date
}

/// Tracks recently shown quiz questions so drills prefer fresh content.
enum RecentQuestionStore {
    static let retentionDays = 7
    static let maxRecords = 200
    private static let storageKey = "recentQuestionRecords"

    static func record(_ question: UnifiedQuestion) {
        record(normalizedKey: question.normalizedText)
    }

    static func record(normalizedKey: String) {
        let key = normalizedKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !key.isEmpty else { return }

        var records = load()
        records.removeAll { $0.normalizedKey == key }
        records.insert(RecentQuestionRecord(normalizedKey: key, lastSeen: Date()), at: 0)

        let cutoff = Calendar.current.date(byAdding: .day, value: -retentionDays, to: Date()) ?? Date.distantPast
        records = records.filter { $0.lastSeen >= cutoff }
        if records.count > maxRecords {
            records = Array(records.prefix(maxRecords))
        }

        save(records)
    }

    static func recentKeys(withinDays days: Int = retentionDays) -> Set<String> {
        let cutoff = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date.distantPast
        return Set(load().filter { $0.lastSeen >= cutoff }.map(\.normalizedKey))
    }

    static func lastSeen(for key: String) -> Date? {
        load().first { $0.normalizedKey == key }?.lastSeen
    }

    /// Prefer unseen questions; fill remaining slots with least-recently-seen repeats.
    static func prioritizeFresh(_ questions: [UnifiedQuestion], limit: Int) -> [UnifiedQuestion] {
        guard limit > 0 else { return [] }

        let recent = recentKeys()
        let unseen = questions.filter { !recent.contains($0.normalizedText) }.shuffled()
        let seen = questions.filter { recent.contains($0.normalizedText) }
            .sorted {
                let left = lastSeen(for: $0.normalizedText) ?? .distantPast
                let right = lastSeen(for: $1.normalizedText) ?? .distantPast
                return left < right
            }

        var result: [UnifiedQuestion] = []
        var seenKeys = Set<String>()

        for question in unseen + seen {
            let key = question.normalizedText
            guard !seenKeys.contains(key) else { continue }
            seenKeys.insert(key)
            result.append(question)
            if result.count >= limit { break }
        }

        return result
    }

    private static func load() -> [RecentQuestionRecord] {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return [] }
        return (try? JSONDecoder().decode([RecentQuestionRecord].self, from: data)) ?? []
    }

    private static func save(_ records: [RecentQuestionRecord]) {
        if let data = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}
