import Foundation

/// Big Fat Notebook reading citations — optional for chem, bio, and phys blocks.
enum ScheduleBFNCatalog {
    static let scienceTitle = "Big Fat Notebook: Science"
    static let scienceCode = "BFN-Sci"
    static let scienceISBN = "9780761160957"

    static let biologyTitle = "Big Fat Notebook: Biology"
    static let biologyCode = "BFN-Bio"
    static let biologyISBN = "9781523504367"

    struct Citation: Hashable {
        let unit: String
        let chapters: String
        let pages: String

        var shortLine: String {
            "\(unit) · \(chapters) · \(pages)"
        }
    }

    private static func topicKey(for block: StudyBlock) -> String {
        block.sampleTossups.first?.topic ?? block.chapterTitle
    }

    // MARK: - BFN-Sci (MS · Units 1–11)

    private static let scienceByTopic: [String: Citation] = [
        "Atoms & periodic table": Citation(
            unit: "Unit 2",
            chapters: "Ch 7 Periodic Table, Atomic Structure, and Compounds",
            pages: "p59"
        ),
        "Atoms review": Citation(
            unit: "Unit 2",
            chapters: "Ch 6–7 Matter · Atoms · Periodic table",
            pages: "p59"
        ),
        "Elements & ions": Citation(
            unit: "Unit 2",
            chapters: "Ch 7 Periodic Table and Compounds",
            pages: "p59"
        ),
        "Ions & compounds": Citation(
            unit: "Unit 2",
            chapters: "Ch 7 Atomic Structure and Compounds",
            pages: "p59"
        ),
        "Compounds review": Citation(
            unit: "Unit 2",
            chapters: "Ch 7 Compounds · Ch 8 Solutions",
            pages: "p59"
        ),
        "States of matter": Citation(
            unit: "Unit 2",
            chapters: "Ch 6 Matter, Properties, and Phases",
            pages: "p59"
        ),
        "Chemical reactions": Citation(
            unit: "Unit 2",
            chapters: "Ch 6–8 Matter · Solutions · Chemical change",
            pages: "p59"
        ),
        "Acids, bases & pH": Citation(
            unit: "Unit 2",
            chapters: "Ch 6–8 Matter and Solutions",
            pages: "p59"
        ),
        "Acids review": Citation(
            unit: "Unit 2",
            chapters: "Ch 6–8 Matter · Solutions",
            pages: "p59"
        ),
        "Solutions": Citation(
            unit: "Unit 2",
            chapters: "Ch 8 Solutions and Fluids",
            pages: "p59"
        ),
        "Solutions review": Citation(
            unit: "Unit 2",
            chapters: "Ch 8 Solutions and Fluids",
            pages: "p59"
        ),
        "Periodic trends & elements": Citation(
            unit: "Unit 2",
            chapters: "Ch 7 Periodic Table and Atomic Structure",
            pages: "p59"
        ),
        "Periodic trends & lab": Citation(
            unit: "Unit 1",
            chapters: "Ch 3–5 Lab reports · SI units · Lab tools",
            pages: "p1"
        ),
        "Lab & equipment": Citation(
            unit: "Unit 1",
            chapters: "Ch 4–5 SI Units · Lab Safety and Scientific Tools",
            pages: "p1"
        ),
        "About Science + Motion": Citation(
            unit: "Unit 3",
            chapters: "Ch 1–2 Scientific thinking · Ch 9 Motion",
            pages: "p1 · p91"
        ),
        "Motion": Citation(
            unit: "Unit 3",
            chapters: "Ch 9 Motion",
            pages: "p91"
        ),
        "Motion review": Citation(
            unit: "Unit 3",
            chapters: "Ch 9 Motion · Ch 10 Force",
            pages: "p91"
        ),
        "Forces & Newton's laws": Citation(
            unit: "Unit 3",
            chapters: "Ch 10 Force and Newton's Laws · Ch 11 Gravity and Friction",
            pages: "p91"
        ),
        "Forces & momentum": Citation(
            unit: "Unit 3",
            chapters: "Ch 10–11 Forces · Newton's laws",
            pages: "p91"
        ),
        "Work & energy": Citation(
            unit: "Unit 3–4",
            chapters: "Ch 12 Work and Machines · Ch 13 Forms of Energy",
            pages: "p91 · p129"
        ),
        "Waves & electricity": Citation(
            unit: "Unit 4",
            chapters: "Ch 15 Light and Sound · Ch 16 Electricity and Magnetism",
            pages: "p129"
        ),
        // Bio topics — BFN-Sci Units 7–11 (simpler MS life-science sections)
        "Cell structure": Citation(
            unit: "Unit 7",
            chapters: "Ch 29 Cell Theory and Cell Structure",
            pages: "p291"
        ),
        "Cell review": Citation(
            unit: "Unit 7",
            chapters: "Ch 29 Cell Theory and Cell Structure",
            pages: "p291"
        ),
        "Photosynthesis & respiration": Citation(
            unit: "Unit 7",
            chapters: "Ch 30 Cellular Transport and Metabolism",
            pages: "p291"
        ),
        "Cell energy & organization": Citation(
            unit: "Unit 7",
            chapters: "Ch 29–30 Cells · Metabolism",
            pages: "p291"
        ),
        "Energy review": Citation(
            unit: "Unit 7",
            chapters: "Ch 30 Cellular Transport and Metabolism",
            pages: "p291"
        ),
        "Genetics": Citation(
            unit: "Unit 10",
            chapters: "Ch 42 Heredity and Genetics",
            pages: "p433"
        ),
        "Genetics review": Citation(
            unit: "Unit 10",
            chapters: "Ch 42 Heredity and Genetics · Ch 43 Evolution",
            pages: "p433"
        ),
        "Ecology": Citation(
            unit: "Unit 11",
            chapters: "Ch 46 Ecology and Ecosystems · Ch 47 Interdependence",
            pages: "p475"
        ),
        "Ecology review": Citation(
            unit: "Unit 11",
            chapters: "Ch 46–48 Ecology · Biomes",
            pages: "p475"
        ),
        "Human body systems": Citation(
            unit: "Unit 9",
            chapters: "Ch 36–41 Body systems (skeletal through immune)",
            pages: "p373"
        ),
        "Evolution & classification": Citation(
            unit: "Unit 10",
            chapters: "Ch 43 Evolution · Ch 44 Fossils",
            pages: "p433"
        ),
        "Evolution & plants": Citation(
            unit: "Unit 10",
            chapters: "Ch 43 Evolution · Ch 45 History of Life",
            pages: "p433"
        ),
        "Microorganisms & disease": Citation(
            unit: "Unit 7",
            chapters: "Ch 28 Organisms and Biological Classification",
            pages: "p291"
        ),
        "Plants & animals": Citation(
            unit: "Unit 8",
            chapters: "Ch 32–35 Plant structure · Invertebrates · Vertebrates",
            pages: "p333"
        ),
    ]

    // MARK: - BFN-Bio (HS · Units 1–12)

    private static let biologyByTopic: [String: Citation] = [
        "Cell structure": Citation(
            unit: "Unit 3",
            chapters: "Ch 9 Cell Structure and Function",
            pages: "p84"
        ),
        "Cell review": Citation(
            unit: "Unit 3",
            chapters: "Ch 9 Cell Structure and Function",
            pages: "p84"
        ),
        "Photosynthesis & respiration": Citation(
            unit: "Unit 3",
            chapters: "Ch 11 Photosynthesis · Ch 12 Cellular Respiration",
            pages: "p103"
        ),
        "Cell energy & organization": Citation(
            unit: "Unit 3",
            chapters: "Ch 10 Chemical Energy and ATP · Ch 11–12 Energy in cells",
            pages: "p97"
        ),
        "Energy review": Citation(
            unit: "Unit 3",
            chapters: "Ch 10–12 ATP · Photosynthesis · Respiration",
            pages: "p97"
        ),
        "Genetics": Citation(
            unit: "Unit 10",
            chapters: "Ch 44 Introduction to Genetics · Ch 45 DNA and RNA",
            pages: "p413"
        ),
        "Genetics review": Citation(
            unit: "Unit 10",
            chapters: "Ch 44–46 Genetics · Genetic engineering",
            pages: "p413"
        ),
        "Ecology": Citation(
            unit: "Unit 12",
            chapters: "Ch 49 The Ecosystem · Ch 50 Populations",
            pages: "p483"
        ),
        "Ecology review": Citation(
            unit: "Unit 12",
            chapters: "Ch 49–50 Ecosystems · Populations",
            pages: "p483"
        ),
        "Human body systems": Citation(
            unit: "Unit 9",
            chapters: "Ch 36 Body Systems · Ch 40 Respiratory/Circulatory · Ch 41 Digestive",
            pages: "p325"
        ),
        "Evolution & classification": Citation(
            unit: "Unit 11",
            chapters: "Ch 47 Evolution · Ch 48 History of Life",
            pages: "p451"
        ),
        "Evolution & plants": Citation(
            unit: "Unit 7",
            chapters: "Ch 26–28 Plant kingdom · Structure · Reproduction",
            pages: "p229"
        ),
        "Microorganisms & disease": Citation(
            unit: "Unit 4",
            chapters: "Ch 15 Bacteria · Ch 16 Viruses · Ch 18 Disease",
            pages: "p141"
        ),
        "Plants & animals": Citation(
            unit: "Unit 7–8",
            chapters: "Ch 26–29 Plants · Ch 30–35 Animals",
            pages: "p229"
        ),
    ]

    static func scienceCitation(for block: StudyBlock) -> Citation {
        let key = topicKey(for: block)
        if let hit = scienceByTopic[key] { return hit }
        return Citation(
            unit: "See index",
            chapters: "Match today's topic in BFN-Sci",
            pages: "p1"
        )
    }

    static func biologyCitation(for block: StudyBlock) -> Citation? {
        let key = topicKey(for: block)
        return biologyByTopic[key]
    }

    static func scienceOptionText(for block: StudyBlock) -> String {
        let c = scienceCitation(for: block)
        return "\(scienceCode) — \(scienceTitle) · \(c.shortLine)"
    }

    static func biologyOptionText(for block: StudyBlock) -> String {
        if let c = biologyCitation(for: block) {
            return "\(biologyCode) — \(biologyTitle) · \(c.shortLine)"
        }
        return "\(biologyCode) — \(biologyTitle) (ISBN \(biologyISBN)) · Fri review · quick bio recall"
    }
}
