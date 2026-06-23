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

    static func thisWeek(week: Int, subject: Subject? = nil) -> PlanDrillRequest {
        let subtitle: String
        let title: String
        if let subject {
            title = "\(subject.rawValue) quiz"
            subtitle = "Week \(week) · \(subject.rawValue) blocks only"
        } else {
            title = "All subjects"
            subtitle = "Week \(week) · mixed Bio, Chem & Phys"
        }
        return PlanDrillRequest(
            title: title,
            subtitle: subtitle,
            mode: "Week quiz",
            week: week,
            subject: subject,
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

    static var hewittChapter17: PlanDrillRequest {
        PlanDrillRequest(
            title: "Hewitt Ch 17",
            subtitle: HewittChapter17Catalog.subtitle,
            mode: "Hewitt Ch 17",
            week: 0,
            subject: .chemistry,
            block: nil,
            buzzerMixed: false
        )
    }
}

extension StudyBlock {
    var primaryTopic: String {
        sampleTossups.first?.topic ?? chapterTitle
    }
}

extension AppState {
    func scienceBlocks(for calendarWeek: Int) -> [StudyBlock] {
        let subjects: [Subject] = [.chemistry, .biology, .physics]
        let blocks = subjects.flatMap { subject -> [StudyBlock] in
            guard let contentWeek = ScheduleSplitTrack.contentWeek(subject: subject, calendarWeek: calendarWeek) else {
                return []
            }
            return self.blocks(for: contentWeek, pass: currentPass).filter { $0.subject == subject }
        }
        return blocks.sorted { $0.day.rawValue < $1.day.rawValue }
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
            if let subject = request.subject {
                return questionsForSubjectWeek(subject, week: request.week)
            }
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
        case "Hewitt Ch 17":
            return hewittChapter17Questions(limit: 30)
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
        return selectDrillQuestions(from: pool, limit: limit)
    }

    func questionsForBlock(
        _ block: StudyBlock,
        limit: Int = ScheduleConstants.dayTopicQuizQuestionCount
    ) -> [UnifiedQuestion] {
        selectDrillQuestions(from: buildQuestionsForBlock(block), limit: limit)
    }

    func questionsForWeek(_ week: Int, limit: Int = 20) -> [UnifiedQuestion] {
        let blocks = scienceBlocks(for: week)
        let pool = buildCurriculumFirstPool(for: blocks, minimumCount: limit)
        return selectDrillQuestions(from: pool, limit: limit)
    }

    func questionsForSubjectWeek(_ subject: Subject, week: Int, limit: Int = 15) -> [UnifiedQuestion] {
        let blocks = scienceBlocks(for: week).filter { $0.subject == subject }
        if !blocks.isEmpty {
            let pool = buildCurriculumFirstPool(for: blocks, minimumCount: limit)
            return selectDrillQuestions(from: pool, limit: limit)
        }
        return questionsForSubject(subject, week: week, limit: limit)
    }

    func questionsForSubject(_ subject: Subject, week: Int, limit: Int) -> [UnifiedQuestion] {
        let blocks = scienceBlocks(for: week).filter { $0.subject == subject }
        if !blocks.isEmpty {
            let pool = blocks.flatMap { buildQuestionsForBlock($0) }
            return selectDrillQuestions(from: pool, limit: limit)
        }

        var pool = SeedData.tossupQuestions
            .filter { $0.week == week && $0.subject == subject }
            .map { $0.toUnified() }
        if pool.isEmpty, let contentWeek = ScheduleSplitTrack.contentWeek(subject: subject, calendarWeek: week) {
            pool = SeedData.tossupQuestions
                .filter { $0.week == contentWeek && $0.subject == subject }
                .map { $0.toUnified() }
        }
        pool = supplementThinPool(pool: pool, subject: subject, week: week, limit: limit)
        return selectDrillQuestions(from: pool, limit: limit)
    }

    func questionsForBuzzerMixed(week: Int, limit: Int = 15) -> [UnifiedQuestion] {
        let blocks = scienceBlocks(for: week)
        var pool = blocks.flatMap { buildQuestionsForBlock($0) }
        if pool.count < limit {
            pool.append(contentsOf: SeedData.tossupQuestions.filter { $0.week == week }.map { $0.toUnified() })
        }
        return selectDrillQuestions(from: pool, limit: limit)
    }

    func questionsForTossupDrill(
        subject: Subject,
        week: Int?,
        topicFilter: String? = nil,
        limit: Int = 20
    ) -> [UnifiedQuestion] {
        var pool: [UnifiedQuestion]

        if let week {
            let blocks = scienceBlocks(for: week).filter { $0.subject == subject }
            if !blocks.isEmpty {
                pool = blocks.flatMap { buildQuestionsForBlock($0) }
            } else {
                pool = SeedData.tossupQuestions
                    .filter { $0.week == week && $0.subject == subject }
                    .map { $0.toUnified() }
                pool = supplementThinPool(pool: pool, subject: subject, week: week, limit: limit)
            }
        } else {
            pool = allUnifiedQuestions.filter { $0.subject == subject || $0.category.subject == subject }
            if pool.count < limit {
                pool.append(contentsOf: SeedData.tossupQuestions.filter { $0.subject == subject }.map { $0.toUnified() })
            }
            pool = supplementThinPool(pool: pool, subject: subject, week: week ?? currentWeek, limit: limit)
        }

        if let topicFilter {
            pool = pool.filter { $0.topic == topicFilter }
        }

        return selectDrillQuestions(from: pool, limit: limit)
    }

    func markQuestionSeen(_ question: UnifiedQuestion) {
        RecentQuestionStore.record(question)
    }

    func selectDrillQuestions(from pool: [UnifiedQuestion], limit: Int) -> [UnifiedQuestion] {
        let deduped = dedupeQuestions(pool)
        let displayable = deduped.filter { Self.looksDisplayable($0) }
        let candidates = displayable.count >= min(limit, 3) ? displayable : deduped
        return RecentQuestionStore.prioritizeFresh(candidates, limit: limit)
    }

    /// Drops stems that look cut off during PDF import (e.g. ending with "of" or "the").
    private static func looksDisplayable(_ question: UnifiedQuestion) -> Bool {
        let text = question.questionText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard text.count >= 10 else { return false }
        let lower = text.lowercased()
        let danglingEndings = [" of", " the", " a", " an", " with", " for", " to", " and", " or", " in", " on", " at", " by"]
        return !danglingEndings.contains(where: { lower.hasSuffix($0) })
    }

    private static let thinPoolThreshold = 12

    /// Week/subject quizzes: block toss-ups first, then block-linked encyclopedia — DOE only if still short.
    private func buildCurriculumFirstPool(for blocks: [StudyBlock], minimumCount: Int) -> [UnifiedQuestion] {
        var pool = blocks.flatMap { $0.sampleTossups.map { $0.toUnified() } }
        pool = dedupeQuestions(pool)

        if pool.count >= minimumCount {
            return pool
        }

        for block in blocks {
            pool.append(contentsOf: encyclopediaQuestions(for: block, limit: 10))
        }
        pool = dedupeQuestions(pool)

        if pool.count >= minimumCount {
            return pool
        }

        let categories = Set(blocks.map { $0.subject.doeCategory })
        for category in categories {
            pool.append(contentsOf: doeUnified(for: category, limit: minimumCount))
        }
        return dedupeQuestions(pool)
    }

    private func buildQuestionsForBlock(_ block: StudyBlock) -> [UnifiedQuestion] {
        let category = block.subject.doeCategory
        var pool = curriculumExtras(for: block)
        pool.append(contentsOf: encyclopediaQuestions(for: block, limit: 15))

        var deduped = dedupeQuestions(pool)

        if deduped.count < Self.thinPoolThreshold {
            deduped = supplementThinPool(pool: deduped, block: block, category: category)
        } else {
            pool.append(contentsOf: doeUnified(for: category, limit: ScheduleConstants.dayTopicQuizQuestionCount / 2))
            deduped = dedupeQuestions(pool)
        }

        if deduped.count < ScheduleConstants.dayTopicQuizQuestionCount {
            var fill = deduped
            fill.append(contentsOf: weekSubjectSeed(for: block))
            fill.append(contentsOf: doeUnified(for: category, limit: ScheduleConstants.dayTopicQuizQuestionCount))
            fill.append(contentsOf: encyclopediaSubjectQuestions(for: block.subject, limit: 20))
            deduped = dedupeQuestions(fill)
        }

        return deduped
    }

    private func supplementThinPool(
        pool: [UnifiedQuestion],
        block: StudyBlock,
        category: DOECategory
    ) -> [UnifiedQuestion] {
        var expanded = pool
        expanded.append(contentsOf: doeUnified(for: category, limit: 30))
        expanded.append(contentsOf: encyclopediaQuestions(for: block, limit: 25))
        expanded.append(contentsOf: encyclopediaSubjectQuestions(for: block.subject, limit: 20))
        return dedupeQuestions(expanded)
    }

    private func supplementThinPool(
        pool: [UnifiedQuestion],
        subject: Subject,
        week: Int,
        limit: Int
    ) -> [UnifiedQuestion] {
        var expanded = pool
        expanded.append(contentsOf: doeUnified(for: subject.doeCategory, limit: max(limit * 2, 25)))
        expanded.append(contentsOf: encyclopediaSubjectQuestions(for: subject, limit: 25))
        expanded.append(contentsOf: SeedData.tossupQuestions
            .filter { $0.week == week && $0.subject == subject }
            .map { $0.toUnified() })
        return dedupeQuestions(expanded)
    }

    private func encyclopediaSubjectQuestions(for subject: Subject, limit: Int) -> [UnifiedQuestion] {
        let subjectName: String = switch subject {
        case .biology: "Life Science"
        case .chemistry: "Chemistry"
        case .physics: "Physical Science"
        }
        return encyclopedia.questions(subject: subjectName, difficulty: nil, limit: limit, type: "tossUp")
            .map { $0.toUnified() }
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
