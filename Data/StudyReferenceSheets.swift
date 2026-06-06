import Foundation

/// Shared reference tables from science-bowl-prep — shown when relevant to a block.
enum StudyReferenceSheets {
    static func sheets(for block: StudyBlock) -> [ReadingSection] {
        var result: [ReadingSection] = []
        let topic = block.primaryTopic.lowercased()

        if block.subject == .chemistry && (topic.contains("atom") || topic.contains("periodic") || topic.contains("element")) {
            result.append(top20Elements)
        }
        if block.subject == .chemistry && (topic.contains("ion") || topic.contains("compound") || block.week >= 5) {
            if !result.contains(where: { $0.title == commonIons.title }) {
                result.append(commonIons)
            }
        }
        if block.subject == .biology && (topic.contains("cell") || block.week == 1 || block.week == 5 || block.week == 9) {
            result.append(organelles)
        }
        if block.subject == .biology && (topic.contains("energy") || topic.contains("photo") || topic.contains("respiration") || block.week == 5) {
            result.append(photoRespiration)
        }
        if block.subject == .physics || block.subject == .chemistry {
            if topic.contains("lab") || topic.contains("measurement") || block.week == 4 && block.subject == .chemistry {
                result.append(siBaseUnits)
            }
        }
        if block.subject == .physics {
            result.append(physicsFormulas)
        }
        if block.subject == .biology && (topic.contains("ecology") || block.week == 3 || block.week == 7 || block.week == 10) {
            result.append(symbiosisTypes)
        }
        return result
    }

    private static let top20Elements = ReadingSection(
        title: "Top 20 elements — symbols to memorize",
        body: """
        H (1) Hydrogen · He (2) Helium · Li (3) Lithium · Be (4) Beryllium · B (5) Boron
        C (6) Carbon · N (7) Nitrogen · O (8) Oxygen · F (9) Fluorine · Ne (10) Neon
        Na (11) Sodium · Mg (12) Magnesium · Al (13) Aluminum · Si (14) Silicon · P (15) Phosphorus
        S (16) Sulfur · Cl (17) Chlorine · Ar (18) Argon · K (19) Potassium · Ca (20) Calcium

        NSB tip: They often ask symbol from name, name from symbol, or atomic number. Chlorine = 17 protons = Cl.
        """
    )

    private static let commonIons = ReadingSection(
        title: "Common ions & formulas",
        body: """
        Water H₂O · Carbon dioxide CO₂ · Table salt NaCl · Glucose C₆H₁₂O₆
        Sodium ion Na⁺ · Chloride Cl⁻ · Oxide O²⁻ · Calcium Ca²⁺ · Carbonate CO₃²⁻ · Hydroxide OH⁻

        Ionic bond = metal + nonmetal (electrons transferred). Covalent = nonmetals share electrons (H₂O, CO₂).
        """
    )

    private static let organelles = ReadingSection(
        title: "Organelle function pairs",
        body: """
        Nucleus — stores DNA, controls the cell
        Mitochondria — ATP / cellular respiration
        Ribosome — protein synthesis
        Chloroplast — photosynthesis (plants)
        Cell wall — structure & support (plants)
        Cell membrane — controls what enters and exits
        Lysosome — breaks down waste (many eukaryotes)
        Golgi apparatus — packages and ships proteins
        Rough ER — protein synthesis (has ribosomes)
        Smooth ER — lipids (no ribosomes on surface)

        Plant-only: cell wall + chloroplast. Prokaryotes lack a nucleus.
        """
    )

    private static let photoRespiration = ReadingSection(
        title: "Photosynthesis vs cellular respiration",
        body: """
        Photosynthesis (chloroplast)
        Inputs: CO₂ + H₂O + light energy
        Outputs: glucose + O₂

        Cellular respiration (mitochondria)
        Inputs: glucose + O₂
        Outputs: CO₂ + H₂O + ATP

        ATP is the cell's energy currency. These processes are roughly reverse of each other — O₂ is released in photosynthesis and used in respiration.
        """
    )

    private static let siBaseUnits = ReadingSection(
        title: "SI base units",
        body: """
        Length — meter (m)
        Mass — kilogram (kg)
        Time — second (s)
        Temperature — kelvin (K) · K = °C + 273
        Amount of substance — mole (mol)
        Electric current — ampere (A)

        Read a graduated cylinder at eye level at the bottom of the meniscus. Always wear safety goggles in lab.
        """
    )

    private static let physicsFormulas = ReadingSection(
        title: "Physics formula set",
        body: """
        v = d/t — average speed from distance and time
        F = ma — net force, mass, acceleration
        W = Fd — work (joules)
        P = W/t — power
        p = mv — momentum
        PE = mgh — gravitational potential energy
        KE = ½mv² — kinetic energy
        v = fλ — wave speed, frequency, wavelength
        V = IR — Ohm's law

        Mass stays the same everywhere; weight = mg changes with gravity.
        """
    )

    private static let symbiosisTypes = ReadingSection(
        title: "Symbiosis & ecology quick reference",
        body: """
        Producer — makes food from sunlight (first in food chain)
        Consumer — eats other organisms
        Decomposer — breaks down dead matter

        Mutualism — both species benefit
        Commensalism — one benefits, other unaffected
        Parasitism — one benefits, other harmed

        ~10% energy rule: only about 10% of energy passes to the next trophic level.
        Carrying capacity (K) = maximum population an environment can support.
        """
    )
}
