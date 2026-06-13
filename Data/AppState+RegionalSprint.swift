import Foundation

extension AppState {
    func regionalSprintQuestions(for packId: String, limit: Int = 15) -> [UnifiedQuestion] {
        guard let pack = RegionalSprintCatalog.pack(id: packId) else { return [] }

        var pool: [UnifiedQuestion] = []

        let encyclopediaQuestions = encyclopedia.questions(
            forTopicIds: [pack.topicId],
            limit: limit,
            type: nil
        )
        pool.append(contentsOf: encyclopediaQuestions.map { $0.toUnified() })

        for item in pack.knowCold where !item.answerFromKnowCold.isEmpty {
            pool.append(UnifiedQuestion(
                id: UUID(),
                source: .customCurriculum,
                category: pack.track.subject?.doeCategory ?? .generalScience,
                questionType: .tossUp,
                format: .shortAnswer,
                topic: pack.title,
                questionText: item.prompt,
                choices: [],
                answer: item.answerFromKnowCold,
                sourceFile: "",
                sourceDescription: "Regional Sprint · Know cold",
                setNumber: nil,
                roundNumber: nil,
                sourceYear: nil
            ))
        }

        for (question, answer) in pack.tossups {
            pool.append(UnifiedQuestion(
                id: UUID(),
                source: .customCurriculum,
                category: pack.track.subject?.doeCategory ?? .generalScience,
                questionType: .tossUp,
                format: .shortAnswer,
                topic: pack.title,
                questionText: question,
                choices: [],
                answer: answer,
                sourceFile: "",
                sourceDescription: "Regional Sprint",
                setNumber: nil,
                roundNumber: nil,
                sourceYear: nil
            ))
        }

        return selectDrillQuestions(from: pool, limit: limit)
    }

    func regionalSprintMixedQuestions(track: RegionalSprintCatalog.Track?, limit: Int = 20) -> [UnifiedQuestion] {
        let packList = track.map { RegionalSprintCatalog.packs(for: $0) } ?? RegionalSprintCatalog.packs
        var pool: [UnifiedQuestion] = []
        for pack in packList {
            pool.append(contentsOf: regionalSprintQuestions(for: pack.id, limit: 6))
        }
        return selectDrillQuestions(from: pool, limit: limit)
    }
}

private extension String {
    /// Parses "Prompt text? (Answer)" know-cold lines.
    var prompt: String {
        if hasSuffix(")"), let open = lastIndex(of: "(") {
            return String(self[..<open]).trimmingCharacters(in: .whitespaces)
        }
        return self
    }

    var answerFromKnowCold: String {
        if hasSuffix(")"), let open = lastIndex(of: "(") {
            let answerStart = index(after: open)
            let answerEnd = index(before: endIndex)
            return String(self[answerStart..<answerEnd])
        }
        return ""
    }
}
