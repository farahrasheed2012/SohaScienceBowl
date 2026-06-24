import Foundation

enum SeedData {
    static let studyBlocks: [StudyBlock] = weeks1Through4 + weeks5Through10
    static let tossupQuestions: [TossupQuestion] = studyBlocks.flatMap(\.sampleTossups)

    static let checklistItems: [ChecklistItem] = [
        // Biology
        ChecklistItem(id: UUID(), subject: .biology, category: "Cell biology", description: "Cell structure — nucleus, mitochondria, ribosomes, chloroplast, cell wall, membrane", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .biology, category: "Cell biology", description: "Photosynthesis & respiration — inputs/outputs · chloroplast vs mitochondria · ATP", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .biology, category: "Genetics", description: "DNA & heredity — gene, chromosome, allele · Punnett squares · dominant/recessive", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .biology, category: "Anatomy & physiology", description: "Human body systems — digestive, circulatory, respiratory, nervous (organ + job)", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .biology, category: "Ecology", description: "Ecology & animal behavior — food webs · biomes · symbiosis · innate vs learned behavior", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .biology, category: "Ecology", description: "Evolution & classification — natural selection · kingdom→species · binomial names", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .biology, category: "Cell biology", description: "Microorganisms & disease — bacteria vs virus · vaccines · antibiotics (bacteria only)", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .biology, category: "Plant biology", description: "Plants & animals — root/stem/leaf · tissues · basic animal groups · life cycles", isCompleted: false),
        // Chemistry
        ChecklistItem(id: UUID(), subject: .chemistry, category: "Periodic table", description: "Atoms & periodic table — p/n/e · atomic # vs mass # · groups/periods · first 20 symbols", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .chemistry, category: "Reactions", description: "Ions & compounds — Na⁺, Cl⁻, O²⁻ · ionic vs covalent · H₂O, CO₂, NaCl", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .chemistry, category: "Reactions", description: "Chemical reactions — balance equations · reactants/products · exo/endothermic", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .chemistry, category: "Reactions", description: "Acids, bases & pH — scale 0–14 · neutral = 7 · H⁺/OH⁻ · HCl, NaOH", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .chemistry, category: "States of matter", description: "States of matter — particle model · phase changes · melting/boiling", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .chemistry, category: "Reactions", description: "Solutions — solvent/solute · saturation · concentration · separation methods", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .chemistry, category: "Lab skills", description: "Lab & equipment — beaker, flask, balance, graduated cylinder · SI units · safety", isCompleted: false),
        // Physics
        ChecklistItem(id: UUID(), subject: .physics, category: "Motion", description: "Motion — speed, velocity, acceleration · d-t graphs · v = d/t", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .physics, category: "Forces", description: "Forces & Newton's laws — inertia · F = ma · friction · action-reaction", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .physics, category: "Thermodynamics", description: "Work, energy & heat — W = Fd · power · KE/PE · heat transfer · efficiency", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .physics, category: "Waves", description: "Waves & light — λ, f, amplitude · v = fλ · reflection/refraction", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .physics, category: "Electromagnetism", description: "Electricity — current, voltage, resistance · V = IR · series vs parallel", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .physics, category: "Thermodynamics", description: "Energy conservation — identify energy forms · heat vs temperature in a scenario", isCompleted: false)
    ]

    static func block(week: Int, day: Weekday, subject: Subject, pass: StudyPass,
                      book: String, chapter: String, title: String,
                      pass2Book: String? = nil, pass2Chapter: String? = nil, pass2Title: String? = nil,
                      backupBookLine: String? = nil,
                      focus: String, formulas: String, knowCold: [String],
                      topic: String, tossups: [(String, String)],
                      flashOnly: Bool = false) -> StudyBlock {
        var questions = tossups.map { q, a in
            TossupQuestion(id: UUID(), question: q, answer: a, subject: subject, week: week, topic: topic)
        }
        questions = expandTossups(
            questions: questions,
            knowCold: knowCold,
            subject: subject,
            week: week,
            topic: topic,
            targetCount: 8
        )
        return StudyBlock(
            id: UUID(),
            week: week,
            day: day,
            subject: subject,
            pass: pass,
            bookCode: book,
            chapter: chapter,
            chapterTitle: title,
            focus: focus,
            formulasAndTerms: formulas,
            knowCold: knowCold,
            sampleTossups: questions,
            pass2BookCode: pass2Book,
            pass2Chapter: pass2Chapter,
            pass2ChapterTitle: pass2Title,
            backupBookLine: backupBookLine,
            isFlashCardOnly: flashOnly
        )
    }

    /// Fills out 5–8 toss-ups per block using explicit toss-ups plus know-cold prompts.
    private static func expandTossups(
        questions: [TossupQuestion],
        knowCold: [String],
        subject: Subject,
        week: Int,
        topic: String,
        targetCount: Int
    ) -> [TossupQuestion] {
        let minimum = 5
        let goal = min(targetCount, max(minimum, questions.count + knowCold.count))
        guard questions.count < goal else { return Array(questions.prefix(targetCount)) }

        var result = questions
        var seen = Set(result.map { $0.question.lowercased() })

        for line in knowCold where result.count < goal {
            guard line.hasSuffix(")"), let open = line.lastIndex(of: "(") else { continue }
            let prompt = String(line[..<open]).trimmingCharacters(in: .whitespaces)
            let answerStart = line.index(after: open)
            let answerEnd = line.index(before: line.endIndex)
            let answer = String(line[answerStart..<answerEnd])
            let key = prompt.lowercased()
            guard !seen.contains(key), !prompt.isEmpty else { continue }
            seen.insert(key)
            result.append(
                TossupQuestion(id: UUID(), question: prompt, answer: answer, subject: subject, week: week, topic: topic)
            )
        }

        return Array(result.prefix(targetCount))
    }

    static func topics(for calendarWeek: Int) -> [Subject: String] {
        var result: [Subject: String] = [:]
        for subject in [Subject.chemistry, .biology, .physics] {
            if let contentWeek = ScheduleSplitTrack.contentWeek(subject: subject, calendarWeek: calendarWeek) {
                result[subject] = curriculumTopic(week: contentWeek, subject: subject)
            } else if ScheduleSplitTrack.isPreStartWeek(calendarWeek: calendarWeek),
                      subject == .biology || subject == .physics || subject == .chemistry {
                result[subject] = "Starts calendar week 3 (\(subject.rawValue) Week 1)"
            }
        }
        return result
    }

    private static func curriculumTopic(week: Int, subject: Subject) -> String {
        switch (week, subject) {
        case (1, .chemistry): return "Atoms & periodic table"
        case (2, .chemistry): return "States of matter & bonding"
        case (3, .chemistry): return "Solutions & reactions"
        case (4, .chemistry): return "The atom"
        case (5, .chemistry): return "Covalent bonding & stoichiometry"
        case (6, .chemistry): return "Solutions & neutralization"
        case (7, .chemistry): return "Reactions & periodic trends"
        case (8, .chemistry): return "Lab math & phase changes"
        case (9, .chemistry): return "Isotopes & ions"
        case (10, .chemistry): return "Summer capstone"
        case (1, .biology): return "Cell structure"
        case (2, .biology): return "Genetics"
        case (3, .biology): return "Ecology"
        case (4, .biology): return "Evolution & classification"
        case (5, .biology): return "Photosynthesis & respiration"
        case (6, .biology): return "Population ecology & microbes"
        case (7, .biology): return "Immunity & plants"
        case (8, .biology): return "Plant transport & tissues"
        case (9, .biology): return "Cell division & body systems"
        case (10, .biology): return "Summer capstone"
        case (1, .physics): return "About Science + Motion"
        case (2, .physics): return "Forces & Newton's laws"
        case (3, .physics): return "Forces (continued)"
        case (4, .physics): return "Momentum"
        case (5, .physics): return "Work & energy"
        case (6, .physics): return "Gravity"
        case (7, .physics): return "Heat & thermodynamics"
        case (8, .physics): return "Electricity intro"
        case (9, .physics): return "Magnetism & waves"
        case (10, .physics): return "Summer capstone"
        default: return "Week \(week)"
        }
    }
}
