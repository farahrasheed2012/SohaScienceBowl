#!/usr/bin/env python3
"""Append Texas Regional Sprint topics, questions, and topic readings."""

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TOPICS = ROOT / "Resources/StudyContent/topics.json"
QUESTIONS = ROOT / "Resources/StudyContent/questions.json"
READINGS = ROOT / "Resources/StudyContent/topic_readings.json"

NEW_TOPICS = [
    {
        "id": "ls-reg-resp-photosyn",
        "subject": "Life Science",
        "title": "Regional Sprint: Respiration & Photosynthesis",
        "whatIsIt": "Texas regional rounds drill every stage of cellular respiration and photosynthesis — where each step happens and what goes in/out.",
        "howItWorks": "Glycolysis splits glucose to pyruvate in the cytoplasm (2 ATP net). Pyruvate enters mitochondria for the Krebs (citric acid) cycle in the matrix, producing CO₂, NADH, and FADH₂. The electron transport chain on the inner mitochondrial membrane uses O₂ as the final electron acceptor to make lots of ATP. Photosynthesis: light reactions in thylakoid membranes make ATP and NADPH; the Calvin cycle in the stroma fixes CO₂ into glucose.",
        "realWorldExample": "Marathon runners need aerobic respiration for sustained ATP; plants use Calvin cycle products to build cellulose in cell walls.",
        "keyTerms": [
            {"term": "Glycolysis", "definition": "Cytoplasm; glucose → 2 pyruvate; 2 ATP net."},
            {"term": "Krebs cycle", "definition": "Mitochondrial matrix; pyruvate → CO₂; makes NADH/FADH₂."},
            {"term": "Electron transport chain", "definition": "Inner mitochondrial membrane; O₂ final acceptor; most ATP."},
            {"term": "Calvin cycle", "definition": "Chloroplast stroma; uses ATP/NADPH to fix CO₂ into sugar."},
        ],
        "nsbTraps": [
            "Glycolysis location = cytoplasm, NOT mitochondria.",
            "Calvin cycle is in stroma; light reactions in thylakoids — don't swap.",
            "O₂ is a product of photosynthesis but a reactant in aerobic respiration.",
        ],
        "didYouKnow": ["One glucose through full aerobic respiration can yield ~30–32 ATP."],
        "relatedTopics": ["ls-cellular-respiration", "ls-photosynthesis", "ls-cell-organelles"],
    },
    {
        "id": "ls-reg-genetics",
        "subject": "Life Science",
        "title": "Regional Sprint: Genetics & Molecular Biology",
        "whatIsIt": "Fast-recall DNA replication enzymes, central dogma, and pedigree patterns including codominance and sex-linked traits.",
        "howItWorks": "Helicase unwinds DNA; DNA polymerase adds nucleotides 5′→3′; primase makes RNA primers. Transcription (RNA polymerase) makes mRNA; translation at ribosomes builds protein from codons. Codominance: both alleles expressed (e.g., AB blood type). Sex-linked traits (often X-linked) appear more often in males. Pedigree squares = males, circles = females; shaded = affected.",
        "realWorldExample": "Sickle cell allele shows codominance in heterozygotes; hemophilia tracks as X-linked recessive in royal pedigrees.",
        "keyTerms": [
            {"term": "Helicase", "definition": "Unwinds the DNA double helix during replication."},
            {"term": "DNA polymerase", "definition": "Adds DNA nucleotides during replication."},
            {"term": "Codominance", "definition": "Both alleles fully expressed in heterozygote."},
            {"term": "Sex-linked", "definition": "Gene on X or Y; often X-linked recessive."},
        ],
        "nsbTraps": [
            "DNA polymerase builds DNA; RNA polymerase builds RNA — don't swap.",
            "Males have only one X — one recessive allele can cause X-linked disease.",
        ],
        "didYouKnow": ["RNA uses uracil (U) instead of thymine (T)."],
        "relatedTopics": ["ls-dna-rna", "ls-genetics", "ls-mutations"],
    },
    {
        "id": "ls-reg-anatomy",
        "subject": "Life Science",
        "title": "Regional Sprint: Human Anatomy",
        "whatIsIt": "Exact blood path through the heart, neuron structure, and basic nephron filtration for regional toss-ups.",
        "howItWorks": "Deoxygenated blood: body → vena cava → right atrium → tricuspid valve → right ventricle → pulmonary artery → lungs → pulmonary veins → left atrium → mitral (bicuspid) valve → left ventricle → aorta → body. Neuron: dendrites receive signals, cell body integrates, axon conducts away; myelin speeds impulses. Nephron: glomerulus filters blood; filtrate becomes urine through proximal tubule, loop of Henle, distal tubule, collecting duct.",
        "realWorldExample": "A heart murmur may involve a faulty valve; multiple sclerosis damages myelin.",
        "keyTerms": [
            {"term": "Tricuspid valve", "definition": "RA → RV (right side)."},
            {"term": "Mitral valve", "definition": "LA → LV (left side); also called bicuspid."},
            {"term": "Axon", "definition": "Carries nerve impulse away from cell body."},
            {"term": "Glomerulus", "definition": "Ball of capillaries where blood is filtered in nephron."},
        ],
        "nsbTraps": [
            "Pulmonary artery carries deoxygenated blood — only artery that does.",
            "Left ventricle wall is thickest — pumps to entire body.",
        ],
        "didYouKnow": ["The heart beats ~100,000 times per day."],
        "relatedTopics": ["ls-circulatory", "ls-nervous", "ls-digestive"],
    },
    {
        "id": "ls-reg-phyla",
        "subject": "Life Science",
        "title": "Regional Sprint: Animal Phyla",
        "whatIsIt": "Nine major animal phyla — key body plans for instant taxonomy recognition at Texas regionals.",
        "howItWorks": "Porifera (sponges, no tissues). Cnidaria (radial symmetry, stinging cells). Platyhelminthes (flatworms, acoelomate). Nematoda (roundworms, pseudocoelom). Mollusca (soft body, often shell). Annelida (segmented worms). Arthropoda (jointed legs, exoskeleton — insects, spiders, crustaceans). Echinodermata (five-part symmetry, spiny skin). Chordata (notochord; includes vertebrates).",
        "realWorldExample": "Jellyfish = Cnidaria; earthworm = Annelida; grasshopper = Arthropoda.",
        "keyTerms": [
            {"term": "Porifera", "definition": "Sponges; no true tissues."},
            {"term": "Cnidaria", "definition": "Jellyfish, coral; radial symmetry; nematocysts."},
            {"term": "Arthropoda", "definition": "Largest phylum; exoskeleton; jointed appendages."},
            {"term": "Chordata", "definition": "Notochord at some life stage; vertebrates inside."},
        ],
        "nsbTraps": [
            "Starfish are Echinodermata, NOT fish (Chordata).",
            "Insects are Arthropoda — six legs, three body regions.",
        ],
        "didYouKnow": ["Arthropods make up over 80% of known animal species."],
        "relatedTopics": ["ls-classification", "ls-evolution"],
    },
    {
        "id": "ch-reg-nomenclature",
        "subject": "Chemistry",
        "title": "Regional Sprint: IUPAC & Polyatomic Ions",
        "whatIsIt": "Instant compound naming and charged polyatomic ions tested heavily at Texas chemistry regionals.",
        "howItWorks": "Prefixes: mono-, di-, tri-, tetra- for covalent compounds. Ionic: metal + nonmetal '-ide'; transition metals use Roman numerals. Common polyatomics: acetate C₂H₃O₂⁻, nitrate NO₃⁻, sulfate SO₄²⁻, carbonate CO₃²⁻, phosphate PO₄³⁻, permanganate MnO₄⁻, dichromate Cr₂O₇²⁻, hydroxide OH⁻, ammonium NH₄⁺.",
        "realWorldExample": "KMnO₄ is potassium permanganate; Na₂Cr₂O₇ is sodium dichromate.",
        "keyTerms": [
            {"term": "Acetate", "definition": "C₂H₃O₂⁻"},
            {"term": "Permanganate", "definition": "MnO₄⁻"},
            {"term": "Dichromate", "definition": "Cr₂O₇²⁻"},
            {"term": "Roman numeral", "definition": "Shows charge of transition metal cation."},
        ],
        "nsbTraps": [
            "Permanganate Mn is +7; dichromate Cr is +6.",
            "'Bi-' means 2; 'ter-' means 3 in covalent prefixes.",
        ],
        "didYouKnow": ["IUPAC names are the same worldwide — no language confusion."],
        "relatedTopics": ["ch-elements-compounds", "ch-organic", "ch-chemical-bonds"],
    },
    {
        "id": "ch-reg-trends",
        "subject": "Chemistry",
        "title": "Regional Sprint: Periodic Trends",
        "whatIsIt": "Direction of electronegativity, ionization energy, atomic radius, and electron affinity — including common exceptions.",
        "howItWorks": "Across a period (L→R): atomic radius decreases, electronegativity increases, ionization energy increases, electron affinity becomes more negative. Down a group: radius increases, IE decreases. Exceptions: N vs O (N higher IE due to half-filled 2p); Be vs B; noble gases have no electron affinity.",
        "realWorldExample": "Fluorine is most electronegative; francium is largest atom.",
        "keyTerms": [
            {"term": "Electronegativity", "definition": "Increases up and to the right; F is highest."},
            {"term": "Ionization energy", "definition": "Energy to remove an electron; increases up and right."},
            {"term": "Atomic radius", "definition": "Decreases across period; increases down group."},
            {"term": "Electron affinity", "definition": "Energy change adding electron; noble gases ~0."},
        ],
        "nsbTraps": [
            "Nitrogen IE > Oxygen — half-filled 2p is stable.",
            "Metals lose electrons easily — low IE.",
        ],
        "didYouKnow": ["Noble gases were once called inert gases until compounds like XeF₄ were made."],
        "relatedTopics": ["ch-periodic-table", "ch-chemical-bonds", "ch-atomic-structure"],
    },
    {
        "id": "ch-reg-gas-laws",
        "subject": "Chemistry",
        "title": "Regional Sprint: Gas Laws & Molarity",
        "whatIsIt": "Mental-math gas law ratios and solution concentration for regional chemistry speed rounds.",
        "howItWorks": "Boyle: P₁V₁ = P₂V₂ (T constant). Charles: V₁/T₁ = V₂/T₂ (P constant). Combined: P₁V₁/T₁ = P₂V₂/T₂. Molarity M = moles solute / liters solution. Dilution: M₁V₁ = M₂V₂.",
        "realWorldExample": "Scuba tanks compress gas (Boyle); hot air balloons (Charles).",
        "keyTerms": [
            {"term": "Boyle's Law", "definition": "P and V inverse at constant T."},
            {"term": "Charles's Law", "definition": "V and T direct at constant P."},
            {"term": "Molarity", "definition": "M = mol/L."},
            {"term": "STP", "definition": "0 °C, 1 atm; 1 mol ideal gas ≈ 22.4 L."},
        ],
        "nsbTraps": [
            "Use Kelvin for Charles's Law — never Celsius in ratio.",
            "Boyle: double pressure → half volume.",
        ],
        "didYouKnow": ["Avogadro's law: equal volumes of gases at same T,P have equal moles."],
        "relatedTopics": ["ch-solutions", "ch-mole", "ch-states-matter"],
    },
    {
        "id": "ch-reg-acids",
        "subject": "Chemistry",
        "title": "Regional Sprint: Acids & Bases (Advanced)",
        "whatIsIt": "Arrhenius vs Brønsted-Lowry definitions and memorized strong acids/bases for regional rounds.",
        "howItWorks": "Arrhenius: acid produces H⁺ in water; base produces OH⁻. Brønsted-Lowry: acid donates H⁺; base accepts H⁺. Strong acids (memorize): HCl, HBr, HI, HNO₃, H₂SO₄, HClO₄. Strong bases: Group 1 hydroxides (NaOH, KOH). pH = −log[H⁺].",
        "realWorldExample": "Stomach acid is HCl; drain cleaner may contain NaOH.",
        "keyTerms": [
            {"term": "Arrhenius acid", "definition": "Produces H⁺ in aqueous solution."},
            {"term": "Brønsted-Lowry acid", "definition": "Proton (H⁺) donor."},
            {"term": "Strong acid", "definition": "Fully ionizes; e.g. HCl, HNO₃, H₂SO₄."},
            {"term": "Conjugate base", "definition": "What remains after acid donates H⁺."},
        ],
        "nsbTraps": [
            "H₂SO₄ diprotic — can donate 2 H⁺.",
            "NH₃ is Brønsted base (accepts H⁺) but not Arrhenius base (no OH⁻).",
        ],
        "didYouKnow": ["pH 3 is 10× more acidic than pH 4 (log scale)."],
        "relatedTopics": ["ch-acids-bases", "ch-solutions", "ch-chemical-reactions"],
    },
    {
        "id": "ps-reg-kinematics",
        "subject": "Physical Science",
        "title": "Regional Sprint: Kinematics",
        "whatIsIt": "Constant-acceleration motion under gravity — regional physics math without calculus.",
        "howItWorks": "v = d/t; a = Δv/Δt. Free fall: g ≈ 9.8 m/s² (often 10 for mental math). v = v₀ + at; d = v₀t + ½at²; v² = v₀² + 2ad. At max height, v = 0.",
        "realWorldExample": "Dropped ball gains 9.8 m/s each second; projectile peaks when vertical v = 0.",
        "keyTerms": [
            {"term": "Acceleration due to gravity", "definition": "g ≈ 9.8 m/s² downward."},
            {"term": "Kinematic equations", "definition": "Relate v, d, a, t for constant a."},
            {"term": "Free fall", "definition": "Motion under gravity only (ignore air resistance)."},
        ],
        "nsbTraps": [
            "Speed is scalar; velocity is vector.",
            "At apex of throw, velocity is zero but acceleration is still g.",
        ],
        "didYouKnow": ["Galileo showed heavy and light objects fall at same rate (ignoring air)."],
        "relatedTopics": ["ps-motion", "ps-forces", "ps-newtons-laws"],
    },
    {
        "id": "ps-reg-forces",
        "subject": "Physical Science",
        "title": "Regional Sprint: Forces (Advanced)",
        "whatIsIt": "Free-body diagrams, centripetal force, and torque for regional physics depth.",
        "howItWorks": "ΣF = ma. Centripetal F_c = mv²/r toward center (not a separate force — net force causing circular motion). Torque τ = rF sin θ; balanced torques for equilibrium. Friction: static vs kinetic. Draw free-body diagram: all forces on object as vectors.",
        "realWorldExample": "Car turning: friction provides centripetal force; seesaw balances torques.",
        "keyTerms": [
            {"term": "Centripetal force", "definition": "F_c = mv²/r toward center of circle."},
            {"term": "Torque", "definition": "τ = rF sin θ; rotational tendency."},
            {"term": "Free-body diagram", "definition": "All forces acting on one object drawn."},
            {"term": "Net force", "definition": "Vector sum determines acceleration."},
        ],
        "nsbTraps": [
            "Centripetal is not centrifugal — it's the net inward force.",
            "Longer lever arm → greater torque for same force.",
        ],
        "didYouKnow": ["A satellite in orbit is constantly falling but also moving forward."],
        "relatedTopics": ["ps-forces", "ps-newtons-laws", "ps-motion"],
    },
    {
        "id": "ps-reg-waves",
        "subject": "Physical Science",
        "title": "Regional Sprint: Optics & Waves",
        "whatIsIt": "EM spectrum order, Snell's law, and wave math for regional physics fast recall.",
        "howItWorks": "EM spectrum (low→high f): radio, microwave, infrared, visible, UV, X-ray, gamma. v = fλ. Snell: n₁ sin θ₁ = n₂ sin θ₂. Period T = 1/f. Reflection: angle of incidence = angle of reflection.",
        "realWorldExample": "Rainbow = dispersion; fiber optics use total internal reflection.",
        "keyTerms": [
            {"term": "Snell's Law", "definition": "n₁ sin θ₁ = n₂ sin θ₂"},
            {"term": "Period", "definition": "T = 1/f; seconds per cycle."},
            {"term": "Electromagnetic spectrum", "definition": "All EM waves; c = 3×10⁸ m/s in vacuum."},
        ],
        "nsbTraps": [
            "Frequency and energy increase together across spectrum.",
            "Light slows in denser medium → bends toward normal.",
        ],
        "didYouKnow": ["Red light has lower frequency than violet."],
        "relatedTopics": ["ps-light", "ps-reflection-refraction", "ps-waves"],
    },
]

NEW_QUESTIONS = [
    # ls-reg-resp-photosyn
    {"id": "reg-001", "subject": "Life Science", "subtopic": "Regional Respiration", "type": "tossUp", "questionText": "In which organelle compartment does the Krebs cycle occur?", "answerChoices": None, "correctAnswer": "Mitochondrial matrix", "difficulty": "regional", "topicId": "ls-reg-resp-photosyn"},
    {"id": "reg-002", "subject": "Life Science", "subtopic": "Regional Photosynthesis", "type": "tossUp", "questionText": "Where in the chloroplast does the Calvin cycle take place?", "answerChoices": None, "correctAnswer": "Stroma", "difficulty": "regional", "topicId": "ls-reg-resp-photosyn"},
    {"id": "reg-003", "subject": "Life Science", "subtopic": "Regional Respiration", "type": "multipleChoice", "questionText": "Where does glycolysis occur?", "answerChoices": {"W": "Mitochondrial matrix", "X": "Cytoplasm", "Y": "Thylakoid", "Z": "Nucleus"}, "correctAnswer": "X", "difficulty": "regional", "topicId": "ls-reg-resp-photosyn"},
    {"id": "reg-004", "subject": "Life Science", "subtopic": "Regional Respiration", "type": "tossUp", "questionText": "What molecule is the final electron acceptor in the electron transport chain?", "answerChoices": None, "correctAnswer": "Oxygen", "difficulty": "regional", "topicId": "ls-reg-resp-photosyn"},
    # ls-reg-genetics
    {"id": "reg-005", "subject": "Life Science", "subtopic": "Regional Genetics", "type": "tossUp", "questionText": "What enzyme unwinds the DNA double helix during replication?", "answerChoices": None, "correctAnswer": "Helicase", "difficulty": "regional", "topicId": "ls-reg-genetics"},
    {"id": "reg-006", "subject": "Life Science", "subtopic": "Regional Genetics", "type": "tossUp", "questionText": "What enzyme synthesizes a new DNA strand during replication?", "answerChoices": None, "correctAnswer": "DNA polymerase", "difficulty": "regional", "topicId": "ls-reg-genetics"},
    {"id": "reg-007", "subject": "Life Science", "subtopic": "Regional Genetics", "type": "multipleChoice", "questionText": "Blood type AB is an example of what inheritance pattern?", "answerChoices": {"W": "Incomplete dominance", "X": "Codominance", "Y": "Sex-linked recessive", "Z": "Polygenic"}, "correctAnswer": "X", "difficulty": "regional", "topicId": "ls-reg-genetics"},
    {"id": "reg-008", "subject": "Life Science", "subtopic": "Regional Genetics", "type": "tossUp", "questionText": "Hemophilia is commonly inherited as what type of trait?", "answerChoices": None, "correctAnswer": "X-linked recessive", "difficulty": "regional", "topicId": "ls-reg-genetics"},
    # ls-reg-anatomy
    {"id": "reg-009", "subject": "Life Science", "subtopic": "Regional Anatomy", "type": "tossUp", "questionText": "After leaving the right ventricle, blood flows to what organ to pick up oxygen?", "answerChoices": None, "correctAnswer": "Lungs", "difficulty": "regional", "topicId": "ls-reg-anatomy"},
    {"id": "reg-010", "subject": "Life Science", "subtopic": "Regional Anatomy", "type": "multipleChoice", "questionText": "Which heart valve is between the left atrium and left ventricle?", "answerChoices": {"W": "Tricuspid", "X": "Mitral (bicuspid)", "Y": "Pulmonary semilunar", "Z": "Aortic semilunar"}, "correctAnswer": "X", "difficulty": "regional", "topicId": "ls-reg-anatomy"},
    {"id": "reg-011", "subject": "Life Science", "subtopic": "Regional Anatomy", "type": "tossUp", "questionText": "What part of a neuron carries impulses away from the cell body?", "answerChoices": None, "correctAnswer": "Axon", "difficulty": "regional", "topicId": "ls-reg-anatomy"},
    {"id": "reg-012", "subject": "Life Science", "subtopic": "Regional Anatomy", "type": "tossUp", "questionText": "In the nephron, what structure filters blood under pressure?", "answerChoices": None, "correctAnswer": "Glomerulus", "difficulty": "regional", "topicId": "ls-reg-anatomy"},
    # ls-reg-phyla
    {"id": "reg-013", "subject": "Life Science", "subtopic": "Regional Phyla", "type": "tossUp", "questionText": "Jellyfish and corals belong to what animal phylum?", "answerChoices": None, "correctAnswer": "Cnidaria", "difficulty": "regional", "topicId": "ls-reg-phyla"},
    {"id": "reg-014", "subject": "Life Science", "subtopic": "Regional Phyla", "type": "multipleChoice", "questionText": "Which phylum includes insects, spiders, and crustaceans?", "answerChoices": {"W": "Mollusca", "X": "Annelida", "Y": "Arthropoda", "Z": "Echinodermata"}, "correctAnswer": "Y", "difficulty": "regional", "topicId": "ls-reg-phyla"},
    {"id": "reg-015", "subject": "Life Science", "subtopic": "Regional Phyla", "type": "tossUp", "questionText": "What phylum includes sponges?", "answerChoices": None, "correctAnswer": "Porifera", "difficulty": "regional", "topicId": "ls-reg-phyla"},
    {"id": "reg-016", "subject": "Life Science", "subtopic": "Regional Phyla", "type": "tossUp", "questionText": "Starfish belong to what phylum?", "answerChoices": None, "correctAnswer": "Echinodermata", "difficulty": "regional", "topicId": "ls-reg-phyla"},
    # ch-reg-nomenclature
    {"id": "reg-017", "subject": "Chemistry", "subtopic": "Regional Nomenclature", "type": "tossUp", "questionText": "What is the formula and charge of the permanganate ion?", "answerChoices": None, "correctAnswer": "MnO₄⁻", "difficulty": "regional", "topicId": "ch-reg-nomenclature"},
    {"id": "reg-018", "subject": "Chemistry", "subtopic": "Regional Nomenclature", "type": "tossUp", "questionText": "What is the formula and charge of the dichromate ion?", "answerChoices": None, "correctAnswer": "Cr₂O₇²⁻", "difficulty": "regional", "topicId": "ch-reg-nomenclature"},
    {"id": "reg-019", "subject": "Chemistry", "subtopic": "Regional Nomenclature", "type": "tossUp", "questionText": "What is the formula and charge of the acetate ion?", "answerChoices": None, "correctAnswer": "C₂H₃O₂⁻", "difficulty": "regional", "topicId": "ch-reg-nomenclature"},
    # ch-reg-trends
    {"id": "reg-020", "subject": "Chemistry", "subtopic": "Regional Trends", "type": "multipleChoice", "questionText": "Which element has the highest electronegativity?", "answerChoices": {"W": "Oxygen", "X": "Chlorine", "Y": "Fluorine", "Z": "Nitrogen"}, "correctAnswer": "Y", "difficulty": "regional", "topicId": "ch-reg-trends"},
    {"id": "reg-021", "subject": "Chemistry", "subtopic": "Regional Trends", "type": "tossUp", "questionText": "Across a period left to right, atomic radius generally increases or decreases?", "answerChoices": None, "correctAnswer": "Decreases", "difficulty": "regional", "topicId": "ch-reg-trends"},
    {"id": "reg-022", "subject": "Chemistry", "subtopic": "Regional Trends", "type": "tossUp", "questionText": "Which has higher first ionization energy: nitrogen or oxygen?", "answerChoices": None, "correctAnswer": "Nitrogen", "difficulty": "regional", "topicId": "ch-reg-trends"},
    # ch-reg-gas-laws
    {"id": "reg-023", "subject": "Chemistry", "subtopic": "Regional Gas Laws", "type": "tossUp", "questionText": "State Boyle's Law in words or formula.", "answerChoices": None, "correctAnswer": "P₁V₁ = P₂V₂", "difficulty": "regional", "topicId": "ch-reg-gas-laws"},
    {"id": "reg-024", "subject": "Chemistry", "subtopic": "Regional Gas Laws", "type": "multipleChoice", "questionText": "A gas at 2 atm occupies 4 L. At constant temperature, what is the volume at 4 atm?", "answerChoices": {"W": "1 L", "X": "2 L", "Y": "4 L", "Z": "8 L"}, "correctAnswer": "X", "difficulty": "regional", "topicId": "ch-reg-gas-laws"},
    {"id": "reg-025", "subject": "Chemistry", "subtopic": "Regional Molarity", "type": "tossUp", "questionText": "What is the molarity of a solution with 2 moles of solute in 0.5 L?", "answerChoices": None, "correctAnswer": "4 M", "difficulty": "regional", "topicId": "ch-reg-gas-laws"},
    # ch-reg-acids
    {"id": "reg-026", "subject": "Chemistry", "subtopic": "Regional Acids", "type": "multipleChoice", "questionText": "Which is a Brønsted-Lowry acid?", "answerChoices": {"W": "NH₃", "X": "OH⁻", "Y": "HCl", "Z": "NaOH"}, "correctAnswer": "Y", "difficulty": "regional", "topicId": "ch-reg-acids"},
    {"id": "reg-027", "subject": "Chemistry", "subtopic": "Regional Acids", "type": "tossUp", "questionText": "Name three strong acids memorized for regional rounds.", "answerChoices": None, "correctAnswer": "HCl, HNO₃, H₂SO₄", "difficulty": "regional", "topicId": "ch-reg-acids"},
    {"id": "reg-028", "subject": "Chemistry", "subtopic": "Regional Acids", "type": "tossUp", "questionText": "An Arrhenius base produces what ion in water?", "answerChoices": None, "correctAnswer": "OH⁻", "difficulty": "regional", "topicId": "ch-reg-acids"},
    # ps-reg-kinematics
    {"id": "reg-029", "subject": "Physical Science", "subtopic": "Regional Kinematics", "type": "tossUp", "questionText": "What is the approximate acceleration due to gravity near Earth's surface in m/s²?", "answerChoices": None, "correctAnswer": "9.8", "difficulty": "regional", "topicId": "ps-reg-kinematics"},
    {"id": "reg-030", "subject": "Physical Science", "subtopic": "Regional Kinematics", "type": "multipleChoice", "questionText": "A ball is dropped from rest. After 2 s (use g = 10 m/s²), what is its speed?", "answerChoices": {"W": "5 m/s", "X": "10 m/s", "Y": "20 m/s", "Z": "40 m/s"}, "correctAnswer": "Y", "difficulty": "regional", "topicId": "ps-reg-kinematics"},
    # ps-reg-forces
    {"id": "reg-031", "subject": "Physical Science", "subtopic": "Regional Forces", "type": "tossUp", "questionText": "What is the formula for centripetal force?", "answerChoices": None, "correctAnswer": "mv²/r", "difficulty": "regional", "topicId": "ps-reg-forces"},
    {"id": "reg-032", "subject": "Physical Science", "subtopic": "Regional Forces", "type": "tossUp", "questionText": "What is the formula for torque?", "answerChoices": None, "correctAnswer": "rF sin θ", "difficulty": "regional", "topicId": "ps-reg-forces"},
    # ps-reg-waves
    {"id": "reg-033", "subject": "Physical Science", "subtopic": "Regional Waves", "type": "tossUp", "questionText": "State Snell's Law.", "answerChoices": None, "correctAnswer": "n₁ sin θ₁ = n₂ sin θ₂", "difficulty": "regional", "topicId": "ps-reg-waves"},
    {"id": "reg-034", "subject": "Physical Science", "subtopic": "Regional Waves", "type": "multipleChoice", "questionText": "Which has the highest frequency in the electromagnetic spectrum?", "answerChoices": {"W": "Radio waves", "X": "Visible light", "Y": "Ultraviolet", "Z": "Gamma rays"}, "correctAnswer": "Z", "difficulty": "regional", "topicId": "ps-reg-waves"},
]

READING_TEMPLATE = {
    "ls-reg-resp-photosyn": [
        {"bookCode": "CB", "label": "Ch 6–7 — Harvesting energy · Photosynthesis", "role": "primary"},
        {"bookCode": "FLS", "label": "Ch 4 — Cell energy", "role": "alsoOK"},
        {"bookCode": "OSB", "label": "Ch 5 — Photosynthesis", "role": "alsoOK"},
    ],
    "ls-reg-genetics": [
        {"bookCode": "CB", "label": "Ch 10–11 — Molecular biology · Gene control", "role": "primary"},
        {"bookCode": "FLS", "label": "Ch 4 — Genetics", "role": "alsoOK"},
    ],
    "ls-reg-anatomy": [
        {"bookCode": "CB", "label": "Ch 20–28 — Animal structure & systems", "role": "primary"},
        {"bookCode": "FLS", "label": "Ch 16–20 — Body systems", "role": "alsoOK"},
    ],
    "ls-reg-phyla": [
        {"bookCode": "CB", "label": "Ch 18–19 — Invertebrate & vertebrate diversity", "role": "primary"},
        {"bookCode": "FLS", "label": "Ch 12 — Sponges, Cnidarians, Worms", "role": "alsoOK"},
    ],
    "ch-reg-nomenclature": [
        {"bookCode": "Tro", "label": "Ch 5 — Nomenclature · ions", "role": "primary"},
        {"bookCode": "Mod", "label": "Ch 7 — Chemical formulas", "role": "alsoOK"},
    ],
    "ch-reg-trends": [
        {"bookCode": "Mod", "label": "Ch 5 — Periodic law & trends", "role": "primary"},
        {"bookCode": "Tro", "label": "Ch 4 — Periodic properties", "role": "alsoOK"},
    ],
    "ch-reg-gas-laws": [
        {"bookCode": "Tro", "label": "Ch 9 — Gases", "role": "primary"},
        {"bookCode": "Mod", "label": "Ch 10 — States of matter", "role": "alsoOK"},
    ],
    "ch-reg-acids": [
        {"bookCode": "Tro", "label": "Ch 14 — Acids & bases", "role": "primary"},
        {"bookCode": "Mod", "label": "Ch 14 — Acids & bases", "role": "alsoOK"},
    ],
    "ps-reg-kinematics": [
        {"bookCode": "Expl", "label": "App. B — Motion", "role": "primary"},
        {"bookCode": "Expl", "label": "Ch 2 — Newton's laws intro", "role": "alsoOK"},
    ],
    "ps-reg-forces": [
        {"bookCode": "Expl", "label": "Ch 2 — Newton's laws", "role": "primary"},
        {"bookCode": "Expl", "label": "Ch 3 — Momentum", "role": "alsoOK"},
    ],
    "ps-reg-waves": [
        {"bookCode": "Expl", "label": "Ch 13 — Light & color", "role": "primary"},
        {"bookCode": "Expl", "label": "Ch 12 — Sound", "role": "alsoOK"},
    ],
}


def merge_unique(existing: list, new_items: list, key: str) -> list:
    seen = {item[key] for item in existing}
    out = list(existing)
    added = 0
    for item in new_items:
        if item[key] not in seen:
            out.append(item)
            seen.add(item[key])
            added += 1
    return out, added


def main() -> None:
    topics = json.loads(TOPICS.read_text(encoding="utf-8"))
    questions = json.loads(QUESTIONS.read_text(encoding="utf-8"))
    readings = json.loads(READINGS.read_text(encoding="utf-8"))

    topics, t_added = merge_unique(topics, NEW_TOPICS, "id")
    questions, q_added = merge_unique(questions, NEW_QUESTIONS, "id")

    for tid, lines in READING_TEMPLATE.items():
        if tid not in readings:
            readings[tid] = lines

    TOPICS.write_text(json.dumps(topics, indent=2) + "\n", encoding="utf-8")
    QUESTIONS.write_text(json.dumps(questions, indent=2) + "\n", encoding="utf-8")
    READINGS.write_text(json.dumps(readings, indent=2) + "\n", encoding="utf-8")

    print(f"Topics: +{t_added} (total {len(topics)})")
    print(f"Questions: +{q_added} (total {len(questions)})")
    print(f"Readings: {len(READING_TEMPLATE)} regional sprint entries")


if __name__ == "__main__":
    main()
