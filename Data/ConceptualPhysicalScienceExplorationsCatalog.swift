import Foundation

/// Conceptual Physical Science Explorations — official part/chapter/section index from the textbook TOC.
enum ConceptualPhysicalScienceExplorationsCatalog {
    struct PartInfo: Hashable {
        let id: String
        let name: String
        let startPage: Int
    }

    struct Section: Hashable {
        let id: String
        let title: String
    }

    struct Chapter: Hashable {
        let number: Int
        let title: String
        let part: PartInfo
        let startPage: Int
        let sections: [Section]
    }

    struct Appendix: Hashable {
        let letter: String
        let title: String
        let startPage: Int
    }

    static let editionTitle = "Conceptual Physical Science Explorations (Hewitt et al.)"

    private static let parts: [PartInfo] = [
        PartInfo(id: "intro", name: "Front Matter", startPage: 0),
        PartInfo(id: "p1", name: "Part One — Mechanics", startPage: 15),
        PartInfo(id: "p2", name: "Part Two — Forms of Energy", startPage: 165),
        PartInfo(id: "p3", name: "Part Three — Chemistry", startPage: 357),
        PartInfo(id: "p4", name: "Part Four — Earth Science", startPage: 581),
        PartInfo(id: "p5", name: "Part Five — Astronomy", startPage: 765),
    ]

    private static let partByID: [String: PartInfo] = {
        Dictionary(uniqueKeysWithValues: parts.map { ($0.id, $0) })
    }()

    static let appendices: [Appendix] = [
        Appendix(letter: "A", title: "On Measurement and Unit Conversion", startPage: 837),
        Appendix(letter: "B", title: "Linear and Rotational Motion", startPage: 840),
        Appendix(letter: "C", title: "Working with Vector Components", startPage: 846),
        Appendix(letter: "D", title: "Exponential Growth and Doubling Time", startPage: 850),
        Appendix(letter: "E", title: "Safety", startPage: 854),
    ]

    static let chapters: [Chapter] = [
        Chapter(number: 1, title: "About Science", part: partByID["intro"]!, startPage: 1, sections: [Section(id: "1.1", title: "A Brief History of Advances in Science"), Section(id: "1.2", title: "Mathematics and Conceptual Physical Science"), Section(id: "1.3", title: "Scientific Methods—Classic Tools"), Section(id: "1.4", title: "Scientific Hypotheses Must Be Testable"), Section(id: "1.5", title: "A Scientific Attitude Underlies Good Science"), Section(id: "1.6", title: "The Search for Order—Science, Art, and Religion"), Section(id: "1.7", title: "Technology—Practical Use of the Findings of Science"), Section(id: "1.8", title: "The Physical Sciences: Physics, Chemistry, Earth Science, and Astronomy"), Section(id: "1.9", title: "In Perspective")]),
        Chapter(number: 2, title: "Newton's First Law of Motion—The Law of Inertia", part: partByID["p1"]!, startPage: 17, sections: [Section(id: "2.1", title: "Aristotle's Classification of Motion"), Section(id: "2.2", title: "Galileo's Concept of Inertia"), Section(id: "2.3", title: "Galileo's Concepts of Speed and Velocity"), Section(id: "2.4", title: "Motion Is Relative"), Section(id: "2.5", title: "Newton's First Law of Motion—The Law of Inertia"), Section(id: "2.6", title: "Net Force—The Combination of All Forces That Act on an Object"), Section(id: "2.7", title: "Equilibrium for Objects at Rest"), Section(id: "2.8", title: "The Support Force—Why We Don't Fall Through the Floor"), Section(id: "2.9", title: "Equilibrium for Moving Objects"), Section(id: "2.10", title: "Earth Moves Around the Sun")]),
        Chapter(number: 3, title: "Newton's Second Law of Motion—Force and Acceleration", part: partByID["p1"]!, startPage: 37, sections: [Section(id: "3.1", title: "Galileo Developed the Concept of Acceleration"), Section(id: "3.2", title: "Force Causes Acceleration"), Section(id: "3.3", title: "Mass Is a Measure of Inertia"), Section(id: "3.4", title: "Mass Resists Acceleration"), Section(id: "3.5", title: "Newton's Second Law Links Force, Acceleration, and Mass"), Section(id: "3.6", title: "Friction Is a Force That Affects Motion"), Section(id: "3.7", title: "Objects in Free Fall Have Equal Acceleration"), Section(id: "3.8", title: "Newton's Second Law Explains Why Objects in Free Fall Have Equal Acceleration"), Section(id: "3.9", title: "Acceleration of Fall Is Less When Air Drag Acts")]),
        Chapter(number: 4, title: "Newton's Third Law of Motion—Action and Reaction", part: partByID["p1"]!, startPage: 57, sections: [Section(id: "4.1", title: "A Force Is Part of an Interaction"), Section(id: "4.2", title: "Newton's Third Law—Action and Reaction"), Section(id: "4.3", title: "A Simple Rule Helps Identify Action and Reaction"), Section(id: "4.4", title: "Action and Reaction on Objects of Different Masses"), Section(id: "4.5", title: "Action and Reaction Forces Act on Different Objects"), Section(id: "4.6", title: "The Classic Horse-Cart Problem—A Mind Stumper"), Section(id: "4.7", title: "Action Equals Reaction"), Section(id: "4.8", title: "Summary of Newton's Three Laws")]),
        Chapter(number: 5, title: "Momentum", part: partByID["p1"]!, startPage: 74, sections: [Section(id: "5.1", title: "Momentum Is Inertia in Motion"), Section(id: "5.2", title: "Impulse Changes Momentum"), Section(id: "5.3", title: "Momentum Is Conserved When No External Force Acts"), Section(id: "5.4", title: "Momentum Change Is Greater When Bouncing Occurs"), Section(id: "5.5", title: "Conservation of Momentum in Collisions")]),
        Chapter(number: 6, title: "Energy", part: partByID["p1"]!, startPage: 90, sections: [Section(id: "6.1", title: "Work—Force × Distance"), Section(id: "6.2", title: "Power—How Quickly Work Gets Done"), Section(id: "6.3", title: "Mechanical Energy"), Section(id: "6.4", title: "Potential Energy Is Stored Energy"), Section(id: "6.5", title: "Kinetic Energy Is Energy of Motion"), Section(id: "6.6", title: "Work-Energy Theorem"), Section(id: "6.7", title: "Conservation of Energy"), Section(id: "6.8", title: "Machines—Devices to Multiply Forces"), Section(id: "6.9", title: "Efficiency—A Measure of Work Done for Energy Spent"), Section(id: "6.10", title: "Sources of Energy"), Section(id: "6.11", title: "Energy for Life")]),
        Chapter(number: 7, title: "Gravity, Projectiles, and Satellite Motion", part: partByID["p1"]!, startPage: 112, sections: [Section(id: "7.1", title: "The Legend of the Falling Apple"), Section(id: "7.2", title: "The Fact of the Falling Moon"), Section(id: "7.3", title: "Newton's Grandest Discovery—The Law of Universal Gravitation"), Section(id: "7.4", title: "Gravity and Distance: The Inverse-Square Law"), Section(id: "7.5", title: "The Universal Gravitational Constant, G"), Section(id: "7.6", title: "The Mass of the Earth Is Measured"), Section(id: "7.7", title: "Projectile Motion"), Section(id: "7.8", title: "Fast-Moving Projectiles—Satellites"), Section(id: "7.9", title: "Circular Satellite Orbits"), Section(id: "7.10", title: "Elliptical Orbits"), Section(id: "7.11", title: "Escape Speed")]),
        Chapter(number: 8, title: "Fluid Mechanics", part: partByID["p1"]!, startPage: 137, sections: [Section(id: "8.1", title: "Density—A Measure of Compactness"), Section(id: "8.2", title: "Pressure—Force per Area"), Section(id: "8.3", title: "Buoyancy in a Liquid"), Section(id: "8.4", title: "Archimedes' Principle—Sink or Swim"), Section(id: "8.5", title: "Pressure in a Gas"), Section(id: "8.6", title: "Atmospheric Pressure Is Due to the Weight of the Atmosphere"), Section(id: "8.7", title: "Pascal's Principle—The Transmission of Pressure in a Fluid"), Section(id: "8.8", title: "Buoyancy in a Gas—More Archimedes' Principle"), Section(id: "8.9", title: "Bernoulli's Principle—Flying with Physics")]),
        Chapter(number: 9, title: "Heat", part: partByID["p2"]!, startPage: 167, sections: [Section(id: "9.1", title: "Thermal Energy—The Total Energy in a Substance"), Section(id: "9.2", title: "Temperature—Average Kinetic Energy per Molecule in a Substance"), Section(id: "9.3", title: "Absolute Zero—Nature's Lowest Possible Temperature"), Section(id: "9.4", title: "Heat Is the Movement of Thermal Energy"), Section(id: "9.5", title: "Specific Heat Capacity—A Measure of Thermal Inertia"), Section(id: "9.6", title: "Thermal Expansion"), Section(id: "9.7", title: "Conduction—Heat Transfer via Particle Collision"), Section(id: "9.8", title: "Convection—Heat Transfer via Moving Fluids"), Section(id: "9.9", title: "Radiation—Heat Transfer via Radiant Energy"), Section(id: "9.10", title: "Energy Changes with Change of Phase")]),
        Chapter(number: 10, title: "Electricity", part: partByID["p2"]!, startPage: 192, sections: [Section(id: "10.1", title: "Electric Charge Is a Basic Characteristic of Matter"), Section(id: "10.2", title: "Coulomb's Law—The Force Between Charged Particles"), Section(id: "10.3", title: "Electric Polarization"), Section(id: "10.4", title: "Electric Current—The Flow of Electric Charge"), Section(id: "10.5", title: "An Electric Circuit Is Produced by Electrical Pressure—Voltage"), Section(id: "10.6", title: "Electrical Resistance"), Section(id: "10.7", title: "Ohm's Law—The Relationship Among Current, Voltage, and Resistance"), Section(id: "10.8", title: "Electric Shock"), Section(id: "10.9", title: "Direct Current and Alternating Current"), Section(id: "10.10", title: "Electric Power—The Rate of Doing Work"), Section(id: "10.11", title: "Electric Circuits—Series and Parallel")]),
        Chapter(number: 11, title: "Magnetism", part: partByID["p2"]!, startPage: 216, sections: [Section(id: "11.1", title: "Magnetic Poles—Attraction and Repulsion"), Section(id: "11.2", title: "Magnetic Fields—Regions of Magnetic Influence"), Section(id: "11.3", title: "Magnetic Domains—Clusters of Aligned Atoms"), Section(id: "11.4", title: "The Interaction Between Electric Currents and Magnetic Fields"), Section(id: "11.5", title: "Magnetic Forces Are Exerted on Moving Charges"), Section(id: "11.6", title: "Electromagnetic Induction—How Voltage Is Created"), Section(id: "11.7", title: "Faraday's Law"), Section(id: "11.8", title: "Power Production and Stepping Current and Voltage with Transformers"), Section(id: "11.9", title: "The Induction of Fields—Both Electric and Magnetic")]),
        Chapter(number: 12, title: "Waves and Sound", part: partByID["p2"]!, startPage: 235, sections: [Section(id: "12.1", title: "Special Wiggles—Vibrations and Waves"), Section(id: "12.2", title: "Wave Motion—Transporting Energy"), Section(id: "12.3", title: "Wave Speed"), Section(id: "12.4", title: "Sound Travels in Longitudinal Waves"), Section(id: "12.5", title: "Speed of Sound"), Section(id: "12.6", title: "Sound Can Be Reflected and Refracted"), Section(id: "12.7", title: "Forced Vibrations and Natural Frequency"), Section(id: "12.8", title: "Resonance—Adding Waves in Synchronization"), Section(id: "12.9", title: "Interference—Wave Addition and Subtraction"), Section(id: "12.10", title: "The Doppler Effect—Changes in Frequency due to Motion"), Section(id: "12.11", title: "Wave Barriers and Bow Waves"), Section(id: "12.12", title: "Shock Waves and the Sonic Boom")]),
        Chapter(number: 13, title: "Light, Reflection, and Color", part: partByID["p2"]!, startPage: 260, sections: [Section(id: "13.1", title: "The Electromagnetic Spectrum—and the Tiny Bit That Is Light"), Section(id: "13.2", title: "Why Materials Are Either Transparent or Opaque"), Section(id: "13.3", title: "Reflection of Light"), Section(id: "13.4", title: "Refraction—The Bending of Light Due to Changing Speed"), Section(id: "13.5", title: "Rainbows and Mirages Are Caused by Refraction"), Section(id: "13.6", title: "Color Science"), Section(id: "13.7", title: "Mixing Colored Lights"), Section(id: "13.8", title: "Mixing Colored Pigments"), Section(id: "13.9", title: "Why the Sky Is Blue"), Section(id: "13.10", title: "Why Sunsets Are Red"), Section(id: "13.11", title: "Why Clouds Are White")]),
        Chapter(number: 14, title: "Properties of Light", part: partByID["p2"]!, startPage: 287, sections: [Section(id: "14.1", title: "Light Dispersion and Rainbows"), Section(id: "14.2", title: "Lenses"), Section(id: "14.3", title: "Image Formation by a Lens"), Section(id: "14.4", title: "Diffraction—The Spreading of Light"), Section(id: "14.5", title: "Interference—Constructive and Destructive"), Section(id: "14.6", title: "Interference Colors by Reflection from Thin Films"), Section(id: "14.7", title: "Polarization—Evidence for the Transverse Wave Nature of Light"), Section(id: "14.8", title: "Wave-Particle Duality—Two Sides of the Same Coin")]),
        Chapter(number: 15, title: "The Atom", part: partByID["p2"]!, startPage: 315, sections: [Section(id: "15.1", title: "Discovering the Invisible Atom"), Section(id: "15.2", title: "Elements and the Periodic Table"), Section(id: "15.3", title: "The Atomic Nucleus Consists of Protons and Neutrons"), Section(id: "15.4", title: "Isotopes and Atomic Mass"), Section(id: "15.5", title: "Electron Shells—Regions About the Nucleus Where Electrons Are Located")]),
        Chapter(number: 16, title: "Nuclear Energy", part: partByID["p2"]!, startPage: 334, sections: [Section(id: "16.1", title: "Radioactivity—The Disintegration of the Atomic Nucleus"), Section(id: "16.2", title: "Alpha, Beta, and Gamma Rays"), Section(id: "16.3", title: "Environmental Radiation"), Section(id: "16.4", title: "Transmutation of Elements—Changing Identities"), Section(id: "16.5", title: "Half-Life Is a Measure of Radioactive Decay Rate"), Section(id: "16.6", title: "Nuclear Fission—The Breaking Apart of Atomic Nuclei"), Section(id: "16.7", title: "The Mass-Energy Relationship: E = mc²"), Section(id: "16.8", title: "The Chain Reaction of Matter"), Section(id: "16.9", title: "Nuclear Fusion—The Combining of Atomic Nuclei")]),
        Chapter(number: 17, title: "Elements of Chemistry", part: partByID["p3"]!, startPage: 359, sections: [Section(id: "17.1", title: "Chemistry Is Known as the Central Science"), Section(id: "17.2", title: "The Submicroscopic World Is Super-Small"), Section(id: "17.3", title: "The Phase of Matter Can Change"), Section(id: "17.4", title: "Matter Has Physical and Chemical Properties"), Section(id: "17.5", title: "Determining Physical and Chemical Changes Can Be Difficult"), Section(id: "17.6", title: "The Periodic Table Helps Us to Understand the Elements"), Section(id: "17.7", title: "Elements Can Combine to Form Compounds"), Section(id: "17.8", title: "There Is a System for Naming Compounds")]),
        Chapter(number: 18, title: "How Atoms Bond and Molecules Attract", part: partByID["p3"]!, startPage: 384, sections: [Section(id: "18.1", title: "Electron-Dot Structures Help Us to Understand Bonding"), Section(id: "18.2", title: "Atoms Can Lose or Gain Electrons to Become Ions"), Section(id: "18.3", title: "Ionic Bonds Result from a Transfer of Electrons"), Section(id: "18.4", title: "Metal Atoms Bond by Losing Their Electrons"), Section(id: "18.5", title: "Covalent Bonds Result from a Sharing of Electrons"), Section(id: "18.6", title: "Electrons May Be Shared Unevenly in a Covalent Bond"), Section(id: "18.7", title: "Polar Molecules Are Shared Unevenly in a Polar Molecule"), Section(id: "18.8", title: "Molecules Are Attractive")]),
        Chapter(number: 19, title: "How Chemicals Mix", part: partByID["p3"]!, startPage: 412, sections: [Section(id: "19.1", title: "Most Materials Are Mixtures"), Section(id: "19.2", title: "The Chemist's Classification of Matter"), Section(id: "19.3", title: "A Solution Is a Single-Phase Homogeneous Mixture"), Section(id: "19.4", title: "Concentration Is Given as Moles per Liter"), Section(id: "19.5", title: "Solubility Measures How Well a Solute Dissolves"), Section(id: "19.6", title: "Soaps Work by Being Both Polar and Nonpolar"), Section(id: "19.7", title: "Purifying the Water We Drink")]),
        Chapter(number: 20, title: "How Chemicals React", part: partByID["p3"]!, startPage: 437, sections: [Section(id: "20.1", title: "Chemical Reactions Are Represented by Chemical Equations"), Section(id: "20.2", title: "Chemical Reactions Can Be Slow or Fast; Activation Energy Is the Energy Needed for Reactants to React"), Section(id: "20.3", title: "Catalysts Speed Up Chemical Reactions"), Section(id: "20.4", title: "Chemical Reactions Can Be Either Exothermic or Endothermic"), Section(id: "20.5", title: "Chemical Reactions Are Driven by Entropy")]),
        Chapter(number: 21, title: "Two Types of Chemical Reactions", part: partByID["p3"]!, startPage: 460, sections: [Section(id: "21.1", title: "Acids Donate and Bases Accept Hydrogen Ions"), Section(id: "21.2", title: "Some Acids and Bases Are Stronger Than Others"), Section(id: "21.3", title: "Solutions Can Be Acidic, Basic, or Neutral; the pH Scale Is Used to Describe Acidity"), Section(id: "21.4", title: "Rainwater Is Acidic, and Ocean Water Is Basic"), Section(id: "21.5", title: "Oxidation Is the Loss of Electrons and Reduction Is the Gain of Electrons"), Section(id: "21.6", title: "The Energy of Flowing Electrons Can Be Harnessed"), Section(id: "21.7", title: "Oxidation Is Responsible for Corrosion and Combustion"), Section(id: "21.8", title: "Hydrogen Is a Possible Clean-Burning Fuel")]),
        Chapter(number: 22, title: "Organic Compounds", part: partByID["p3"]!, startPage: 490, sections: [Section(id: "22.1", title: "Hydrocarbons Contain Only Carbon and Hydrogen"), Section(id: "22.2", title: "Unsaturated Hydrocarbons Contain Multiple Bonds"), Section(id: "22.3", title: "Functional Groups Give Organic Compounds Their Distinctive Properties"), Section(id: "22.4", title: "Alcohols, Phenols, and Ethers"), Section(id: "22.5", title: "Amines and Alkaloids"), Section(id: "22.6", title: "Carbonyl Compounds"), Section(id: "22.7", title: "Polymers")]),
        Chapter(number: 23, title: "The Nutrients of Life", part: partByID["p3"]!, startPage: 521, sections: [Section(id: "23.1", title: "Biomolecules Are Produced and Used by Organisms"), Section(id: "23.2", title: "Carbohydrates Give Structure and Energy"), Section(id: "23.3", title: "Lipids Are Insoluble in Water"), Section(id: "23.4", title: "Proteins Are Polymers of Amino Acids"), Section(id: "23.5", title: "Nucleic Acids Code for Proteins"), Section(id: "23.6", title: "Vitamins Are Organic; Minerals Are Inorganic"), Section(id: "23.7", title: "Metabolism Is the Cycling of Biomolecules Through the Body")]),
        Chapter(number: 24, title: "Medicinal Chemistry", part: partByID["p3"]!, startPage: 554, sections: [Section(id: "24.1", title: "Medicines Are Drugs That Benefit the Body"), Section(id: "24.2", title: "The Lock-and-Key Model Guides Chemists in Creating New Medicines"), Section(id: "24.3", title: "Chemotherapy Cures the Host by Killing the Disease"), Section(id: "24.4", title: "The Nervous System Is a Network of Neurons"), Section(id: "24.5", title: "Psychoactive Drugs Alter the Mind or Behavior"), Section(id: "24.6", title: "Pain Relievers Inhibit the Transmission or Perception of Pain")]),
        Chapter(number: 25, title: "Rocks and Minerals", part: partByID["p4"]!, startPage: 583, sections: [Section(id: "25.1", title: "Our Rocky Planet"), Section(id: "25.2", title: "What Is a Mineral?"), Section(id: "25.3", title: "Mineral Properties"), Section(id: "25.4", title: "Classification of Rock-Forming Minerals"), Section(id: "25.5", title: "The Formation of Minerals and Rock"), Section(id: "25.6", title: "Rocks Are Divided into Three Main Groups"), Section(id: "25.7", title: "Igneous Rocks Form When Magma Cools"), Section(id: "25.8", title: "Sedimentary Rocks Blanket Most of Earth's Surface"), Section(id: "25.9", title: "Metamorphic Rocks Are Changed Rocks"), Section(id: "25.10", title: "The Rock Cycle")]),
        Chapter(number: 26, title: "The Architecture of Earth", part: partByID["p4"]!, startPage: 616, sections: [Section(id: "26.1", title: "Earthquakes Make Seismic Waves"), Section(id: "26.2", title: "Seismic Waves Reveal Earth's Internal Layers"), Section(id: "26.3", title: "Internal Motion Deforms Earth's Surface")]),
        Chapter(number: 27, title: "Plate Tectonics—A Unifying Theory", part: partByID["p4"]!, startPage: 638, sections: [Section(id: "27.1", title: "Continental Drift—An Idea Before Its Time"), Section(id: "27.2", title: "Search for the Mechanism to Support Continental Drift"), Section(id: "27.3", title: "The Theory of Plate Tectonics"), Section(id: "27.4", title: "Three Types of Plate Boundaries"), Section(id: "27.5", title: "The Theory That Explains Much")]),
        Chapter(number: 28, title: "Shaping Earth's Surface", part: partByID["p4"]!, startPage: 660, sections: [Section(id: "28.1", title: "The Hydrologic Cycle"), Section(id: "28.2", title: "Groundwater—Water Below the Surface"), Section(id: "28.3", title: "The Work of Groundwater"), Section(id: "28.4", title: "Surface Water and Rivers—Water at Earth's Surface"), Section(id: "28.5", title: "The Work of Surface Water"), Section(id: "28.6", title: "Glaciers and Glaciation—Earth's Frozen Water"), Section(id: "28.7", title: "The Work of Glaciers"), Section(id: "28.8", title: "The Work of Air")]),
        Chapter(number: 29, title: "Geologic Time—Reading the Rock Record", part: partByID["p4"]!, startPage: 690, sections: [Section(id: "29.1", title: "Relative Dating—The Placement of Rocks in Order"), Section(id: "29.2", title: "Radiometric Dating Reveals the Actual Time of Rock Formation"), Section(id: "29.3", title: "Geologic Time"), Section(id: "29.4", title: "Precambrian Time—A Time of Hidden Life"), Section(id: "29.5", title: "The Paleozoic Era—A Time of Life Diversification"), Section(id: "29.6", title: "The Mesozoic Era—The Age of Reptiles"), Section(id: "29.7", title: "The Cenozoic Era—The Age of Mammals"), Section(id: "29.8", title: "Earth History in a Capsule")]),
        Chapter(number: 30, title: "The Atmosphere, the Oceans, and Their Interactions", part: partByID["p4"]!, startPage: 715, sections: [Section(id: "30.1", title: "Components of Earth's Atmosphere"), Section(id: "30.2", title: "Vertical Structure of the Atmosphere"), Section(id: "30.3", title: "Solar Energy"), Section(id: "30.4", title: "Driving Forces of Air Motion"), Section(id: "30.5", title: "Global Atmospheric Circulation Patterns"), Section(id: "30.6", title: "Components of Earth's Oceans"), Section(id: "30.7", title: "Oceanic Circulation")]),
        Chapter(number: 31, title: "Weather", part: partByID["p4"]!, startPage: 741, sections: [Section(id: "31.1", title: "Water in the Atmosphere"), Section(id: "31.2", title: "Weather Variables"), Section(id: "31.3", title: "There Are Many Different Clouds"), Section(id: "31.4", title: "Air Masses, Fronts, and Storms"), Section(id: "31.5", title: "Weather Can Be Violent"), Section(id: "31.6", title: "The Weather—Number-One Topic of Conversation")]),
        Chapter(number: 32, title: "The Solar System", part: partByID["p5"]!, startPage: 767, sections: [Section(id: "32.1", title: "The Solar System Is Mostly Empty Space"), Section(id: "32.2", title: "Solar Systems Form from Nebula"), Section(id: "32.3", title: "The Sun Is Our Prime Source of Energy"), Section(id: "32.4", title: "The Inner Planets Are Rocky"), Section(id: "32.5", title: "The Outer Planets Are Gaseous"), Section(id: "32.6", title: "Earth's Moon"), Section(id: "32.7", title: "Failed Planet Formation")]),
        Chapter(number: 33, title: "Stars", part: partByID["p5"]!, startPage: 796, sections: [Section(id: "33.1", title: "Observing the Night Sky"), Section(id: "33.2", title: "Stars Have Different Brightness and Color"), Section(id: "33.3", title: "The Hertzsprung-Russell Diagram Describes Stars"), Section(id: "33.4", title: "The Life Cycles of Stars"), Section(id: "33.5", title: "Novae and Supernovae Are Stellar Explosions"), Section(id: "33.6", title: "Supergiant Stars Collapse into Black Holes")]),
        Chapter(number: 34, title: "Galaxies and the Cosmos", part: partByID["p5"]!, startPage: 816, sections: [Section(id: "34.1", title: "A Galaxy Is an Island of Stars"), Section(id: "34.2", title: "Elliptical, Spiral, and Irregular Galaxies"), Section(id: "34.3", title: "Active Galaxies Emit Huge Amounts of Energy"), Section(id: "34.4", title: "Galaxies Form Clusters and Superclusters"), Section(id: "34.5", title: "Galaxies Are Moving Away from One Another"), Section(id: "34.6", title: "Further Evidence for the Big Bang"), Section(id: "34.7", title: "Dark Matter Is Invisible"), Section(id: "34.8", title: "Dark Energy Opposes Gravity")]),
    ]

    private static let byNumber: [Int: Chapter] = {
        Dictionary(uniqueKeysWithValues: chapters.map { ($0.number, $0) })
    }()

    private static let appendixByLetter: [String: Appendix] = {
        Dictionary(uniqueKeysWithValues: appendices.map { ($0.letter, $0) })
    }()

    static func chapter(_ number: Int) -> Chapter? {
        byNumber[number]
    }

    static func appendix(_ letter: String) -> Appendix? {
        appendixByLetter[letter.uppercased()]
    }

    /// Formats `1`, `2–4`, `10–13`, `1 + App. B`, or `16 · 24`.
    static func formatReference(_ chapterPart: String) -> String {
        var labels: [String] = []
        let normalized = chapterPart
            .replacingOccurrences(of: "Ch ", with: "")
            .trimmingCharacters(in: .whitespaces)

        if normalized.contains("App.") {
            let segments = normalized.split(separator: "+", omittingEmptySubsequences: true)
            for segment in segments {
                let piece = segment.trimmingCharacters(in: .whitespaces)
                if piece.lowercased().contains("app.") {
                    let letter = piece
                        .replacingOccurrences(of: "App.", with: "")
                        .replacingOccurrences(of: "Appendix", with: "")
                        .trimmingCharacters(in: .whitespaces)
                    if let appendix = appendix(letter) {
                        labels.append("Appendix \(appendix.letter) — \(appendix.title)")
                    } else {
                        labels.append(piece)
                    }
                } else {
                    labels.append(formatChapterNumbers(piece))
                }
            }
            return labels.joined(separator: " · ")
        }

        return formatChapterNumbers(normalized)
    }

    private static func formatChapterNumbers(_ chapterPart: String) -> String {
        let numbers = parseChapterNumbers(chapterPart)
        guard !numbers.isEmpty else { return "Ch \(chapterPart)" }
        return numbers.compactMap { number in
            guard let ch = chapter(number) else { return "Ch \(number)" }
            return "\(ch.part.name) · Ch \(ch.number) — \(ch.title)"
        }.joined(separator: " · ")
    }

    static func parseChapterNumbers(_ chapterPart: String) -> [Int] {
        var result: [Int] = []
        let normalized = chapterPart
            .replacingOccurrences(of: "Ch ", with: "")
            .trimmingCharacters(in: .whitespaces)

        for segment in normalized.split(separator: "·").map({ $0.trimmingCharacters(in: .whitespaces) }) {
            if segment.contains("–") {
                let bounds = segment.split(separator: "–").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
                if bounds.count == 2, bounds[0] <= bounds[1] {
                    result.append(contentsOf: bounds[0]...bounds[1])
                    continue
                }
            }
            if segment.contains("-") && !segment.contains("–") {
                let bounds = segment.split(separator: "-").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
                if bounds.count == 2, bounds[0] <= bounds[1] {
                    result.append(contentsOf: bounds[0]...bounds[1])
                    continue
                }
            }
            if let n = Int(segment) {
                result.append(n)
            }
        }
        return result
    }

    static func formattedLine(chapter: String, title: String) -> String {
        "\(editionTitle) — \(formatReference(chapter)) — \(title)"
    }

    /// Chapters grouped by part (for Topics reference).
    static var chaptersGroupedByPart: [(part: PartInfo, chapters: [Chapter])] {
        var seen = Set<String>()
        var groups: [(PartInfo, [Chapter])] = []
        for chapter in chapters {
            if seen.insert(chapter.part.id).inserted {
                groups.append((chapter.part, chapters.filter { $0.part.id == chapter.part.id }))
            }
        }
        return groups
    }

    static func chaptersGroupedByPart(filterPartIDs: Set<String>) -> [(part: PartInfo, chapters: [Chapter])] {
        chaptersGroupedByPart.filter { filterPartIDs.contains($0.part.id) }
    }
}
