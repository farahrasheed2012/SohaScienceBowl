import Foundation

/// Full deep-dive study text from science-bowl-prep.md (weeks 1–10).
enum DeepDiveContent {
    private struct Key: Hashable {
        var week: Int
        var day: Weekday
        var subject: Subject
    }

    static func passWorkflow(week: Int, pass: StudyPass) -> String? {
        switch pass {
        case .pass1 where week >= 1 && week <= 4:
            return """
            Pass 1 block workflow (Weeks 1–4):
            • Minutes 0–5 — Quick recall (5 toss-ups from last week, same subject)
            • Minutes 5–20 — Read for Focus · copy Formulas & key terms into notebook
            • Minutes 20–25 — Know cold without notes
            • Minutes 25–30 — Sample toss-ups · 3 facts + 1 miss
            """
        case .pass2 where week >= 5 && week <= 8:
            return """
            Pass 2 block workflow (Weeks 5–8):
            • First 15 min — DOE toss-ups on today’s topic
            • Next 15 min — re-read the Tro/CB/Expl section for any miss
            • Use harder regional wording; take fewer notes than Pass 1
            """
        case .pass3 where week >= 9:
            return """
            Pass 3 block workflow (Weeks 9–10):
            • Flash cards first on today’s topic
            • Open Tro/Mod/CB/FLS/Expl only if stuck
            • Finish with 5 DOE-style toss-ups per science block
            • No new reading — review only
            """
        default:
            return nil
        }
    }

    static func weekTheme(week: Int, pass: StudyPass) -> String? {
        switch (week, pass) {
        case (1, .pass1): return "Week 1 — Foundations"
        case (2, .pass1): return "Week 2 — Building depth"
        case (3, .pass1): return "Week 3 — Mid-level mastery"
        case (4, .pass1): return "Week 4 — Round-ready"
        case (5, .pass2): return "Week 5 — Foundations (again · Tro/CB)"
        case (6, .pass2): return "Week 6 — Building depth (again)"
        case (7, .pass2): return "Week 7 — Mid-level mastery (again)"
        case (8, .pass2): return "Week 8 — Round-ready (again)"
        case (9, .pass3): return "Week 9 — Final review (1 of 2)"
        case (10, .pass3): return "Week 10 — Final review (2 of 2)"
        default: return nil
        }
    }

    static func fridayReviewNote(week: Int) -> String? {
        switch week {
        case 2:
            return "Friday 4:40–5:40 — Timed drill + re-read any chapter where you missed questions"
        case 3:
            return "Friday 4:40–5:40 — Timed drill: 20 toss-ups (Bio + Chem + Phys only) · log misses by subject"
        case 4:
            return "Friday 4:40–5:40 — Full mock round (25 toss-ups, your categories only) · pick 2 weak subtopics for Pass 2"
        case 5:
            return "Friday 4:40–5:40 — Review Pass 1 gaps · list chapters where DOE misses clustered · re-read one weak chapter"
        case 6:
            return "Friday 4:40–5:40 — Timed drill: 20 toss-ups · regional-level wording · log misses by subject"
        case 7:
            return "Friday 4:40–5:40 — Timed drill: 20 toss-ups · log misses by subtopic"
        case 8:
            return "Friday 4:40–5:40 — Full mock round (25 toss-ups) · regional difficulty · pick 2 weak subtopics for Pass 3"
        case 9:
            return "Friday 4:40–5:40 — Mixed drill: 15 toss-ups across all 3 categories · update flash card pile"
        case 10:
            return "Friday 4:40–5:40 — Final summer mock round (25 toss-ups) · celebrate wins · list 3 topics to keep reviewing in fall"
        default:
            return nil
        }
    }

    static func blockContent(for block: StudyBlock, pass: StudyPass) -> String? {
        let key = Key(week: block.week, day: block.day, subject: block.subject)
        if block.week >= 1 && block.week <= 4 && pass == .pass1 {
            return pass1Content[key]
        }
        if block.week >= 5 && block.week <= 8 && pass == .pass2 {
            return pass2Content[key]
        }
        if block.week >= 9 && pass == .pass3 {
            return pass3Content[key]
        }
        return nil
    }

    // MARK: - Pass 1 (Weeks 1–4)

    private static let pass1Content: [Key: String] = {
        var map: [Key: String] = [:]

        // Week 1
        map[Key(week: 1, day: .monday, subject: .chemistry)] = """
        Proton (+1, in nucleus) · neutron (neutral) · electron (−1) · atomic number = # protons · mass number = p + n · isotopes (same Z, different n) · nucleus holds almost all mass · electron cloud = volume · neutral atom: protons = electrons.

        Know cold: element with 17 protons (Chlorine) · C-12 has 6 electrons when neutral · electron has ~zero mass compared to proton.

        Sample toss-ups: atomic number of atom with 15 protons → 15 (Phosphorus) · 11 p + 12 n → mass number 23.
        """
        map[Key(week: 1, day: .thursday, subject: .chemistry)] = """
        Periods = horizontal rows · groups = vertical columns (similar properties) · metals / nonmetals / metalloids · valence electrons (intro) · subscripts in formulas · ionic vs molecular compounds · H₂O, CO₂, NaCl.

        Na → Na⁺ + e⁻ when sodium loses one electron. Group 18 = noble gases (very unreactive).

        Know cold: noble gas group (18) · CO₂ formula · Na forms Na⁺.
        """
        map[Key(week: 1, day: .tuesday, subject: .biology)] = """
        Nucleus (DNA/chromosomes) · cell membrane (selective barrier) · mitochondria → ATP · ribosomes → proteins · ER & Golgi → transport/modify proteins · vacuole & chloroplast & cell wall (plants) · prokaryote (no nucleus) vs eukaryote (has nucleus).

        ATP = energy currency of the cell. Match each organelle to its job.

        Know cold: organelle for ATP (mitochondria) · two plant-only structures (cell wall, chloroplast).
        """
        map[Key(week: 1, day: .friday, subject: .biology)] = """
        cell → tissue → organ → system → organism · specialization (same DNA, different genes expressed) · tissue types: muscle, nerve, epithelial, connective · structure matches function.

        Muscle and nerve cells look different because different genes are turned on — not because the DNA is different.

        Know cold: order from simplest — cell → tissue → organ → organism.
        """
        map[Key(week: 1, day: .wednesday, subject: .physics)] = """
        Speed (scalar) vs velocity (vector — has direction) · acceleration · distance-time graphs: slope = speed · flat horizontal line = at rest · v = d/t.

        120 km in 2 h → 60 km/h. A flat d-t graph means zero speed (not moving).

        Know cold: v = d/t · 150 km in 3 h → 50 km/h · horizontal d-t line = at rest.
        """

        // Week 2
        map[Key(week: 2, day: .monday, subject: .chemistry)] = """
        Particle model: solid (fixed shape & volume) · liquid (fixed volume) · gas (fills container) · melting / freezing / boiling / condensation · phase changes absorb or release energy · evaporation (surface only) vs boiling (throughout liquid).

        At the same temperature, gas particles move fastest. Ice melting increases spacing between particles.

        Know cold: which state has fastest particles (gas) · boiling vs evaporation (throughout vs surface only).
        """
        map[Key(week: 2, day: .thursday, subject: .chemistry)] = """
        Reactants → products · balance equations (conservation of mass) · exothermic (releases heat) vs endothermic (absorbs heat) · signs of reaction: color change, gas, precipitate, temperature change.

        Balance H₂ + Cl₂ → 2HCl. Exothermic reactions feel hot because energy is released.

        Know cold: balance H₂ + Cl₂ → HCl · exothermic = releases heat.
        """
        map[Key(week: 2, day: .tuesday, subject: .biology)] = """
        DNA · gene · chromosome · allele · dominant (capital) vs recessive (lowercase) · genotype (letters) vs phenotype (observable trait) · Punnett square · Tt × Tt → 3:1 phenotype ratio · homozygous (TT, tt) vs heterozygous (Tt).

        Know cold: Tt × Tt phenotypic ratio (3:1) · dominant allele written with capital letter.
        """
        map[Key(week: 2, day: .friday, subject: .biology)] = """
        Bones/muscles/levers (fulcrum, effort, load) · heart pumps blood · lungs: O₂ in, CO₂ out · arteries carry blood away from heart · veins toward heart · RBC carries O₂.

        Know cold: three parts of a lever (fulcrum, effort, load) · arteries carry blood away from heart.
        """
        map[Key(week: 2, day: .wednesday, subject: .physics)] = """
        Inertia (Newton's 1st — objects resist change in motion) · F = ma (Newton's 2nd) · action-reaction pairs (Newton's 3rd) · friction opposes motion · net force · N = kg·m/s².

        F = 20 N, m = 4 kg → a = 5 m/s². Double the mass, same force → acceleration halves. Earth pulls you down; you pull Earth up (equal & opposite).

        Know cold: F = ma numeric practice · Newton's 3rd in words.
        """

        // Week 3
        map[Key(week: 3, day: .monday, subject: .chemistry)] = """
        pH scale 0–14 · neutral = 7 · pH < 7 = acid · pH > 7 = base · H⁺ and OH⁻ · common acids (HCl) and bases (NaOH) · indicators change color.

        Pure water at 25 °C has pH 7. pH 11 is basic (alkaline).

        Know cold: pH of pure water (7) · pH 3 is acid or base (acid).
        """
        map[Key(week: 3, day: .thursday, subject: .chemistry)] = """
        Solvent + solute → solution · saturation · concentration · separation: filtration (solid from liquid) · distillation (by boiling point) · dilution lowers concentration.

        In salt water, salt (NaCl) is the solute. Filter sand from water — sand stays on paper.

        Know cold: solute in salt water (salt) · separate sand from water (filtration).
        """
        map[Key(week: 3, day: .tuesday, subject: .biology)] = """
        Food chain/web · producer (makes food from sunlight) · consumer · decomposer · symbiosis: mutualism, commensalism, parasitism · biomes · ~10% energy rule between trophic levels.

        Producer gets sun energy first. Name three biomes (e.g. desert, forest, tundra).

        Know cold: organism that makes its own food (producer) · three symbiosis types.
        """
        map[Key(week: 3, day: .friday, subject: .biology)] = """
        Bacteria vs virus · pathogens · antibodies · vaccines train immunity · antibiotics work on bacteria only — not viruses.

        Antibiotics do not cure the flu (viral). Vaccines help the body produce antibodies before infection.

        Know cold: antibiotic for flu? (no) · vaccine purpose (immunity/antibodies).
        """
        map[Key(week: 3, day: .wednesday, subject: .physics)] = """
        Work W = Fd (joules) · power P = W/t · KE and PE · simple machines: lever, pulley · efficiency = useful output / total input.

        More height → more gravitational PE. F = 10 N, d = 5 m → W = 50 J. SI unit of work = joule (J).

        Know cold: unit of work (J) · F = 10 N, d = 5 m → 50 J.
        """

        // Week 4
        map[Key(week: 4, day: .monday, subject: .chemistry)] = """
        Valence electrons · atomic radius trends (↓ across period, ↑ down group) · reactivity · memorize symbols H through Ca (first 20 elements).

        Symbol for potassium = K. Sodium atom is larger than chlorine atom (same period, Cl has more protons pulling electrons in).

        Know cold: symbol for K · which is larger: Na or Cl (Na).
        """
        map[Key(week: 4, day: .thursday, subject: .chemistry)] = """
        SI base units (kg, m, s, mol) · significant figures (intro) · lab equipment: beaker, flask, balance, graduated cylinder · safety goggles · read meniscus at eye level.

        SI base unit for mass = kilogram (kg). Graduated cylinder measures liquid volume precisely.

        Know cold: SI mass unit (kg) · glassware for precise liquid volume (graduated cylinder).
        """
        map[Key(week: 4, day: .tuesday, subject: .biology)] = """
        Natural selection · variation · adaptation · taxonomy kingdom → species · binomial name (Homo sapiens) · fossil & anatomy evidence for evolution.

        Charles Darwin — natural selection. Most specific rank = species.

        Know cold: scientist for natural selection (Darwin) · most specific taxonomic rank (species).
        """
        map[Key(week: 4, day: .friday, subject: .biology)] = """
        Root (absorb water/minerals) · stem (support, transport) · leaf (photosynthesis) · xylem/phloem intro · animal tissues.

        Most photosynthesis occurs in leaves. Roots anchor the plant and absorb water.

        Know cold: primary root function (absorb water) · where photosynthesis mainly occurs (leaves).
        """
        map[Key(week: 4, day: .wednesday, subject: .physics)] = """
        Wavelength λ · frequency f · amplitude · v = fλ · reflection & refraction · V = IR (Ohm's law) · series vs parallel circuits · Hz, m/s, Ω, A.

        Higher pitch = higher frequency. I = 2 A, R = 5 Ω → V = 10 V. In series, resistances add (more R). In parallel, current splits.

        Know cold: higher pitch → higher or lower f (higher) · I = 2 A, R = 5 Ω → 10 V · unit of current (ampere/A).
        """

        return map
    }()

    // MARK: - Pass 2 (Weeks 5–8)

    private static let pass2Content: [Key: String] = {
        var map: [Key: String] = [:]

        // Week 5
        map[Key(week: 5, day: .monday, subject: .chemistry)] = """
        Average atomic mass (weighted) · isotopes · Tro depth on atomic structure · DOE → re-read missed sections.

        Know the weighted average: the average atomic mass on the periodic table is closer to the heavier isotope. Isotopes have the same atomic number (same element) but different neutron counts.

        After DOE drill: re-read Tro Ch 4 §4.3–4.6 for any atomic-structure miss.
        """
        map[Key(week: 5, day: .thursday, subject: .chemistry)] = """
        Cations (+) · anions (−) · Na⁺, Cl⁻, Ca²⁺, O²⁻ · CO₃²⁻, OH⁻ · ionic vs covalent · name simple compounds.

        Ionic = metal + nonmetal (electrons transferred). Covalent = nonmetals share electrons. Practice naming simple ionic compounds and spotting polyatomic ions.
        """
        map[Key(week: 5, day: .tuesday, subject: .biology)] = """
        Nucleolus · rough vs smooth ER · Golgi · lysosome · cytoskeleton · phospholipid bilayer · Campbell-level plant vs animal.

        Rough ER has ribosomes (protein synthesis). Smooth ER makes lipids. Lysosome digests worn-out parts. Cytoskeleton gives shape and movement. Phospholipid bilayer = cell membrane structure.
        """
        map[Key(week: 5, day: .friday, subject: .biology)] = """
        ATP currency · respiration: glucose + O₂ → CO₂ + H₂O + ATP · photosynthesis: reverse · mitochondria vs chloroplast · aerobic vs anaerobic (intro).

        Respiration inputs: glucose + O₂. Outputs: CO₂ + H₂O + ATP. Photosynthesis inputs: CO₂ + H₂O + light. Output: glucose + O₂. Match each process to its organelle.
        """
        map[Key(week: 5, day: .wednesday, subject: .physics)] = """
        Precision vs accuracy · acceleration sign when slowing · v-t graph slope = acceleration · relative motion (intro).

        Slowing down = negative acceleration (if velocity is positive). On a v-t graph, slope = acceleration (not speed). Precision = repeatability; accuracy = closeness to true value.
        """

        // Week 6
        map[Key(week: 6, day: .monday, subject: .chemistry)] = """
        Physical vs chemical change · conservation of matter · endo/exothermic revisit · classify: burning wood · melting ice.

        Physical change = same substance (melting ice). Chemical change = new substances (burning wood). Matter is never created or destroyed in a chemical reaction.
        """
        map[Key(week: 6, day: .thursday, subject: .chemistry)] = """
        Synthesis · decomposition · single/double replacement · combustion · balance harder equations · identify type from equation.

        A + B → AB = synthesis. AB → A + B = decomposition. Combustion always needs O₂. Practice balancing Fe + O₂ → Fe₂O₃ and classifying reaction types from the equation.
        """
        map[Key(week: 6, day: .tuesday, subject: .biology)] = """
        Mendel · Aa × Aa genotypic ratio · phenotype 3:1 · heterozygous vs homozygous · dihybrid (intro).

        Aa × Aa genotypic ratio = 1 AA : 2 Aa : 1 aa. Phenotypic ratio with complete dominance = 3:1. Homozygous = same alleles (AA or aa). Heterozygous = Aa.
        """
        map[Key(week: 6, day: .friday, subject: .biology)] = """
        Digestive path mouth→intestines · alveoli O₂/CO₂ diffusion · heart chambers · arteries/veins/capillaries · RBC carries O₂.

        Most nutrient absorption = small intestine. Alveoli = gas exchange in lungs. Arteries carry blood away from heart; veins toward heart. Capillaries = exchange sites.
        """
        map[Key(week: 6, day: .wednesday, subject: .physics)] = """
        p = mv · conservation of momentum · elastic vs inelastic collision (concept) · net force diagrams · friction types.

        Momentum = mass × velocity (kg·m/s). In a closed system, total momentum is conserved. At equal velocity, heavier object has more momentum (truck > bicycle).
        """

        // Week 7
        map[Key(week: 7, day: .monday, subject: .chemistry)] = """
        Strong vs weak acids/bases · neutralization: acid + base → salt + water · titration (concept) · HCl + NaOH.

        HCl + NaOH → NaCl + H₂O. pH < 7 = acid; pH > 7 = base. Neutralization combines H⁺ and OH⁻ to form water. Titration slowly adds one solution to the other to find concentration.
        """
        map[Key(week: 7, day: .thursday, subject: .chemistry)] = """
        M = mol/L · M₁V₁ = M₂V₂ · solubility · electrolytes vs nonelectrolytes · dilution ↓ concentration.

        Adding solvent dilutes the solution (concentration decreases). Saturated solution at room temperature will not dissolve more crystal. Electrolytes dissociate in water and conduct electricity.
        """
        map[Key(week: 7, day: .tuesday, subject: .biology)] = """
        Carrying capacity (K) · exponential vs logistic growth · biotic vs abiotic · primary vs secondary succession · carbon cycle (intro).

        Carrying capacity = max population the environment supports. Sunlight, water, and soil are abiotic. Primary succession starts on bare rock; secondary follows a disturbance.
        """
        map[Key(week: 7, day: .friday, subject: .biology)] = """
        Innate vs adaptive immunity · B cells · T cells · memory cells · lytic cycle (intro) · allergies (intro).

        Innate = fast, general (skin, mucous, stomach acid). Adaptive = specific with memory. Second infection often milder because memory cells recognize the pathogen faster.
        """
        map[Key(week: 7, day: .wednesday, subject: .physics)] = """
        PE = mgh · KE = ½mv² · W = mg (weight) · conservation of energy · mass vs weight · projectile (qualitative).

        As a ball rises, gravitational PE increases. Mass stays the same on the Moon; weight is less. Energy converts between forms but total energy is conserved in a closed system.
        """

        // Week 8
        map[Key(week: 8, day: .monday, subject: .chemistry)] = """
        Atomic radius ↓ across period · ionization energy ↑ across period · electronegativity trends · halogen reactivity top of group.

        Left to right across a period: atomic radius decreases, ionization energy increases. Fluorine is the most reactive halogen. Down a group, radius increases.
        """
        map[Key(week: 8, day: .thursday, subject: .chemistry)] = """
        Sig figs rules · K = °C + 273 · percent error · density d = m/V · unit analysis.

        0.00450 has 3 significant figures. 25°C = 298 K. Percent error = |measured − accepted| / accepted × 100. Always track units through calculations.
        """
        map[Key(week: 8, day: .tuesday, subject: .biology)] = """
        Natural selection mechanisms · gene pool · geographic isolation · reproductive isolation · adaptive radiation (intro).

        Mutations are the ultimate source of genetic variation. Populations separated by a mountain range undergo geographic isolation. Reproductive isolation can lead to new species.
        """
        map[Key(week: 8, day: .friday, subject: .biology)] = """
        Xylem (water up) · phloem (sugars) · meristem · epithelial/muscle/nervous/connective tissues · organ systems overview.

        Xylem transports water upward. Phloem transports sugars. Meristem = growth tissue in plants. Four animal tissue types: epithelial, muscle, nervous, connective.
        """
        map[Key(week: 8, day: .wednesday, subject: .physics)] = """
        V = IR · series R_total ↑ · parallel 1/R_total = 1/R₁ + 1/R₂ · v = fλ · ROYGBIV · Ch 14 lenses/dispersion (stretch).

        More resistors in series → total resistance increases. In parallel, current splits. v = fλ links wave speed, frequency, and wavelength. Speed of light c ≈ 3×10⁸ m/s.
        """

        return map
    }()

    // MARK: - Pass 3 (Weeks 9–10)

    private static let pass3Content: [Key: String] = {
        var map: [Key: String] = [:]

        // Week 9
        map[Key(week: 9, day: .monday, subject: .chemistry)] = """
        Atoms flash cards: p/n/e · Z · A · isotopes · average mass · 5 DOE toss-ups.

        Without the book: state particle charges and locations. Proton defines the element (atomic number). Isotopes = same Z, different neutron count.
        """
        map[Key(week: 9, day: .thursday, subject: .chemistry)] = """
        Periodic table & compounds: groups/periods · ionic/covalent · Na⁺, Cl⁻ · H₂O, CO₂, NaCl · 5 DOE.

        Flash drill: Na → Na⁺ (loses one electron). CO₂ formula. Know ionic vs covalent for common compounds.
        """
        map[Key(week: 9, day: .tuesday, subject: .biology)] = """
        Cell review: organelles · plant vs animal · prokaryote/eukaryote · 5 DOE.

        From memory: name 4 organelles and one job each. Plant-only: cell wall and chloroplast. Prokaryotes lack a nucleus.
        """
        map[Key(week: 9, day: .friday, subject: .biology)] = """
        Photosynthesis vs respiration · ATP · levels of organization · 5 DOE.

        Write both processes from memory (words OK). Order: cell → tissue → organ → system → organism. Gas released in photosynthesis = O₂.
        """
        map[Key(week: 9, day: .wednesday, subject: .physics)] = """
        SI units · v = d/t · d-t graph reading · timed 5 toss-ups · compare to Monday misses.

        Formula for average speed: v = d/t. SI unit for distance = meter (m). Flat d-t graph = at rest.
        """

        // Week 10
        map[Key(week: 10, day: .monday, subject: .chemistry)] = """
        Acids & bases review: pH · H⁺/OH⁻ · neutralization · HCl · NaOH · 5 DOE.

        pH 0–14 · neutral = 7 · acid < 7 · base > 7. pH 2 is strongly acidic; pH 12 is basic. Acid + base → salt + water.
        """
        map[Key(week: 10, day: .thursday, subject: .chemistry)] = """
        Solutions review: solute/solvent · saturation · filtration · distillation · 5 DOE.

        In salt water, salt is the solute. Unsaturated solution can still dissolve more solute. Filtration separates insoluble solids from liquids.
        """
        map[Key(week: 10, day: .tuesday, subject: .biology)] = """
        Ecology review: food webs · symbiosis · carrying capacity · biotic/abiotic · 5 DOE.

        Three symbiosis types: mutualism, commensalism, parasitism. Soil is abiotic. Producer gets sun energy first in a food chain.
        """
        map[Key(week: 10, day: .friday, subject: .biology)] = """
        Genetics · microbes · immunity: Punnett · bacteria vs virus · vaccines · antibodies · 5 DOE.

        Tt × Tt → 3:1 phenotypic ratio. Antibiotics do not work on viruses. Vaccines train the body to produce antibodies. Dominant allele = capital letter.
        """
        map[Key(week: 10, day: .wednesday, subject: .physics)] = """
        Energy & gravity: W = Fd · PE/KE · conservation · weight vs mass · 5 DOE.

        W = Fd: 8 N for 3 m = 24 J. Ball falls → PE converts to KE. Weight = mg; mass is constant everywhere.
        """

        return map
    }()
}
