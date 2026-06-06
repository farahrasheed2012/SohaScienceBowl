import Foundation

enum Pass1ReadingContent {
    private static func k(_ week: Int, _ day: Weekday, _ subject: Subject) -> BlockReadingContent.Key {
        BlockReadingContent.Key(week: week, day: day, subject: subject)
    }

    private static func rs(_ title: String, _ body: String) -> ReadingSection {
        ReadingSection(title: title, body: body)
    }

    static let map: [BlockReadingContent.Key: [ReadingSection]] = {
        var m: [BlockReadingContent.Key: [ReadingSection]] = [:]

        // WEEK 1 — Monday Chemistry: Atoms
        m[k(1, .monday, .chemistry)] = [
            rs("Big picture", """
            Atoms are the foundation of every chemistry toss-up. Science Bowl questions rarely ask you to draw Bohr models — they ask fast facts: how many protons, what is the mass number, which particle has negative charge, what are isotopes.

            Today's reading in Mod Ch 3 builds the vocabulary you need before the periodic table makes sense.
            """),
            rs("Subatomic particles — know these cold", """
            Proton: charge +1, mass ≈ 1 amu, in the nucleus. Defines the element — atomic number Z = number of protons.

            Neutron: charge 0, mass ≈ 1 amu, in the nucleus. Isotopes differ only in neutron count.

            Electron: charge −1, mass ≈ 0 (negligible), in electron cloud around nucleus. In a neutral atom, electrons = protons.

            Mass number A = protons + neutrons. It is NOT the decimal number on the periodic table (that's average atomic mass).
            """),
            rs("Worked examples", """
            Example 1: An atom has 17 protons → atomic number 17 → chlorine (Cl). Neutral atom has 17 electrons.

            Example 2: 11 protons + 12 neutrons → A = 23. Element is sodium (Na). Electrons in neutral atom = 11.

            Example 3: Carbon-12 and carbon-14 both have 6 protons (both are carbon). C-14 has 8 neutrons; C-12 has 6. Same Z, different n → isotopes.
            """),
            rs("Common mix-ups & NSB tips", """
            • Atomic number vs mass number — number of protons vs protons + neutrons.
            • Isotopes have the same atomic number, not the same mass number.
            • Almost all mass is in the nucleus; the electron cloud is mostly empty space but defines the atom's size.
            • Toss-ups often give proton count and ask for element name, or give p + n and ask for mass number.
            """)
        ]

        m[k(1, .thursday, .chemistry)] = [
            rs("Big picture", """
            The periodic table is chemistry's map. Periods (rows) show energy levels filling; groups (columns) show elements with similar valence electrons and similar reactivity.

            Today connects atomic structure to formulas and ions — how Na becomes Na⁺ and why NaCl is written that way.
            """),
            rs("Periodic table layout", """
            Periods = horizontal rows (7 total). Atomic number increases left to right.

            Groups = vertical columns. Group 1 = alkali metals (reactive). Group 17 = halogens (reactive). Group 18 = noble gases (very unreactive — full outer shell).

            Metals (left/center) · nonmetals (upper right) · metalloids (staircase boundary, e.g. Si, Ge).

            Subscripts in formulas count atoms: H₂O = 2 hydrogens, 1 oxygen. No subscript means 1 (NaCl = 1 Na, 1 Cl).
            """),
            rs("Ions and bonding intro", """
            Sodium atom (11 e⁻) loses 1 electron → Na⁺ (10 e⁻, but still 11 protons → net +1 charge).

            Ionic compounds form between metals and nonmetals (electrons transferred): Na⁺ + Cl⁻ → NaCl.

            Molecular/covalent compounds form when nonmetals share electrons: H₂O, CO₂.

            Know common formulas: H₂O (water), CO₂ (carbon dioxide), NaCl (table salt).
            """),
            rs("NSB tips", """
            • "Which group contains noble gases?" → Group 18.
            • "What ion does sodium form?" → Na⁺ (loses one electron).
            • They may ask ionic vs molecular for a familiar compound.
            • Start memorizing symbols — you'll need H through Ca by Week 4.
            """)
        ]

        m[k(1, .tuesday, .biology)] = [
            rs("Big picture", """
            Every biology toss-up eventually ties back to cells. NSB asks which organelle does a specific job, plant vs animal differences, and prokaryote vs eukaryote.

            FLS Ch 1 gives the organelle tour. Your job is to match structure to function fast.
            """),
            rs("Organelles — structure meets function", """
            Nucleus — control center; holds DNA on chromosomes.

            Mitochondria — "powerhouse"; cellular respiration makes ATP (energy currency).

            Ribosomes — protein synthesis (on rough ER or free in cytoplasm).

            Endoplasmic reticulum (ER) — transport highway. Rough ER has ribosomes; smooth ER makes lipids.

            Golgi apparatus — packages and ships proteins.

            Plant-only: cell wall (rigid support), chloroplast (photosynthesis), large central vacuole (storage).

            Cell membrane — selective barrier; controls what enters and leaves.
            """),
            rs("Prokaryote vs eukaryote", """
            Prokaryotes (bacteria, archaea): no nucleus, no membrane-bound organelles, DNA in nucleoid region.

            Eukaryotes (plants, animals, fungi, protists): nucleus present, membrane-bound organelles.

            Both have ribosomes and cell membrane. Size: eukaryotes are generally larger.
            """),
            rs("NSB tips", """
            • "Which organelle makes ATP?" → Mitochondria.
            • "Two structures in plant but not animal cells?" → Cell wall and chloroplast (vacuole also acceptable).
            • Same DNA in all your cells — different genes turned on = specialization (muscle vs nerve shape).
            • Bonus chains often ask respiration inputs/outputs after an ATP organelle toss-up.
            """)
        ]

        m[k(1, .friday, .biology)] = [
            rs("Big picture", """
            Cells don't work alone. Multicellular organisms build up: cell → tissue → organ → organ system → organism.

            Specialization means cells with the same DNA express different genes — a muscle cell and nerve cell look totally different but share the same genome.
            """),
            rs("Levels of organization", """
            Cell — smallest unit of life (muscle cell, nerve cell, skin cell).

            Tissue — group of similar cells with one job (muscle tissue, nervous tissue, epithelial, connective).

            Organ — tissues working together (heart, lung, stomach).

            Organ system — organs cooperating (circulatory, digestive, nervous).

            Organism — complete living thing.

            Order for toss-ups: cell → tissue → organ → organ system → organism.
            """),
            rs("Tissue types (preview)", """
            Epithelial — covers surfaces, lines cavities (skin lining, stomach lining).

            Connective — support and connect (bone, blood, fat).

            Muscle — movement (skeletal, smooth, cardiac).

            Nervous — sends signals (brain, spinal cord, nerves).

            Structure matches function: long thin nerve cells carry signals; elongated muscle cells contract.
            """),
            rs("NSB tips", """
            • "Why do muscle and nerve cells look different with same DNA?" → Different genes expressed / cell specialization.
            • FLS Ch 2 sets up energy topics for Pass 2 (photosynthesis & respiration in CB).
            • Friday deeper bio blocks often connect to body systems in Week 2.
            """)
        ]

        m[k(1, .wednesday, .physics)] = [
            rs("Big picture", """
            Motion is the entry point for physics toss-ups. Expl Ch 1 + Appendix B introduce how scientists measure movement and read graphs.

            Master v = d/t and distance-time graphs before forces in Week 2.
            """),
            rs("Speed, velocity, acceleration", """
            Speed — how fast (scalar: number only). Units: m/s, km/h.

            Velocity — speed with direction (vector). "60 km/h north" is velocity; "60 km/h" is speed.

            Acceleration — change in velocity over time. a = Δv/Δt. Slowing down is still acceleration (often negative if velocity is positive).

            Average speed = total distance ÷ total time: v = d/t.
            """),
            rs("Distance-time graphs", """
            Slope of d-t graph = speed. Steeper slope = faster motion.

            Horizontal (flat) line = object at rest (distance not changing).

            Straight diagonal line = constant speed.

            Curved line = changing speed (acceleration).

            Example: 150 km in 3 h → v = 150/3 = 50 km/h.
            """),
            rs("NSB tips", """
            • Always check units — km/h vs m/s.
            • "Flat d-t graph" → at rest / zero speed (very common toss-up).
            • Hypothesis vs theory vs law: hypothesis = testable explanation; theory = well-supported explanation; law = describes pattern (doesn't explain why).
            • Multi-leg trip bonus: add distances, add times, then divide (don't average the speeds).
            """)
        ]

        // WEEK 2
        m[k(2, .monday, .chemistry)] = [
            rs("Big picture", """
            Matter exists as solid, liquid, or gas because of particle spacing and motion. Phase changes (melting, boiling, freezing, condensing) involve energy even when temperature stays constant on a heating curve plateau.
            """),
            rs("Particle model of matter", """
            Solid — particles close, fixed positions, vibrate in place. Fixed shape and volume.

            Liquid — particles close but slide past each other. Fixed volume, takes container shape.

            Gas — particles far apart, move freely. Fills container; compressible.

            At the same temperature, gas particles have the most kinetic energy and move fastest.
            """),
            rs("Phase changes & energy", """
            Melting (solid → liquid) and boiling (liquid → gas) absorb energy.

            Freezing and condensation release energy.

            Evaporation — only at the liquid surface, below boiling point.

            Boiling — throughout the liquid at the boiling point.

            During a phase change on a heating curve, temperature stays flat while energy breaks or forms intermolecular attractions.
            """),
            rs("NSB tips", """
            • "Which state has fastest particles at same T?" → Gas.
            • Boiling absorbs energy (endothermic for the substance).
            • Melting ice increases spacing between particles (same substance, different arrangement).
            """)
        ]

        m[k(2, .thursday, .chemistry)] = [
            rs("Big picture", """
            Chemical reactions rearrange atoms — nothing is created or destroyed (conservation of mass). Balancing equations and spotting reaction types are core NSB skills.
            """),
            rs("Balancing & reaction signs", """
            Reactants (left) → Products (right). Coefficients balance atom counts.

            Example: H₂ + Cl₂ → 2HCl (need 2 HCl for 2 H and 2 Cl).

            2H₂ + O₂ → 2H₂O — classic synthesis/combustion pattern.

            Signs of chemical change: color change, gas produced, precipitate forms, temperature change — not just phase change.
            """),
            rs("Exothermic vs endothermic", """
            Exothermic — releases heat to surroundings (feels hot). Products have less stored chemical energy.

            Endothermic — absorbs heat (feels cold). Example: cold pack.

            Combustion (burning) is exothermic. Photosynthesis is endothermic (stores energy).
            """),
            rs("NSB tips", """
            • Balance with smallest whole-number coefficients.
            • "Releases heat" → exothermic.
            • Decomposition looks like AB → A + B (opposite of synthesis).
            """)
        ]

        m[k(2, .tuesday, .biology)] = [
            rs("Big picture", """
            Genetics is how traits pass from parents to offspring. DNA → genes → alleles → Punnett squares. NSB loves genotype vs phenotype and 3:1 ratios.
            """),
            rs("Vocabulary chain", """
            DNA — double helix; instructions for life.

            Gene — segment of DNA coding for one trait or protein.

            Chromosome — long DNA molecule with many genes.

            Allele — different versions of a gene (T vs t for tall vs short).

            Genotype — letter codes (TT, Tt, tt). Phenotype — what you observe (tall, short).
            """),
            rs("Punnett squares", """
            Dominant allele (capital T) masks recessive (lowercase t) with complete dominance.

            Heterozygous Tt — one of each allele. Homozygous TT or tt — same allele twice.

            Monohybrid cross Tt × Tt:
            Genotypic ratio 1 TT : 2 Tt : 1 tt
            Phenotypic ratio 3 dominant : 1 recessive (3:1)

            Write parent alleles on top and side, fill in four boxes.
            """),
            rs("NSB tips", """
            • Dominant = capital letter (always).
            • Tt × Tt phenotypic ratio → 3:1.
            • Bonus may ask genotypic ratio → 1:2:1 or phenotype of tt → recessive.
            """)
        ]

        m[k(2, .friday, .biology)] = [
            rs("Big picture", """
            Your body is systems working together. Muscles and bones use levers; heart and blood vessels move blood; lungs exchange O₂ and CO₂. Direction matters for arteries vs veins.
            """),
            rs("Musculoskeletal — levers", """
            Lever: fulcrum (pivot) · effort (force applied) · load (resistance moved).

            Bones act as levers; joints as fulcrums; muscles provide effort.

            Three classes of levers differ in fulcrum/effort/load placement — know the three parts by name.
            """),
            rs("Circulatory & respiratory", """
            Heart pumps blood. Arteries carry blood away from heart (remember: A = Away). Veins carry blood toward heart.

            Capillaries — tiny vessels where exchange happens.

            Lungs: O₂ diffuses into blood; CO₂ diffuses out.

            Red blood cells (RBCs) carry oxygen using hemoglobin.

            Digestive path preview: mouth → esophagus → stomach → small intestine (most absorption) → large intestine.
            """),
            rs("NSB tips", """
            • Arteries = away from heart (not always oxygenated — pulmonary artery goes to lungs).
            • Three lever parts: fulcrum, effort, load.
            • Alveoli = site of gas exchange in lungs.
            """)
        ]

        m[k(2, .wednesday, .physics)] = [
            rs("Big picture", """
            Newton's three laws explain almost every force toss-up. F = ma is the most tested formula in middle-school physics. Action-reaction pairs act on different objects.
            """),
            rs("Newton's three laws", """
            1st (Inertia): Objects resist changes in motion. Rest stays at rest; moving stays moving unless net force acts.

            2nd: F = ma. Net force (N) = mass (kg) × acceleration (m/s²). Same force on bigger mass → smaller acceleration.

            3rd: Every action has equal and opposite reaction. Forces come in pairs on different objects. Earth pulls you down; you pull Earth up.
            """),
            rs("Friction & net force", """
            Friction opposes motion (static vs kinetic). Net force = vector sum of all forces. Zero net force → constant velocity (including rest).

            Example: F = 20 N, m = 4 kg → a = F/m = 5 m/s².

            Double mass with same force → acceleration halves (inverse relationship).
            """),
            rs("NSB tips", """
            • SI unit of force = Newton (N).
            • 4 kg at 5 m/s² → F = 20 N.
            • Action-reaction: forces equal, opposite direction, different objects.
            • Week 6 Pass 2 adds momentum p = mv.
            """)
        ]

        // WEEK 3
        m[k(3, .monday, .chemistry)] = [
            rs("Big picture", """
            Acids and bases show up constantly in NSB. pH measures acidity; neutral is 7. Know HCl as acid, NaOH as base, and that indicators change color.
            """),
            rs("pH scale", """
            pH 0–14 at standard conditions. pH 7 = neutral (pure water at 25 °C).

            pH < 7 = acidic (more H⁺). pH > 7 = basic/alkaline (more OH⁻).

            Lower pH = stronger acid. pH 2 is strongly acidic; pH 12 is strongly basic.

            Acids taste sour (don't taste in lab!). Bases feel slippery.
            """),
            rs("Common acids & bases", """
            HCl — hydrochloric acid (stomach acid dilute form).

            NaOH — sodium hydroxide (strong base).

            Neutralization: acid + base → salt + water. HCl + NaOH → NaCl + H₂O.

            Indicators: litmus red in acid, blue in base; universal indicator gives color across the scale.
            """),
            rs("NSB tips", """
            • pH of pure water → 7.
            • pH 11 → basic.
            • Bonus may ask what ion pH measures → H⁺ (hydrogen ion concentration).
            """)
        ]

        m[k(3, .thursday, .chemistry)] = [
            rs("Big picture", """
            Solutions are homogeneous mixtures. Know solvent vs solute, saturation, and how to separate mixtures (filtration, distillation).
            """),
            rs("Solutions vocabulary", """
            Solute — dissolved substance (salt in salt water).

            Solvent — dissolving medium (water in salt water — "universal solvent").

            Saturated — dissolved maximum solute at that temperature.

            Unsaturated — can still dissolve more.

            Concentration — amount of solute per amount of solution. Dilution with more solvent lowers concentration.
            """),
            rs("Separation methods", """
            Filtration — separates insoluble solid from liquid (sand from water; filter paper traps solid).

            Distillation — separates liquids by boiling point differences.

            Evaporation — leaves solid solute after solvent evaporates.

            Magnetism, decanting, chromatography — know filtration for solid/liquid NSB questions.
            """),
            rs("NSB tips", """
            • Salt in salt water → solute is salt (NaCl).
            • Add solvent → concentration decreases.
            • Saturated solution at room temp + crystal → often will not dissolve more.
            """)
        ]

        m[k(3, .tuesday, .biology)] = [
            rs("Big picture", """
            Ecology links organisms to each other and the environment. Food chains, energy flow, symbiosis, and biomes appear in toss-ups and bonus chains.
            """),
            rs("Energy in ecosystems", """
            Producer (autotroph) — makes own food from sunlight (plants, algae). Gets energy first from sun.

            Consumer (heterotroph) — eats others (herbivore, carnivore, omnivore).

            Decomposer — breaks down dead organic matter (bacteria, fungi).

            ~10% rule: roughly 10% of energy passes to next trophic level; rest lost as heat.

            Food web — many interconnected food chains.
            """),
            rs("Symbiosis & biomes", """
            Mutualism — both benefit (bee + flower).

            Commensalism — one benefits, other unaffected (remora + shark).

            Parasitism — one benefits, other harmed (tick + dog).

            Biomes: desert, tundra, taiga, temperate forest, tropical rainforest, grassland, savanna — know climate + dominant plants.
            """),
            rs("NSB tips", """
            • Producer = makes food from sunlight.
            • Name three symbiosis types.
            • Sunlight, water, soil minerals = abiotic (not living).
            """)
        ]

        m[k(3, .friday, .biology)] = [
            rs("Big picture", """
            Microbes and immunity — bacteria vs viruses, vaccines, antibiotics. Critical distinction: antibiotics work on bacteria, NOT viruses.
            """),
            rs("Bacteria vs viruses", """
            Bacteria — living single-celled prokaryotes; treated with antibiotics; reproduce on own.

            Viruses — not fully "alive"; need host cell to replicate; no antibiotic cure (antivirals exist but different class).

            Pathogen — disease-causing agent (bacteria, virus, fungus, parasite).
            """),
            rs("Immunity", """
            Antibodies — proteins that mark pathogens for destruction.

            Vaccines — expose body to weakened/inactive pathogen or piece of it → trains adaptive immunity before real infection.

            Innate immunity — fast, general (skin, mucous, stomach acid).

            Adaptive immunity — specific, has memory; second infection often milder.
            """),
            rs("NSB tips", """
            • Antibiotic for flu? → No (flu is viral).
            • Vaccines help produce antibodies / immunity.
            • Bonus: name one innate barrier → skin, mucous membranes, stomach acid.
            """)
        ]

        m[k(3, .wednesday, .physics)] = [
            rs("Big picture", """
            Work and energy connect force to motion. W = Fd, power = W/t, and energy converts between forms but is conserved in a closed system.
            """),
            rs("Work & power", """
            Work W = F × d (force parallel to displacement). Unit: joule (J). No movement → no work (pushing a wall).

            Power P = W/t — how fast work is done. Unit: watt (W).

            Example: F = 10 N, d = 5 m → W = 50 J.
            """),
            rs("Energy forms", """
            Kinetic energy (KE) — motion. KE = ½mv² (concept level).

            Potential energy (PE) — stored due to position. Gravitational PE = mgh.

            More height → more gravitational PE. Ball falling converts PE → KE.

            Simple machines (lever, pulley, inclined plane) trade distance for force; efficiency = useful output / total input.
            """),
            rs("NSB tips", """
            • SI unit of work → joule (J).
            • F = 10 N, d = 5 m → 50 J.
            • Pass 2 Week 7 adds PE = mgh and KE = ½mv² calculations.
            """)
        ]

        // WEEK 4
        m[k(4, .monday, .chemistry)] = [
            rs("Big picture", """
            Periodic trends predict reactivity and size. Memorize symbols H through Ca (first 20 elements) — NSB asks these directly.
            """),
            rs("Trends across a period", """
            Left to right: atomic radius decreases (more protons pull electrons closer).

            Ionization energy increases (harder to remove an electron).

            Electronegativity increases (stronger pull on shared electrons).

            Down a group: radius increases (new energy level).
            """),
            rs("Valence electrons & reactivity", """
            Valence electrons — outermost electrons; determine bonding and group behavior.

            Group 1 — 1 valence e⁻ (very reactive metals). Group 17 — 7 valence e⁻ (reactive halogens). Group 18 — full outer shell (unreactive).

            Na is larger than Cl in the same period (Cl has more protons pulling shell in).
            """),
            rs("NSB tips", """
            • Symbol for potassium → K (from Latin kalium).
            • Larger atom: Na or Cl → Na.
            • Fluorine = most reactive halogen.
            • Use the Top 20 elements reference sheet — flash card any you miss.
            """)
        ]

        m[k(4, .thursday, .chemistry)] = [
            rs("Big picture", """
            Lab skills and SI units appear in measurement toss-ups. Know equipment names and how to read a graduated cylinder safely.
            """),
            rs("Lab equipment", """
            Beaker — mix and heat; rough volume (not precise).

            Erlenmeyer flask — mix, swirl; not for precise measuring.

            Graduated cylinder — measure liquid volume precisely; read meniscus at eye level.

            Balance — mass (in grams or kilograms).

            Bunsen burner — heat source. Always safety goggles; tie back hair; know eyewash/fire blanket location.
            """),
            rs("SI & significant figures", """
            Base units: kg (mass), m (length), s (time), mol (amount), K (temperature), A (current).

            Significant figures — digits that carry meaning in a measurement. 0.00450 has 3 sig figs (leading zeros don't count; trailing zero after decimal does).

            K = °C + 273. 25 °C = 298 K.

            Density d = m/V.
            """),
            rs("NSB tips", """
            • SI base unit for mass → kilogram (kg), not gram.
            • Precise liquid volume → graduated cylinder.
            • Percent error = |measured − accepted| / accepted × 100.
            """)
        ]

        m[k(4, .tuesday, .biology)] = [
            rs("Big picture", """
            Evolution explains diversity of life through natural selection. Classification (taxonomy) organizes species from kingdom down to species.
            """),
            rs("Natural selection", """
            Charles Darwin — natural selection. Variation exists in populations; some traits improve survival/reproduction; advantageous traits become more common over generations.

            Adaptation — trait that helps survival in environment.

            Evidence: fossils, anatomy (homologous structures), DNA similarities, embryology.
            """),
            rs("Taxonomy", """
            Kingdom → Phylum → Class → Order → Family → Genus → Species (King Philip Came Over For Good Soup).

            Binomial nomenclature — two-part Latin name: Homo sapiens (genus + species).

            Most specific rank = species. Broadest = kingdom.
            """),
            rs("NSB tips", """
            • Scientist for natural selection → Charles Darwin.
            • Most specific taxonomic rank → species.
            • Geographic isolation can lead to speciation (Pass 2 Week 8).
            """)
        ]

        m[k(4, .friday, .biology)] = [
            rs("Big picture", """
            Plant structure supports photosynthesis and transport. Animal tissues organize into organs and systems.
            """),
            rs("Plant parts", """
            Root — anchors plant, absorbs water and minerals from soil.

            Stem — support, transport (xylem and phloem run through stem).

            Leaf — main site of photosynthesis (chloroplasts in mesophyll cells).

            Xylem — transports water upward (dead cells, hollow).

            Phloem — transports sugars (sap) to where needed.
            """),
            rs("Animal tissues", """
            Epithelial — covers and lines.

            Connective — support (bone, blood).

            Muscle — movement.

            Nervous — signals.

            Meristem (plants) — growth tissue at tips and roots.
            """),
            rs("NSB tips", """
            • Primary root function → absorb water/minerals.
            • Most photosynthesis → leaves.
            • Xylem = water up; phloem = sugars (Pass 2 Week 8 depth).
            """)
        ]

        m[k(4, .wednesday, .physics)] = [
            rs("Big picture", """
            Waves, light, and electricity round out Pass 1 physics. v = fλ links wave properties; V = IR is Ohm's law for circuits.
            """),
            rs("Wave properties", """
            Wavelength λ — distance crest to crest (m).

            Frequency f — cycles per second (Hz).

            Amplitude — height of wave; related to energy/loudness/brightness.

            v = fλ — wave speed = frequency × wavelength.

            Higher pitch → higher frequency. ROYGBIV — red lowest frequency visible, violet highest.
            """),
            rs("Light & electricity", """
            Reflection — bounce off surface. Refraction — bend entering new medium.

            Current I — flow of charge (ampere, A). Voltage V — electrical pressure. Resistance R — opposition (ohm, Ω).

            Ohm's law: V = I × R. I = 2 A, R = 5 Ω → V = 10 V.

            Series circuit — one path; resistances add; R_total increases.

            Parallel — branches; current splits; 1/R_total = 1/R₁ + 1/R₂.
            """),
            rs("NSB tips", """
            • Higher pitch → higher frequency.
            • I = 2 A, R = 5 Ω → 10 V.
            • More resistors in series → total R increases.
            • Speed of light c ≈ 3 × 10⁸ m/s (electromagnetic waves).
            • Pass 2 Week 8 adds Ch 14 lenses/dispersion stretch.
            """)
        ]

        return m
    }()
}
