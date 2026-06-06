#!/usr/bin/env python3
"""Download all DOE Middle School sample question PDFs into Resources/DOE-PDFs/."""

import os
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DEST_ROOT = ROOT / "Resources" / "DOE-PDFs"

URLS = []

def add_set(set_num, folder, urls, year=None):
    for i, url in enumerate(urls, start=1):
        filename = url.split("/")[-1]
        URLS.append((set_num, folder, filename, url))

# Set 1 (2009) — 18 rounds
add_set(1, "Set-1", [
    f"https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-1/m_round{n:02d}.pdf"
    for n in range(1, 19)
])

# Set 2 (2008) — 10 rounds
add_set(2, "Set-2", [
    f"https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-2/sample_questions_r{n}.pdf"
    for n in range(1, 11)
])

# Set 3 (2007)
set3 = [f"https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-3/Round-{n}C-MS.pdf" for n in range(1, 16)]
set3.append("https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-3/Energy-Category.pdf")
add_set(3, "Set-3", set3)

# Set 4–6
add_set(4, "Set-4", [f"https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-4/Round{n}.pdf" for n in range(1, 18)])
add_set(5, "Set-5", [f"https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-5/Round{n}.pdf" for n in range(1, 17)])
add_set(6, "Set-6", [f"https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-6/Round{n}.pdf" for n in range(1, 18)])

# Set 7
add_set(7, "Set-7", [f"https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-7/MS_Round-{n}.pdf" for n in range(1, 16)])

# Set 8
add_set(8, "Set-8", [f"https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-8/Round-{n}-A.pdf" for n in range(1, 18)])

# Set 9
set9 = ["RegionalMS_1.pdf", "RegionalMS_2.pdf"] + [f"RegionalMS_{n}A.pdf" for n in range(3, 18)]
add_set(9, "Set-9", [f"https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-9/{f}" for f in set9])

# Set 10–12
add_set(10, "Set-10", [f"https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-10/{n}A_MS_Reg_2016.pdf" for n in range(1, 18)])
set11 = ["MS_1.pdf", "MS_2.pdf"] + [f"MS_{n}A.pdf" for n in range(3, 18)]
add_set(11, "Set-11", [f"https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-set-11/{f}" for f in set11])
add_set(12, "Set-12", [f"https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-12/MSRound-{n}.pdf" for n in range(1, 18)])

# Set 13
add_set(13, "Set-13", [f"https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-13/2019-NSB-MSR-Round-{n}A.pdf" for n in range(1, 18)])

# Sample Rounds
add_set(0, "Sample-Rounds", [
    "https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Rounds/rr2_for_web.pdf",
    "https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Rounds/rr5_for_web.pdf",
    "https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Rounds/de1_for_web.pdf",
    "https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Rounds/de3_for_web.pdf",
])

# Set 14–16
add_set(14, "Set-14", [f"https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-14/2020-MS-Rd{n}.pdf" for n in range(1, 18)])

set15 = [
    "Set-1-MS-2021.pdf", "Set-2-MS-2021.pdf", "Set-3-MS-2021.pdf", "Set-4-MS-2021.pdf",
    "Set-5-MS-2021.pdf", "Set-6-MS-2021.pdf",
    "https://science.osti.gov/-/media/wdts/nsb/pdf/HS-Sample-Questions/Sample-Set-16/Set-7-HS-2021.pdf",
    "Set-8-MS-2021.pdf", "Set-9-MS-2021.pdf", "Set-10-MS-2021.pdf",
]
add_set(15, "Set-15", [
    u if u.startswith("http") else f"https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-15/{u}"
    for u in set15
])

add_set(16, "Set-16", [f"https://science.osti.gov/-/media/wdts/nsb/pdf/MS-Sample-Questions/Sample-Set-16/2022-MS-{n}.pdf" for n in range(1, 10)])


def download(url: str, dest: Path) -> bool:
    dest.parent.mkdir(parents=True, exist_ok=True)
    if dest.exists() and dest.stat().st_size > 0:
        print(f"  skip (exists) {dest.name}")
        return True
    try:
        urllib.request.urlretrieve(url, dest)
        print(f"  ✓ {dest.name}")
        return True
    except Exception as e:
        print(f"  ✗ {dest.name} — {e}")
        return False


def main():
    ok = 0
    total = len(URLS)
    current_set = None
    for set_num, folder, filename, url in URLS:
        if set_num != current_set:
            current_set = set_num
            label = "Sample Rounds" if set_num == 0 else f"Set {set_num}"
            print(f"\n[{label}]")
        dest = DEST_ROOT / folder / filename
        if download(url, dest):
            ok += 1
    print(f"\nDownloaded {ok} / {total} files successfully")
    print(f"Output: {DEST_ROOT}")


if __name__ == "__main__":
    main()
