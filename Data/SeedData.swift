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

    static func topics(for week: Int) -> [Subject: String] {
        switch week {
        case 1: return [.chemistry: "Atoms & periodic table", .biology: "Cell structure", .physics: "About Science + Motion"]
        case 2: return [.chemistry: "States of matter & bonding", .biology: "Genetics", .physics: "Forces & Newton's laws"]
        case 3: return [.chemistry: "Solutions & reactions", .biology: "Ecology", .physics: "Forces (continued)"]
        case 4: return [.chemistry: "The atom", .biology: "Evolution & classification", .physics: "Momentum"]
        case 5: return [.chemistry: "Covalent bonding & stoichiometry", .biology: "Photosynthesis & respiration", .physics: "Work & energy"]
        case 6: return [.chemistry: "Solutions & neutralization", .biology: "Population ecology & microbes", .physics: "Gravity"]
        case 7: return [.chemistry: "Reactions & periodic trends", .biology: "Immunity & plants", .physics: "Heat & thermodynamics"]
        case 8: return [.chemistry: "Lab math & phase changes", .biology: "Plant transport & tissues", .physics: "Electricity intro"]
        case 9: return [.chemistry: "Isotopes & ions", .biology: "Cell division & body systems", .physics: "Magnetism & waves"]
        default: return [.chemistry: "Summer capstone", .biology: "Summer capstone", .physics: "Summer capstone"]
        }
    }
}
