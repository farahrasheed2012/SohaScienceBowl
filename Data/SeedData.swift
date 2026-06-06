import Foundation

enum SeedData {
    static let studyBlocks: [StudyBlock] = weeks1Through4 + weeks5Through8 + weeks9Through10
    static let tossupQuestions: [TossupQuestion] = studyBlocks.flatMap(\.sampleTossups)

    static let checklistItems: [ChecklistItem] = [
        // Biology
        ChecklistItem(id: UUID(), subject: .biology, category: "Life Sciences", description: "Cell structure — nucleus, mitochondria, ribosomes, chloroplast, cell wall, membrane", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .biology, category: "Life Sciences", description: "Photosynthesis & respiration — inputs/outputs · chloroplast vs mitochondria · ATP", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .biology, category: "Life Sciences", description: "DNA & heredity — gene, chromosome, allele · Punnett squares · dominant/recessive", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .biology, category: "Life Sciences", description: "Human body systems — digestive, circulatory, respiratory, nervous (organ + job)", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .biology, category: "Life Sciences", description: "Ecology — food webs · producers/consumers/decomposers · biomes · symbiosis types", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .biology, category: "Life Sciences", description: "Evolution & classification — natural selection · kingdom→species · binomial names", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .biology, category: "Life Sciences", description: "Microorganisms & disease — bacteria vs virus · vaccines · antibiotics (bacteria only)", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .biology, category: "Life Sciences", description: "Plants & animals — root/stem/leaf · tissues · basic life cycles", isCompleted: false),
        // Chemistry
        ChecklistItem(id: UUID(), subject: .chemistry, category: "Physical Sciences", description: "Atoms & periodic table — p/n/e · atomic # vs mass # · groups/periods · first 20 symbols", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .chemistry, category: "Physical Sciences", description: "Ions & compounds — Na⁺, Cl⁻, O²⁻ · ionic vs covalent · H₂O, CO₂, NaCl", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .chemistry, category: "Physical Sciences", description: "Chemical reactions — balance equations · reactants/products · exo/endothermic", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .chemistry, category: "Physical Sciences", description: "Acids, bases & pH — scale 0–14 · neutral = 7 · H⁺/OH⁻ · HCl, NaOH", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .chemistry, category: "Physical Sciences", description: "States of matter — particle model · phase changes · melting/boiling", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .chemistry, category: "Physical Sciences", description: "Solutions — solvent/solute · saturation · concentration · separation methods", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .chemistry, category: "Physical Sciences", description: "Lab & equipment — beaker, flask, balance, graduated cylinder · SI units · safety", isCompleted: false),
        // Physics
        ChecklistItem(id: UUID(), subject: .physics, category: "Physical Sciences", description: "Motion — speed, velocity, acceleration · d-t graphs · v = d/t", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .physics, category: "Physical Sciences", description: "Forces & Newton's laws — inertia · F = ma · friction · action-reaction", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .physics, category: "Physical Sciences", description: "Work & energy — W = Fd · power · KE/PE · simple machines · efficiency", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .physics, category: "Physical Sciences", description: "Waves & light — λ, f, amplitude · v = fλ · reflection/refraction", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .physics, category: "Physical Sciences", description: "Electricity — current, voltage, resistance · V = IR · series vs parallel", isCompleted: false),
        ChecklistItem(id: UUID(), subject: .physics, category: "Physical Sciences", description: "Energy transfer — conservation · identify energy forms in a scenario", isCompleted: false)
    ]

    static func block(week: Int, day: Weekday, subject: Subject, pass: StudyPass,
                      book: String, chapter: String, title: String,
                      pass2Book: String? = nil, pass2Chapter: String? = nil, pass2Title: String? = nil,
                      focus: String, formulas: String, knowCold: [String],
                      topic: String, tossups: [(String, String)],
                      flashOnly: Bool = false) -> StudyBlock {
        let questions = tossups.map { q, a in
            TossupQuestion(id: UUID(), question: q, answer: a, subject: subject, week: week, topic: topic)
        }
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
            isFlashCardOnly: flashOnly
        )
    }

    static func topics(for week: Int) -> [Subject: String] {
        let index = ((week - 1) % 4) + 1
        switch index {
        case 1: return [.chemistry: "Atoms & periodic table", .biology: "Cell structure", .physics: "Motion"]
        case 2: return [.chemistry: "States of matter", .biology: "Genetics", .physics: "Forces & Newton's laws"]
        case 3: return [.chemistry: "Acids, bases & pH", .biology: "Ecology", .physics: "Work & energy"]
        default: return [.chemistry: "Periodic trends & lab", .biology: "Evolution & plants", .physics: "Waves & electricity"]
        }
    }
}
