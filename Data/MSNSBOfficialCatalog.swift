import Foundation

/// Middle School National Science Bowl — **official DOE competition categories and study guidance only.**
/// DOE does not publish a granular subtopic syllabus; questions are sourced from textbooks (Tips & Resources).
enum MSNSBOfficialCatalog {
    static let rulesSourceTitle = "2026 National Science Bowl Rules"
    static let rulesSourceDetail = "Rule 3-1 — question categories for middle school and high school"
    static let rulesPDFURL = URL(string: "https://science.osti.gov/-/media/wdts/nsb/pdf/NSB-Resources/Rules2026.pdf")!

    static let faqURL = URL(string: "https://science.osti.gov/wdts/nsb/FAQ")!
    static let tipsURL = URL(string: "https://science.osti.gov/wdts/nsb/Regional-Competitions/Resources/Tips-and-Resources")!
    static let sampleQuestionsURL = URL(string: "https://science.osti.gov/wdts/nsb/Regional-Competitions/Resources/MS-Sample-Questions")!

    static let regionalContentLevel =
        "Middle School Regional — 6th through 8th grade science and Algebra II textbooks"
    static let nationalContentLevel =
        "Middle School National — honors-level high school science and Algebra II textbooks"

    /// Middle school topic areas described on DOE Tips & Resources (not a numbered chapter syllabus).
    /// https://science.osti.gov/wdts/nsb/Regional-Competitions/Resources/Tips-and-Resources
    struct TopicScope: Identifiable, Hashable {
        let id: String
        let name: String
        let topics: String
        /// Rule 3-1 competition category IDs this study area maps to.
        let competitionCategoryIds: [String]
    }

    static let topicScopes: [TopicScope] = [
        TopicScope(
            id: "life-science",
            name: "Life Science",
            topics: "Cell biology, genetics, anatomy and physiology, plant biology, ecology, and animal behavior.",
            competitionCategoryIds: ["biology"]
        ),
        TopicScope(
            id: "physical-science",
            name: "Physical Science",
            topics: "Chemistry — reactions, periodic table, states of matter. Physics — forces, motion, waves, electromagnetism, thermodynamics.",
            competitionCategoryIds: ["chemistry", "physics"]
        ),
        TopicScope(
            id: "mathematics",
            name: "Mathematics",
            topics: "Algebra I and II, geometry, probability, statistics, and general number sense.",
            competitionCategoryIds: ["mathematics"]
        ),
    ]

    static let earthAndEnergyNote =
        "Earth and Space Science and Energy are also official Rule 3-1 categories — prep from DOE sample questions and Tips & Resources when you specialize in those areas."

    static func topicScope(forCategoryId categoryId: String) -> TopicScope? {
        topicScopes.first { $0.competitionCategoryIds.contains(categoryId) }
    }

    static func topicScopeLabel(forCategoryId categoryId: String) -> String? {
        topicScope(forCategoryId: categoryId)?.topics
    }

    struct Category: Identifiable, Hashable {
        let id: String
        let name: String
        let emoji: String
        /// How middle school sample question packets often label this area (DOE MS Sample Questions).
        let samplePacketLabels: [String]
        /// DOE FAQ wording for middle school question areas.
        let faqGrouping: String?
        let tipsSubjectHeading: String
        let recommendedResources: [String]
        /// Encyclopedia `subject` strings in this app that align with this DOE category for study.
        let encyclopediaSubjectKeys: [String]

        var encyclopediaSubjects: [NSBSubject] {
            encyclopediaSubjectKeys.compactMap { key in
                NSBSubject.allCases.first { $0.rawValue == key }
            }
        }
    }

    /// Six competition categories — verbatim from DOE Rules 2026 §3-1.
    static let categories: [Category] = [
        Category(
            id: "biology",
            name: "Biology",
            emoji: "🧬",
            samplePacketLabels: ["Life Science"],
            faqGrouping: "life science",
            tipsSubjectHeading: "Life Science",
            recommendedResources: [
                "Focus on Life Science, Prentice Hall (California Edition)",
                "Campbell, Biology: Concepts & Connections, 7th Edition",
                "Sadava, Life",
                "Glencoe Biology, McGraw-Hill",
                "Campbell, Biology",
                "Raven, Biology"
            ],
            encyclopediaSubjectKeys: ["Life Science"]
        ),
        Category(
            id: "chemistry",
            name: "Chemistry",
            emoji: "🧪",
            samplePacketLabels: ["Physical Science"],
            faqGrouping: "physical science",
            tipsSubjectHeading: "Physical Science",
            recommendedResources: [
                "Physical Science, McGraw-Hill",
                "Hewitt, Conceptual Physical Science",
                "Giancoli, Physics",
                "Zumdahl, Chemistry"
            ],
            encyclopediaSubjectKeys: ["Chemistry"]
        ),
        Category(
            id: "earth-space",
            name: "Earth and Space Science",
            emoji: "🌍",
            samplePacketLabels: ["Earth and Space Science"],
            faqGrouping: "earth and space science",
            tipsSubjectHeading: "Earth and Space Science",
            recommendedResources: [
                "Heath Earth Science",
                "Glencoe Earth Science",
                "Seeds, Foundations of Astronomy",
                "Tarbuck and Lutgens, Foundations of Earth Science"
            ],
            encyclopediaSubjectKeys: ["Earth & Space Science"]
        ),
        Category(
            id: "energy",
            name: "Energy",
            emoji: "⚡",
            samplePacketLabels: ["Energy"],
            faqGrouping: "energy",
            tipsSubjectHeading: "Energy",
            recommendedResources: [
                "U.S. Department of Energy National Laboratory websites"
            ],
            encyclopediaSubjectKeys: ["Energy"]
        ),
        Category(
            id: "mathematics",
            name: "Mathematics",
            emoji: "📐",
            samplePacketLabels: ["Math", "Mathematics"],
            faqGrouping: "mathematics",
            tipsSubjectHeading: "Math",
            recommendedResources: [
                "Algebra 1",
                "Geometry",
                "Algebra 2"
            ],
            encyclopediaSubjectKeys: ["Math"]
        ),
        Category(
            id: "physics",
            name: "Physics",
            emoji: "⚛️",
            samplePacketLabels: ["Physical Science"],
            faqGrouping: "physical science",
            tipsSubjectHeading: "Physical Science",
            recommendedResources: [
                "Physical Science, McGraw-Hill",
                "Hewitt, Conceptual Physical Science",
                "Giancoli, Physics",
                "Zumdahl, Chemistry"
            ],
            encyclopediaSubjectKeys: ["Physical Science"]
        ),
    ]

    static func category(for id: String) -> Category? {
        categories.first { $0.id == id }
    }
}
