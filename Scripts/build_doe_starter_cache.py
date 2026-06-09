#!/usr/bin/env python3
"""Build bundled DOE starter cache from encyclopedia questions.json."""

import json
import uuid
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
QUESTIONS = ROOT / "Resources/StudyContent/questions.json"
OUT = ROOT / "Resources/StudyContent/doe_starter_cache.json"

SUBJECT_MAP = {
    "Life Science": ("Biology", "TOSS-UP", "Short Answer"),
    "Chemistry": ("Chemistry", "TOSS-UP", "Short Answer"),
    "Physical Science": ("Physics", "TOSS-UP", "Short Answer"),
    "Earth & Space Science": ("Earth and Space", "TOSS-UP", "Short Answer"),
    "Energy": ("Energy", "TOSS-UP", "Short Answer"),
    "Math": ("Math", "TOSS-UP", "Multiple Choice"),
}

# Prefer a mix of categories for offline drills.
PREFERRED_ORDER = [
    "Life Science",
    "Chemistry",
    "Physical Science",
    "Earth & Space Science",
    "Energy",
    "Math",
]


def main() -> None:
    with QUESTIONS.open(encoding="utf-8") as f:
        all_qs = json.load(f)

    by_subject: dict[str, list] = {s: [] for s in PREFERRED_ORDER}
    for q in all_qs:
        subj = q.get("subject", "")
        if subj in by_subject:
            by_subject[subj].append(q)

    picked: list = []
    per_cat = 8
    for subj in PREFERRED_ORDER:
        picked.extend(by_subject[subj][:per_cat])

    out = []
    for i, q in enumerate(picked):
        cat, qtype, fmt = SUBJECT_MAP[q["subject"]]
        choices = []
        answer = q["correctAnswer"]
        if q.get("answerChoices"):
            choices = [f"{k}) {v}" for k, v in sorted(q["answerChoices"].items())]
            answer = q["answerChoices"].get(q["correctAnswer"], q["correctAnswer"])

        out.append(
            {
                "id": str(uuid.uuid4()).upper(),
                "setNumber": 0,
                "roundNumber": 1,
                "questionNumber": i + 1,
                "category": cat,
                "questionType": qtype,
                "format": fmt,
                "questionText": q["questionText"],
                "choices": choices,
                "answer": answer,
                "sourceFile": "doe_starter_cache",
                "sourceYear": 2024,
            }
        )

    OUT.write_text(json.dumps(out, indent=2) + "\n", encoding="utf-8")
    print(f"Wrote {len(out)} starter DOE questions → {OUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
