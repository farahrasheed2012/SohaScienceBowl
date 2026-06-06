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
        let index = ((week - 1) % 4) + 1
        switch index {
        case 1: return "Foundations"
        case 2: return "Building depth"
        case 3: return "Mid-level mastery"
        default: return "Round-ready"
        }
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
        default:
            return []
        }
    }

    func questionsForBlock(_ block: StudyBlock) -> [UnifiedQuestion] {
        let category = block.subject.doeCategory

        switch currentPass {
        case .pass2:
            // Pass 2: DOE first — mostly official questions for today's subject.
            var pool = doeUnified(for: category, limit: 14)
            pool.append(contentsOf: block.sampleTossups.prefix(2).map { $0.toUnified() })
            return dedupeQuestions(pool).shuffled()

        case .pass3:
            var pool = doeUnified(for: category, limit: 12)
            pool.append(contentsOf: curriculumExtras(for: block))
            return dedupeQuestions(pool).shuffled()

        case .pass1:
            var pool = curriculumExtras(for: block)
            pool.append(contentsOf: doeUnified(for: category, limit: 8))
            return dedupeQuestions(pool).shuffled()
        }
    }

    func questionsForWeek(_ week: Int, limit: Int = 20) -> [UnifiedQuestion] {
        switch currentPass {
        case .pass2:
            var pool: [UnifiedQuestion] = []
            for category in [DOECategory.biology, .chemistry, .physics] {
                pool.append(contentsOf: doeUnified(for: category, limit: 8))
            }
            pool.append(contentsOf: scienceBlocks(for: week).flatMap { $0.sampleTossups.map { $0.toUnified() } })
            return Array(dedupeQuestions(pool).shuffled().prefix(limit))

        default:
            let blockQuestions = scienceBlocks(for: week).flatMap { questionsForBlock($0) }
            return Array(dedupeQuestions(blockQuestions).shuffled().prefix(limit))
        }
    }

    func questionsForSubject(_ subject: Subject, week: Int, limit: Int) -> [UnifiedQuestion] {
        let block = scienceBlocks(for: week).first { $0.subject == subject }
        if let block {
            return Array(questionsForBlock(block).prefix(limit))
        }

        var pool = SeedData.tossupQuestions
            .filter { $0.week == week && $0.subject == subject }
            .map { $0.toUnified() }
        let doeLimit = currentPass == .pass2 ? 12 : 8
        pool.append(contentsOf: doeUnified(for: subject.doeCategory, limit: doeLimit))
        return Array(dedupeQuestions(pool).shuffled().prefix(limit))
    }

    func questionsForBuzzerMixed(week: Int, limit: Int = 15) -> [UnifiedQuestion] {
        if currentPass == .pass2 {
            var pool: [UnifiedQuestion] = []
            for category in [DOECategory.biology, .chemistry, .physics] {
                pool.append(contentsOf: doeUnified(for: category, limit: 6))
            }
            return Array(dedupeQuestions(pool).shuffled().prefix(limit))
        }

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
        if !passManuallySet {
            currentPass = ScheduleConstants.studyPass(for: today)
        }
    }

    func userDidSetWeek(_ week: Int) {
        weekManuallySet = true
        currentWeek = week
    }

    func userDidSetPass(_ pass: StudyPass) {
        passManuallySet = true
        currentPass = pass
    }

    func resetScheduleToCalendar() {
        weekManuallySet = false
        passManuallySet = false
        refreshScheduleFromCalendar()
    }
}
