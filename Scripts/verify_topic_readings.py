#!/usr/bin/env python3
"""Verify topic_readings.json covers all NSB topics with readings."""

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TOPICS = ROOT / "Resources/StudyContent/topics.json"
READINGS = ROOT / "Resources/StudyContent/topic_readings.json"


def main() -> int:
    with TOPICS.open(encoding="utf-8") as f:
        topics = json.load(f)
    with READINGS.open(encoding="utf-8") as f:
        readings = json.load(f)

    topic_ids = {t["id"] for t in topics}
    reading_ids = set(readings.keys()) if isinstance(readings, dict) else {r["topicId"] for r in readings}

    missing = sorted(topic_ids - reading_ids)
    extra = sorted(reading_ids - topic_ids)

    print(f"Topics: {len(topic_ids)} · Readings: {len(reading_ids)}")
    if missing:
        print(f"Missing readings ({len(missing)}):", ", ".join(missing[:10]), "…" if len(missing) > 10 else "")
    if extra:
        print(f"Extra reading keys ({len(extra)}):", ", ".join(extra[:10]), "…" if len(extra) > 10 else "")

    if missing:
        return 1
    print("OK — all topics have readings.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
