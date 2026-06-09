import Foundation

extension SeedData {
    // MARK: - Weeks 5–8 (Pass 2 — same rotation, Tro/CB/Expl deeper)

    static let weeks5Through8: [StudyBlock] = {
        (5...8).flatMap { week in
            let w = ((week - 1) % 4) + 1
            return week5Through8Blocks(forWeek: week, templateWeek: w)
        }
    }()

    private static func week5Through8Blocks(forWeek week: Int, templateWeek w: Int) -> [StudyBlock] {
        switch w {
        case 1:
            return [
                block(week: week, day: .monday, subject: .chemistry, pass: .pass2,
                      book: "Mod", chapter: "Ch 3", title: "Atoms (review)",
                      pass2Book: "Tro", pass2Chapter: "Ch 4 §4.3–4.6", pass2Title: "Atoms & Elements",
                      focus: "Same core as Week 1 with Tro depth: isotopes · average atomic mass · DOE questions first, then re-read missed sections",
                      formulas: "Z = # protons · A = p + n · isotopes · average atomic mass",
                      knowCold: ["Carbon-12 neutral atom — electrons? (6)", "Isotopes differ in which particle? (Neutrons)"],
                      topic: "Atoms & periodic table",
                      tossups: [
                          ("DOE-style: Carbon-12 has 6 protons — how many electrons in a neutral atom?", "6"),
                          ("DOE-style: Two isotopes of an element differ in which subatomic particle count?", "Neutrons")
                      ]),
                block(week: week, day: .tuesday, subject: .biology, pass: .pass2,
                      book: "OSB", chapter: "Ch 3", title: "Cell Structure (review)",
                      backupBookLine: "FLS Ch 1 · CB Ch 4",
                      focus: "Deeper than FLS: nucleus/nucleolus · rough vs smooth ER · Golgi · lysosome · cytoskeleton · phospholipid bilayer · prokaryote vs eukaryote",
                      formulas: "rough ER · smooth ER · lysosome · Golgi · cytoskeleton",
                      knowCold: ["Function of lysosome? (Digests worn-out parts)", "Two organelles in plant not animal? (Cell wall, chloroplast)"],
                      topic: "Cell structure",
                      tossups: [
                          ("DOE-style: Which organelle digests worn-out cell parts?", "Lysosome"),
                          ("DOE-style: Name two organelles found in plant cells but not in typical animal cells.", "Cell wall and chloroplast")
                      ]),
                block(week: week, day: .wednesday, subject: .physics, pass: .pass2,
                      book: "Expl", chapter: "Ch 1 + App. B", title: "Motion (deeper + DOE)",
                      focus: "Re-read with DOE misses in mind · acceleration from graph · precision vs accuracy · relative motion (intro)",
                      formulas: "v = d/t · slope on d-t = speed · slope on v-t = acceleration",
                      knowCold: ["Car slows from 20 m/s to 10 m/s — acceleration sign? (Negative)", "Slope on v-t graph means? (Acceleration)"],
                      topic: "Motion",
                      tossups: [
                          ("DOE-style: A car slows from 20 m/s to 10 m/s — is acceleration positive or negative?", "Negative"),
                          ("DOE-style: On a velocity-time graph, what physical quantity does slope represent?", "Acceleration")
                      ]),
                block(week: week, day: .thursday, subject: .chemistry, pass: .pass2,
                      book: "Mod", chapter: "Ch 5 + Ch 7", title: "Ions (review)",
                      pass2Book: "Tro", pass2Chapter: "Ch 4 §4.7–4.8 + Ch 5", pass2Title: "Ions · Molecules & Compounds",
                      focus: "Cations (+) · anions (−) · Na⁺, Cl⁻, Ca²⁺, O²⁻ · ionic vs covalent bonding · polyatomic ions CO₃²⁻, OH⁻",
                      formulas: "cation (+) · anion (−) · ionic vs covalent · NaCl ionic",
                      knowCold: ["Charge on oxide ion? (2−)", "NaCl — ionic or covalent? (Ionic)"],
                      topic: "Ions & compounds",
                      tossups: [
                          ("DOE-style: What is the charge on the oxide ion?", "2−"),
                          ("DOE-style: Is NaCl held together by ionic or covalent bonds?", "Ionic")
                      ]),
                block(week: week, day: .friday, subject: .biology, pass: .pass2,
                      book: "OSB", chapter: "Ch 1 + Ch 16", title: "Cell Energy (review)",
                      backupBookLine: "FLS Ch 2 · CB Ch 6–7",
                      focus: "ATP · cellular respiration vs photosynthesis · mitochondria vs chloroplast · aerobic vs anaerobic (intro)",
                      formulas: "respiration I/O · photosynthesis I/O · mitochondria · chloroplast",
                      knowCold: ["Organelle for cellular respiration? (Mitochondria)", "Gas released in photosynthesis? (Oxygen/O₂)"],
                      topic: "Photosynthesis & respiration",
                      tossups: [
                          ("DOE-style: Name the organelle where cellular respiration mainly occurs.", "Mitochondria"),
                          ("DOE-style: What gas is released as a product of photosynthesis?", "Oxygen/O₂")
                      ])
            ]
        case 2:
            return [
                block(week: week, day: .monday, subject: .chemistry, pass: .pass2,
                      book: "Mod", chapter: "Ch 10", title: "States of Matter (review)",
                      pass2Book: "Tro", pass2Chapter: "Ch 3", pass2Title: "Matter and Energy",
                      focus: "Physical vs chemical change · conservation of matter · endothermic vs exothermic · classify burning wood vs melting ice",
                      formulas: "physical vs chemical change · conservation of mass",
                      knowCold: ["Burning log — physical or chemical? (Chemical)", "Is matter created in a reaction? (Conserved)"],
                      topic: "States of matter",
                      tossups: [
                          ("DOE-style: Is burning wood a physical or chemical change?", "Chemical"),
                          ("DOE-style: In a chemical reaction, is matter created or conserved?", "Conserved")
                      ]),
                block(week: week, day: .tuesday, subject: .biology, pass: .pass2,
                      book: "OSB", chapter: "Ch 7 + Ch 8", title: "Genetics (review)",
                      backupBookLine: "FLS Ch 4 · CB Ch 9",
                      focus: "Mendel · Aa × Aa genotypic ratio 1:2:1 · phenotype 3:1 · heterozygous vs homozygous · dihybrid (intro)",
                      formulas: "Aa × Aa → 1 AA : 2 Aa : 1 aa · phenotype 3:1",
                      knowCold: ["Aa × Aa genotypic ratio? (1:2:1)", "Phenotype of aa if A dominant? (Recessive phenotype)"],
                      topic: "Genetics",
                      tossups: [
                          ("DOE-style: Cross Aa × Aa — what genotypic ratio is expected?", "1:2:1"),
                          ("DOE-style: If A is dominant, what is the phenotype of aa?", "Recessive phenotype")
                      ]),
                block(week: week, day: .wednesday, subject: .physics, pass: .pass2,
                      book: "Expl", chapter: "Ch 2–5", title: "Newton's laws + Momentum",
                      focus: "All 3 laws (deeper) · momentum p = mv · conservation of momentum · elastic vs inelastic collisions · friction types",
                      formulas: "p = mv · conservation of momentum · F = ma",
                      knowCold: ["2 kg at 3 m/s — momentum? (6 kg·m/s)", "Same v — truck or bike more momentum? (Truck)"],
                      topic: "Forces & momentum",
                      tossups: [
                          ("DOE-style: A 2 kg object moves at 3 m/s — what is its momentum?", "6 kg·m/s"),
                          ("DOE-style: At equal velocity, which has greater momentum, a truck or a bicycle?", "Truck")
                      ]),
                block(week: week, day: .thursday, subject: .chemistry, pass: .pass2,
                      book: "Mod", chapter: "Ch 8", title: "Reactions (review)",
                      pass2Book: "Tro", pass2Chapter: "Ch 7 §7.1–7.4", pass2Title: "Chemical Reactions",
                      focus: "Synthesis · decomposition · single/double replacement · combustion · balance harder equations",
                      formulas: "A + B → AB · AB → A + B · combustion needs O₂",
                      knowCold: ["Classify 2H₂O → 2H₂ + O₂ (Decomposition)", "Balance Fe + O₂ → Fe₂O₃"],
                      topic: "Chemical reactions",
                      tossups: [
                          ("DOE-style: Classify 2H₂O → 2H₂ + O₂ — synthesis or decomposition?", "Decomposition"),
                          ("DOE-style: Balance Fe + O₂ → Fe₂O₃ (smallest whole-number coefficients).", "4Fe + 3O₂ → 2Fe₂O₃")
                      ]),
                block(week: week, day: .friday, subject: .biology, pass: .pass2,
                      book: "OSB", chapter: "Ch 16", title: "Body Systems (review)",
                      backupBookLine: "FLS Ch 16–20 · CB Ch 21–23",
                      focus: "Digestive path · alveoli O₂/CO₂ diffusion · heart chambers · arteries/veins/capillaries · RBC carries O₂",
                      formulas: "small intestine = absorption · vein toward heart",
                      knowCold: ["Most nutrient absorption where? (Small intestine)", "Veins carry blood toward or away from heart? (Toward heart)"],
                      topic: "Human body systems",
                      tossups: [
                          ("DOE-style: In which organ does most nutrient absorption occur?", "Small intestine"),
                          ("DOE-style: Do veins generally carry blood toward or away from the heart?", "Toward heart")
                      ])
            ]
        case 3:
            return [
                block(week: week, day: .monday, subject: .chemistry, pass: .pass2,
                      book: "Mod", chapter: "Ch 14", title: "Acids & Bases (review)",
                      pass2Book: "Tro", pass2Chapter: "Ch 14", pass2Title: "Acids and Bases",
                      focus: "Strong vs weak acids/bases · neutralization: acid + base → salt + water · titration (concept) · HCl + NaOH",
                      formulas: "HCl + NaOH → NaCl + H₂O · pH < 7 acid · pH > 7 base",
                      knowCold: ["HCl + NaOH products? (NaCl and water)", "pH 11 — acid or base? (Basic)"],
                      topic: "Acids, bases & pH",
                      tossups: [
                          ("DOE-style: What are the products of HCl + NaOH?", "NaCl and water"),
                          ("DOE-style: Is pH 11 acidic or basic?", "Basic")
                      ]),
                block(week: week, day: .tuesday, subject: .biology, pass: .pass2,
                      book: "OSB", chapter: "Ch 19 + Ch 20", title: "Population Ecology · Communities",
                      backupBookLine: "FLS Ch 7 · CB Ch 36–37",
                      focus: "Carrying capacity (K) · exponential vs logistic growth · biotic vs abiotic · primary vs secondary succession · carbon cycle (intro)",
                      formulas: "carrying capacity · primary succession · biotic vs abiotic",
                      knowCold: ["Term for max population environment supports? (Carrying capacity)", "Is sunlight biotic or abiotic? (Abiotic)"],
                      topic: "Ecology",
                      tossups: [
                          ("DOE-style: What term describes the maximum population an environment can support?", "Carrying capacity"),
                          ("DOE-style: Is sunlight biotic or abiotic?", "Abiotic")
                      ]),
                block(week: week, day: .wednesday, subject: .physics, pass: .pass2,
                      book: "Expl", chapter: "Ch 6–7", title: "Energy · Gravity",
                      focus: "PE = mgh · KE = ½mv² · W = mg (weight) · conservation of energy · mass vs weight · projectile motion (qualitative)",
                      formulas: "PE = mgh · KE = ½mv² · weight = mg",
                      knowCold: ["Ball rises — PE up or down? (Increases)", "On Moon — mass, weight, or both different? (Weight; mass unchanged)"],
                      topic: "Work & energy",
                      tossups: [
                          ("DOE-style: As a ball rises, does gravitational potential energy increase or decrease?", "Increases"),
                          ("DOE-style: On the Moon, is an object's mass, weight, or both different from Earth?", "Weight (mass unchanged)")
                      ]),
                block(week: week, day: .thursday, subject: .chemistry, pass: .pass2,
                      book: "Mod", chapter: "Ch 12", title: "Solutions (review)",
                      pass2Book: "Tro", pass2Chapter: "Ch 13", pass2Title: "Solutions",
                      focus: "Molarity M = mol/L · M₁V₁ = M₂V₂ · solubility · electrolytes vs nonelectrolytes · dilution ↓ concentration",
                      formulas: "M = mol/L · M₁V₁ = M₂V₂ · saturated · unsaturated",
                      knowCold: ["Add solvent — concentration up or down? (Down)", "Saturated + crystal at RT — dissolves? (No)"],
                      topic: "Solutions",
                      tossups: [
                          ("DOE-style: Adding solvent to a solution — does concentration increase or decrease?", "Decreases"),
                          ("DOE-style: In a saturated solution at room temperature, will an added crystal dissolve?", "No")
                      ]),
                block(week: week, day: .friday, subject: .biology, pass: .pass2,
                      book: "OSB", chapter: "Ch 13 + Ch 17", title: "Microbes · Immune System (deeper)",
                      backupBookLine: "FLS Ch 8 · 21 · CB Ch 16 · 24",
                      focus: "Innate vs adaptive immunity · B cells · T cells · memory cells · lytic cycle (intro) · allergies (intro)",
                      formulas: "innate vs adaptive · memory cells · antibody",
                      knowCold: ["Why second infection often milder? (Memory cells/adaptive immunity)", "One innate barrier? (Skin/mucous/stomach acid)"],
                      topic: "Microorganisms & disease",
                      tossups: [
                          ("DOE-style: Why is a second infection with the same pathogen often milder?", "Memory cells/adaptive immunity"),
                          ("DOE-style: Name one innate immune barrier.", "Skin/mucous/stomach acid")
                      ])
            ]
        default:
            return [
                block(week: week, day: .monday, subject: .chemistry, pass: .pass2,
                      book: "Mod", chapter: "Ch 5", title: "Periodic trends (review)",
                      pass2Book: "Tro", pass2Chapter: "Ch 9 §9.7 · §9.9", pass2Title: "Periodic trends",
                      focus: "Atomic radius · ionization energy · electronegativity trends · metallic character · halogen reactivity",
                      formulas: "radius ↓ across period · ionization energy ↑ across period · F most reactive halogen",
                      knowCold: ["Across period — radius increases or decreases? (Decreases)", "F or I more reactive halogen? (Fluorine)"],
                      topic: "Periodic trends & elements",
                      tossups: [
                          ("DOE-style: Across a period left to right, does atomic radius generally increase or decrease?", "Decreases"),
                          ("DOE-style: Which halogen is generally most reactive, fluorine or iodine?", "Fluorine")
                      ]),
                block(week: week, day: .tuesday, subject: .biology, pass: .pass2,
                      book: "OSB", chapter: "Ch 11 + Ch 12", title: "Evolution (review)",
                      backupBookLine: "FLS Ch 5–6 · CB Ch 13–14",
                      focus: "Natural selection mechanisms · gene pool · geographic isolation · reproductive isolation · adaptive radiation (intro)",
                      formulas: "geographic isolation · reproductive isolation · mutations = variation",
                      knowCold: ["Populations separated by mountain — what isolation? (Geographic isolation)", "Source of genetic variation? (Mutations)"],
                      topic: "Evolution & classification",
                      tossups: [
                          ("DOE-style: Populations separated by a mountain range may undergo what type of isolation?", "Geographic isolation"),
                          ("DOE-style: What is the ultimate source of genetic variation in a population?", "Mutations")
                      ]),
                block(week: week, day: .wednesday, subject: .physics, pass: .pass2,
                      book: "Expl", chapter: "Ch 10–13", title: "Electricity · Waves · Light",
                      pass2Book: "Expl", pass2Chapter: "Ch 10–14", pass2Title: "Electricity · Waves · Light · Properties of Light",
                      focus: "V = IR · series vs parallel · v = fλ · electromagnetic spectrum · Ch 14 lenses/dispersion (stretch)",
                      formulas: "V = IR · series R_total ↑ · v = fλ · ROYGBIV",
                      knowCold: ["More resistors in series — R up or down? (Up)", "SI unit of current? (Ampere/A)"],
                      topic: "Waves & electricity",
                      tossups: [
                          ("DOE-style: More resistors added in series — does total resistance increase or decrease?", "Increases"),
                          ("DOE-style: What is the SI unit of electric current?", "Ampere (A)")
                      ]),
                block(week: week, day: .thursday, subject: .chemistry, pass: .pass2,
                      book: "Mod", chapter: "Ch 2", title: "Measurements (review)",
                      pass2Book: "Tro", pass2Chapter: "Ch 2", pass2Title: "Measurement and Problem Solving",
                      focus: "Significant figures · unit analysis · density d = m/V · K = °C + 273 · percent error (intro)",
                      formulas: "sig figs · K = °C + 273 · d = m/V",
                      knowCold: ["Sig figs in 0.00450? (3)", "25°C to kelvin? (298 K)"],
                      topic: "Lab & equipment",
                      tossups: [
                          ("DOE-style: How many significant figures are in 0.00450?", "3"),
                          ("DOE-style: Convert 25°C to kelvin.", "298 K")
                      ]),
                block(week: week, day: .friday, subject: .biology, pass: .pass2,
                      book: "OSB", chapter: "Ch 14 + Ch 15", title: "Plants · Animal Structure",
                      backupBookLine: "FLS Ch 10–11 · CB Ch 31 · 20",
                      focus: "Xylem (water up) · phloem (sugars) · meristem · epithelial/muscle/nervous/connective tissues",
                      formulas: "xylem · phloem · meristem · tissue types",
                      knowCold: ["Xylem moves water up or down? (Up)", "Tissue that transports sugars? (Phloem)"],
                      topic: "Plants & animals",
                      tossups: [
                          ("DOE-style: Which vascular tissue transports water upward in plants?", "Xylem"),
                          ("DOE-style: Name the vascular tissue that transports sugars in plants.", "Phloem")
                      ])
            ]
        }
    }

    // MARK: - Weeks 9–10 (Pass 3 — flash card mode)

    static let weeks9Through10: [StudyBlock] = [
        block(week: 9, day: .monday, subject: .chemistry, pass: .pass3,
              book: "Tro/Mod", chapter: "Ch 3–4", title: "Atoms review",
              focus: "Flash cards: subatomic particles · atomic # · mass # · isotopes · 5 DOE toss-ups · open book only if stuck",
              formulas: "Z = # protons · A = p + n · isotopes",
              knowCold: ["What particle defines the element? (Proton/atomic number)", "Same Z, different n — called? (Isotopes)"],
              topic: "Atoms review", tossups: [
                  ("Flash card: What particle defines the element?", "Proton/atomic number"),
                  ("Flash card: Same Z, different n — what are these called?", "Isotopes")
              ], flashOnly: true),
        block(week: 9, day: .tuesday, subject: .biology, pass: .pass3,
              book: "OSB", chapter: "Ch 3", title: "Cell review",
                      backupBookLine: "FLS Ch 1 · CB Ch 4",
              focus: "Organelles & functions · plant vs animal · prokaryote/eukaryote · flash cards · 5 DOE",
              formulas: "nucleus · mitochondria · chloroplast · ribosome · cell wall",
              knowCold: ["Organelle that makes ATP? (Mitochondria)", "Plant-only organelle for photosynthesis? (Chloroplast)"],
              topic: "Cell review", tossups: [
                  ("Flash card: Organelle that makes ATP?", "Mitochondria"),
                  ("Flash card: Plant-only organelle for photosynthesis?", "Chloroplast")
              ], flashOnly: true),
        block(week: 9, day: .wednesday, subject: .physics, pass: .pass3,
              book: "Expl", chapter: "Ch 1 + App. B", title: "Motion review",
              focus: "SI units · v = d/t · graph reading · timed 5 toss-ups",
              formulas: "v = d/t · SI: m, kg, s",
              knowCold: ["Formula for average speed? (v = d/t)", "SI unit for distance? (Meter/m)"],
              topic: "Motion review", tossups: [
                  ("Flash card: Formula for average speed?", "v = d/t"),
                  ("Flash card: SI unit for distance?", "Meter/m")
              ], flashOnly: true),
        block(week: 9, day: .thursday, subject: .chemistry, pass: .pass3,
              book: "Tro/Mod", chapter: "Ch 4–5", title: "Periodic table & compounds",
              focus: "Groups/periods · ionic/covalent · common ions · formulas · flash cards",
              formulas: "NaCl · CO₂ · H₂O · Na⁺ · ionic vs covalent",
              knowCold: ["Formula for carbon dioxide? (CO₂)", "Na loses one electron — ion symbol? (Na⁺)"],
              topic: "Compounds review", tossups: [
                  ("Flash card: Formula for carbon dioxide?", "CO₂"),
                  ("Flash card: Na loses one electron — ion symbol?", "Na⁺")
              ], flashOnly: true),
        block(week: 9, day: .friday, subject: .biology, pass: .pass3,
              book: "OSB", chapter: "Ch 4 + Ch 5", title: "Energy & organization",
                      backupBookLine: "FLS Ch 2 · CB Ch 6–7",
              focus: "Photosynthesis vs respiration · ATP · levels of organization · flash cards",
              formulas: "photosynthesis I/O · respiration I/O · cell→tissue→organ→system",
              knowCold: ["Gas released in photosynthesis? (Oxygen/O₂)", "Order: cell, organ, tissue, organism? (Cell→tissue→organ→organism)"],
              topic: "Energy review", tossups: [
                  ("Flash card: Gas released in photosynthesis?", "Oxygen/O₂"),
                  ("Flash card: Order: cell, organ, tissue, organism?", "Cell→tissue→organ→organism")
              ], flashOnly: true),

        block(week: 10, day: .monday, subject: .chemistry, pass: .pass3,
              book: "Tro/Mod", chapter: "Ch 14", title: "Acids & bases review",
              focus: "pH scale · H⁺/OH⁻ · neutralization · common acids/bases · flash cards",
              formulas: "pH 0–14 · acid < 7 · base > 7 · acid + base → salt + water",
              knowCold: ["pH of pure water? (7)", "pH 2 — acid or base? (Acid)"],
              topic: "Acids review", tossups: [
                  ("Flash card: pH of pure water?", "7"),
                  ("Flash card: pH 2 — acid or base?", "Acid")
              ], flashOnly: true),
        block(week: 10, day: .tuesday, subject: .biology, pass: .pass3,
              book: "CB/FLS", chapter: "Ch 36–37", title: "Ecology review",
                      backupBookLine: "FLS Ch 7 · CB Ch 36–37",
              focus: "Food webs · symbiosis · carrying capacity · biotic/abiotic · flash cards",
              formulas: "producer · consumer · decomposer · mutualism · commensalism · parasitism",
              knowCold: ["Name three symbiosis types. (Mutualism, commensalism, parasitism)", "Is soil biotic or abiotic? (Abiotic)"],
              topic: "Ecology review", tossups: [
                  ("Flash card: Name three symbiosis types.", "Mutualism, commensalism, parasitism"),
                  ("Flash card: Is soil biotic or abiotic?", "Abiotic")
              ], flashOnly: true),
        block(week: 10, day: .wednesday, subject: .physics, pass: .pass3,
              book: "Expl", chapter: "Ch 6–7", title: "Energy & gravity review",
              focus: "PE/KE · W = Fd · conservation · weight vs mass · flash cards",
              formulas: "W = Fd · PE = mgh · KE = ½mv² · weight = mg",
              knowCold: ["8 N for 3 m — work done? (24 J)", "Ball falls — PE converts to? (Kinetic energy/KE)"],
              topic: "Energy review", tossups: [
                  ("Flash card: 8 N for 3 m — work done?", "24 J"),
                  ("Flash card: Ball falls — PE converts to what?", "Kinetic energy/KE")
              ], flashOnly: true),
        block(week: 10, day: .thursday, subject: .chemistry, pass: .pass3,
              book: "Tro/Mod", chapter: "Ch 12–13", title: "Solutions review",
              focus: "Solute/solvent · concentration · saturation · separation methods · flash cards",
              formulas: "solute · solvent · saturated · unsaturated · filtration",
              knowCold: ["In salt water, which is the solute? (Salt)", "Unsaturated — will more solute dissolve? (Yes)"],
              topic: "Solutions review", tossups: [
                  ("Flash card: In salt water, which is the solute?", "Salt"),
                  ("Flash card: Unsaturated solution — will more solute dissolve?", "Yes")
              ], flashOnly: true),
        block(week: 10, day: .friday, subject: .biology, pass: .pass3,
              book: "OSB", chapter: "Ch 8 + Ch 13 + Ch 17", title: "Genetics · microbes · immunity",
                      backupBookLine: "FLS Ch 3–4 · 8 · 21 · CB Ch 16 · 24",
              focus: "Punnett · bacteria vs virus · vaccines · antibodies · flash cards",
              formulas: "Tt × Tt → 3:1 · antibiotic ≠ virus · antibody",
              knowCold: ["Antibiotic for a virus — yes or no? (No)", "Tt × Tt — expected phenotypic ratio? (3:1)"],
              topic: "Genetics review", tossups: [
                  ("Flash card: Antibiotic for a virus — yes or no?", "No"),
                  ("Flash card: Tt × Tt — expected phenotypic ratio?", "3:1")
              ], flashOnly: true)
    ]
}
