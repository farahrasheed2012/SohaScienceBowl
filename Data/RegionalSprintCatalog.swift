import Foundation

/// Texas regional fast-recall sprint packs — know-cold + toss-ups beyond the summer MS schedule.
enum RegionalSprintCatalog {
    enum Track: String, CaseIterable, Identifiable {
        case lifeScience = "Life Science"
        case chemistry = "Chemistry"
        case physics = "Physics"

        var id: String { rawValue }

        var emoji: String {
            switch self {
            case .lifeScience: return "🧬"
            case .chemistry: return "🧪"
            case .physics: return "⚛️"
            }
        }

        var subject: Subject? {
            switch self {
            case .lifeScience: return .biology
            case .chemistry: return .chemistry
            case .physics: return .physics
            }
        }
    }

    struct Pack: Identifiable {
        let id: String
        let track: Track
        let title: String
        let subtitle: String
        let topicId: String
        let knowCold: [String]
        let tossups: [(question: String, answer: String)]

        var tossupCount: Int { tossups.count }
        var knowColdCount: Int { knowCold.count }
    }

    static let packs: [Pack] = [
        Pack(
            id: "ls-reg-resp-photosyn",
            track: .lifeScience,
            title: "Respiration & Photosynthesis",
            subtitle: "Glycolysis · Krebs · ETC · Calvin — locations & I/O",
            topicId: "ls-reg-resp-photosyn",
            knowCold: [
                "Glycolysis location? (Cytoplasm)",
                "Krebs cycle location? (Mitochondrial matrix)",
                "ETC location? (Inner mitochondrial membrane)",
                "Calvin cycle location? (Chloroplast stroma)",
                "ETC final electron acceptor? (Oxygen)",
                "Photosynthesis gas released? (Oxygen)",
                "Aerobic respiration gas consumed? (Oxygen)",
            ],
            tossups: [
                ("Where does glycolysis occur?", "Cytoplasm"),
                ("Where does the Krebs cycle occur?", "Mitochondrial matrix"),
                ("Where does the Calvin cycle occur?", "Chloroplast stroma"),
                ("Final electron acceptor in the ETC?", "Oxygen"),
                ("Light reactions location in chloroplast?", "Thylakoid membranes"),
            ]
        ),
        Pack(
            id: "ls-reg-genetics",
            track: .lifeScience,
            title: "Genetics & Molecular Biology",
            subtitle: "Helicase · polymerase · pedigrees · sex-linked",
            topicId: "ls-reg-genetics",
            knowCold: [
                "Enzyme that unwinds DNA? (Helicase)",
                "Enzyme that builds DNA strand? (DNA polymerase)",
                "Enzyme that builds RNA from DNA? (RNA polymerase)",
                "AB blood type inheritance? (Codominance)",
                "Hemophilia inheritance pattern? (X-linked recessive)",
                "Pedigree square shape? (Male)",
                "Pedigree circle shape? (Female)",
            ],
            tossups: [
                ("What enzyme unwinds DNA during replication?", "Helicase"),
                ("What enzyme synthesizes new DNA?", "DNA polymerase"),
                ("Blood type AB shows what inheritance?", "Codominance"),
                ("Hemophilia is commonly what type of trait?", "X-linked recessive"),
                ("Transcription produces what nucleic acid?", "mRNA"),
            ]
        ),
        Pack(
            id: "ls-reg-anatomy",
            track: .lifeScience,
            title: "Human Anatomy Sprint",
            subtitle: "Heart path · neuron · nephron",
            topicId: "ls-reg-anatomy",
            knowCold: [
                "Deoxygenated blood enters heart via? (Vena cava)",
                "RA to RV valve? (Tricuspid)",
                "RV to lungs via? (Pulmonary artery)",
                "Oxygenated blood returns via? (Pulmonary veins)",
                "LA to LV valve? (Mitral / bicuspid)",
                "LV pumps to body via? (Aorta)",
                "Neuron impulse carrier away from cell body? (Axon)",
                "Nephron filter structure? (Glomerulus)",
            ],
            tossups: [
                ("Valve between left atrium and left ventricle?", "Mitral (bicuspid)"),
                ("Artery carrying deoxygenated blood to lungs?", "Pulmonary artery"),
                ("Neuron part that receives signals?", "Dendrites"),
                ("Fatty layer that speeds nerve impulses?", "Myelin"),
                ("First step of nephron filtration?", "Glomerulus"),
            ]
        ),
        Pack(
            id: "ls-reg-phyla",
            track: .lifeScience,
            title: "Nine Animal Phyla",
            subtitle: "Porifera through Chordata — instant recognition",
            topicId: "ls-reg-phyla",
            knowCold: [
                "Sponges phylum? (Porifera)",
                "Jellyfish phylum? (Cnidaria)",
                "Flatworms phylum? (Platyhelminthes)",
                "Roundworms phylum? (Nematoda)",
                "Snails/clams phylum? (Mollusca)",
                "Segmented worms phylum? (Annelida)",
                "Insects/spiders phylum? (Arthropoda)",
                "Starfish phylum? (Echinodermata)",
                "Vertebrates phylum? (Chordata)",
            ],
            tossups: [
                ("Phylum of jellyfish and coral?", "Cnidaria"),
                ("Phylum of insects and spiders?", "Arthropoda"),
                ("Phylum of sponges?", "Porifera"),
                ("Phylum of starfish?", "Echinodermata"),
                ("Phylum of earthworms?", "Annelida"),
            ]
        ),
        Pack(
            id: "ch-reg-nomenclature",
            track: .chemistry,
            title: "IUPAC & Polyatomic Ions",
            subtitle: "Acetate · permanganate · dichromate · naming sprint",
            topicId: "ch-reg-nomenclature",
            knowCold: [
                "Acetate formula? (C₂H₃O₂⁻)",
                "Permanganate formula? (MnO₄⁻)",
                "Dichromate formula? (Cr₂O₇²⁻)",
                "Nitrate formula? (NO₃⁻)",
                "Sulfate formula? (SO₄²⁻)",
                "Hydroxide formula? (OH⁻)",
                "Ammonium formula? (NH₄⁺)",
            ],
            tossups: [
                ("Formula and charge of permanganate?", "MnO₄⁻"),
                ("Formula and charge of dichromate?", "Cr₂O₇²⁻"),
                ("Formula and charge of acetate?", "C₂H₃O₂⁻"),
                ("Prefix meaning 2 in covalent names?", "Di-"),
                ("Roman numerals used for which metals?", "Transition metals"),
            ]
        ),
        Pack(
            id: "ch-reg-trends",
            track: .chemistry,
            title: "Periodic Trends",
            subtitle: "Electronegativity · IE · radius · exceptions",
            topicId: "ch-reg-trends",
            knowCold: [
                "Most electronegative element? (Fluorine)",
                "Atomic radius across period L→R? (Decreases)",
                "Ionization energy down a group? (Decreases)",
                "Higher IE: N or O? (Nitrogen)",
                "Noble gas electron affinity? (~Zero / none)",
                "Metals tend to lose or gain electrons? (Lose)",
            ],
            tossups: [
                ("Highest electronegativity element?", "Fluorine"),
                ("Atomic radius trend across a period?", "Decreases"),
                ("Which has higher first ionization energy: N or O?", "Nitrogen"),
                ("Atomic radius trend down a group?", "Increases"),
                ("Group 1 elements called?", "Alkali metals"),
            ]
        ),
        Pack(
            id: "ch-reg-gas-laws",
            track: .chemistry,
            title: "Gas Laws & Molarity",
            subtitle: "Boyle · Charles · M = mol/L · dilution",
            topicId: "ch-reg-gas-laws",
            knowCold: [
                "Boyle's Law? (P₁V₁ = P₂V₂)",
                "Charles's Law ratio? (V₁/T₁ = V₂/T₂)",
                "Molarity formula? (M = mol/L)",
                "Dilution formula? (M₁V₁ = M₂V₂)",
                "Temperature unit for gas laws? (Kelvin)",
                "1 mol ideal gas at STP volume? (~22.4 L)",
            ],
            tossups: [
                ("State Boyle's Law.", "P₁V₁ = P₂V₂"),
                ("2 atm, 4 L → 4 atm at constant T: new volume?", "2 L"),
                ("Molarity of 2 mol in 0.5 L?", "4 M"),
                ("Charles's Law relates volume to what?", "Temperature (Kelvin)"),
                ("Dilution equation?", "M₁V₁ = M₂V₂"),
            ]
        ),
        Pack(
            id: "ch-reg-acids",
            track: .chemistry,
            title: "Acids & Bases (Advanced)",
            subtitle: "Arrhenius · Brønsted-Lowry · strong acids",
            topicId: "ch-reg-acids",
            knowCold: [
                "Arrhenius acid produces? (H⁺)",
                "Arrhenius base produces? (OH⁻)",
                "Brønsted acid does? (Donates H⁺)",
                "Brønsted base does? (Accepts H⁺)",
                "Three strong acids? (HCl, HNO₃, H₂SO₄)",
                "Strong base example? (NaOH)",
                "Neutral pH? (7)",
            ],
            tossups: [
                ("Arrhenius base ion in water?", "OH⁻"),
                ("Is HCl Arrhenius acid or base?", "Acid"),
                ("NH₃ is Brønsted-Lowry acid or base?", "Base"),
                ("pH of neutral solution?", "7"),
                ("Name two strong acids besides HCl.", "HNO₃ and H₂SO₄"),
            ]
        ),
        Pack(
            id: "ps-reg-kinematics",
            track: .physics,
            title: "Kinematics Sprint",
            subtitle: "v = d/t · g ≈ 9.8 · constant acceleration",
            topicId: "ps-reg-kinematics",
            knowCold: [
                "Average speed formula? (v = d/t)",
                "Acceleration formula? (a = Δv/Δt)",
                "g near Earth surface? (~9.8 m/s²)",
                "At max height, vertical velocity? (Zero)",
                "Speed scalar or vector? (Scalar)",
                "Velocity scalar or vector? (Vector)",
            ],
            tossups: [
                ("Approximate g in m/s²?", "9.8"),
                ("Dropped from rest, speed after 2 s (g=10)?", "20 m/s"),
                ("Formula relating v, d, t at constant speed?", "v = d/t"),
                ("At projectile peak, vertical velocity?", "0"),
                ("Acceleration units in SI?", "m/s²"),
            ]
        ),
        Pack(
            id: "ps-reg-forces",
            track: .physics,
            title: "Forces (Advanced)",
            subtitle: "Centripetal · torque · free-body diagrams",
            topicId: "ps-reg-forces",
            knowCold: [
                "Newton's 2nd Law? (F = ma)",
                "Centripetal force formula? (mv²/r)",
                "Torque formula? (rF sin θ)",
                "Centripetal direction? (Toward center)",
                "Friction opposes? (Motion / sliding)",
                "Net force zero means acceleration? (Zero)",
            ],
            tossups: [
                ("Centripetal force formula?", "mv²/r"),
                ("Torque formula?", "rF sin θ"),
                ("Car turning: friction provides what force?", "Centripetal"),
                ("ΣF = 0 implies what about acceleration?", "Zero acceleration"),
                ("Unit of force in SI?", "Newton (N)"),
            ]
        ),
        Pack(
            id: "ps-reg-waves",
            track: .physics,
            title: "Optics & Waves Sprint",
            subtitle: "EM spectrum · Snell · f · T · λ",
            topicId: "ps-reg-waves",
            knowCold: [
                "Wave equation? (v = fλ)",
                "Period formula? (T = 1/f)",
                "Snell's Law? (n₁ sin θ₁ = n₂ sin θ₂)",
                "Highest frequency EM radiation? (Gamma rays)",
                "Speed of light in vacuum? (~3 × 10⁸ m/s)",
                "Reflection law? (Angle of incidence = angle of reflection)",
            ],
            tossups: [
                ("State Snell's Law.", "n₁ sin θ₁ = n₂ sin θ₂"),
                ("Highest frequency in EM spectrum?", "Gamma rays"),
                ("Period T in terms of frequency?", "T = 1/f"),
                ("Wave speed formula?", "v = fλ"),
                ("Visible light sits between IR and what?", "Ultraviolet"),
            ]
        ),
    ]

    static func pack(forTopicId topicId: String) -> Pack? {
        packs.first { $0.topicId == topicId }
    }

    static func pack(id: String) -> Pack? {
        packs.first { $0.id == id }
    }

    static func packs(for track: Track) -> [Pack] {
        packs.filter { $0.track == track }
    }

    static var allTopicIds: [String] {
        packs.map(\.topicId)
    }
}
