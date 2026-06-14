import Foundation

enum Pass2ReadingContent {
    private static func k(_ week: Int, _ day: Weekday, _ subject: Subject) -> BlockReadingContent.Key {
        BlockReadingContent.Key(week: week, day: day, subject: subject)
    }

    private static func rs(_ title: String, _ body: String) -> ReadingSection {
        ReadingSection(title: title, body: body)
    }

    static let map: [BlockReadingContent.Key: [ReadingSection]] = {
        var m: [BlockReadingContent.Key: [ReadingSection]] = [:]

        // WEEK 5 — Pass 2 foundations
        m[k(5, .monday, .chemistry)] = [
            rs("Pass 2 workflow", """
            15 minutes DOE toss-ups first → 15 minutes re-read Tro Ch 4 §4.3–4.6 only for misses. Less note-taking than Pass 1; harder regional wording.
            """),
            rs("Average atomic mass & isotopes", """
            The number on the periodic table (e.g. 12.01 for carbon) is weighted average atomic mass — not mass number of one isotope.

            Isotopes: same atomic number (same element), different neutron count. C-12 and C-14 both have 6 protons.

            Average is closer to the more abundant isotope. Carbon's 12.01 is near 12 because C-12 is common.
            """),
            rs("Tro depth — atomic structure", """
            Re-read electron shells, valence electrons, and how isotope notation works (¹²C vs ¹⁴C).

            Neutral atom: electrons = protons. Ion charge tells you electrons lost or gained.

            After DOE drill: log every miss — if you miss isotope or average mass, re-read that Tro section same day.
            """)
        ]

        m[k(5, .thursday, .chemistry)] = [
            rs("Ions in depth", """
            Cation (+) — metal loses electrons: Na → Na⁺, Ca → Ca²⁺.

            Anion (−) — nonmetal gains electrons: Cl → Cl⁻, O → O²⁻.

            Polyatomic ions: CO₃²⁻ (carbonate), OH⁻ (hydroxide), NO₃⁻ (nitrate) — memorize common ones.

            Ionic = metal + nonmetal. Covalent = nonmetals sharing (CO₂, H₂O).
            """),
            rs("Naming & NSB patterns", """
            NaCl — sodium chloride (ionic). CO₂ — carbon dioxide (covalent).

            Oxide ion O²⁻ has charge 2−.

            Toss-up: "Charge on oxide ion?" → 2−. "NaCl ionic or covalent?" → ionic.
            """)
        ]

        m[k(5, .tuesday, .biology)] = [
            rs("Campbell-level cell detail", """
            Nucleolus — makes ribosome parts inside nucleus.

            Rough ER — ribosomes attached; protein synthesis and export.

            Smooth ER — lipids, detox (no ribosomes on surface).

            Golgi — modifies, sorts, packages proteins.

            Lysosome — digestive enzymes; breaks down worn organelles and debris.

            Cytoskeleton — microtubules and filaments; shape and movement.

            Phospholipid bilayer — cell membrane structure; hydrophilic heads out, tails in.
            """),
            rs("Plant vs animal — NSB favorites", """
            Plant-only: cell wall, chloroplast, large central vacuole.

            Both: nucleus, mitochondria, ER, Golgi, ribosomes, membrane.

            "Which organelle digests worn-out parts?" → Lysosome.
            """)
        ]

        m[k(5, .friday, .biology)] = [
            rs("Energy processes — write from memory", """
            Cellular respiration (mitochondria):
            glucose + O₂ → CO₂ + H₂O + ATP

            Photosynthesis (chloroplast):
            CO₂ + H₂O + light → glucose + O₂

            ATP = energy currency. Aerobic respiration needs O₂; anaerobic (fermentation) makes less ATP.
            """),
            rs("DOE bonus chains", """
            Toss-up: "Organelle for respiration?" → Mitochondria.

            Bonus parts often ask: two inputs, two outputs, photosynthesis organelle.

            Practice writing both equations without the book — words OK for inputs/outputs.
            """)
        ]

        m[k(5, .wednesday, .physics)] = [
            rs("Work & energy (Ch 6)", """
            Work W = Fd (joules, J). No movement → no work (force must have a component along displacement).

            KE = ½mv² — kinetic energy. Double speed → KE × 4.

            PE = mgh — gravitational potential energy. Higher → more PE.

            Conservation of energy — energy converts between forms; total conserved in closed system.
            """),
            rs("NSB tips", """
            • 10 N for 4 m → W = 40 J.
            • Double speed → KE multiplied by 4.
            • SI unit of work = joule (J).
            """)
        ]

        // WEEK 6
        m[k(6, .monday, .chemistry)] = [
            rs("Physical vs chemical change", """
            Physical — same substance, different state or shape: melting ice, crushing rock, dissolving sugar.

            Chemical — new substances with new properties: burning wood, rusting iron, baking a cake.

            Conservation of mass: atoms rearrange but total mass unchanged in closed system.
            """),
            rs("NSB classification", """
            Burning wood → chemical (ash, smoke, new substances).

            Melting ice → physical (still H₂O).

            "Matter created in reaction?" → No — conserved.
            """)
        ]

        m[k(6, .thursday, .chemistry)] = [
            rs("Reaction types", """
            Synthesis (combination): A + B → AB. Example: 2H₂ + O₂ → 2H₂O.

            Decomposition: AB → A + B. Example: 2H₂O → 2H₂ + O₂.

            Single replacement: A + BC → AC + B.

            Double replacement: AB + CD → AD + CB (often forms precipitate).

            Combustion: fuel + O₂ → CO₂ + H₂O (hydrocarbons).
            """),
            rs("Balancing practice", """
            Fe + O₂ → Fe₂O₃ balanced: 4Fe + 3O₂ → 2Fe₂O₃.

            Always start with atoms that appear once on each side if possible.

            Classify 2H₂O → 2H₂ + O₂ → decomposition (one reactant splits).
            """)
        ]

        m[k(6, .tuesday, .biology)] = [
            rs("Mendel & ratios", """
            Aa × Aa genotypic ratio: 1 AA : 2 Aa : 1 aa (1:2:1).

            Phenotypic ratio with complete dominance: 3:1 (only aa shows recessive).

            Homozygous AA or aa; heterozygous Aa.

            Dihybrid (intro): two traits — 9:3:3:1 phenotypic ratio for AaBb × AaBb.
            """),
            rs("NSB genetics", """
            "Phenotype of aa if A dominant?" → recessive phenotype.

            Capital letter = dominant allele always.
            """)
        ]

        m[k(6, .friday, .biology)] = [
            rs("Body systems detail", """
            Digestion: mouth (mechanical/chemical start) → stomach (acid, protein) → small intestine (most nutrient absorption) → large intestine (water).

            Respiration: trachea → bronchi → bronchioles → alveoli (O₂/CO₂ diffusion).

            Heart: four chambers; arteries away, veins toward, capillaries exchange.

            RBCs carry O₂ on hemoglobin.
            """),
            rs("NSB favorites", """
            Most absorption → small intestine.

            Veins → toward heart (generally).

            Gas exchange → alveoli.
            """)
        ]

        m[k(6, .wednesday, .physics)] = [
            rs("Gravity & projectiles (Ch 7)", """
            Weight W = mg — force of gravity (N). Mass (kg) is constant; weight changes with g.

            On Moon: same mass, less weight.

            PE = mgh increases as height increases. Ball thrown up: rising → PE up, KE down.

            Projectile motion (qualitative): horizontal and vertical motions are independent.
            """)
        ]

        // WEEK 7
        m[k(7, .monday, .chemistry)] = [
            rs("Acids, bases & neutralization", """
            Strong acids/bases ionize completely in water (HCl, NaOH).

            Weak acids/bases partial ionization (acetic acid, ammonia).

            Neutralization: H⁺ + OH⁻ → H₂O. Acid + base → salt + water.

            HCl + NaOH → NaCl + H₂O.
            """),
            rs("Titration concept", """
            Titration — slowly add one solution to another until neutralization (indicator color change).

            Used to find unknown concentration. Not full lab calculation at MS level — know the idea.
            """)
        ]

        m[k(7, .thursday, .chemistry)] = [
            rs("Molarity & dilution", """
            Molarity M = moles of solute / liters of solution (mol/L).

            Dilution: M₁V₁ = M₂V₂ — adding solvent decreases M.

            Electrolytes dissociate in water and conduct electricity (NaCl, acids). Nonelectrolytes do not (sugar).

            Saturated solution cannot dissolve more solute at that temperature.
            """),
            rs("NSB tips", """
            Add solvent → concentration decreases.

            Saturated + crystal at room temp → usually will not dissolve.
            """)
        ]

        m[k(7, .tuesday, .biology)] = [
            rs("Population ecology", """
            Carrying capacity (K) — max population environment supports long-term.

            Exponential growth — J-curve, unlimited resources (idealized).

            Logistic growth — S-curve, levels off at K.

            Biotic = living factors. Abiotic = nonliving (sunlight, water, temperature, soil).
            """),
            rs("Succession", """
            Primary succession — starts on bare rock/lava; pioneer species (lichens).

            Secondary succession — after disturbance (fire, farm abandoned); soil already present.

            Carbon cycle — CO₂ in atmosphere ↔ photosynthesis ↔ respiration ↔ decomposition.
            """)
        ]

        m[k(7, .friday, .biology)] = [
            rs("Immune system", """
            Innate — fast, nonspecific: skin, mucous, stomach acid, inflammation.

            Adaptive — specific: B cells (antibodies), T cells (kill infected cells).

            Memory cells — remember pathogen; faster response on second exposure.

            Virus lytic cycle — hijack host cell to replicate. Allergies = overactive immune response.
            """),
            rs("NSB tips", """
            Second infection milder → memory cells / adaptive immunity.

            Innate barrier examples: skin, mucous membranes, stomach acid.
            """)
        ]

        m[k(7, .wednesday, .physics)] = [
            rs("Heat & temperature (Ch 9)", """
            Temperature — average kinetic energy per molecule. Heat — thermal energy transferred between objects.

            Heat flows from hot to cold until thermal equilibrium.

            Absolute zero = 0 K (−273°C) — lowest possible temperature.

            Specific heat capacity — how much energy needed to raise 1 kg by 1°C (thermal inertia).

            Conduction — heat transfer by particle collisions through a material.
            """),
            rs("NSB tips", """
            • Heat ≠ temperature (heat is energy transfer).
            • 25°C = 298 K.
            • Next: Ch 10 electricity.
            """)
        ]

        // WEEK 8
        m[k(8, .monday, .chemistry)] = [
            rs("Periodic trends — regional level", """
            Across period left → right: atomic radius decreases, ionization energy increases, electronegativity increases.

            Down group: radius increases.

            Halogens (Group 17): fluorine most reactive — small, strong pull for one electron.

            Iodine less reactive than fluorine (larger, outer electrons farther from nucleus).
            """)
        ]

        m[k(8, .thursday, .chemistry)] = [
            rs("Measurement & error", """
            Sig figs: 0.00450 → 3 sig figs. 1200 ambiguous without bar — use scientific notation.

            K = °C + 273. 25 °C = 298 K.

            Percent error = |measured − accepted| / accepted × 100%.

            Density d = m/V. Unit analysis — track units through calculations.
            """)
        ]

        m[k(8, .tuesday, .biology)] = [
            rs("Evolution mechanisms", """
            Gene pool — all alleles in a population.

            Geographic isolation — physical barrier splits population (mountain range, river).

            Reproductive isolation — cannot interbreed → may become separate species.

            Mutations — ultimate source of new alleles / genetic variation.

            Adaptive radiation — one ancestor → many species in different niches (finches).
            """)
        ]

        m[k(8, .friday, .biology)] = [
            rs("Plant transport & tissues", """
            Xylem — dead hollow cells; water and minerals up from roots (transpiration pull).

            Phloem — living cells; sugars from leaves to roots/fruits (translocation).

            Meristem — undifferentiated growth tissue at shoot/root tips.

            Four animal tissue types: epithelial, muscle, nervous, connective — know one job each.
            """)
        ]

        m[k(8, .wednesday, .physics)] = [
            rs("Electricity (Ch 10)", """
            Charge — fundamental property of matter. Like charges repel; opposites attract.

            Current I — flow of charge (ampere, A). Voltage V — electrical pressure. Resistance R — opposition (ohm, Ω).

            Ohm's law: V = I × R. I = 2 A, R = 5 Ω → V = 10 V.

            Series circuit — one path; R_total = R₁ + R₂ + …

            Parallel — branches; current splits; 1/R_total = 1/R₁ + 1/R₂.
            """),
            rs("Week 8 mock prep", """
            Friday: full 25-toss-up mock at regional difficulty. Log misses by subtopic — pick 2 weak areas for Pass 3 flash cards.
            """)
        ]

        return m
    }()
}
