import Foundation

extension SeedData {
    // MARK: - Weeks 1–4 (full content)

    static let weeks1Through4: [StudyBlock] = [
        // WEEK 1
        block(week: 1, day: .monday, subject: .chemistry, pass: .pass1,
              book: "Mod", chapter: "Ch 3", title: "Atoms: The Building Blocks of Matter",
              pass2Book: "Tro", pass2Chapter: "Ch 4 §4.3–4.6", pass2Title: "Atoms & Elements",
              focus: "Proton (+1, in nucleus) · neutron (neutral, nucleus) · electron (−1, shells/cloud) · atomic number Z = # protons (defines element) · mass number A = protons + neutrons · isotopes = same Z, different neutrons · nucleus ≈ all mass · electron cloud ≈ all volume · neutral atom: protons = electrons",
              formulas: "Z = # protons · A = p + n · ¹²C vs ¹⁴C (isotopes) · p⁺, n⁰, e⁻",
              knowCold: ["Element with 17 protons? (Chlorine)", "C-12 (6 protons): electrons in neutral atom? (6)", "~zero-mass particle? (Electron)"],
              topic: "Atoms & periodic table",
              tossups: [
                  ("What is the atomic number of an atom with 15 protons?", "15 (Phosphorus)"),
                  ("An atom has 11 protons and 12 neutrons. What is its mass number?", "23")
              ]),
        block(week: 1, day: .tuesday, subject: .biology, pass: .pass1,
              book: "OSB", chapter: "Ch 3", title: "Cell Structure and Function",
                      backupBookLine: "FLS Ch 1 · CB Ch 4",
              focus: "Nucleus (contains DNA/chromosomes) · cell membrane (selective barrier) · cytoplasm · mitochondria → ATP · ribosomes → proteins · ER & Golgi → transport/modify proteins · vacuole (large in plants) · chloroplast (plants only, photosynthesis) · cell wall (plants only) · prokaryote (no nucleus) vs eukaryote (has nucleus)",
              formulas: "ATP = energy currency · organelle → function pairs",
              knowCold: ["Which organelle makes ATP? (Mitochondria)", "Two plant-only structures? (Cell wall, chloroplast)", "Nucleus job? (Houses DNA, controls cell)"],
              topic: "Cell structure",
              tossups: [
                  ("Which organelle produces most ATP in eukaryotes?", "Mitochondria"),
                  ("Name two structures found in plant cells but not in typical animal cells.", "Cell wall and chloroplast")
              ]),
        block(week: 1, day: .wednesday, subject: .physics, pass: .pass1,
              book: "Expl", chapter: "Ch 1", title: "About Science (+ App B optional)",
              focus: "~1 hr: Expl Ch 1 (hypothesis, SI units, precision). Optional 10-min skim: App. B motion graphs if time remains.",
              formulas: "v = d/t · a = Δv/Δt (concept) · slope = rise/run",
              knowCold: ["Theory vs law — which is broader? (Theory)", "120 km in 2 h → speed? (60 km/h)", "Flat d-t line means? (At rest / zero speed)", "Speed vs velocity difference? (Velocity has direction)"],
              topic: "About Science + Motion",
              tossups: [
                  ("A car goes 150 km in 3 hours. What is its average speed?", "50 km/h"),
                  ("What does a horizontal (flat) line on a distance-time graph indicate?", "The object is at rest / not moving")
              ]),
        block(week: 1, day: .thursday, subject: .chemistry, pass: .pass1,
              book: "Mod", chapter: "Ch 5", title: "Periodic Law",
              pass2Book: "Tro", pass2Chapter: "Ch 4 §4.7–4.8 + Ch 5", pass2Title: "Ions · Molecules & Compounds",
              focus: "~1 hr · section: periods & groups · metals/nonmetals · valence electrons (intro) · subscripts in formulas · H₂O, CO₂, NaCl",
              formulas: "Na → Na⁺ + e⁻ · Group 18 = noble gases · H₂O, CO₂, NaCl",
              knowCold: ["Noble gas group number? (18)", "CO₂ formula? (CO₂)", "Na forms Na⁺ or Na⁻? (Na⁺)"],
              topic: "Elements & ions",
              tossups: [
                  ("Which group on the periodic table contains the noble gases?", "Group 18"),
                  ("What is the chemical formula for table salt?", "NaCl")
              ]),
        block(week: 1, day: .friday, subject: .biology, pass: .pass1,
              book: "OSB", chapter: "Ch 1", title: "Levels of Organization",
                      backupBookLine: "FLS Ch 2 · CB Ch 6–7",
              focus: "~1 hr · section: cell → tissue → organ → system → organism · specialization · tissue types",
              formulas: "Levels of organization in order",
              knowCold: ["Order from simplest: organ, cell, tissue, organism? (Cell → tissue → organ → organism)", "Why do muscle cells look different from nerve cells? (Specialization / different genes expressed)"],
              topic: "Cell energy & organization",
              tossups: [
                  ("List from simplest to most complex: organ, cell, tissue, organism.", "Cell → tissue → organ → organism"),
                  ("Why can muscle cells and nerve cells look so different if they have the same DNA?", "Different genes are expressed / cell specialization")
              ]),

        // WEEK 2
        block(week: 2, day: .monday, subject: .chemistry, pass: .pass1,
              book: "Mod", chapter: "Ch 10", title: "States of Matter",
              pass2Book: "Tro", pass2Chapter: "Ch 3", pass2Title: "Matter and Energy",
              focus: "Solid (fixed shape & volume) · liquid (fixed volume, takes shape of container) · gas (fills container) · particle model: spacing & motion differences · melting / freezing / boiling / condensation · phase changes absorb or release energy · heating curve: flat plateau during phase change · evaporation (surface only) vs boiling (throughout)",
              formulas: "Solid ↔ liquid ↔ gas transitions · evaporation vs boiling · heating curve plateau = phase change",
              knowCold: ["Which state has fastest-moving particles? (Gas)", "Boiling vs evaporation — one difference? (Boiling occurs throughout liquid; evaporation only at surface)", "Ice melting — what happens to particle spacing? (Spacing increases)"],
              topic: "States of matter",
              tossups: [
                  ("Which state of matter has particles with the most kinetic energy at the same temperature?", "Gas"),
                  ("During boiling, is energy absorbed by or released from the substance?", "Absorbed")
              ]),
        block(week: 2, day: .tuesday, subject: .biology, pass: .pass1,
              book: "OSB", chapter: "Ch 7", title: "Genetics — DNA & genes (part 1)",
                      backupBookLine: "FLS Ch 4 · CB Ch 9",
              focus: "~1 hr · part 1: DNA · gene · chromosome · allele · dominant vs recessive. Finish Punnett squares Friday (Ch 8).",
              formulas: "Tt × Tt → 3 dominant : 1 recessive phenotype · homozygous (TT, tt) vs heterozygous (Tt)",
              knowCold: ["Tt × Tt phenotype ratio? (3:1)", "Dominant allele: capital or lowercase? (Capital)"],
              topic: "Genetics",
              tossups: [
                  ("What molecule carries genetic information in the cell?", "DNA"),
                  ("What is an alternate form of a gene called?", "An allele")
              ]),
        block(week: 2, day: .wednesday, subject: .physics, pass: .pass1,
              book: "Expl", chapter: "Ch 2", title: "Newton's 1st & 2nd Laws (part 1)",
              pass2Book: "Expl", pass2Chapter: "Ch 2–5", pass2Title: "Newton's Laws + Momentum",
              focus: "~1 hr · part 1: inertia · F = ma · net force · friction (intro). Wed week 3 = Newton's 3rd; week 4 = momentum wrap-up.",
              formulas: "F = ma · a = F/m · units: Newton (N), kg, m/s²",
              knowCold: ["F=20 N, m=4 kg → a? (5 m/s²)", "Double mass, same force → acceleration? (Halves)"],
              topic: "Forces & Newton's laws",
              tossups: [
                  ("A 4 kg object experiences an acceleration of 5 m/s². What is the net force?", "20 N (F = 4 × 5)"),
                  ("Newton's 3rd law: Earth pulls you down. What do you pull on Earth?", "Up (equal and opposite force)")
              ]),
        block(week: 2, day: .thursday, subject: .chemistry, pass: .pass1,
              book: "Mod", chapter: "Ch 8", title: "Chemical Equations and Reactions",
              pass2Book: "Tro", pass2Chapter: "Ch 7 §7.1–7.4", pass2Title: "Chemical Reactions",
              focus: "Reactants → products · balancing equations (conservation of mass) · exothermic (releases heat) vs endothermic (absorbs heat) · signs of a chemical reaction (color change, gas, precipitate, energy change)",
              formulas: "2H₂ + O₂ → 2H₂O · H₂ + Cl₂ → 2HCl (balanced) · exothermic = releases heat",
              knowCold: ["Balance H₂ + Cl₂ → HCl (answer: H₂ + Cl₂ → 2HCl)", "Exothermic = releases or absorbs? (Releases)"],
              topic: "Chemical reactions",
              tossups: [
                  ("Balance the following: H₂ + Cl₂ → HCl", "H₂ + Cl₂ → 2HCl"),
                  ("A reaction that releases heat to the surroundings is called what?", "Exothermic")
              ]),
        block(week: 2, day: .friday, subject: .biology, pass: .pass1,
              book: "OSB", chapter: "Ch 8", title: "Genetics — Punnett squares (part 2)",
                      backupBookLine: "FLS Ch 4 · CB Ch 9",
              focus: "~1 hr · part 2: genotype vs phenotype · Punnett square · Tt × Tt → 3:1 · heterozygous vs homozygous",
              formulas: "Tt × Tt → 3 dominant : 1 recessive phenotype · homozygous (TT, tt) vs heterozygous (Tt)",
              knowCold: ["Tt × Tt phenotype ratio? (3:1)", "Dominant allele: capital or lowercase? (Capital)"],
              topic: "Genetics",
              tossups: [
                  ("In a monohybrid cross Tt × Tt, what is the expected phenotypic ratio?", "3:1 (3 dominant : 1 recessive)"),
                  ("How is a dominant allele typically written in genetics notation?", "With a capital letter")
              ]),

        // WEEK 3
        block(week: 3, day: .monday, subject: .chemistry, pass: .pass1,
              book: "Mod", chapter: "Ch 14", title: "Acids and Bases",
              pass2Book: "Tro", pass2Chapter: "Ch 14", pass2Title: "Acids and Bases",
              focus: "pH scale 0–14 · neutral = 7 · below 7 = acid (more H⁺) · above 7 = base (more OH⁻) · common acids (HCl, H₂SO₄, vinegar) · common bases (NaOH, baking soda, ammonia) · indicators change color with pH",
              formulas: "pH < 7 acid · pH > 7 base · pH = 7 neutral · HCl · NaOH",
              knowCold: ["pH of pure water? (7)", "pH 3 — acid or base? (Acid)"],
              topic: "Acids, bases & pH",
              tossups: [
                  ("What is the pH of a neutral solution at 25°C?", "7"),
                  ("Is a solution with pH 11 acidic or basic?", "Basic")
              ]),
        block(week: 3, day: .tuesday, subject: .biology, pass: .pass1,
              book: "OSB", chapter: "Ch 19", title: "Ecology — communities (part 1)",
                      backupBookLine: "FLS Ch 7 · CB Ch 36–37",
              focus: "~1 hr · part 1: producers · consumers · decomposers · food chains · symbiosis types",
              formulas: "Mutualism (+/+) · commensalism (+/0) · parasitism (+/−) · 10% energy rule",
              knowCold: ["3 biomes? (tundra, desert, rainforest, grassland, taiga, temperate forest)", "Who gets sun energy first in a food chain? (Producer)"],
              topic: "Ecology",
              tossups: [
                  ("What do we call an organism that makes its own food from sunlight?", "Producer (autotroph)"),
                  ("Name the three types of symbiosis.", "Mutualism, commensalism, parasitism")
              ]),
        block(week: 3, day: .wednesday, subject: .physics, pass: .pass1,
              book: "Expl", chapter: "Ch 3", title: "Newton's 3rd Law & friction (part 2)",
              pass2Book: "Expl", pass2Chapter: "Ch 6–7", pass2Title: "Energy · Gravity",
              focus: "~1 hr · part 2: action-reaction pairs · friction · net force · N = kg·m/s². Wed week 7 = momentum.",
              formulas: "F = ma · action-reaction pairs · friction opposes motion · N = kg·m/s²",
              knowCold: ["Newton's 3rd law in words? (Every action has equal and opposite reaction)", "F=20 N, m=4 kg → a? (5 m/s²)"],
              topic: "Forces & Newton's laws",
              tossups: [
                  ("Newton's 3rd law: Earth pulls you down. What do you pull on Earth?", "Up (equal and opposite force)"),
                  ("A 4 kg object experiences an acceleration of 5 m/s². What is the net force?", "20 N (F = 4 × 5)")
              ]),
        block(week: 3, day: .thursday, subject: .chemistry, pass: .pass1,
              book: "Mod", chapter: "Ch 12", title: "Solutions",
              pass2Book: "Tro", pass2Chapter: "Ch 13", pass2Title: "Solutions",
              focus: "Solution = solute dissolved in solvent · aqueous = water as solvent · saturation · concentration · filtration separates insoluble solid from liquid · distillation separates liquids by boiling point differences",
              formulas: "Solute dissolved in solvent · dilution ↓ concentration · filtration vs distillation",
              knowCold: ["Salt water — which is the solute? (Salt / NaCl)", "Separate sand from water? (Filtration)"],
              topic: "Solutions",
              tossups: [
                  ("In a salt water solution, which substance is the solute?", "Salt (sodium chloride)"),
                  ("What separation method would you use to separate sand from water?", "Filtration")
              ]),
        block(week: 3, day: .friday, subject: .biology, pass: .pass1,
              book: "OSB", chapter: "Ch 16", title: "Body systems — musculoskeletal & cardiopulmonary",
                      backupBookLine: "FLS Ch 16–20 · CB Ch 21–23",
              focus: "~1 hr · section: levers · heart · arteries/veins · lungs O₂/CO₂ · capillaries",
              formulas: "Lever: fulcrum · effort · load · artery = away from heart · vein = toward heart",
              knowCold: ["Three parts of a lever? (Fulcrum, effort, load)", "Arteries carry blood toward or away from heart? (Away from heart)"],
              topic: "Human body systems",
              tossups: [
                  ("Name the three parts of a lever system.", "Fulcrum, effort (force), and load"),
                  ("Do arteries carry blood toward or away from the heart?", "Away from the heart")
              ]),

        // WEEK 4
        block(week: 4, day: .monday, subject: .chemistry, pass: .pass1,
              book: "Mod", chapter: "Ch 5 §3 + Ch 4", title: "Periodic Properties + Electrons",
              pass2Book: "Tro", pass2Chapter: "Ch 9 §9.7 · §9.9", pass2Title: "Periodic trends",
              focus: "Valence electrons determine reactivity · atomic radius decreases across a period, increases down a group · first 20 element symbols: H through Ca",
              formulas: "Radius ↓ across period · ↑ down group · first 20 symbols",
              knowCold: ["Symbol for potassium? (K)", "Na vs Cl — which atom is larger? (Na)"],
              topic: "Periodic trends & elements",
              tossups: [
                  ("What is the chemical symbol for potassium?", "K"),
                  ("Which is the larger atom: sodium (Na) or chlorine (Cl)?", "Sodium (Na)")
              ]),
        block(week: 4, day: .tuesday, subject: .biology, pass: .pass1,
              book: "OSB", chapter: "Ch 11", title: "Evolution — natural selection (part 1)",
                      backupBookLine: "FLS Ch 5–6 · CB Ch 13–14",
              focus: "~1 hr · part 1: natural selection · variation · adaptation · fossil evidence. Fri = classification (Ch 12).",
              formulas: "Taxonomy mnemonic · Homo sapiens",
              knowCold: ["Scientist associated with natural selection? (Charles Darwin)", "Most specific taxonomic rank? (Species)"],
              topic: "Evolution & classification",
              tossups: [
                  ("What scientist is most closely associated with the theory of natural selection?", "Charles Darwin"),
                  ("What is the most specific level in the classification system?", "Species")
              ]),
        block(week: 4, day: .wednesday, subject: .physics, pass: .pass1,
              book: "Expl", chapter: "Ch 12", title: "Waves & sound (part 1)",
              pass2Book: "Expl", pass2Chapter: "Ch 10–13", pass2Title: "Electricity · Waves · Light",
              focus: "~1 hr · part 1: wavelength · frequency · amplitude · v = fλ · reflection · refraction",
              formulas: "v = fλ · wavelength (λ) · frequency (f) · amplitude",
              knowCold: ["Higher pitch → higher or lower frequency? (Higher)", "v = fλ relates which three quantities? (Speed, frequency, wavelength)"],
              topic: "Waves",
              tossups: [
                  ("A higher-pitched sound corresponds to a higher or lower frequency?", "Higher frequency"),
                  ("What does the amplitude of a wave relate to?", "Energy / loudness (for sound)")
              ]),
        block(week: 4, day: .thursday, subject: .chemistry, pass: .pass1,
              book: "Mod", chapter: "Ch 2", title: "Measurements and Calculations",
              pass2Book: "Tro", pass2Chapter: "Ch 2", pass2Title: "Measurement and Problem Solving",
              focus: "SI base units (mass = kg, length = m, time = s, temperature = K, amount = mol, current = A) · significant figures · lab equipment · read meniscus at eye level · safety: goggles always",
              formulas: "kg, m, s, mol · read meniscus at eye level · graduated cylinder = precise volume",
              knowCold: ["SI unit for mass? (Kilogram, kg)", "Glassware for precise volume? (Graduated cylinder)"],
              topic: "Lab & equipment",
              tossups: [
                  ("What is the SI base unit for mass?", "Kilogram (kg)"),
                  ("Which piece of lab glassware is used to measure liquid volume most precisely?", "Graduated cylinder")
              ]),
        block(week: 4, day: .friday, subject: .biology, pass: .pass1,
              book: "OSB", chapter: "Ch 12", title: "Classification & taxonomy (part 2)",
                      backupBookLine: "FLS Ch 5–6 · CB Ch 13–14",
              focus: "~1 hr · part 2: Domain → Kingdom → … → Species · binomial nomenclature · Homo sapiens",
              formulas: "Taxonomy mnemonic · Homo sapiens",
              knowCold: ["Scientist associated with natural selection? (Charles Darwin)", "Most specific taxonomic rank? (Species)"],
              topic: "Evolution & classification",
              tossups: [
                  ("What scientist is most closely associated with the theory of natural selection?", "Charles Darwin"),
                  ("What is the most specific level in the classification system?", "Species")
              ]),
    ]
}
