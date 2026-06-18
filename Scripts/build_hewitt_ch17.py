#!/usr/bin/env python3
"""Generate Hewitt Ch 17 NSB question JSON for Science Bowl Coach and TossUp."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FARAH = ROOT.parent
TOPIC_ID = "hewitt-ch17"

# (section, kind, type, question, choices_dict_or_none, answer)
# kind: tossUp | bonus; type: mc | sa
PAIRS: list[tuple[str, str, str, str, dict[str, str] | None, str]] = [
    ("17.1", "tossUp", "mc",
     "Chemistry is called the \"central science\" primarily because it:",
     {"W": "is the oldest of all sciences",
      "X": "connects and underlies biology, physics, geology, and other sciences",
      "Y": "is the most difficult subject to study",
      "Z": "was developed before mathematics"},
     "X"),
    ("17.1", "bonus", "sa",
     "Name TWO scientific fields that rely heavily on chemistry as a foundation.",
     None,
     "Any two of: biology, physics, geology, environmental science, medicine, materials science"),
    ("17.1", "tossUp", "sa",
     "What term describes matter that has a uniform and definite composition throughout?",
     None,
     "Pure substance"),
    ("17.1", "bonus", "mc",
     "Which of the following best describes what chemists primarily study?",
     {"W": "The motion of planets and stars",
      "X": "The composition, structure, and properties of matter and how it changes",
      "Y": "The flow of electrical current through circuits",
      "Z": "The behavior of living organisms"},
     "X"),
    ("17.2", "tossUp", "mc",
     "Which of the following correctly lists the three subatomic particles found in atoms?",
     {"W": "Protons, electrons, neutrons",
      "X": "Protons, photons, neutrons",
      "Y": "Electrons, quarks, photons",
      "Z": "Ions, protons, electrons"},
     "W"),
    ("17.2", "bonus", "sa",
     "Where is virtually all of the mass of an atom concentrated?",
     None,
     "The nucleus"),
    ("17.2", "tossUp", "sa",
     "What is the term for atoms of the same element that have different numbers of neutrons?",
     None,
     "Isotopes"),
    ("17.2", "bonus", "mc",
     "Approximately how many times smaller is an atom compared to a typical living cell?",
     {"W": "10 times smaller", "X": "100 times smaller", "Y": "1,000 times smaller", "Z": "10,000 times smaller"},
     "Z"),
    ("17.2", "tossUp", "mc",
     "The electrons in an atom are located:",
     {"W": "Inside the nucleus alongside protons",
      "X": "Randomly scattered throughout the atom with no pattern",
      "Y": "In regions of space outside the nucleus called orbitals or shells",
      "Z": "Attached directly to neutrons"},
     "Y"),
    ("17.2", "bonus", "sa",
     "What charge does a proton carry, and what charge does an electron carry?",
     None,
     "Proton is positive (+1); electron is negative (−1)"),
    ("17.2", "tossUp", "sa",
     "What is the name of the particle in the nucleus that has no electrical charge?",
     None,
     "Neutron"),
    ("17.2", "bonus", "mc",
     "If an atom has 6 protons, 6 neutrons, and 6 electrons, what element is it?",
     {"W": "Nitrogen", "X": "Oxygen", "Y": "Carbon", "Z": "Boron"},
     "Y"),
    ("17.3", "tossUp", "mc",
     "In which phase of matter do particles have the most energy and move most freely?",
     {"W": "Solid", "X": "Liquid", "Y": "Gas", "Z": "Plasma"},
     "Y"),
    ("17.3", "bonus", "sa",
     "What is the term for the phase change from liquid to gas that occurs at the surface of a liquid at temperatures below boiling point?",
     None,
     "Evaporation"),
    ("17.3", "tossUp", "sa",
     "What is the term for the temperature at which a solid changes directly into a liquid?",
     None,
     "Melting point"),
    ("17.3", "bonus", "mc",
     "Which phase change describes a gas turning directly into a solid, skipping the liquid phase?",
     {"W": "Condensation", "X": "Sublimation", "Y": "Deposition", "Z": "Freezing"},
     "Y"),
    ("17.3", "tossUp", "mc",
     "In a solid, particles:",
     {"W": "Move rapidly and are far apart",
      "X": "Slide past each other freely",
      "Y": "Vibrate in fixed positions and are closely packed",
      "Z": "Have no attraction to each other"},
     "Y"),
    ("17.3", "bonus", "sa",
     "What is the term for the phase change in which a solid converts directly to a gas without passing through the liquid phase? Give an everyday example.",
     None,
     "Sublimation; dry ice or mothballs"),
    ("17.3", "tossUp", "sa",
     "What happens to the temperature of a substance while it is undergoing a phase change, such as melting or boiling?",
     None,
     "It remains constant"),
    ("17.3", "bonus", "mc",
     "Which of the following correctly describes a liquid?",
     {"W": "Definite shape and definite volume",
      "X": "No definite shape and no definite volume",
      "Y": "Definite volume but no definite shape",
      "Z": "Definite shape but no definite volume"},
     "Y"),
    ("17.4", "tossUp", "mc",
     "Which of the following is a PHYSICAL property of matter?",
     {"W": "Flammability", "X": "Ability to rust", "Y": "Density", "Z": "Reactivity with acid"},
     "Y"),
    ("17.4", "bonus", "sa",
     "Give TWO examples of chemical properties of matter.",
     None,
     "Any two of: flammability, reactivity with acid, ability to rust, toxicity, tendency to oxidize"),
    ("17.4", "tossUp", "sa",
     "What physical property describes the ratio of a substance's mass to its volume?",
     None,
     "Density"),
    ("17.4", "bonus", "mc",
     "Which of the following is a CHEMICAL property?",
     {"W": "Boiling point", "X": "Color", "Y": "Malleability", "Z": "Flammability"},
     "Z"),
    ("17.4", "tossUp", "mc",
     "A substance's melting point, color, and hardness are all examples of:",
     {"W": "Chemical properties", "X": "Physical properties", "Y": "Intensive reactions", "Z": "Atomic properties"},
     "X"),
    ("17.4", "bonus", "sa",
     "What is the difference between an intensive physical property and an extensive physical property? Give one example of each.",
     None,
     "Intensive does not depend on amount (density, boiling point); extensive depends on amount (mass, volume)"),
    ("17.5", "tossUp", "mc",
     "Which of the following is an example of a CHEMICAL change?",
     {"W": "Crushing a can", "X": "Melting ice", "Y": "Dissolving sugar in water", "Z": "Burning wood"},
     "Z"),
    ("17.5", "bonus", "sa",
     "List THREE signs that a chemical change may have occurred.",
     None,
     "Any three of: color change, gas production, precipitate, heat/light, odor change, irreversibility"),
    ("17.5", "tossUp", "sa",
     "When iron rusts, is this a physical or chemical change? Explain in one sentence.",
     None,
     "Chemical change — iron reacts with oxygen to form iron oxide"),
    ("17.5", "bonus", "mc",
     "Dissolving salt in water is generally considered a physical change because:",
     {"W": "It produces a new gas", "X": "The salt changes color",
      "Y": "The salt can be recovered by evaporating the water", "Z": "It releases a large amount of heat"},
     "Y"),
    ("17.5", "tossUp", "mc",
     "Which of the following is the BEST example of a physical change?",
     {"W": "Burning paper", "X": "Digesting food", "Y": "Cutting hair", "Z": "Souring milk"},
     "Y"),
    ("17.5", "bonus", "sa",
     "Why can it sometimes be difficult to classify a change as physical or chemical?",
     None,
     "Some changes show signs of both or can be interpreted different ways"),
    ("17.6", "tossUp", "mc",
     "On the periodic table, elements in the same COLUMN (group) share:",
     {"W": "The same number of protons", "X": "The same atomic mass",
      "Y": "Similar chemical properties", "Z": "The same number of neutrons"},
     "Y"),
    ("17.6", "bonus", "sa",
     "What is the atomic number of an element, and what does it tell you?",
     None,
     "Number of protons in the nucleus; it uniquely identifies the element"),
    ("17.6", "tossUp", "sa",
     "What scientist is most credited with developing the modern periodic table by arranging elements by atomic mass and repeating properties?",
     None,
     "Dmitri Mendeleev"),
    ("17.6", "bonus", "mc",
     "Elements in Group 18 of the periodic table are called noble gases. They are chemically unreactive primarily because:",
     {"W": "They are all metals", "X": "They have complete outer electron shells",
      "Y": "They are liquids at room temperature", "Z": "They have very high atomic masses"},
     "X"),
    ("17.6", "tossUp", "mc",
     "The rows (horizontal) of the periodic table are called:",
     {"W": "Groups", "X": "Families", "Y": "Periods", "Z": "Series"},
     "Y"),
    ("17.6", "bonus", "sa",
     "What are the two broad categories that most elements fall into on the periodic table, and which side of the table does each occupy?",
     None,
     "Metals (left/center) and nonmetals (right); metalloids along the staircase"),
    ("17.6", "tossUp", "sa",
     "What is the name given to the elements in Group 1 of the periodic table, which are highly reactive metals?",
     None,
     "Alkali metals"),
    ("17.6", "bonus", "mc",
     "Which of the following elements is a halogen?",
     {"W": "Sodium (Na)", "X": "Calcium (Ca)", "Y": "Chlorine (Cl)", "Z": "Argon (Ar)"},
     "Y"),
    ("17.6", "tossUp", "sa",
     "How many naturally occurring elements exist?",
     None,
     "92"),
    ("17.6", "bonus", "mc",
     "In the periodic table, as you move LEFT to RIGHT across a period, the atomic number:",
     {"W": "Decreases by one each step", "X": "Stays the same",
      "Y": "Increases by one each step", "Z": "Doubles each step"},
     "Y"),
    ("17.7", "tossUp", "mc",
     "A compound differs from a mixture in that a compound:",
     {"W": "Contains only one type of atom",
      "X": "Has components that can be separated by physical means",
      "Y": "Has elements chemically bonded in fixed ratios",
      "Z": "Is always a liquid at room temperature"},
     "Y"),
    ("17.7", "bonus", "sa",
     "Water is a compound with the chemical formula H₂O. What does this formula tell you about the ratio of hydrogen to oxygen atoms in water?",
     None,
     "2 hydrogen atoms for every 1 oxygen atom"),
    ("17.7", "tossUp", "sa",
     "What type of chemical bond forms when one atom transfers electrons to another atom, creating oppositely charged ions that attract each other?",
     None,
     "Ionic bond"),
    ("17.7", "bonus", "mc",
     "Which of the following is an example of a compound (not a mixture or pure element)?",
     {"W": "Gold (Au)", "X": "Air", "Y": "Table salt (NaCl)", "Z": "Brass"},
     "Y"),
    ("17.7", "tossUp", "mc",
     "A covalent bond forms when two atoms:",
     {"W": "Transfer electrons from one to the other completely",
      "X": "Share electrons between them",
      "Y": "Repel each other due to like charges",
      "Z": "Exchange protons in their nuclei"},
     "X"),
    ("17.7", "bonus", "sa",
     "What is the law of definite proportions, and how does it apply to compounds?",
     None,
     "A compound always contains the same elements in the same proportion by mass"),
    ("17.7", "tossUp", "sa",
     "What is the smallest unit of a compound that still has the chemical properties of that compound?",
     None,
     "Molecule"),
    ("17.7", "bonus", "mc",
     "Table salt forms when sodium and chlorine combine. This is an example of:",
     {"W": "A physical change forming a mixture", "X": "A chemical change forming a compound",
      "Y": "Sublimation", "Z": "A nuclear reaction"},
     "X"),
    ("17.8", "tossUp", "mc",
     "In the name \"dinitrogen monoxide,\" the prefix \"mono-\" indicates:",
     {"W": "Two atoms of nitrogen", "X": "One atom of oxygen", "Y": "Two molecules total", "Z": "The compound is a metal"},
     "X"),
    ("17.8", "bonus", "sa",
     "Using the system for naming binary covalent compounds, what is the name of CO₂?",
     None,
     "Carbon dioxide"),
    ("17.8", "tossUp", "sa",
     "What is the name of the compound with the formula N₂O₄?",
     None,
     "Dinitrogen tetroxide"),
    ("17.8", "bonus", "mc",
     "When naming an ionic compound, which ion's name is written first?",
     {"W": "The negative ion", "X": "The ion with higher atomic mass",
      "Y": "The positive ion (cation)", "Z": "Whichever is a metal"},
     "Y"),
    ("17.8", "tossUp", "mc",
     "What is the correct name for the compound NaCl?",
     {"W": "Sodium chlorine", "X": "Sodium chloride", "Y": "Monosodium chloride", "Z": "Natrium chloride"},
     "X"),
    ("17.8", "bonus", "sa",
     "What prefix is used in compound naming to indicate FOUR atoms of an element?",
     None,
     "Tetra-"),
    ("17.8", "tossUp", "sa",
     "What is the chemical formula for water, and using the naming system for covalent compounds, what would its systematic name be?",
     None,
     "H₂O; dihydrogen monoxide"),
    ("17.8", "bonus", "mc",
     "Which compound name is correctly written?",
     {"W": "Iron two oxide", "X": "Iron(II) oxide", "Y": "Diiron oxide", "Z": "Iron monoxide"},
     "X"),
    ("17.8", "tossUp", "sa",
     "What suffix is added to the name of the nonmetal element when naming a binary ionic compound?",
     None,
     "-ide"),
]


def section_title(section: str) -> str:
    titles = {
        "17.1": "Chemistry Is Known as the Central Science",
        "17.2": "The Submicroscopic World Is Super-Small",
        "17.3": "The Phase of Matter Can Change",
        "17.4": "Matter Has Physical and Chemical Properties",
        "17.5": "Determining Physical and Chemical Changes Can Be Difficult",
        "17.6": "The Periodic Table",
        "17.7": "Elements Can Combine to Form Compounds",
        "17.8": "There Is a System for Naming Compounds",
    }
    return titles.get(section, section)


def build_coach() -> list[dict]:
    out = []
    for i, (section, kind, qtype, text, choices, answer) in enumerate(PAIRS, start=1):
        entry: dict = {
            "id": f"h17-{i:03d}",
            "subject": "Chemistry",
            "subtopic": f"§{section} {section_title(section)}",
            "type": kind,
            "questionText": text,
            "answerChoices": choices,
            "correctAnswer": answer if qtype == "sa" else answer,
            "difficulty": "grade7",
            "topicId": TOPIC_ID,
        }
        if qtype == "mc" and choices:
            entry["answerChoices"] = choices
            entry["correctAnswer"] = answer
        else:
            entry["answerChoices"] = None
            entry["correctAnswer"] = answer
        out.append(entry)
    return out


def build_tossup() -> list[dict]:
    out = []
    for i, (section, kind, qtype, text, choices, answer) in enumerate(PAIRS, start=1):
        if qtype == "mc" and choices:
            choice_list = [f"{k}) {v}" for k, v in sorted(choices.items())]
            qtype_str = "multipleChoice"
            ans = answer
        else:
            choice_list = None
            qtype_str = "shortAnswer"
            ans = answer
        label = "Toss-Up" if kind == "tossUp" else "Bonus"
        out.append({
            "id": f"h17-{i:03d}",
            "subject": "chemistry",
            "round": f"{label} §{section}",
            "type": qtype_str,
            "questionText": text,
            "choices": choice_list,
            "correctAnswer": ans,
            "sourcePDF": "Hewitt-Ch17",
        })
    return out


def main() -> None:
    coach_path = ROOT / "Resources/StudyContent/hewitt_ch17_questions.json"
    tossup_path = FARAH / "TossUp/TossUp/Resources/hewitt_ch17_questions.json"

    coach_path.parent.mkdir(parents=True, exist_ok=True)
    tossup_path.parent.mkdir(parents=True, exist_ok=True)

    coach = build_coach()
    tossup = build_tossup()

    coach_path.write_text(json.dumps(coach, indent=2) + "\n")
    tossup_path.write_text(json.dumps(tossup, indent=2) + "\n")

    print(f"Wrote {len(coach)} questions to {coach_path}")
    print(f"Wrote {len(tossup)} questions to {tossup_path}")


if __name__ == "__main__":
    main()
