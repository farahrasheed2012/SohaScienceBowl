import Foundation

/// How a plan-aligned drill selects questions.
struct PlanDrillRequest: Hashable {
    var title: String
    var subtitle: String
    var mode: String
    var week: Int
    var subject: Subject?
    var block: StudyBlock?
    var buzzerMixed: Bool
    var mathDay: Weekday?
    var weakAreaReview: Bool = false
    var regionalPackId: String?
    var regionalTrack: RegionalSprintCatalog.Track?

    static func todayBlock(_ block: StudyBlock, week: Int) -> PlanDrillRequest {
        PlanDrillRequest(
            title: "Today's block",
            subtitle: "\(block.day.shortName) · \(block.subject.rawValue) · \(block.sampleTossups.first?.topic ?? block.chapterTitle)",
            mode: "Today's block quiz",
            week: week,
            subject: block.subject,
            block: block,
            buzzerMixed: false
        )
    }

    static func thisWeek(week: Int) -> PlanDrillRequest {
        PlanDrillRequest(
            title: "This week",
            subtitle: "Week \(week) · all Bio, Chem & Phys blocks",
            mode: "Week quiz",
            week: week,
            subject: nil,
            block: nil,
            buzzerMixed: false
        )
    }

    static func buzzer(slot: ScheduleConstants.BuzzerSlot, week: Int) -> PlanDrillRequest {
        PlanDrillRequest(
            title: "Buzzer drill",
            subtitle: slot.label,
            mode: "Buzzer drill",
            week: week,
            subject: slot.subjects.count == 1 ? slot.subjects[0] : nil,
            block: nil,
            buzzerMixed: slot.isMixed
        )
    }

    static func dayBlock(_ block: StudyBlock, week: Int) -> PlanDrillRequest {
        PlanDrillRequest(
            title: "\(block.day.shortName) · \(block.subject.rawValue)",
            subtitle: block.sampleTossups.first?.topic ?? block.chapterTitle,
            mode: "Day topic quiz",
            week: week,
            subject: block.subject,
            block: block,
            buzzerMixed: false
        )
    }

    static func mathQuiz(week: Int, day: Weekday) -> PlanDrillRequest {
        let reading = ScheduleOpenStaxCatalog.mathReading(week: week, day: day)
        return PlanDrillRequest(
            title: "Math quiz",
            subtitle: reading?.title ?? "Math practice",
            mode: "Math quiz",
            week: week,
            subject: nil,
            block: nil,
            buzzerMixed: false,
            mathDay: day
        )
    }

    static func weakAreaReview() -> PlanDrillRequest {
        PlanDrillRequest(
            title: "Today's review",
            subtitle: "Flash cards due + weak topics",
            mode: "Weak area review",
            week: 0,
            subject: nil,
            block: nil,
            buzzerMixed: false,
            weakAreaReview: true
        )
    }

    static func regionalSprint(packId: String) -> PlanDrillRequest {
        let pack = RegionalSprintCatalog.pack(id: packId)
        return PlanDrillRequest(
            title: "Regional Sprint",
            subtitle: pack?.title ?? packId,
            mode: "Regional sprint",
            week: 0,
            subject: pack?.track.subject,
            block: nil,
            buzzerMixed: false,
            regionalPackId: packId
        )
    }

    static func regionalSprint(track: RegionalSprintCatalog.Track) -> PlanDrillRequest {
        PlanDrillRequest(
            title: "Regional Sprint",
            subtitle: "\(track.rawValue) · all packs",
            mode: "Regional sprint",
            week: 0,
            subject: track.subject,
            block: nil,
            buzzerMixed: false,
            regionalTrack: track
        )
    }

    static func regionalSprintMixed() -> PlanDrillRequest {
        PlanDrillRequest(
            title: "Regional Sprint",
            subtitle: "Mixed · Life + Chem + Phys",
            mode: "Regional sprint",
            week: 0,
            subject: nil,
            block: nil,
            buzzerMixed: true
        )
    }
}

extension StudyBlock {
    var primaryTopic: String {
        sampleTossups.first?.topic ?? chapterTitle
    }
}

extension AppState {
    func scienceBlocks(for week: Int) -> [StudyBlock] {
        blocks(for: week, pass: currentPass)
            .sorted { $0.day.rawValue < $1.day.rawValue }
    }

    func weekTheme(for week: Int) -> String {
        ScheduleConstants.weekThemeLabel(for: week)
    }

    func questions(for request: PlanDrillRequest) -> [UnifiedQuestion] {
        switch request.mode {
        case "Today's block quiz", "Day topic quiz":
            guard let block = request.block else { return [] }
            return questionsForBlock(block)
        case "Week quiz":
            return questionsForWeek(request.week)
        case "Buzzer drill":
            if request.buzzerMixed {
                return questionsForBuzzerMixed(week: request.week)
            }
            if let subject = request.subject {
                return questionsForSubject(subject, week: request.week, limit: 15)
            }
            return questionsForWeek(request.week, limit: 15)
        case "Math quiz":
            guard let day = request.mathDay else { return [] }
            return questionsForMath(week: request.week, day: day)
        case "Weak area review":
            return todaysWeakAreaQuestions(limit: 12)
        case "Regional sprint":
            if let packId = request.regionalPackId {
                return regionalSprintQuestions(for: packId, limit: 18)
            }
            if let track = request.regionalTrack {
                return regionalSprintMixedQuestions(track: track, limit: 20)
            }
            return regionalSprintMixedQuestions(track: nil, limit: 25)
        default:
            return []
        }
    }

    func questionsForMath(week: Int, day: Weekday, limit: Int = 10) -> [UnifiedQuestion] {
        guard let reading = ScheduleOpenStaxCatalog.mathReading(week: week, day: day) else { return [] }
        let topicIds = MathQuizCatalog.topicIds(for: reading)
        let encyclopediaQuestions = encyclopedia.questions(forTopicIds: topicIds, limit: limit, type: "tossUp")
        var pool = encyclopediaQuestions.map { $0.toUnified() }
        if pool.count < limit {
            let extra = encyclopedia.questions(subject: "Math", difficulty: nil, limit: limit, type: "multipleChoice")
            pool.append(contentsOf: extra.map { $0.toUnified() })
        }
        return Array(dedupeQuestions(pool).shuffled().prefix(limit))
    }

    func questionsForBlock(
        _ block: StudyBlock,
        limit: Int = ScheduleConstants.dayTopicQuizQuestionCount
    ) -> [UnifiedQuestion] {
        let category = block.subject.doeCategory
        let curriculum = curriculumExtras(for: block)
        let encyclopediaPool = encyclopediaQuestions(for: block, limit: 12)

        var pool: [UnifiedQuestion] = curriculum
        pool.append(contentsOf: encyclopediaPool)
        pool.append(contentsOf: doeUnified(for: category, limit: limit / 2))

        var deduped = dedupeQuestions(pool)
        if deduped.count < limit {
            var fill = pool
            fill.append(contentsOf: weekSubjectSeed(for: block))
            fill.append(contentsOf: doeUnified(for: category, limit: limit))
            deduped = dedupeQuestions(fill)
        }

        return Array(deduped.shuffled().prefix(limit))
    }

    func questionsForWeek(_ week: Int, limit: Int = 20) -> [UnifiedQuestion] {
        let blockQuestions = scienceBlocks(for: week).flatMap { questionsForBlock($0) }
        return Array(dedupeQuestions(blockQuestions).shuffled().prefix(limit))
    }

    func questionsForSubject(_ subject: Subject, week: Int, limit: Int) -> [UnifiedQuestion] {
        let block = scienceBlocks(for: week).first { $0.subject == subject }
        if let block {
            return Array(questionsForBlock(block).prefix(limit))
        }

        var pool = SeedData.tossupQuestions
            .filter { $0.week == week && $0.subject == subject }
            .map { $0.toUnified() }
        pool.append(contentsOf: doeUnified(for: subject.doeCategory, limit: 8))
        return Array(dedupeQuestions(pool).shuffled().prefix(limit))
    }

    func questionsForBuzzerMixed(week: Int, limit: Int = 15) -> [UnifiedQuestion] {
        let blocks = scienceBlocks(for: week)
        var pool = blocks.flatMap { questionsForBlock($0) }
        if pool.count < limit {
            pool.append(contentsOf: SeedData.tossupQuestions.filter { $0.week == week }.map { $0.toUnified() })
        }
        return Array(dedupeQuestions(pool).shuffled().prefix(limit))
    }

    private func curriculumExtras(for block: StudyBlock) -> [UnifiedQuestion] {
        var pool = block.sampleTossups.map { $0.toUnified() }

        for item in knowColdItems(for: block) where !item.answer.isEmpty {
            pool.append(UnifiedQuestion(
                id: UUID(),
                source: .customCurriculum,
                category: block.subject.doeCategory,
                questionType: .tossUp,
                format: .shortAnswer,
                topic: block.primaryTopic,
                questionText: item.prompt,
                choices: [],
                answer: item.answer,
                sourceFile: "",
                sourceDescription: "Week \(block.week) · Know cold",
                setNumber: nil,
                roundNumber: nil,
                sourceYear: nil
            ))
        }

        let topic = block.primaryTopic
        let seedExtra = SeedData.tossupQuestions
            .filter { $0.week == block.week && $0.subject == block.subject && $0.topic == topic }
            .map { $0.toUnified() }
        pool.append(contentsOf: seedExtra)
        return pool
    }

    private func encyclopediaQuestions(for block: StudyBlock, limit: Int) -> [UnifiedQuestion] {
        let topicIds = encyclopedia.relatedTopics(for: block).map(\.id)
        guard !topicIds.isEmpty else { return [] }
        return encyclopedia.questions(forTopicIds: topicIds, limit: limit, type: "tossUp")
            .map { $0.toUnified() }
    }

    private func weekSubjectSeed(for block: StudyBlock) -> [UnifiedQuestion] {
        SeedData.tossupQuestions
            .filter { $0.week == block.week && $0.subject == block.subject }
            .map { $0.toUnified() }
    }

    private func doeUnified(for category: DOECategory, limit: Int) -> [UnifiedQuestion] {
        guard limit > 0, !doeStore.doeQuestions.isEmpty else { return [] }
        return Array(
            doeStore.doeQuestions
                .filter { $0.category == category }
                .shuffled()
                .prefix(limit)
                .map { $0.toUnified() }
        )
    }

    private func dedupeQuestions(_ questions: [UnifiedQuestion]) -> [UnifiedQuestion] {
        var seen = Set<String>()
        var result: [UnifiedQuestion] = []
        for q in questions {
            let key = q.normalizedText
            if seen.contains(key) { continue }
            seen.insert(key)
            result.append(q)
        }
        return result
    }

    func refreshScheduleFromCalendar() {
        guard autoSyncScheduleFromCalendar else { return }
        let today = Date()
        if !weekManuallySet {
            currentWeek = ScheduleConstants.weekNumber(for: today)
        }
        currentPass = .pass1
    }

    func userDidSetWeek(_ week: Int) {
        weekManuallySet = true
        currentWeek = week
    }

    func userDidSetPass(_ pass: StudyPass) {
        passManuallySet = false
        currentPass = .pass1
    }

    func resetScheduleToCalendar() {
        weekManuallySet = false
        passManuallySet = false
        refreshScheduleFromCalendar()
    }
}
