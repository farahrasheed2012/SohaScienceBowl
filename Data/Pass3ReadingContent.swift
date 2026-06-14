import Foundation

enum Pass3ReadingContent {
    private static func k(_ week: Int, _ day: Weekday, _ subject: Subject) -> BlockReadingContent.Key {
        BlockReadingContent.Key(week: week, day: day, subject: subject)
    }

    private static func rs(_ title: String, _ body: String) -> ReadingSection {
        ReadingSection(title: title, body: body)
    }

    static let map: [BlockReadingContent.Key: [ReadingSection]] = {
        var m: [BlockReadingContent.Key: [ReadingSection]] = [:]

        // WEEK 9 — flash card review
        m[k(9, .monday, .chemistry)] = [
            rs("Pass 3 workflow", """
            Flash cards first on today's topic. Open Tro/Mod only if stuck. Finish with 5 DOE-style toss-ups. No new reading — review only.

            If you open the book more than twice in one block, keep that topic on flash cards through fall.
            """),
            rs("Atoms — flash drill targets", """
            Proton +1 in nucleus · defines element (atomic number Z).

            Neutron 0 in nucleus · isotopes differ in neutron count.

            Electron −1 in cloud · negligible mass.

            A = p + n. Average atomic mass on table ≠ mass number of one isotope.

            Drill without book: particle charges, locations, isotope definition.
            """)
        ]

        m[k(9, .thursday, .chemistry)] = [
            rs("Periodic table & compounds review", """
            Groups = columns (similar properties). Periods = rows.

            Na → Na⁺ (loses 1 e⁻). Cl → Cl⁻ (gains 1 e⁻).

            H₂O covalent · NaCl ionic · CO₂ covalent.

            Flash: CO₂ formula, Na⁺ symbol, ionic vs covalent for common pairs.
            """)
        ]

        m[k(9, .tuesday, .biology)] = [
            rs("Cell review — from memory", """
            Name 4 organelles + one job each without notes.

            Plant-only: cell wall, chloroplast.

            Prokaryote: no nucleus. Eukaryote: nucleus + membrane-bound organelles.

            ATP organelle = mitochondria. Photosynthesis organelle = chloroplast.
            """)
        ]

        m[k(9, .friday, .biology)] = [
            rs("Energy & organization review", """
            Write photosynthesis and respiration inputs/outputs from memory.

            Order: cell → tissue → organ → organ system → organism.

            Gas released in photosynthesis = O₂.

            Compare Monday misses — redo weak flash cards before Friday mixed drill.
            """)
        ]

        m[k(9, .wednesday, .physics)] = [
            rs("Magnetism & waves (Ch 11–12)", """
            Magnetic poles — north and south. Like poles repel; unlike attract.

            Moving charges and currents create magnetic fields (electromagnetism intro).

            Wave: wavelength λ, frequency f, amplitude. v = fλ.

            Sound — longitudinal waves. Higher pitch → higher frequency.

            Reflection — bounce off surface. Refraction — bend when speed changes in a new medium.
            """)
        ]

        // WEEK 10 — final review
        m[k(10, .monday, .chemistry)] = [
            rs("Acids & bases — final drill", """
            pH 0–14 · neutral = 7 · acid < 7 · base > 7.

            pH 2 strongly acidic; pH 12 basic.

            HCl acid · NaOH base · neutralization → salt + water.

            Flash until automatic — then 5 DOE toss-ups.
            """)
        ]

        m[k(10, .thursday, .chemistry)] = [
            rs("Solutions — final drill", """
            Solute dissolved in solvent. Salt is solute in salt water.

            Unsaturated can still dissolve more. Saturated cannot at that temperature.

            Filtration — solid from liquid. Distillation — by boiling point.
            """)
        ]

        m[k(10, .tuesday, .biology)] = [
            rs("Ecology — final drill", """
            Producer · consumer · decomposer.

            Mutualism · commensalism · parasitism — name all three with an example.

            Carrying capacity · biotic vs abiotic (soil = abiotic).

            Food web connects many chains; ~10% energy between levels.
            """)
        ]

        m[k(10, .friday, .biology)] = [
            rs("Genetics · microbes · immunity", """
            Tt × Tt → 3:1 phenotypic ratio.

            Antibiotics do NOT work on viruses.

            Vaccines → antibodies / immunity.

            Bacteria vs virus: bacteria living cells; viruses need host.

            Friday Aug 14: final 25-toss-up summer mock — celebrate wins, list 3 topics for fall review.
            """)
        ]

        m[k(10, .wednesday, .physics)] = [
            rs("Light (Ch 13) — final drill", """
            Electromagnetic spectrum — radio → microwave → infrared → visible → UV → X-ray → gamma.

            ROYGBIV — red lowest frequency in visible; violet highest.

            Reflection — angle of incidence = angle of reflection.

            Refraction — light bends entering a new medium (speed change).

            Review v = fλ. Ball falls: PE → KE.
            """)
        ]

        return m
    }()
}
