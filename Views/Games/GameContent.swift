import Foundation
import SwiftUI

enum GameContent {
    // MARK: - Science Wordle

    static let curatedFiveLetterTerms: [String] = [
        "ACIDS", "ALGAE", "AMINO", "ARRAY", "ATOMS", "BEAMS", "BONDS", "BRAIN",
        "CELLS", "CHART", "CLONE", "COMET", "CYCLE", "DELTA", "DENSE", "EARTH",
        "ENZYM", "FIBER", "FIELD", "FLAME", "FLUID", "FOCUS", "FORCE", "FUNGI",
        "GAMMA", "GENES", "GLAND", "GLASS", "GRIDS", "HABIT", "HEATS", "HERTZ",
        "HUMAN", "HYDRO", "IONIC", "LASER", "LIGHT", "LUNAR", "MAGMA", "METAL",
        "MICRO", "MOLES", "MOTOR", "NITRO", "NOBLE", "NODES", "OCEAN", "OPTIC",
        "ORBIT", "ORGAN", "OXIDE", "PHASE", "PHOTO", "PIVOT", "PLANT", "PLASM",
        "POLAR", "POWER", "PRESS", "PRISM", "PROOF", "PULSE", "QUARK", "RADAR",
        "RADIO", "REACT", "RELAY", "RIGID", "ROBOT", "ROCKS", "ROOTS", "SALTS",
        "SCALE", "SCANS", "SEEDS", "SENSE", "SHOCK", "SIGMA", "SLIDE", "SOLAR",
        "SOLID", "SONAR", "SOUND", "SPACE", "SPARK", "SPERM", "SPINE", "SPORE",
        "STARS", "STEAM", "STEMS", "STOMA", "STORM", "STRAW", "SUGAR", "SWAMP",
        "SWEAT", "TEMPO", "TENSE", "TIDES", "TORCH", "TOXIN", "TRACE", "TRACK",
        "TRAIT", "TREES", "TREND", "TRIAL", "ULTRA", "UNITS", "URINE", "VALVE",
        "VAPOR", "VIRAL", "VIRUS", "VITAL", "VOCAL", "VOLTS", "WASTE", "WATER",
        "WAVES", "WHALE", "WHEAT", "WIDTH", "WINDS", "WIRED", "WORMS", "YEAST",
        "ZONES",
    ]

    static var wordleBank: [String] {
        let elementNames = ElementData.first20
            .map { $0.name.uppercased() }
            .filter { $0.count == 5 }
        let merged = Set(curatedFiveLetterTerms + elementNames)
        return merged.sorted()
    }

    static func dailyWordleWord(on date: Date = Date()) -> String {
        let bank = wordleBank
        guard !bank.isEmpty else { return "ATOMS" }
        let day = Calendar.current.ordinality(of: .day, in: .year, for: date) ?? 1
        return bank[day % bank.count]
    }

    static func randomWordleWord(excluding: String? = nil) -> String {
        let bank = wordleBank.filter { $0 != excluding?.uppercased() }
        return bank.randomElement() ?? "ATOMS"
    }

    // MARK: - True or False Blitz

    struct TrueFalseStatement: Identifiable, Hashable {
        let id: String
        let statement: String
        let isTrue: Bool
        let hint: String
        let subject: Subject
    }

    static let trueFalseStatements: [TrueFalseStatement] = [
        TrueFalseStatement(id: "tf1", statement: "Photosynthesis occurs in the chloroplasts of plant cells.", isTrue: true, hint: "Chloroplasts capture light energy.", subject: .biology),
        TrueFalseStatement(id: "tf2", statement: "The mitochondria is the site of cellular respiration.", isTrue: true, hint: "Mitochondria produce ATP.", subject: .biology),
        TrueFalseStatement(id: "tf3", statement: "Animal cells have a rigid cell wall made of cellulose.", isTrue: false, hint: "Plant cells have cell walls; animal cells do not.", subject: .biology),
        TrueFalseStatement(id: "tf4", statement: "DNA is found in the nucleus of eukaryotic cells.", isTrue: true, hint: "The nucleus stores genetic material.", subject: .biology),
        TrueFalseStatement(id: "tf5", statement: "All bacteria are harmful to humans.", isTrue: false, hint: "Many bacteria are beneficial.", subject: .biology),
        TrueFalseStatement(id: "tf6", statement: "Osmosis is the diffusion of water across a membrane.", isTrue: true, hint: "Water moves from high to low concentration.", subject: .biology),
        TrueFalseStatement(id: "tf7", statement: "Ribosomes are found only in the nucleus.", isTrue: false, hint: "Ribosomes are in cytoplasm and on ER.", subject: .biology),
        TrueFalseStatement(id: "tf8", statement: "Meiosis produces four genetically unique haploid cells.", isTrue: true, hint: "Meiosis makes gametes.", subject: .biology),
        TrueFalseStatement(id: "tf9", statement: "Carbon has an atomic number of 6.", isTrue: true, hint: "C is element 6.", subject: .chemistry),
        TrueFalseStatement(id: "tf10", statement: "Noble gases readily form chemical bonds.", isTrue: false, hint: "Noble gases have full outer shells.", subject: .chemistry),
        TrueFalseStatement(id: "tf11", statement: "NaCl is an ionic compound.", isTrue: true, hint: "Sodium chloride forms ions in solution.", subject: .chemistry),
        TrueFalseStatement(id: "tf12", statement: "pH 7 is neutral on the pH scale.", isTrue: true, hint: "Pure water is pH 7.", subject: .chemistry),
        TrueFalseStatement(id: "tf13", statement: "A catalyst speeds up a chemical reaction without being consumed.", isTrue: true, hint: "Enzymes are biological catalysts.", subject: .chemistry),
        TrueFalseStatement(id: "tf14", statement: "Oxygen gas is diatomic (O₂).", isTrue: true, hint: "Most common form of oxygen is O₂.", subject: .chemistry),
        TrueFalseStatement(id: "tf15", statement: "Acids have a pH greater than 7.", isTrue: false, hint: "Acids have pH below 7.", subject: .chemistry),
        TrueFalseStatement(id: "tf16", statement: "Force equals mass times acceleration (F = ma).", isTrue: true, hint: "Newton's second law.", subject: .physics),
        TrueFalseStatement(id: "tf17", statement: "Sound travels faster in air than in steel.", isTrue: false, hint: "Sound is faster in denser media.", subject: .physics),
        TrueFalseStatement(id: "tf18", statement: "Light travels in a straight line in a uniform medium.", isTrue: true, hint: "Rectilinear propagation.", subject: .physics),
        TrueFalseStatement(id: "tf19", statement: "Gravity on the Moon is stronger than on Earth.", isTrue: false, hint: "Moon gravity is about 1/6 of Earth's.", subject: .physics),
        TrueFalseStatement(id: "tf20", statement: "Energy cannot be created or destroyed, only transformed.", isTrue: true, hint: "Law of conservation of energy.", subject: .physics),
        TrueFalseStatement(id: "tf21", statement: "Voltage is measured in amperes.", isTrue: false, hint: "Voltage is in volts; current is amperes.", subject: .physics),
        TrueFalseStatement(id: "tf22", statement: "Friction always opposes motion.", isTrue: true, hint: "Friction acts against the direction of motion.", subject: .physics),
        TrueFalseStatement(id: "tf23", statement: "Helium is a noble gas.", isTrue: true, hint: "He is in group 18.", subject: .chemistry),
        TrueFalseStatement(id: "tf24", statement: "Protons carry a negative charge.", isTrue: false, hint: "Protons are positive; electrons are negative.", subject: .physics),
    ]

    static func shuffledTrueFalseStatements(count: Int = 15) -> [TrueFalseStatement] {
        Array(trueFalseStatements.shuffled().prefix(count))
    }

    // MARK: - Molecule Match

    struct MoleculePair: Identifiable, Hashable {
        let id: String
        let formula: String
        let name: String
    }

    static let moleculePairs: [MoleculePair] = [
        MoleculePair(id: "m1", formula: "H₂O", name: "Water"),
        MoleculePair(id: "m2", formula: "CO₂", name: "Carbon dioxide"),
        MoleculePair(id: "m3", formula: "NaCl", name: "Salt"),
        MoleculePair(id: "m4", formula: "O₂", name: "Oxygen"),
        MoleculePair(id: "m5", formula: "CH₄", name: "Methane"),
        MoleculePair(id: "m6", formula: "NH₃", name: "Ammonia"),
        MoleculePair(id: "m7", formula: "HCl", name: "Hydrochloric acid"),
        MoleculePair(id: "m8", formula: "C₆H₁₂O₆", name: "Glucose"),
    ]

    // MARK: - Cell Builder

    enum CellType: String, CaseIterable, Identifiable {
        case animal
        case plant

        var id: String { rawValue }

        var title: String {
            switch self {
            case .animal: return "Animal Cell"
            case .plant: return "Plant Cell"
            }
        }
    }

    struct Organelle: Identifiable, Hashable {
        let id: String
        let name: String
        let zoneID: String
        let cellTypes: Set<CellType>
        let icon: String
    }

    struct CellZone: Identifiable, Hashable {
        let id: String
        let label: String
        let cellTypes: Set<CellType>
        /// Normalized center (0–1) within the cell diagram.
        let centerX: CGFloat
        let centerY: CGFloat
        let radius: CGFloat
    }

    static let cellZones: [CellZone] = [
        CellZone(id: "nucleus", label: "Nucleus", cellTypes: [.animal, .plant], centerX: 0.5, centerY: 0.45, radius: 0.14),
        CellZone(id: "mitochondria", label: "Mitochondria", cellTypes: [.animal, .plant], centerX: 0.28, centerY: 0.62, radius: 0.10),
        CellZone(id: "chloroplast", label: "Chloroplast", cellTypes: [.plant], centerX: 0.72, centerY: 0.55, radius: 0.10),
        CellZone(id: "vacuole", label: "Vacuole", cellTypes: [.plant], centerX: 0.65, centerY: 0.35, radius: 0.12),
        CellZone(id: "ribosome", label: "Ribosome", cellTypes: [.animal, .plant], centerX: 0.35, centerY: 0.38, radius: 0.08),
        CellZone(id: "membrane", label: "Cell Membrane", cellTypes: [.animal, .plant], centerX: 0.5, centerY: 0.78, radius: 0.10),
        CellZone(id: "wall", label: "Cell Wall", cellTypes: [.plant], centerX: 0.5, centerY: 0.12, radius: 0.10),
    ]

    static let organelles: [Organelle] = [
        Organelle(id: "nucleus", name: "Nucleus", zoneID: "nucleus", cellTypes: [.animal, .plant], icon: "circle.fill"),
        Organelle(id: "mitochondria", name: "Mitochondria", zoneID: "mitochondria", cellTypes: [.animal, .plant], icon: "oval.fill"),
        Organelle(id: "chloroplast", name: "Chloroplast", zoneID: "chloroplast", cellTypes: [.plant], icon: "leaf.fill"),
        Organelle(id: "vacuole", name: "Vacuole", zoneID: "vacuole", cellTypes: [.plant], icon: "drop.fill"),
        Organelle(id: "ribosome", name: "Ribosome", zoneID: "ribosome", cellTypes: [.animal, .plant], icon: "circle.grid.2x2.fill"),
        Organelle(id: "membrane", name: "Cell Membrane", zoneID: "membrane", cellTypes: [.animal, .plant], icon: "circle.dashed"),
        Organelle(id: "wall", name: "Cell Wall", zoneID: "wall", cellTypes: [.plant], icon: "square.dashed"),
    ]

    static func organelles(for cellType: CellType) -> [Organelle] {
        organelles.filter { $0.cellTypes.contains(cellType) }
    }

    static func zones(for cellType: CellType) -> [CellZone] {
        cellZones.filter { $0.cellTypes.contains(cellType) }
    }
}
