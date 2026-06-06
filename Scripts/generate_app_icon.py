#!/usr/bin/env python3
"""
Generate the science-themed app icon for Science Bowl Coach (1024x1024 PNG).
Run from project root: python3 Scripts/generate_app_icon.py
Requires: pip install Pillow
"""
import math
import os

try:
    from PIL import Image, ImageDraw
except ImportError:
    print("Install Pillow: pip install Pillow")
    raise SystemExit(1)

W = H = 1024
CREAM = (245, 240, 232)
AMBER = (232, 140, 51)
DARKER = (200, 115, 40)

img = Image.new("RGB", (W, H), CREAM)
draw = ImageDraw.Draw(img)
cx, cy = W // 2, H // 2

draw.ellipse([cx - 70, cy - 70, cx + 70, cy + 70], fill=AMBER, outline=DARKER)
draw.ellipse([cx - 240, cy - 100, cx + 240, cy + 100], outline=AMBER, width=24)
draw.ellipse([cx - 140, cy - 220, cx + 140, cy + 220], outline=AMBER, width=24)

for angle in [0, math.pi / 2, math.pi, 3 * math.pi / 2]:
    for rx, ry in [(240, 100), (140, 220)]:
        ex = int(cx + rx * math.cos(angle))
        ey = int(cy + ry * math.sin(angle))
        draw.ellipse([ex - 35, ey - 35, ex + 35, ey + 35], fill=AMBER, outline=DARKER)

script_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(script_dir)
out_dir = os.path.join(project_root, "Resources", "Assets.xcassets", "AppIcon.appiconset")
os.makedirs(out_dir, exist_ok=True)
out_path = os.path.join(out_dir, "AppIcon.png")
img.save(out_path)
print("Saved:", out_path)
