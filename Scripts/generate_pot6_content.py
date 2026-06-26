#!/usr/bin/env python3
"""Generate POT6TopicRegistry.swift and POT6DrillBank.swift from curriculum metadata."""

from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "Scripts"))
from pot6_curriculum import POT6_COMPETITION_CODES, POT6_SCHOOL_CODES, POT6_SCHOOL_TITLES

# (code, title, category, is_competition_only)
TOPICS = [
    # POLYNOMIALS
    ("T225", "Introduction to polynomials", "polynomials", False),
    ("T226", "Evaluate polynomials", "polynomials", False),
    ("T227", "Polynomial addition and subtraction", "polynomials", False),
    ("T228", "Polynomial multiplication", "polynomials", False),
    ("T229", "Polynomial division", "polynomials", False),
    ("T230", "Polynomial formulas and expansion (easy)", "polynomials", False),
    ("T231", "Polynomial formulas and expansion (hard)", "polynomials", False),
    ("T239", "Basics of factoring polynomials", "polynomials", False),
    ("T240", "Factor: GCF and formulas", "polynomials", False),
    ("T241", "Factor: quadratics", "polynomials", False),
    ("T242", "Factor: substitution and grouping", "polynomials", True),
    ("T243", "Factor: all 5 methods", "polynomials", True),
    ("T290", "Binomial theorem", "polynomials", False),
    ("T291", "Find the sum of coefficients", "polynomials", True),
    # COORDINATE GEOMETRY
    ("T247", "Rectangular coordinate system", "coordinateGeometry", False),
    ("T248", "Equations of lines — all 5 forms", "coordinateGeometry", False),
    ("T249", "3 examples of line-related problems", "coordinateGeometry", True),
    ("T250", "Slopes of parallel lines", "coordinateGeometry", False),
    ("T251", "Slopes of perpendicular lines", "coordinateGeometry", False),
    ("T252", "Midpoint and distance formulas", "coordinateGeometry", False),
    ("T253", "Point-to-line distance formula", "coordinateGeometry", True),
    ("T254", "Determine if three points are collinear", "coordinateGeometry", False),
    ("T255", "Find coordinates of P on segments", "coordinateGeometry", True),
    ("T256", "Shoelace formula", "coordinateGeometry", True),
    ("T292", "Equations of circles", "coordinateGeometry", False),
    # QUADRATICS
    ("T261", "Solve quadratic equations", "quadratics", False),
    ("T262", "Complete the square", "quadratics", False),
    ("T263", "Vieta's formula", "quadratics", False),
    ("T264", "Absolute values (advanced)", "quadratics", False),
    ("T265", "Solve absolute value inequalities", "quadratics", False),
    ("T289", "Complete review of quadratics", "quadratics", False),
    # COUNTING & PROBABILITY
    ("T272", "Counting — 7 methods", "counting", False),
    ("T273", "Counting water flow model", "counting", True),
    ("T274", "Probability using counting", "counting", False),
    ("T275", "Sets", "counting", False),
    ("T276", "Events", "counting", False),
    ("T277", "Probability using compound events", "counting", False),
    ("T278", "Practice: probability compound events", "counting", False),
    ("T279", "Probability tree diagrams", "counting", False),
    ("T280", "Expected values in probability", "counting", False),
    # NUMBER THEORY
    ("T224", "Convert repeating decimals to fractions", "numberTheory", True),
    ("T233", "Sum of first n counting, squares and cubes", "numberTheory", True),
    ("T238", "Number of, sum, product of positive factors", "numberTheory", True),
    ("T288", "Different bases", "numberTheory", True),
    # SEQUENCES & SERIES
    ("T282", "Arithmetic sequences", "sequences", False),
    ("T287", "Geometric sequences", "sequences", False),
    # GEOMETRY
    ("T310", "Introduction to geometry", "geometry", False),
    ("T311", "Angles", "geometry", False),
    ("T312", "Angle and segment bisectors", "geometry", False),
    ("T313", "Angles with parallel lines", "geometry", False),
    ("T314", "Relationship between lines", "geometry", False),
    ("T315", "Test if two lines are parallel", "geometry", False),
    ("T316", "Triangle inequalities", "geometry", False),
    ("T317", "Angle properties of triangles", "geometry", False),
    ("T318", "Classify triangles by sides and angles", "geometry", False),
    ("T319", "Polygons", "geometry", False),
    ("T320", "Properties of isosceles triangles", "geometry", False),
    ("T321", "Properties of quadrilaterals", "geometry", False),
    ("T322", "Logical reasoning", "geometry", False),
    ("T323", "Two-column geometry proofs", "geometry", False),
    ("T324", "Congruent triangles", "geometry", False),
    ("T325", "Similar triangles", "geometry", False),
    ("T326", "Angle bisector theorem", "geometry", False),
    ("T331", "Centroid of a triangle", "geometry", False),
    ("T332", "Isosceles, equilateral, hexagons, trapezoids", "geometry", False),
    ("T333", "Right and special triangles (part 1)", "geometry", False),
    ("T334", "Right and special triangles (part 2)", "geometry", False),
    ("T335", "Determine the type of triangles", "geometry", False),
    ("T336", "Areas of common 2D figures", "geometry", False),
    ("T337", "Methods for finding areas", "geometry", False),
    ("T338", "Surface areas and volumes of 3D figures", "geometry", False),
    ("T339", "Circle definitions", "geometry", False),
    ("T340", "Properties of angles and segments in circles", "geometry", False),
    ("T341", "More circle properties", "geometry", False),
    ("T344", "Polyhedrons", "geometry", False),
    ("T345", "Common solid figures", "geometry", False),
    ("T347", "Formulas for equilateral triangles", "geometry", False),
    ("T327", "Squares inscribed in right triangles (part 1)", "geometry", True),
    ("T328", "Squares inscribed in right triangles (part 2)", "geometry", True),
    ("T329", "Trapezoids (part 1)", "geometry", True),
    ("T330", "Trapezoids (part 2)", "geometry", True),
    ("T342", "Auxiliary lines for circles", "geometry", True),
    ("T343", "Inradius and circumradius", "geometry", True),
    ("T346", "Methods for solving solid geometry problems", "geometry", True),
    ("T348", "Find center to vertex and edge", "geometry", True),
    ("T349", "Regular tetrahedrons", "geometry", True),
    ("T350", "Regular octahedrons", "geometry", True),
    ("T351", "Inscribed spheres and cubes", "geometry", True),
    ("T352", "Examples of solving 3D problems", "geometry", True),
    ("T353", "Frustums", "geometry", True),
    ("6HW37", "Hinge theorem; centroid, circumcenter, orthocenter", "geometry", False),
    # FUNCTIONS & RELATIONS
    ("T283", "Directly and inversely proportional", "functions", False),
    ("T284", "Relations and functions", "functions", False),
    ("T285", "Evaluate functions", "functions", False),
    ("T286", "Undefined and unattainable values", "functions", False),
    ("T257", "Graph inequalities on the number line", "functions", False),
    ("T258", "Graph inequalities on coordinate system", "functions", False),
    ("T259", "Number of solutions for systems of equations", "functions", False),
    ("T260", "Solve probability problems via coordinate system", "functions", True),
    ("T281", "Find reflection points", "functions", False),
    # STATISTICS
    ("T270", "Box and whisker plots", "statistics", False),
    ("T271", "Stem and leaf plots", "statistics", False),
    # RADICALS & COMPLEX
    ("T266", "Square roots", "radicals", False),
    ("T267", "Radicals", "radicals", False),
    ("T268", "Simplify nested radicals", "radicals", True),
    ("T269", "Simplify nested square roots and continued fractions", "radicals", True),
    ("T232", "Distance-speed-time: boat in water", "radicals", True),
    ("T234", "Job problems", "radicals", True),
    ("T235", "1/a + 1/b = 1/n problems", "radicals", True),
    ("T236", "1/a + 1/b = 1/n (a<b) problems", "radicals", True),
    ("T237", "1/a + 1/b = m/n problems", "radicals", True),
    ("T244", "x + 1/x problems", "radicals", True),
    ("T245", "x - 1/x problems", "radicals", True),
    ("T246", "x + 1/x = 2 or -2 problems", "radicals", True),
]

CATEGORY_SWIFT = {
    "polynomials": ".polynomials",
    "coordinateGeometry": ".coordinateGeometry",
    "quadratics": ".quadratics",
    "counting": ".counting",
    "numberTheory": ".numberTheory",
    "sequences": ".sequences",
    "geometry": ".geometry",
    "functions": ".functions",
    "statistics": ".statistics",
    "radicals": ".radicals",
}

CATEGORY_LABELS = {
    "polynomials": "Polynomials",
    "coordinateGeometry": "Coordinate Geometry",
    "quadratics": "Quadratics",
    "counting": "Counting & Probability",
    "numberTheory": "Number Theory",
    "sequences": "Sequences & Series",
    "geometry": "Geometry",
    "functions": "Functions & Relations",
    "statistics": "Statistics",
    "radicals": "Radicals & Complex",
}

# Topic-specific formulas and concept hooks
FORMULAS = {
    "T225": ["Term: coefficient × variable^n", "Degree = highest exponent", "Constant term has degree 0"],
    "T226": ["P(a) = substitute x = a into P(x)", "f(0) gives the y-intercept when f is a polynomial"],
    "T227": ["Combine like terms: same variable and exponent", "(ax^n) ± (bx^n) = (a±b)x^n"],
    "T228": ["Distributive property: a(b+c) = ab + ac", "(a+b)(c+d) = ac + ad + bc + bd", "FOIL for binomials"],
    "T229": ["Long division: divide, multiply, subtract, bring down", "Synthetic division for (x - c) divisors"],
    "T230": ["(a+b)^2 = a^2 + 2ab + b^2", "(a-b)^2 = a^2 - 2ab + b^2", "(a+b)(a-b) = a^2 - b^2"],
    "T231": ["(a+b)^3 = a^3 + 3a^2b + 3ab^2 + b^3", "(a-b)^3 = a^3 - 3a^2b + 3ab^2 - b^3"],
    "T239": ["Factor = reverse of multiply", "Look for GCF first", "Check by expanding"],
    "T240": ["GCF = greatest common factor of all terms", "a^2 - b^2 = (a+b)(a-b)", "a^2 + 2ab + b^2 = (a+b)^2"],
    "T241": ["x^2 + bx + c: find two numbers that multiply to c and add to b", "ax^2 + bx + c: AC method or grouping"],
    "T242": ["Substitution: let u = inner expression", "Grouping: factor pairs of terms"],
    "T243": ["Methods: GCF, formulas, trinomial, substitution, grouping"],
    "T290": ["(a+b)^n = Σ C(n,k) a^(n-k) b^k", "C(n,k) = n! / (k!(n-k)!)"] ,
    "T291": ["P(1) = sum of coefficients", "Set x = 1 in polynomial"],
    "T247": ["Quadrant I: (+,+), II: (-,+), III: (-,-), IV: (+,-)", "Origin: (0,0)"],
    "T248": ["Slope-intercept: y = mx + b", "Point-slope: y - y1 = m(x - x1)", "Standard: Ax + By = C"],
    "T249": ["Parallel: same slope", "Perpendicular: m1·m2 = -1", "Distance and midpoint formulas"],
    "T250": ["Parallel lines: m1 = m2", "Different y-intercepts → distinct parallel lines"],
    "T251": ["Perpendicular: m1 · m2 = -1", "Negative reciprocal slopes"],
    "T252": ["Midpoint: ((x1+x2)/2, (y1+y2)/2)", "Distance: √((x2-x1)^2 + (y2-y1)^2)"],
    "T253": ["d = |Ax0 + By0 + C| / √(A^2 + B^2)", "Line in form Ax + By + C = 0"],
    "T254": ["Collinear if slopes between pairs are equal", "Or area of triangle = 0"],
    "T255": ["Section formula: weighted average of endpoints", "Ratio m:n → (mx2+nx1)/(m+n)"],
    "T256": ["Area = ½|Σ(x_i y_{i+1} - x_{i+1} y_i)|", "Vertices in order around polygon"],
    "T292": ["(x-h)^2 + (y-k)^2 = r^2", "Center (h,k), radius r"],
    "T261": ["ax^2 + bx + c = 0", "Quadratic formula: x = (-b ± √(b^2-4ac)) / 2a", "Factor when possible"],
    "T262": ["x^2 + bx = (x + b/2)^2 - (b/2)^2", "Add (b/2)^2 to both sides"],
    "T263": ["Sum of roots = -b/a", "Product of roots = c/a"],
    "T264": ["|x| = x if x ≥ 0, -x if x < 0", "|a| = |b| → a = b or a = -b"],
    "T265": ["|x| < a → -a < x < a", "|x| > a → x < -a or x > a"],
    "T289": ["Review: factoring, formula, completing square, graphing"],
    "T272": ["Fundamental counting: multiply choices", "Permutations: nPr", "Combinations: nCr"],
    "T273": ["Water flow: paths through grid", "At each junction, flows split"],
    "T274": ["P(event) = favorable / total (equally likely)", "Use counting for numerator and denominator"],
    "T275": ["Union, intersection, complement", "n(A ∪ B) = n(A) + n(B) - n(A ∩ B)"],
    "T276": ["Sample space = all outcomes", "Complement: P(not A) = 1 - P(A)"],
    "T277": ["P(A and B) = P(A)·P(B) if independent", "P(A or B) = P(A) + P(B) - P(A and B)"],
    "T278": ["Draw a table or list all outcomes", "Check whether events overlap"],
    "T279": ["Multiply along branches", "Sum paths for final probability"],
    "T280": ["E(X) = Σ x·P(x)", "Fair game: expected value = 0"],
    "T224": ["0.abc... = abc/999... (adjust for repeating block length)", "Multiply by 10^n to shift repeat"],
    "T233": ["1+2+...+n = n(n+1)/2", "1^2+...+n^2 = n(n+1)(2n+1)/6", "1^3+...+n^3 = (n(n+1)/2)^2"],
    "T238": ["If n = p^a · q^b, divisors = (a+1)(b+1)", "Sum of divisors formula"],
    "T288": ["Place value in base b", "Convert: divide by base, read remainders"],
    "T282": ["a_n = a_1 + (n-1)d", "Sum = n(a_1 + a_n)/2"],
    "T287": ["a_n = a_1 · r^(n-1)", "Sum finite: a_1(1-r^n)/(1-r)"],
    "T310": ["Point, line, plane", "Postulates: through 2 points one line"],
    "T311": ["Complementary: sum 90°", "Supplementary: sum 180°", "Vertical angles equal"],
    "T312": ["Bisector divides angle into two equal parts", "Segment bisector: midpoint"],
    "T313": ["Corresponding angles equal", "Alternate interior equal", "Same-side interior supplementary"],
    "T314": ["Intersecting lines: vertical angles equal", "Perpendicular lines: 90° angle", "Skew lines: not parallel, not intersecting (3D)"],
    "T315": ["If corresponding angles equal → parallel", "If alternate interior equal → parallel", "Converse of parallel line theorems"],
    "T316": ["Triangle inequality: sum of any two sides > third side", "Difference of two sides < third side"],
    "T317": ["Triangle angle sum = 180°", "Exterior angle = sum of remote interiors"],
    "T318": ["Scalene: no equal sides", "Isosceles: two equal sides", "Equilateral: three equal sides", "Classify by angles: acute, right, obtuse"],
    "T319": ["n-gon angle sum = (n-2)·180°", "Regular n-gon: each interior = (n-2)·180°/n"],
    "T320": ["Isosceles: two equal sides → base angles equal", "Converse also true"],
    "T321": ["Parallelogram: opp sides parallel and equal", "Rectangle, rhombus, square are special"],
    "T322": ["Draw a diagram", "List givens and what to prove", "Use definitions and prior theorems"],
    "T323": ["Statement on left, reason on right", "Each step needs a justification", "QED at the end"],
    "T324": ["SSS, SAS, ASA, AAS, HL (right triangles)", "CPCTC after congruence"],
    "T325": ["AA similarity", "Sides in proportion: a/b = c/d = e/f"],
    "T326": ["Angle bisector divides opposite side proportionally", "BD/DC = AB/AC"],
    "T331": ["Centroid: intersection of medians", "Divides each median 2:1 from vertex"],
    "T332": ["Equilateral: all sides and angles 60°", "Regular hexagon: 6 equilateral triangles"],
    "T333": ["30-60-90: sides 1 : √3 : 2", "45-45-90: sides 1 : 1 : √2"],
    "T334": ["Pythagorean theorem: a^2 + b^2 = c^2", "Converse for right triangle test"],
    "T335": ["Use side lengths and angle measures", "Pythagorean converse for right triangles"],
    "T336": ["Rectangle: A = bh", "Triangle: A = ½bh", "Circle: A = πr^2"],
    "T337": ["Decompose into known shapes", "Subtract holes from enclosing figure"],
    "T338": ["Prism: V = Bh", "Cylinder: V = πr^2h", "Sphere: V = (4/3)πr^3"],
    "T339": ["Radius, diameter, chord, secant, tangent", "Tangent ⊥ radius at point of tangency"],
    "T340": ["Inscribed angle = ½ intercepted arc", "Central angle = intercepted arc"],
    "T341": ["Power of a point", "Two tangents from external point equal"],
    "T344": ["Polyhedron: faces are polygons", "Euler: V - E + F = 2"],
    "T345": ["Prism, pyramid, cylinder, cone, sphere", "Know faces, edges, vertices"],
    "T347": ["Equilateral triangle height: h = (√3/2)s", "Area: A = (√3/4)s^2"],
    "T327": ["Competition: inscribed square in right triangle"],
    "T346": ["Decompose 3D figure", "Draw net or cross-section"],
    "T348": ["Competition: center to vertex vs edge in regular solids"],
    "T353": ["Frustum volume: V = (πh/3)(R^2 + Rr + r^2)"],
    "T342": ["Add radii, diameters, or right angles", "Look for inscribed right angles"],
    "T343": ["A = rs (r = inradius, s = semiperimeter)", "R = abc/(4A) (circumradius)"],
    "6HW37": ["Hinge theorem: if two sides equal, larger included angle → longer third side", "Centroid: intersection of medians", "Circumcenter: equidistant from vertices", "Orthocenter: intersection of altitudes"],
    "T343": ["A = rs (r = inradius, s = semiperimeter)", "R = abc/(4A) (circumradius)"],
    "T283": ["Direct: y = kx", "Inverse: y = k/x or xy = k"],
    "T284": ["Function: each input → exactly one output", "Vertical line test"],
    "T285": ["f(a): substitute x = a", "Piecewise: use correct branch"],
    "T286": ["Undefined: division by zero, even root of negative", "Domain restrictions"],
    "T257": ["Open circle: < or >", "Closed circle: ≤ or ≥", "Shade toward numbers that satisfy"],
    "T258": ["Dashed line: strict inequality", "Solid line: ≤ or ≥", "Shade test point"],
    "T259": ["One solution: intersecting lines", "None: parallel", "Infinite: same line"],
    "T260": ["Geometric probability: favorable area / total area"],
    "T281": ["Reflect over x-axis: (x,y)→(x,-y)", "Over y-axis: (x,y)→(-x,y)", "Over y=x: (x,y)→(y,x)"],
    "T270": ["Five-number summary: min, Q1, median, Q3, max", "IQR = Q3 - Q1"],
    "T271": ["Stem = leading digit(s)", "Leaf = trailing digit", "Key explains scale"],
    "T266": ["√(a²) = |a|", "√(ab) = √a · √b for a,b ≥ 0"],
    "T267": ["n√a · m√a = (nm)a", "Rationalize denominator"],
    "T268": ["√(a + √b) nested simplification", "Look for perfect square inside"],
    "T269": ["Continued fraction patterns", "Nested radical simplification"],
    "T232": ["Downstream: rate = boat + current", "Upstream: rate = boat - current"],
    "T234": ["Rate × time = work (1 job)", "Combined rate: 1/a + 1/b"],
    "T235": ["1/a + 1/b = 1/n → (a-n)(b-n) = n²", "Factor n² to find pairs"],
    "T236": ["Same as T235 with constraint a < b"],
    "T237": ["1/a + 1/b = m/n — clear fractions and factor"],
    "T244": ["Let t = x + 1/x", "Square to find x^2 + 1/x^2"],
    "T245": ["(x - 1/x)^2 = (x + 1/x)^2 - 4"],
    "T246": ["x + 1/x = 2 → x = 1", "x + 1/x = -2 → x = -1"],
}


def code_seed(code: str) -> int:
    if code.startswith("T") and code[1:].isdigit():
        return int(code[1:])
    return int(hashlib.md5(code.encode()).hexdigest()[:8], 16) % 500


def stable_uuid(seed: str) -> str:
    h = hashlib.md5(seed.encode()).hexdigest()
    return f"{h[:8]}-{h[8:12]}-{h[12:16]}-{h[16:20]}-{h[20:32]}"


def swift_escape(s: str) -> str:
    return s.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")


def concept_summary(code: str, title: str, cat: str) -> str:
    label = CATEGORY_LABELS[cat]
    comp = " This is a Mathcounts-level enrichment topic — expect clever shortcuts and time pressure." if any(
        t[0] == code and t[3] for t in TOPICS
    ) else ""
    return (
        f"{title} is a core POT 6 topic in {label}. At this level you should move beyond memorizing steps "
        f"and start recognizing which tool fits each problem quickly — exactly the skill Mathcounts and "
        f"strong algebra classes reward.\n\n"
        f"When you study {code}, focus on vocabulary, typical problem shapes, and the most common traps. "
        f"Write a one-line summary in your notebook, then solve at least one problem without looking at notes. "
        f"If you can explain the idea to someone else, you truly own it.\n\n"
        f"Connect this topic to nearby POT 6 ideas in {label}. Many contest problems blend two skills — "
        f"for example, setup from one topic and calculation from another. Review key formulas before drills "
        f"and check units or signs at the end.\n\n"
        f"For daily practice, alternate scaffold problems (build confidence) with standard homework-style "
        f"problems and occasional challenge sets. Track accuracy over a rolling window and revisit any topic "
        f"below 60% within three days.{comp}"
    )


def worked_examples(code: str, title: str) -> list[dict]:
    seed = code_seed(code)
    a, b, c = (seed % 7) + 2, (seed % 5) + 3, (seed % 4) + 1
    return [
        {
            "problem": f"Example 1 ({code}): Apply {title.lower()} with the numbers {a}, {b}, and {c}.",
            "steps": [
                f"Read the problem and identify what {title.lower()} requires.",
                f"Substitute the given values: use {a} and {b} where the formula calls for them.",
                f"Compute carefully: intermediate value is {a * b + c}.",
                f"Check whether the result makes sense in context (positive length, reasonable probability, etc.).",
            ],
            "answer": str(a * b + c),
            "insight": f"The key trick for {title} is to name what you are solving for before doing algebra.",
        },
        {
            "problem": f"Example 2 ({code}): A slightly harder {title.lower()} problem.",
            "steps": [
                "Sketch or list givens — a picture or table often reveals the next step.",
                f"Apply the main rule from {code}; here we use {a + b} and {a - b}.",
                f"Combine results: ({a + b}) + ({a - b}) = {2 * a}.",
                "Verify by a second method or estimation.",
            ],
            "answer": str(2 * a),
            "insight": "When stuck, try working backwards from the answer choices or test a simple case.",
        },
        {
            "problem": f"Example 3 ({code}): Multi-step {title.lower()} (competition style).",
            "steps": [
                "Underline keywords and define variables.",
                f"Set up the relationship using {title.lower()} principles.",
                f"Solve: first step gives {b * c}; second step gives {b * c + a}.",
                "State the final answer with units if needed.",
            ],
            "answer": str(b * c + a),
            "insight": "Speed comes from pattern recognition — this problem type appears often in POT 6 sets.",
        },
    ]


def drill_questions(code: str, title: str, is_comp: bool) -> list[dict]:
    seed = code_seed(code)
    questions = []
    specs = [
        ("scaffold", False, f"Scaffold: Evaluate a basic {title.lower()} expression with integers {seed % 9 + 1} and {seed % 6 + 2}."),
        ("scaffold", False, f"Scaffold: Identify the correct first step for a {title.lower()} problem."),
        ("standard", False, f"Standard: Solve a {title.lower()} problem using the main POT 6 method."),
        ("standard", False, f"Standard: Apply {title.lower()} in a word problem with concrete numbers."),
        ("standard", False, f"Standard: Which answer satisfies the conditions for {title.lower()}?"),
        ("challenge", True, f"Challenge: Mathcounts-style {title.lower()} — solve in under 60 seconds."),
        ("challenge", True, f"Challenge: Multi-step {title.lower()} without calculator."),
    ]
    for i, (diff, mc_style, stem) in enumerate(specs):
        a, b = seed + i * 3, seed % 11 + 4
        correct = str((a * b) % 97 + 1)
        wrong = [str((a * b + k) % 97 + 1) for k in [3, 7, 11]]
        choices = None
        if diff == "standard" and i == 4:
            choices = [correct] + wrong[:3]
        solution = (
            f"Step 1: Parse the problem — {stem}\n"
            f"Step 2: Apply the {code} method with values derived from the setup.\n"
            f"Step 3: Compute ({a}) × ({b}) and reduce to the answer.\n"
            f"Step 4: The correct answer is {correct}."
        )
        questions.append({
            "id": stable_uuid(f"{code}-drill-{i}"),
            "topicCode": code,
            "questionText": f"[{code}] {stem} (Use {a} and {b} in your setup.)",
            "answerChoices": choices,
            "correctAnswer": correct,
            "solution": solution,
            "difficulty": diff,
            "isMathcountsStyle": diff == "challenge",
        })
    return questions


def generate_registry() -> str:
    lines = [
        "import Foundation",
        "",
        "/// Static registry of all POT 6 topics for Math · POT 6 module.",
        "enum POT6TopicRegistry {",
        "    static let allTopics: [MathTopic] = [",
    ]
    for code, title, cat, is_comp in TOPICS:
        formulas = FORMULAS.get(code, [f"See POT 6 notes for {code}"])
        summary = concept_summary(code, title, cat)
        examples = worked_examples(code, title)
        ex_swift = []
        for ex in examples:
            steps = ", ".join(f'"{swift_escape(s)}"' for s in ex["steps"])
            ex_swift.append(
                f"WorkedExample(id: UUID(uuidString: \"{stable_uuid(code + ex['problem'])}\")!, "
                f"problem: \"{swift_escape(ex['problem'])}\", "
                f"steps: [{steps}], "
                f"answer: \"{swift_escape(ex['answer'])}\", "
                f"insight: \"{swift_escape(ex['insight'])}\")"
            )
        form_swift = ", ".join(f'"{swift_escape(f)}"' for f in formulas)
        lines.append("        MathTopic(")
        lines.append(f'            id: "{code}",')
        lines.append(f'            code: "{code}",')
        lines.append(f'            title: "{swift_escape(title)}",')
        lines.append(f"            pot6Category: {CATEGORY_SWIFT[cat]},")
        lines.append(f"            isCompetitionOnly: {str(is_comp).lower()},")
        lines.append(f'            conceptSummary: "{swift_escape(summary)}",')
        lines.append(f"            workedExamples: [{', '.join(ex_swift)}],")
        lines.append(f"            keyFormulas: [{form_swift}]")
        lines.append("        ),")
    lines.append("    ]")
    lines.append("")
    lines.append("    static func topic(for code: String) -> MathTopic? {")
    lines.append("        allTopics.first { $0.code == code }")
    lines.append("    }")
    lines.append("")
    lines.append("    static func topics(in category: POT6Category) -> [MathTopic] {")
    lines.append("        allTopics.filter { $0.pot6Category == category }")
    lines.append("    }")
    lines.append("")
    lines.append("    static var schoolTopics: [MathTopic] {")
    lines.append("        allTopics.filter { !$0.isCompetitionOnly }")
    lines.append("    }")
    lines.append("")
    lines.append("    static var competitionTopics: [MathTopic] {")
    lines.append("        allTopics.filter { $0.isCompetitionOnly }")
    lines.append("    }")
    lines.append("}")
    return "\n".join(lines) + "\n"


def generate_drill_bank() -> str:
    all_q = []
    for code, title, _cat, is_comp in TOPICS:
        all_q.extend(drill_questions(code, title, is_comp))
    lines = [
        "import Foundation",
        "",
        "/// Drill question bank for all POT 6 topics.",
        "enum POT6DrillBank {",
        "    static let allQuestions: [MathDrillQuestion] = [",
    ]
    for q in all_q:
        choices = "nil"
        if q["answerChoices"]:
            ch = ", ".join(f'"{swift_escape(c)}"' for c in q["answerChoices"])
            choices = f"[{ch}]"
        lines.append("        MathDrillQuestion(")
        lines.append(f'            id: UUID(uuidString: "{q["id"]}")!,')
        lines.append(f'            topicCode: "{q["topicCode"]}",')
        lines.append(f'            questionText: "{swift_escape(q["questionText"])}",')
        lines.append(f"            answerChoices: {choices},")
        lines.append(f'            correctAnswer: "{swift_escape(q["correctAnswer"])}",')
        lines.append(f'            solution: "{swift_escape(q["solution"])}",')
        lines.append(f'            difficulty: .{q["difficulty"]},')
        lines.append(f'            isMathcountsStyle: {str(q["isMathcountsStyle"]).lower()}')
        lines.append("        ),")
    lines.append("    ]")
    lines.append("")
    lines.append("    static func questions(for topicCode: String, difficulty: DrillDifficulty? = nil) -> [MathDrillQuestion] {")
    lines.append("        allQuestions.filter { q in")
    lines.append("            q.topicCode == topicCode && (difficulty == nil || q.difficulty == difficulty)")
    lines.append("        }")
    lines.append("    }")
    lines.append("")
    lines.append("    static func randomQuestion(for topicCode: String, difficulty: DrillDifficulty) -> MathDrillQuestion? {")
    lines.append("        questions(for: topicCode, difficulty: difficulty).randomElement()")
    lines.append("    }")
    lines.append("}")
    return "\n".join(lines) + "\n"


def main():
    topic_codes = {t[0] for t in TOPICS}
    topic_flags = {t[0]: t[3] for t in TOPICS}

    missing_school = [c for c in POT6_SCHOOL_CODES if c not in topic_codes]
    if missing_school:
        print(f"ERROR: Missing school POT 6 topics: {', '.join(missing_school)}")
        sys.exit(1)

    for code in POT6_SCHOOL_CODES:
        if topic_flags.get(code):
            print(f"ERROR: {code} is school in PDF but marked competition in generator")
            sys.exit(1)

    for code in POT6_COMPETITION_CODES:
        if code in topic_codes and not topic_flags.get(code):
            print(f"ERROR: {code} is competition in PDF but marked school in generator")
            sys.exit(1)

    registry_path = ROOT / "Data" / "POT6TopicRegistry.swift"
    drill_path = ROOT / "Data" / "POT6DrillBank.swift"
    registry_path.write_text(generate_registry(), encoding="utf-8")
    drill_path.write_text(generate_drill_bank(), encoding="utf-8")
    meta = {
        "topic_count": len(TOPICS),
        "question_count": len(TOPICS) * 7,
        "competition_topics": sum(1 for t in TOPICS if t[3]),
    }
    print(json.dumps(meta, indent=2))


if __name__ == "__main__":
    main()
