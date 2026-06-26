import Foundation

@MainActor
@Observable
final class EncyclopediaStore {
    var topics: [NSBTopic] = []
    var questions: [NSBQuestion] = []
    var reviewedTopicIds: Set<String> = []
    var sessionHistory: [EncyclopediaSessionRecord] = []
    var wrongCountPerTopicId: [String: Int] = [:]
    var currentStreak: Int = 0
    var lastStudyDate: Date?

    private let reviewedKey = "encyclopedia_reviewed_topic_ids"
    private let sessionsKey = "encyclopedia_session_history"
    private let lastStudyDateKey = "encyclopedia_last_study_date"
    private let streakKey = "encyclopedia_current_streak"
    private let wrongKey = "encyclopedia_wrong_topic_count"

    private var questionCountByTopicId: [String: Int] = [:]

    init() {
        loadContent()
        loadProgress()
    }

    func loadContent() {
        topics = loadJSON(named: "topics", as: [NSBTopic].self) ?? []
        var loaded = loadJSON(named: "questions", as: [NSBQuestion].self) ?? []
        if let hewitt = loadJSON(named: "hewitt_ch17_questions", as: [NSBQuestion].self) {
            loaded.append(contentsOf: hewitt)
        }
        questions = loaded
        rebuildQuestionCounts()
    }

    private func rebuildQuestionCounts() {
        questionCountByTopicId = Dictionary(grouping: questions, by: \.topicId).mapValues(\.count)
    }

    func questionCount(for topicId: String) -> Int {
        questionCountByTopicId[topicId] ?? 0
    }

    func practiceCoverage(for topicId: String) -> EncyclopediaPracticeCoverage {
        EncyclopediaPracticeCoverage(questionCount: questionCount(for: topicId))
    }

    var topicsWithAdequatePractice: Int {
        topics.filter { practiceCoverage(for: $0.id) == .ready }.count
    }

    var topicsMissingPractice: Int {
        topics.filter { practiceCoverage(for: $0.id) == .none }.count
    }

    var topicsWithThinPractice: Int {
        topics.filter { practiceCoverage(for: $0.id) == .thin }.count
    }

    func practiceCoverageSummary(for subject: NSBSubject) -> (ready: Int, thin: Int, none: Int, total: Int) {
        let subjectTopics = topics(for: subject)
        var ready = 0
        var thin = 0
        var none = 0
        for topic in subjectTopics {
            switch practiceCoverage(for: topic.id) {
            case .ready: ready += 1
            case .thin: thin += 1
            case .none: none += 1
            }
        }
        return (ready, thin, none, subjectTopics.count)
    }

    private func loadJSON<T: Decodable>(named name: String, as type: T.Type) -> T? {
        let url = Bundle.main.url(forResource: name, withExtension: "json", subdirectory: "StudyContent")
            ?? Bundle.main.url(forResource: name, withExtension: "json")
        guard let url, let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }

    func topics(for subject: NSBSubject) -> [NSBTopic] {
        topics.filter { $0.subject == subject.rawValue }
    }

    func topic(byId id: String) -> NSBTopic? {
        topics.first { $0.id == id }
    }

    func relatedTopics(for block: StudyBlock) -> [NSBTopic] {
        let subjectNames: [String] = switch block.subject {
        case .biology: ["Life Science"]
        case .chemistry: ["Chemistry", "Physical Science"]
        case .physics: ["Physical Science", "Energy"]
        case .math: []
        }
        let candidates = topics.filter { subjectNames.contains($0.subject) }
        let queryWords = Set(
            block.primaryTopic.lowercased()
                .components(separatedBy: CharacterSet.alphanumerics.inverted)
                .filter { $0.count > 2 }
        )
        let chapterWords = Set(
            block.chapterTitle.lowercased()
                .components(separatedBy: CharacterSet.alphanumerics.inverted)
                .filter { $0.count > 2 }
        )
        let keywords = queryWords.union(chapterWords)

        let scored = candidates.map { topic -> (NSBTopic, Int) in
            let title = topic.title.lowercased()
            var score = 0
            for word in keywords where title.contains(word) { score += 2 }
            if block.primaryTopic.lowercased().contains(title) || title.contains(block.primaryTopic.lowercased()) {
                score += 5
            }
            return (topic, score)
        }
        .filter { $0.1 > 0 }
        .sorted { $0.1 > $1.1 }
        .map(\.0)

        if scored.isEmpty {
            return Array(candidates.prefix(3))
        }
        return Array(scored.prefix(5))
    }

    /// Best encyclopedia article for a drill question (explicit id, then topic-title match).
    func topic(forQuestion question: UnifiedQuestion) -> NSBTopic? {
        if let topicId = question.topicId, let topic = topic(byId: topicId) {
            return topic
        }
        let label = question.topic.trimmingCharacters(in: .whitespacesAndNewlines)
        if Self.genericTopicLabels.contains(label.lowercased()) {
            if let match = bestTopicMatch(
                label: label,
                subject: question.subject,
                extraWords: Self.keywords(from: question.questionText),
                minimumScore: 8
            ) {
                return match
            }
            return nil
        }
        return bestTopicMatch(label: label, subject: question.subject)
    }

    private static let genericTopicLabels: Set<String> = [
        "chemistry", "biology", "physics", "general science", "earth and space", "energy", "math",
    ]

    private static func keywords(from text: String) -> Set<String> {
        Set(
            text.lowercased()
                .components(separatedBy: CharacterSet.alphanumerics.inverted)
                .filter { $0.count > 3 }
        )
    }

    private func bestTopicMatch(
        label: String,
        subject: Subject?,
        extraWords: Set<String> = [],
        minimumScore: Int = 4
    ) -> NSBTopic? {
        var words = Set(
            label.lowercased()
                .components(separatedBy: CharacterSet.alphanumerics.inverted)
                .filter { $0.count > 2 }
        )
        words.formUnion(extraWords)
        guard !words.isEmpty else { return nil }

        let candidates: [NSBTopic] = if let subject {
            topics.filter { topic in
                switch subject {
                case .biology: topic.subject == "Life Science"
                case .chemistry: topic.subject == "Chemistry" || topic.subject == "Physical Science"
                case .physics: topic.subject == "Physical Science" || topic.subject == "Energy"
                case .math: topic.subject == "Math"
                }
            }
        } else {
            topics
        }

        let scored = candidates.map { topic -> (NSBTopic, Int) in
            let title = topic.title.lowercased()
            var score = 0
            if title == label.lowercased() { score += 10 }
            if label.lowercased().contains(title) || title.contains(label.lowercased()) { score += 6 }
            for word in words where title.contains(word) { score += 2 }
            return (topic, score)
        }
        .filter { $0.1 >= minimumScore }
        .sorted { $0.1 > $1.1 }

        return scored.first?.0
    }

    private func bestTopicMatch(label: String, subject: Subject?) -> NSBTopic? {
        bestTopicMatch(label: label, subject: subject, extraWords: [], minimumScore: 4)
    }

    func questions(
        subject: String?,
        difficulty: String?,
        limit: Int,
        type: String?
    ) -> [NSBQuestion] {
        var list = questions
        if let subject, !subject.isEmpty { list = list.filter { $0.subject == subject } }
        if let difficulty, !difficulty.isEmpty { list = list.filter { $0.difficulty == difficulty } }
        if let type, !type.isEmpty { list = list.filter { $0.type == type } }
        return Array(list.shuffled().prefix(limit))
    }

    func questions(forTopicIds topicIds: [String], limit: Int, type: String?) -> [NSBQuestion] {
        guard !topicIds.isEmpty else { return [] }
        let set = Set(topicIds)
        var list = questions.filter { set.contains($0.topicId) }
        if let type, !type.isEmpty { list = list.filter { $0.type == type } }
        return Array(list.shuffled().prefix(limit))
    }

    var weakTopicIds: [String] {
        wrongCountPerTopicId
            .filter { $0.value > 0 }
            .sorted { $0.value > $1.value }
            .map(\.key)
    }

    func markReviewed(topicId: String) {
        reviewedTopicIds.insert(topicId)
        updateStreak()
        saveProgress()
    }

    func recordSession(subject: String, mode: String, score: Int, total: Int, missedTopicIds: [String]) {
        let record = EncyclopediaSessionRecord(
            id: UUID().uuidString,
            date: Date(),
            subject: subject,
            mode: mode,
            score: score,
            total: total,
            missedTopicIds: missedTopicIds
        )
        sessionHistory.insert(record, at: 0)
        for id in missedTopicIds {
            wrongCountPerTopicId[id, default: 0] += 1
        }
        updateStreak()
        saveProgress()
    }

    private func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let previous = lastStudyDate
        lastStudyDate = Date()
        guard let previous else {
            currentStreak = max(1, currentStreak)
            return
        }
        let days = calendar.dateComponents([.day], from: calendar.startOfDay(for: previous), to: today).day ?? 0
        if days == 0 { return }
        if days == 1 { currentStreak += 1 }
        else { currentStreak = 1 }
    }

    private func loadProgress() {
        if let data = UserDefaults.standard.data(forKey: reviewedKey),
           let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
            reviewedTopicIds = decoded
        }
        if let data = UserDefaults.standard.data(forKey: sessionsKey),
           let decoded = try? JSONDecoder().decode([EncyclopediaSessionRecord].self, from: data) {
            sessionHistory = decoded
        }
        lastStudyDate = UserDefaults.standard.object(forKey: lastStudyDateKey) as? Date
        currentStreak = UserDefaults.standard.integer(forKey: streakKey)
        if currentStreak == 0, lastStudyDate != nil { currentStreak = 1 }
        if let data = UserDefaults.standard.data(forKey: wrongKey),
           let decoded = try? JSONDecoder().decode([String: Int].self, from: data) {
            wrongCountPerTopicId = decoded
        }
    }

    private func saveProgress() {
        if let data = try? JSONEncoder().encode(reviewedTopicIds) {
            UserDefaults.standard.set(data, forKey: reviewedKey)
        }
        if let data = try? JSONEncoder().encode(sessionHistory) {
            UserDefaults.standard.set(data, forKey: sessionsKey)
        }
        UserDefaults.standard.set(lastStudyDate, forKey: lastStudyDateKey)
        UserDefaults.standard.set(currentStreak, forKey: streakKey)
        if let data = try? JSONEncoder().encode(wrongCountPerTopicId) {
            UserDefaults.standard.set(data, forKey: wrongKey)
        }
    }

    func importSnapshot(_ snapshot: ProgressBackup.EncyclopediaSnapshot) {
        reviewedTopicIds = Set(snapshot.reviewedTopicIds)
        sessionHistory = snapshot.sessionHistory
        wrongCountPerTopicId = snapshot.wrongCountPerTopicId
        currentStreak = snapshot.currentStreak
        lastStudyDate = snapshot.lastStudyDate
        saveProgress()
    }

    func resetProgress() {
        reviewedTopicIds = []
        sessionHistory = []
        wrongCountPerTopicId = [:]
        currentStreak = 0
        lastStudyDate = nil
        UserDefaults.standard.removeObject(forKey: reviewedKey)
        UserDefaults.standard.removeObject(forKey: sessionsKey)
        UserDefaults.standard.removeObject(forKey: lastStudyDateKey)
        UserDefaults.standard.removeObject(forKey: streakKey)
        UserDefaults.standard.removeObject(forKey: wrongKey)
    }
}
