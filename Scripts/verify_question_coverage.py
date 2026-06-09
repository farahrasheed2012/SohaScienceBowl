#!/usr/bin/env python3
"""Verify questions.json covers all encyclopedia topics (minimum practice per topic)."""

import json
import sys
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TOPICS = ROOT / "Resources/StudyContent/topics.json"
QUESTIONS = ROOT / "Resources/StudyContent/questions.json"

MIN_QUESTIONS = 2


def main() -> int:
    with TOPICS.open(encoding="utf-8") as f:
        topics = json.load(f)
    with QUESTIONS.open(encoding="utf-8") as f:
        questions = json.load(f)

    topic_ids = {t["id"] for t in topics}
    counts = Counter(q["topicId"] for q in questions)
    orphan_ids = sorted(set(counts) - topic_ids)

    no_practice = sorted(t["id"] for t in topics if counts.get(t["id"], 0) == 0)
    thin = sorted(t["id"] for t in topics if 0 < counts.get(t["id"], 0) < MIN_QUESTIONS)
    good = len(topic_ids) - len(no_practice) - len(thin)

    print(f"Topics: {len(topic_ids)} · Questions: {len(questions)} · Min per topic: {MIN_QUESTIONS}")
    print(f"Practice coverage: {good} ready · {len(thin)} thin · {len(no_practice)} missing")

    if orphan_ids:
        print(f"Orphan question topicIds ({len(orphan_ids)}):", ", ".join(orphan_ids[:10]), "…" if len(orphan_ids) > 10 else "")

    if no_practice:
        print(f"\nNo practice ({len(no_practice)}):")
        for tid in no_practice:
            title = next(t["title"] for t in topics if t["id"] == tid)
            subj = next(t["subject"] for t in topics if t["id"] == tid)
            print(f"  [{subj}] {title} ({tid})")

    if thin:
        print(f"\nThin — fewer than {MIN_QUESTIONS} questions ({len(thin)}):")
        for tid in thin[:15]:
            title = next(t["title"] for t in topics if t["id"] == tid)
            print(f"  {title} ({tid}) — {counts[tid]} question(s)")
        if len(thin) > 15:
            print(f"  … and {len(thin) - 15} more")

    if orphan_ids or no_practice:
        return 1

    if thin:
        print(f"\nWARN — {len(thin)} topics still below {MIN_QUESTIONS} questions (not failing build).")
    else:
        print("OK — every topic has at least", MIN_QUESTIONS, "practice questions.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
