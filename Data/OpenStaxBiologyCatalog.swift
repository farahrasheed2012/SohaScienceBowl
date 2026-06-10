import Foundation

/// OpenStax *Concepts of Biology* — section-level index (online book TOC).
enum OpenStaxBiologyCatalog {
    struct Section: Hashable {
        let id: String
        let title: String
        let path: String
    }

    private static let base = "https://openstax.org/books/concepts-biology/pages/"

    private static let byChapter: [Int: [Section]] = [
        1: [
            Section(id: "1.1", title: "Themes and Concepts of Biology", path: "1-1-themes-and-concepts-of-biology"),
            Section(id: "1.2", title: "The Process of Science", path: "1-2-the-process-of-science"),
        ],
        3: [
            Section(id: "3.1", title: "How Cells Are Studied", path: "3-1-how-cells-are-studied"),
            Section(id: "3.2", title: "Comparing Prokaryotic and Eukaryotic Cells", path: "3-2-comparing-prokaryotic-and-eukaryotic-cells"),
            Section(id: "3.3", title: "Eukaryotic Cells", path: "3-3-eukaryotic-cells"),
            Section(id: "3.4", title: "The Cell Membrane", path: "3-4-the-cell-membrane"),
            Section(id: "3.5", title: "Passive Transport", path: "3-5-passive-transport"),
            Section(id: "3.6", title: "Active Transport", path: "3-6-active-transport"),
        ],
        4: [
            Section(id: "4.1", title: "Energy and Metabolism", path: "4-1-energy-and-metabolism"),
            Section(id: "4.2", title: "Glycolysis", path: "4-2-glycolysis"),
            Section(id: "4.3", title: "Citric Acid Cycle and Oxidative Phosphorylation", path: "4-3-citric-acid-cycle-and-oxidative-phosphorylation"),
            Section(id: "4.4", title: "Fermentation", path: "4-4-fermentation"),
            Section(id: "4.5", title: "Connections to Other Metabolic Pathways", path: "4-5-connections-to-other-metabolic-pathways"),
        ],
        5: [
            Section(id: "5.1", title: "Overview of Photosynthesis", path: "5-1-overview-of-photosynthesis"),
            Section(id: "5.2", title: "The Light-Dependent Reactions of Photosynthesis", path: "5-2-the-light-dependent-reactions-of-photosynthesis"),
            Section(id: "5.3", title: "The Calvin Cycle", path: "5-3-the-calvin-cycle"),
        ],
        6: [
            Section(id: "6.1", title: "The Importance of Photosynthesis and Cellular Respiration", path: "6-1-the-importance-of-photosynthesis-and-cellular-respiration"),
            Section(id: "6.2", title: "Aerobic Respiration", path: "6-2-aerobic-respiration"),
            Section(id: "6.3", title: "Anaerobic Respiration", path: "6-3-anaerobic-respiration"),
        ],
        7: [
            Section(id: "7.1", title: "Sexual Reproduction", path: "7-1-sexual-reproduction"),
            Section(id: "7.2", title: "Meiosis", path: "7-2-meiosis"),
            Section(id: "7.3", title: "Variations in Meiosis", path: "7-3-variations-in-meiosis"),
        ],
        8: [
            Section(id: "8.1", title: "Mendel's Experiments", path: "8-1-mendels-experiments"),
            Section(id: "8.2", title: "Laws of Inheritance", path: "8-2-laws-of-inheritance"),
            Section(id: "8.3", title: "Extensions of the Laws of Inheritance", path: "8-3-extensions-of-the-laws-of-inheritance"),
        ],
        11: [
            Section(id: "11.1", title: "Evolution and Its Processes", path: "11-1-evolution-and-its-processes"),
            Section(id: "11.2", title: "Evidence of Evolution", path: "11-2-evidence-of-evolution"),
            Section(id: "11.3", title: "Fossils and the History of Life", path: "11-3-fossils-and-the-history-of-life"),
        ],
        12: [
            Section(id: "12.1", title: "Organisms and Their Environment", path: "12-1-organisms-and-their-environment"),
            Section(id: "12.2", title: "The Animal Body: Basic Form and Function", path: "12-2-the-animal-body-basic-form-and-function"),
            Section(id: "12.3", title: "Animal Nutrition and the Digestive System", path: "12-3-animal-nutrition-and-the-digestive-system"),
        ],
        13: [
            Section(id: "13.1", title: "Prokaryotic Diversity", path: "13-1-prokaryotic-diversity"),
            Section(id: "13.2", title: "Eukaryotic Diversity", path: "13-2-eukaryotic-diversity"),
            Section(id: "13.3", title: "Plant Diversity", path: "13-3-plant-diversity"),
        ],
        14: [
            Section(id: "14.1", title: "The Plant Body", path: "14-1-the-plant-body"),
            Section(id: "14.2", title: "Transport of Water and Solutes in Plants", path: "14-2-transport-of-water-and-solutes-in-plants"),
            Section(id: "14.3", title: "Plant Reproduction", path: "14-3-plant-reproduction"),
        ],
        15: [
            Section(id: "15.1", title: "The Animal Body: Basic Form and Function", path: "15-1-the-animal-body-basic-form-and-function"),
            Section(id: "15.2", title: "Animal Primary Tissues", path: "15-2-animal-primary-tissues"),
            Section(id: "15.3", title: "Homeostasis", path: "15-3-homeostasis"),
        ],
        16: [
            Section(id: "16.1", title: "Digestive System Processes", path: "16-1-digestive-system-processes"),
            Section(id: "16.2", title: "The Nervous System", path: "16-2-the-nervous-system"),
            Section(id: "16.3", title: "The Circulatory System", path: "16-3-the-circulatory-system"),
        ],
        17: [
            Section(id: "17.1", title: "Innate Immunity", path: "17-1-innate-immunity"),
            Section(id: "17.2", title: "Adaptive Immunity", path: "17-2-adaptive-immunity"),
            Section(id: "17.3", title: "Disruptions in the Immune System", path: "17-3-disruptions-in-the-immune-system"),
        ],
        18: [
            Section(id: "18.1", title: "The Musculoskeletal System", path: "18-1-the-musculoskeletal-system"),
            Section(id: "18.2", title: "The Respiratory System", path: "18-2-the-respiratory-system"),
            Section(id: "18.3", title: "The Excretory System", path: "18-3-the-excretory-system"),
        ],
        19: [
            Section(id: "19.1", title: "Population and Community Ecology", path: "19-1-population-and-community-ecology"),
            Section(id: "19.2", title: "Ecosystems and the Biosphere", path: "19-2-ecosystems-and-the-biosphere"),
            Section(id: "19.3", title: "Conservation and Biodiversity", path: "19-3-conservation-and-biodiversity"),
        ],
        20: [
            Section(id: "20.1", title: "Population Demography", path: "20-1-population-demography"),
            Section(id: "20.2", title: "Life Histories and Natural Selection", path: "20-2-life-histories-and-natural-selection"),
            Section(id: "20.3", title: "Environmental Limits to Population Growth", path: "20-3-environmental-limits-to-population-growth"),
        ],
    ]

    static func sections(chapter: Int) -> [Section] {
        byChapter[chapter] ?? []
    }

    static func section(chapter: Int, id: String) -> Section? {
        sections(chapter: chapter).first { $0.id == id }
    }

    static func url(for section: Section) -> URL? {
        URL(string: base + section.path)
    }

    /// e.g. `Ch 3 §3.2–3.4 — Eukaryotic cells & membrane`
    static func formatAssignment(chapter: Int, sectionIds: [String], chapterTitle: String? = nil) -> String {
        guard !sectionIds.isEmpty else { return "Ch \(chapter)" }
        let range = sectionRangeLabel(sectionIds)
        let titleSuffix = chapterTitle.map { " — \($0)" } ?? ""
        if sectionIds.count == 1, let sec = section(chapter: chapter, id: sectionIds[0]) {
            return "Ch \(chapter) §\(sec.id) — \(sec.title)"
        }
        return "Ch \(chapter) §\(range)\(titleSuffix)"
    }

    static func links(chapter: Int, sectionIds: [String]) -> [StudyBookLink] {
        sectionIds.compactMap { id in
            guard let sec = section(chapter: chapter, id: id), let url = url(for: sec) else { return nil }
            return StudyBookLink(label: "OSB §\(sec.id) — \(sec.title)", url: url)
        }
    }

    private static func sectionRangeLabel(_ ids: [String]) -> String {
        guard let first = ids.first else { return "" }
        if ids.count == 1 { return first }
        if let last = ids.last, first.prefix(while: { $0 != "." }).count > 0 {
            return "\(first)–\(last.split(separator: ".").last ?? "")"
        }
        return ids.joined(separator: ", ")
    }
}
