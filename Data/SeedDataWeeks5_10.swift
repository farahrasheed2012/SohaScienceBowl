import Foundation

extension SeedData {
    // MARK: - Weeks 5–10 (single summer pass — new chapters, not re-reads)

    static let weeks5Through10: [StudyBlock] = [
        // WEEK 5 — Energy in living things + work & energy
        block(week: 5, day: .monday, subject: .chemistry, pass: .pass1,
              book: "Expl", chapter: "Ch 18 §18.1–18.6", title: "Chemical Bonding",
              pass2Book: "Mod", pass2Chapter: "Ch 7", pass2Title: "Molecules & Compounds (backup)",
              backupBookLine: "Tro Ch 5",
              focus: "~1 hr · ionic vs covalent vs metallic · Lewis dots (intro) · electronegativity · NaCl vs H₂O vs O₂",
              formulas: "ionic = metal + nonmetal · covalent = nonmetals share · NaCl · H₂O · O₂",
              knowCold: ["NaCl — ionic or covalent? (Ionic)", "O₂ — ionic or covalent? (Covalent)"],
              topic: "Chemical bonding",
              tossups: [
                  ("Is NaCl held together by ionic or covalent bonds?", "Ionic"),
                  ("Two nonmetals sharing electrons form what type of bond?", "Covalent")
              ]),
        block(week: 5, day: .tuesday, subject: .biology, pass: .pass1,
              book: "FLS", chapter: "Ch 2 — Photosynthesis", title: "Photosynthesis (part 1)",
              backupBookLine: "OSB Ch 4 · CB Ch 8",
              focus: "~1 hr · part 1: chloroplast · light reactions · pigments · inputs CO₂ + H₂O + light. Fri = respiration (Ch 5).",
              formulas: "6CO₂ + 6H₂O + light → C₆H₁₂O₆ + 6O₂ · chloroplast",
              knowCold: ["Organelle for photosynthesis? (Chloroplast)", "Gas released in photosynthesis? (Oxygen/O₂)"],
              topic: "Photosynthesis & respiration",
              tossups: [
                  ("Which organelle carries out photosynthesis?", "Chloroplast"),
                  ("What gas is released as a product of photosynthesis?", "Oxygen/O₂")
              ]),
        block(week: 5, day: .wednesday, subject: .physics, pass: .pass1,
              book: "Expl", chapter: "Ch 6 §6.1–6.5", title: "Work & Energy (part 1)",
              focus: "~1 hr · part 1: work W = Fd · joule · KE = ½mv² · energy conservation (intro). Wed week 6 = gravity.",
              formulas: "W = Fd · KE = ½mv² · joule (J)",
              knowCold: ["10 N for 4 m — work? (40 J)", "Double speed — KE multiplied by? (4×)"],
              topic: "Work & energy",
              tossups: [
                  ("How much work is done by a 10 N force over 4 m?", "40 J"),
                  ("If speed doubles, kinetic energy is multiplied by what factor?", "4")
              ]),
        block(week: 5, day: .thursday, subject: .chemistry, pass: .pass1,
              book: "Expl", chapter: "Ch 19 §19.3–19.4", title: "Chemical Quantities",
              pass2Book: "Mod", pass2Chapter: "Ch 6", pass2Title: "Quantities in Chemistry (backup)",
              backupBookLine: "Tro Ch 6",
              focus: "~1 hr · mole concept · molar mass · mole ↔ grams · Avogadro's number (concept) · percent composition (intro)",
              formulas: "mol · molar mass (g/mol) · n = m/M",
              knowCold: ["SI unit for amount of substance? (Mole/mol)", "H₂O molar mass ≈? (18 g/mol)"],
              topic: "Stoichiometry",
              tossups: [
                  ("What is the SI unit for amount of substance?", "Mole (mol)"),
                  ("What is the approximate molar mass of water (H₂O)?", "18 g/mol")
              ]),
        block(week: 5, day: .friday, subject: .biology, pass: .pass1,
              book: "FLS", chapter: "Ch 2 — Cellular Respiration", title: "Cellular Respiration (part 2)",
              backupBookLine: "OSB Ch 5 · CB Ch 9",
              focus: "~1 hr · part 2: mitochondria · aerobic respiration · glucose + O₂ → CO₂ + H₂O + ATP · compare to photosynthesis",
              formulas: "C₆H₁₂O₆ + 6O₂ → 6CO₂ + 6H₂O + ATP · mitochondria",
              knowCold: ["Organelle for cellular respiration? (Mitochondria)", "Gas consumed in aerobic respiration? (Oxygen/O₂)"],
              topic: "Photosynthesis & respiration",
              tossups: [
                  ("Which organelle is the main site of aerobic respiration?", "Mitochondria"),
                  ("What gas is consumed during aerobic cellular respiration?", "Oxygen/O₂")
              ]),

        // WEEK 6 — Ecology depth + gravity
        block(week: 6, day: .monday, subject: .chemistry, pass: .pass1,
              book: "Expl", chapter: "Ch 19 §19.3–19.5", title: "Molarity & Dilution",
              pass2Book: "Mod", pass2Chapter: "Ch 12 §", pass2Title: "Solutions (backup)",
              backupBookLine: "Tro Ch 13",
              focus: "~1 hr · molarity M = mol/L · dilution M₁V₁ = M₂V₂ · saturated vs unsaturated · electrolytes",
              formulas: "M = mol/L · M₁V₁ = M₂V₂ · saturated · unsaturated",
              knowCold: ["Add solvent — concentration up or down? (Down)", "Unit of molarity? (mol/L or M)"],
              topic: "Solutions",
              tossups: [
                  ("Adding solvent to a solution — does concentration increase or decrease?", "Decreases"),
                  ("What is the unit of molarity?", "mol/L (M)")
              ]),
        block(week: 6, day: .tuesday, subject: .biology, pass: .pass1,
              book: "FLS", chapter: "Ch 7 — The Six Kingdoms", title: "Population Ecology (part 2)",
              backupBookLine: "OSB Ch 20 · CB Ch 36",
              focus: "~1 hr · carrying capacity (K) · exponential vs logistic growth · limiting factors · primary vs secondary succession",
              formulas: "carrying capacity · biotic vs abiotic · primary succession",
              knowCold: ["Max population environment supports? (Carrying capacity)", "Is sunlight biotic or abiotic? (Abiotic)"],
              topic: "Ecology",
              tossups: [
                  ("What term describes the maximum population an environment can support?", "Carrying capacity"),
                  ("Is sunlight biotic or abiotic?", "Abiotic")
              ]),
        block(week: 6, day: .wednesday, subject: .physics, pass: .pass1,
              book: "Expl", chapter: "Ch 7 §7.1–7.4 + §7.7", title: "Gravity & Projectile Motion",
              focus: "~1 hr · weight W = mg · mass vs weight · free fall · PE = mgh · projectile motion (qualitative)",
              formulas: "W = mg · PE = mgh · weight ≠ mass",
              knowCold: ["On Moon — mass, weight, or both change? (Weight only)", "Ball rises — PE up or down? (Increases)"],
              topic: "Work & energy",
              tossups: [
                  ("On the Moon, is an object's mass, weight, or both different from Earth?", "Weight (mass unchanged)"),
                  ("As a ball rises, does gravitational potential energy increase or decrease?", "Increases")
              ]),
        block(week: 6, day: .thursday, subject: .chemistry, pass: .pass1,
              book: "Expl", chapter: "Ch 21 §21.1–21.3", title: "Neutralization & Titration",
              pass2Book: "Mod", pass2Chapter: "Ch 14 §", pass2Title: "Acids and Bases (backup)",
              backupBookLine: "Tro Ch 14",
              focus: "~1 hr · neutralization: acid + base → salt + water · HCl + NaOH · strong vs weak (intro) · titration concept",
              formulas: "HCl + NaOH → NaCl + H₂O · acid + base → salt + water",
              knowCold: ["HCl + NaOH products? (NaCl and water)", "pH 11 — acid or base? (Basic)"],
              topic: "Acids, bases & pH",
              tossups: [
                  ("What are the products of HCl + NaOH?", "NaCl and water"),
                  ("Is a solution with pH 11 acidic or basic?", "Basic")
              ]),
        block(week: 6, day: .friday, subject: .biology, pass: .pass1,
              book: "FLS", chapter: "Ch 8 — Bacteria · Viruses", title: "Bacteria & Viruses",
              backupBookLine: "OSB Ch 13 · CB Ch 16",
              focus: "~1 hr · prokaryote · bacteria shapes · virus vs bacterium · antibiotic vs antiviral · vaccines (intro)",
              formulas: "bacteria = prokaryote · virus needs host · antibiotic ≠ virus",
              knowCold: ["Antibiotic for a virus — yes or no? (No)", "Bacteria have nucleus? (No — prokaryote)"],
              topic: "Microorganisms & disease",
              tossups: [
                  ("Can antibiotics treat viral infections?", "No"),
                  ("Do bacteria have a membrane-bound nucleus?", "No (prokaryote)")
              ]),

        // WEEK 7 — Immunity + momentum
        block(week: 7, day: .monday, subject: .chemistry, pass: .pass1,
              book: "Expl", chapter: "Ch 20 §20.1–20.4", title: "Reaction Types (deeper)",
              pass2Book: "Mod", pass2Chapter: "Ch 8 §", pass2Title: "Chemical Reactions (backup)",
              backupBookLine: "Tro Ch 7",
              focus: "~1 hr · synthesis · decomposition · single/double replacement · combustion · balance harder equations",
              formulas: "A + B → AB · AB → A + B · combustion needs O₂",
              knowCold: ["2H₂O → 2H₂ + O₂ — synthesis or decomposition? (Decomposition)", "Combustion requires which gas? (Oxygen/O₂)"],
              topic: "Chemical reactions",
              tossups: [
                  ("Classify 2H₂O → 2H₂ + O₂ — synthesis or decomposition?", "Decomposition"),
                  ("Combustion reactions require which reactant gas?", "Oxygen (O₂)")
              ]),
        block(week: 7, day: .tuesday, subject: .biology, pass: .pass1,
              book: "FLS", chapter: "Ch 21 — The Body's Defenses", title: "Immune System",
              backupBookLine: "OSB Ch 17 · CB Ch 24",
              focus: "~1 hr · innate vs adaptive · B cells · T cells · antibodies · memory cells · vaccines",
              formulas: "innate vs adaptive · memory cells · antibody",
              knowCold: ["Why second infection often milder? (Memory cells)", "One innate barrier? (Skin/mucous membranes)"],
              topic: "Microorganisms & disease",
              tossups: [
                  ("Why is a second infection with the same pathogen often milder?", "Memory cells/adaptive immunity"),
                  ("Name one innate immune barrier.", "Skin/mucous membranes")
              ]),
        block(week: 7, day: .wednesday, subject: .physics, pass: .pass1,
              book: "Expl", chapter: "Ch 5 §5.1–5.5", title: "Momentum & Collisions",
              focus: "~1 hr · momentum p = mv · conservation of momentum · elastic vs inelastic · impulse (intro)",
              formulas: "p = mv · conservation of momentum · F = ma",
              knowCold: ["2 kg at 3 m/s — momentum? (6 kg·m/s)", "Same v — truck or bike more momentum? (Truck)"],
              topic: "Forces & momentum",
              tossups: [
                  ("A 2 kg object moves at 3 m/s — what is its momentum?", "6 kg·m/s"),
                  ("At equal velocity, which has greater momentum, a truck or a bicycle?", "Truck")
              ]),
        block(week: 7, day: .thursday, subject: .chemistry, pass: .pass1,
              book: "Expl", chapter: "Ch 17 §17.6–17.7", title: "Periodic Trends (deeper)",
              pass2Book: "Mod", pass2Chapter: "Ch 5 §", pass2Title: "Periodic Trends (backup)",
              backupBookLine: "Tro Ch 9",
              focus: "~1 hr · ionization energy · electronegativity · metallic character · halogen reactivity · ion size vs atom size",
              formulas: "radius ↓ across period · ionization energy ↑ across period · F most reactive halogen",
              knowCold: ["Across period — radius increases or decreases? (Decreases)", "F or I more reactive halogen? (Fluorine)"],
              topic: "Periodic trends & elements",
              tossups: [
                  ("Across a period left to right, does atomic radius generally increase or decrease?", "Decreases"),
                  ("Which halogen is generally most reactive, fluorine or iodine?", "Fluorine")
              ]),
        block(week: 7, day: .friday, subject: .biology, pass: .pass1,
              book: "FLS", chapter: "Ch 10 — What Are Plants? · Roots, Stems, and Leaves", title: "Plant Structure (part 1)",
              backupBookLine: "OSB Ch 14 · CB Ch 31",
              focus: "~1 hr · part 1: root · stem · leaf · meristem · vascular tissue overview. Fri = xylem/phloem (Ch 15).",
              formulas: "xylem · phloem · meristem · root/stem/leaf",
              knowCold: ["Tissue that transports water up? (Xylem)", "Meristem function? (Growth/dividing cells)"],
              topic: "Plants & animals",
              tossups: [
                  ("Which vascular tissue transports water upward in plants?", "Xylem"),
                  ("What type of plant tissue is responsible for growth?", "Meristem")
              ]),

        // WEEK 8 — Plants + electricity intro
        block(week: 8, day: .monday, subject: .chemistry, pass: .pass1,
              book: "Expl", chapter: "Ch 17 §17.4–17.5", title: "Density & Unit Analysis",
              pass2Book: "Mod", pass2Chapter: "Ch 2 §", pass2Title: "Measurement (backup)",
              backupBookLine: "Tro Ch 2",
              focus: "~1 hr · density d = m/V · unit analysis · K = °C + 273 · percent error (intro) · sig figs review",
              formulas: "d = m/V · K = °C + 273 · sig figs",
              knowCold: ["Sig figs in 0.00450? (3)", "25°C to kelvin? (298 K)"],
              topic: "Lab & equipment",
              tossups: [
                  ("How many significant figures are in 0.00450?", "3"),
                  ("Convert 25°C to kelvin.", "298 K")
              ]),
        block(week: 8, day: .tuesday, subject: .biology, pass: .pass1,
              book: "FLS", chapter: "Ch 11 — Seed Plants", title: "Plant Transport & Tissues (part 2)",
              backupBookLine: "OSB Ch 15 · CB Ch 31",
              focus: "~1 hr · part 2: xylem (water up) · phloem (sugars) · stomata · transpiration (intro)",
              formulas: "xylem · phloem · stomata · transpiration",
              knowCold: ["Phloem transports what? (Sugars)", "Xylem moves water up or down? (Up)"],
              topic: "Plants & animals",
              tossups: [
                  ("Name the vascular tissue that transports sugars in plants.", "Phloem"),
                  ("Does xylem transport water upward or downward?", "Upward")
              ]),
        block(week: 8, day: .wednesday, subject: .physics, pass: .pass1,
              book: "Expl", chapter: "Ch 10 §10.1–10.7 + §10.11", title: "Electricity — Charge & Current",
              focus: "~1 hr · charge · current · voltage · resistance · V = IR · conductors vs insulators · series vs parallel (intro)",
              formulas: "V = IR · current (A) · voltage (V) · resistance (Ω)",
              knowCold: ["SI unit of current? (Ampere/A)", "More resistors in series — R up or down? (Up)"],
              topic: "Electricity",
              tossups: [
                  ("What is the SI unit of electric current?", "Ampere (A)"),
                  ("More resistors added in series — does total resistance increase or decrease?", "Increases")
              ]),
        block(week: 8, day: .thursday, subject: .chemistry, pass: .pass1,
              book: "Expl", chapter: "Ch 17 §17.3–17.5", title: "Heating Curves & Phase Diagrams",
              pass2Book: "Mod", pass2Chapter: "Ch 10 §", pass2Title: "Matter and Energy (backup)",
              backupBookLine: "Tro Ch 3",
              focus: "~1 hr · heating/cooling curves · plateau = phase change · physical vs chemical change review · evaporation vs boiling",
              formulas: "heating curve plateau · physical vs chemical change",
              knowCold: ["Plateau on heating curve means? (Phase change at constant T)", "Melting ice — physical or chemical? (Physical)"],
              topic: "States of matter",
              tossups: [
                  ("On a heating curve, what does a flat plateau indicate?", "Phase change at constant temperature"),
                  ("Is melting ice a physical or chemical change?", "Physical")
              ]),
        block(week: 8, day: .friday, subject: .biology, pass: .pass1,
              book: "FLS", chapter: "Ch 17 — Bones and Muscles", title: "Animal Structure & Tissues",
              backupBookLine: "OSB Ch 18 · CB Ch 20",
              focus: "~1 hr · epithelial · muscle · nervous · connective tissues · organ systems overview",
              formulas: "epithelial · muscle · nervous · connective",
              knowCold: ["Tissue that contracts? (Muscle)", "Tissue that sends signals? (Nervous)"],
              topic: "Plants & animals",
              tossups: [
                  ("Which tissue type is specialized for contraction?", "Muscle"),
                  ("Which tissue type transmits electrical signals?", "Nervous")
              ]),

        // WEEK 9 — Electricity + light
        block(week: 9, day: .monday, subject: .chemistry, pass: .pass1,
              book: "Expl", chapter: "Ch 17 §17.2–17.3", title: "Isotopes & Average Atomic Mass",
              pass2Book: "Mod", pass2Chapter: "Ch 3 §", pass2Title: "Atoms (backup)",
              backupBookLine: "Tro Ch 4",
              focus: "~1 hr · isotopes · average atomic mass · nuclear notation · review Z vs A with calculations",
              formulas: "Z = # protons · A = p + n · average atomic mass",
              knowCold: ["Isotopes differ in which particle? (Neutrons)", "Carbon-12 neutral atom — electrons? (6)"],
              topic: "Atoms & periodic table",
              tossups: [
                  ("Two isotopes of an element differ in which subatomic particle count?", "Neutrons"),
                  ("Carbon-12 has 6 protons — how many electrons in a neutral atom?", "6")
              ]),
        block(week: 9, day: .tuesday, subject: .biology, pass: .pass1,
              book: "FLS", chapter: "Ch 3 — Genetics: The Science of Heredity · Traits and Inheritance", title: "Cell Reproduction (intro)",
              backupBookLine: "OSB Ch 6 · CB Ch 8",
              focus: "~1 hr · mitosis stages (overview) · chromosome · diploid vs haploid (intro) · why cells divide",
              formulas: "mitosis → 2 identical cells · chromosome · diploid",
              knowCold: ["Mitosis produces how many cells? (2)", "Division for growth/repair? (Mitosis)"],
              topic: "Cell structure",
              tossups: [
                  ("How many daughter cells result from one mitosis?", "2"),
                  ("Mitosis is used primarily for what purpose in the body?", "Growth and repair")
              ]),
        block(week: 9, day: .wednesday, subject: .physics, pass: .pass1,
              book: "Expl", chapter: "Ch 10 §10.11 + Ch 12 §12.1–12.3 + Ch 13 §13.1", title: "Circuits & Waves (part 2)",
              focus: "~1 hr · series vs parallel circuits · v = fλ · electromagnetic spectrum · sound vs light (intro)",
              formulas: "V = IR · series R_total ↑ · v = fλ · ROYGBIV",
              knowCold: ["Higher pitch → higher or lower frequency? (Higher)", "v = fλ relates? (Speed, frequency, wavelength)"],
              topic: "Waves & electricity",
              tossups: [
                  ("A higher-pitched sound corresponds to higher or lower frequency?", "Higher frequency"),
                  ("What three quantities does v = fλ relate?", "Speed, frequency, and wavelength")
              ]),
        block(week: 9, day: .thursday, subject: .chemistry, pass: .pass1,
              book: "Expl", chapter: "Ch 18 §18.2–18.4", title: "Ions & Ionic Compounds",
              pass2Book: "Mod", pass2Chapter: "Ch 5 + Ch 7", pass2Title: "Ions & Compounds (backup)",
              backupBookLine: "Tro Ch 4–5",
              focus: "~1 hr · cations (+) · anions (−) · Na⁺, Cl⁻, Ca²⁺, O²⁻ · polyatomic ions CO₃²⁻, OH⁻ · ionic formulas",
              formulas: "cation (+) · anion (−) · NaCl ionic · CO₃²⁻",
              knowCold: ["Charge on oxide ion? (2−)", "Na forms Na⁺ or Na⁻? (Na⁺)"],
              topic: "Ions & compounds",
              tossups: [
                  ("What is the charge on the oxide ion?", "2−"),
                  ("When sodium loses one electron, what ion forms?", "Na⁺")
              ]),
        block(week: 9, day: .friday, subject: .biology, pass: .pass1,
              book: "FLS", chapter: "Ch 18 — Food and Energy · Ch 19 — The Circulatory System", title: "Digestive & Circulatory (deeper)",
              backupBookLine: "OSB Ch 16 § · CB Ch 21–23",
              focus: "~1 hr · digestive path · small intestine absorption · heart chambers · arteries/veins/capillaries · alveoli",
              formulas: "small intestine = absorption · artery away · vein toward heart",
              knowCold: ["Most nutrient absorption where? (Small intestine)", "Veins toward or away from heart? (Toward heart)"],
              topic: "Human body systems",
              tossups: [
                  ("In which organ does most nutrient absorption occur?", "Small intestine"),
                  ("Do veins generally carry blood toward or away from the heart?", "Toward heart")
              ]),

        // WEEK 10 — Summer capstone (light review, no flash-card pass)
        block(week: 10, day: .monday, subject: .chemistry, pass: .pass1,
              book: "Expl", chapter: "Review", title: "Chemistry capstone — atoms to reactions",
              pass2Book: "Mod", pass2Chapter: "Review", pass2Title: "Mod/Tro if stuck",
              backupBookLine: "Tro / BFN-Sci if stuck",
              focus: "~1 hr · no new chapter · pick 2 weak Mod topics from your notebook · know-cold + 8 toss-ups · Tro/BFN-Sci if stuck",
              formulas: "Z · A · pH · balance · M = mol/L · ionic vs covalent",
              knowCold: ["pH of pure water? (7)", "Symbol for potassium? (K)"],
              topic: "Atoms & periodic table",
              tossups: [
                  ("What is the pH of a neutral solution at 25°C?", "7"),
                  ("What is the chemical symbol for potassium?", "K")
              ]),
        block(week: 10, day: .tuesday, subject: .biology, pass: .pass1,
              book: "FLS", chapter: "Review", title: "Biology capstone — cells to ecology",
              backupBookLine: "OSB · CB · BFN-Bio",
              focus: "~1 hr · no new chapter · review organelles · genetics · ecology · immunity · 8 toss-ups on weak areas",
              formulas: "ATP · photosynthesis/respiration · Punnett · symbiosis types",
              knowCold: ["Organelle that makes ATP? (Mitochondria)", "Tt × Tt phenotypic ratio? (3:1)"],
              topic: "Cell structure",
              tossups: [
                  ("Which organelle produces most ATP in eukaryotes?", "Mitochondria"),
                  ("In a monohybrid cross Tt × Tt, what is the expected phenotypic ratio?", "3:1")
              ]),
        block(week: 10, day: .wednesday, subject: .physics, pass: .pass1,
              book: "Expl", chapter: "Ch 11 §11.1–11.5 + Ch 13 §13.3–13.4", title: "Electricity & Magnetism (wrap-up)",
              focus: "~1 hr · magnets · electromagnetism (intro) · review V = IR · circuits · energy forms in a scenario",
              formulas: "V = IR · W = Fd · PE = mgh · KE = ½mv² · v = fλ",
              knowCold: ["SI unit of resistance? (Ohm/Ω)", "Ball falls — PE converts to? (Kinetic energy)"],
              topic: "Electricity",
              tossups: [
                  ("What is the SI unit of electrical resistance?", "Ohm (Ω)"),
                  ("As a ball falls, potential energy is converted primarily into what?", "Kinetic energy")
              ]),
        block(week: 10, day: .thursday, subject: .chemistry, pass: .pass1,
              book: "Expl", chapter: "Review", title: "Lab skills & periodic table",
              pass2Book: "Mod", pass2Chapter: "Review", pass2Title: "Mod/Tro if stuck",
              backupBookLine: "Tro / BFN-Sci if stuck",
              focus: "~1 hr · SI units · sig figs · lab equipment · first 20 elements · safety · optional periodic-table HTML in Calendar tab",
              formulas: "kg, m, s, mol · read meniscus · first 20 symbols",
              knowCold: ["SI unit for mass? (Kilogram/kg)", "Glassware for precise volume? (Graduated cylinder)"],
              topic: "Lab & equipment",
              tossups: [
                  ("What is the SI base unit for mass?", "Kilogram (kg)"),
                  ("Which piece of lab glassware measures liquid volume most precisely?", "Graduated cylinder")
              ]),
        block(week: 10, day: .friday, subject: .biology, pass: .pass1,
              book: "FLS", chapter: "Review", title: "Final summer bio check",
              backupBookLine: "OSB · BFN-Bio",
              focus: "~1 hr · mock toss-ups across bio topics · list 3 topics to keep sharp at school meetings · no new reading",
              formulas: "producer · consumer · antibody · xylem · phloem",
              knowCold: ["Three symbiosis types? (Mutualism, commensalism, parasitism)", "Gas released in photosynthesis? (Oxygen/O₂)"],
              topic: "Ecology",
              tossups: [
                  ("Name the three types of symbiosis.", "Mutualism, commensalism, parasitism"),
                  ("What gas is released as a product of photosynthesis?", "Oxygen/O₂")
              ])
    ]
}
