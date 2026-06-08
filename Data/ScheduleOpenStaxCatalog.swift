import Foundation

/// OpenStax reading links for schedule blocks (biology primary; math TBD).
enum ScheduleOpenStaxCatalog {
    static let biologyBookHome = URL(string: "https://openstax.org/books/concepts-biology/pages/1-introduction")!

    struct BiologyReading: Hashable {
        let chapters: [Int]
        let title: String
        let backup: String
        let urls: [URL]
    }

    private static let chapterURLs: [Int: URL] = [
        1: URL(string: "https://openstax.org/books/concepts-biology/pages/1-introduction")!,
        2: URL(string: "https://openstax.org/books/concepts-biology/pages/2-introduction")!,
        3: URL(string: "https://openstax.org/books/concepts-biology/pages/3-introduction")!,
        4: URL(string: "https://openstax.org/books/concepts-biology/pages/4-introduction")!,
        5: URL(string: "https://openstax.org/books/concepts-biology/pages/5-introduction")!,
        7: URL(string: "https://openstax.org/books/concepts-biology/pages/7-introduction")!,
        8: URL(string: "https://openstax.org/books/concepts-biology/pages/8-introduction")!,
        11: URL(string: "https://openstax.org/books/concepts-biology/pages/11-introduction")!,
        12: URL(string: "https://openstax.org/books/concepts-biology/pages/12-introduction")!,
        13: URL(string: "https://openstax.org/books/concepts-biology/pages/13-introduction")!,
        14: URL(string: "https://openstax.org/books/concepts-biology/pages/14-introduction")!,
        15: URL(string: "https://openstax.org/books/concepts-biology/pages/15-introduction")!,
        16: URL(string: "https://openstax.org/books/concepts-biology/pages/16-introduction")!,
        17: URL(string: "https://openstax.org/books/concepts-biology/pages/17-introduction")!,
        19: URL(string: "https://openstax.org/books/concepts-biology/pages/19-introduction")!,
        20: URL(string: "https://openstax.org/books/concepts-biology/pages/20-introduction")!,
    ]

    private static let biologyByKey: [String: BiologyReading] = [
        "FLS Ch 1": BiologyReading(
            chapters: [3],
            title: "Cells",
            backup: "FLS Ch 1 · CB Ch 4",
            urls: [chapterURLs[3]!]
        ),
        "FLS Ch 2": BiologyReading(
            chapters: [1, 16],
            title: "Cell to organism",
            backup: "FLS Ch 2 · CB Ch 6–7",
            urls: [chapterURLs[1]!, chapterURLs[16]!]
        ),
        "FLS Ch 4": BiologyReading(
            chapters: [7, 8],
            title: "Genetics",
            backup: "FLS Ch 4 · CB Ch 9",
            urls: [chapterURLs[7]!, chapterURLs[8]!]
        ),
        "FLS Ch 9–10": BiologyReading(
            chapters: [16],
            title: "Body systems",
            backup: "FLS Ch 9–10 · CB Ch 21–23",
            urls: [chapterURLs[16]!]
        ),
        "FLS Ch 2 + CB Ch 37 skim": BiologyReading(
            chapters: [19, 20],
            title: "Ecology",
            backup: "FLS Ch 2 · CB Ch 36–37",
            urls: [chapterURLs[19]!, chapterURLs[20]!]
        ),
        "CB Ch 16 + Ch 24": BiologyReading(
            chapters: [13, 17],
            title: "Microbes · immunity",
            backup: "FLS · CB Ch 16 · 24",
            urls: [chapterURLs[13]!, chapterURLs[17]!]
        ),
        "FLS Ch 5–6": BiologyReading(
            chapters: [11, 12],
            title: "Evolution",
            backup: "FLS Ch 5–6 · CB Ch 13–14",
            urls: [chapterURLs[11]!, chapterURLs[12]!]
        ),
        "FLS Ch 2 + CB Ch 31 skim": BiologyReading(
            chapters: [14, 15],
            title: "Plants · animals",
            backup: "FLS Ch 2 · CB Ch 31 · 20",
            urls: [chapterURLs[14]!, chapterURLs[15]!]
        ),
        "CB Ch 4": BiologyReading(
            chapters: [3],
            title: "A Tour of the Cell",
            backup: "FLS Ch 1 · CB Ch 4",
            urls: [chapterURLs[3]!]
        ),
        "CB Ch 6–7": BiologyReading(
            chapters: [4, 5],
            title: "Energy · photosynthesis",
            backup: "FLS · CB Ch 6–7",
            urls: [chapterURLs[4]!, chapterURLs[5]!]
        ),
        "CB Ch 9": BiologyReading(
            chapters: [8],
            title: "Inheritance",
            backup: "FLS Ch 4 · CB Ch 9",
            urls: [chapterURLs[8]!]
        ),
        "CB Ch 21–23": BiologyReading(
            chapters: [16],
            title: "Body systems",
            backup: "FLS Ch 9–10 · CB Ch 21–23",
            urls: [chapterURLs[16]!]
        ),
        "CB Ch 36–37": BiologyReading(
            chapters: [19, 20],
            title: "Ecology",
            backup: "FLS Ch 2 · CB Ch 36–37",
            urls: [chapterURLs[19]!, chapterURLs[20]!]
        ),
        "CB Ch 13–14": BiologyReading(
            chapters: [11, 12],
            title: "Speciation",
            backup: "FLS Ch 5–6 · CB Ch 13–14",
            urls: [chapterURLs[11]!, chapterURLs[12]!]
        ),
        "CB Ch 31 + Ch 20": BiologyReading(
            chapters: [14, 15],
            title: "Plants · animals",
            backup: "CB Ch 31 · 20 · FLS Ch 2",
            urls: [chapterURLs[14]!, chapterURLs[15]!]
        ),
        "CB Ch 4 · FLS Ch 1": BiologyReading(
            chapters: [3],
            title: "Cell review",
            backup: "FLS Ch 1 · CB Ch 4",
            urls: [chapterURLs[3]!]
        ),
        "CB Ch 6–7 · FLS Ch 2": BiologyReading(
            chapters: [4, 5],
            title: "Energy · organization",
            backup: "FLS · CB Ch 6–7",
            urls: [chapterURLs[4]!, chapterURLs[5]!]
        ),
        "CB Ch 36–37 · FLS Ch 2": BiologyReading(
            chapters: [19, 20],
            title: "Ecology review",
            backup: "FLS Ch 2 · CB Ch 36–37",
            urls: [chapterURLs[19]!, chapterURLs[20]!]
        ),
        "CB Ch 16 · 24 · FLS Ch 4": BiologyReading(
            chapters: [8, 13, 17],
            title: "Genetics · microbes · immunity",
            backup: "FLS Ch 4 · CB Ch 16 · 24",
            urls: [chapterURLs[8]!, chapterURLs[13]!, chapterURLs[17]!]
        ),
    ]

    /// Biology reading for a science block (primary OpenStax + backup line).
    static func biologyReading(for block: StudyBlock) -> BiologyReading? {
        guard block.subject == .biology else { return nil }
        if block.bookCode == "OSB" {
            let nums = block.chapter
                .replacingOccurrences(of: "Ch ", with: "")
                .split(separator: "+")
                .compactMap { Int($0.trimmingCharacters(in: .whitespaces).components(separatedBy: "–").first ?? "") }
            if !nums.isEmpty, let first = nums.first {
                let urls = nums.compactMap { chapterURLs[$0] }
                return BiologyReading(
                    chapters: nums,
                    title: block.chapterTitle,
                    backup: block.backupBookLine ?? "",
                    urls: urls
                )
            }
        }
        return biologyByKey.values.first { $0.title == block.chapterTitle }
    }


    static let mathBookHome = URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/1-introduction-to-prerequisites")!

    struct MathReading: Hashable {
        let title: String
        let sectionKeys: [String]
        let backup: String
        let urls: [URL]
    }

    private static let sectionURLs: [String: URL] = [
        "1.1": URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/1-1-real-numbers-algebra-essentials")!,
        "1.2": URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/1-2-exponents-and-scientific-notation")!,
        "1.3": URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/1-3-radicals-and-rational-exponents")!,
        "2.1": URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/2-1-the-rectangular-coordinate-systems-and-graphs")!,
        "2.3": URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/2-3-models-and-applications")!,
        "3.3": URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/3-3-rates-of-change-and-behavior-of-graphs")!,
        "4.1": URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/4-1-linear-functions")!,
        "5.8": URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/5-8-modeling-using-variation")!,
        "6.1": URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/6-1-exponential-functions")!,
        "13.7": URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/13-7-probability")!,
        "home": URL(string: "https://openstax.org/books/algebra-and-trigonometry-2e/pages/1-introduction-to-prerequisites")!
    ]

    private static let mathByWeekDay: [Int: [Weekday: MathReading]] = [
        1: [
            .monday: MathReading(
                title: "Scientific notation",
                sectionKeys: ["1.1", "1.2"],
                backup: "Lar Ch 1 · BFN-A U4",
                urls: [sectionURLs["1.1"]!, sectionURLs["1.2"]!]
            ),
            .tuesday: MathReading(
                title: "Ratios",
                sectionKeys: ["5.8"],
                backup: "Lar Ch 2 · BFN-A U3",
                urls: [sectionURLs["5.8"]!]
            ),
            .wednesday: MathReading(
                title: "Graphs & slope",
                sectionKeys: ["2.1", "4.1", "3.3"],
                backup: "Lar Ch 4 · BFN-A U6",
                urls: [sectionURLs["2.1"]!, sectionURLs["4.1"]!, sectionURLs["3.3"]!]
            ),
            .thursday: MathReading(
                title: "Unit conversion",
                sectionKeys: ["1.1", "1.2"],
                backup: "Lar Ch 1–2 · BFN-A U2",
                urls: [sectionURLs["1.1"]!, sectionURLs["1.2"]!]
            ),
            .friday: MathReading(
                title: "PEMDAS & estimation",
                sectionKeys: ["1.1"],
                backup: "Lar Ch 2 · BFN-A U1",
                urls: [sectionURLs["1.1"]!]
            ),
        ],
        2: [
            .monday: MathReading(
                title: "Percent",
                sectionKeys: ["1.1"],
                backup: "Lar Ch 2 · BFN-A U3",
                urls: [sectionURLs["1.1"]!]
            ),
            .tuesday: MathReading(
                title: "Proportions",
                sectionKeys: ["5.8"],
                backup: "Lar Ch 3 · BFN-A U3",
                urls: [sectionURLs["5.8"]!]
            ),
            .wednesday: MathReading(
                title: "F = ma",
                sectionKeys: ["2.3"],
                backup: "Lar Ch 3 · BFN-A U5",
                urls: [sectionURLs["2.3"]!]
            ),
            .thursday: MathReading(
                title: "Exponents",
                sectionKeys: ["1.2", "6.1"],
                backup: "Lar Ch 8 · BFN-A U4",
                urls: [sectionURLs["1.2"]!, sectionURLs["6.1"]!]
            ),
            .friday: MathReading(
                title: "Body-scale ratios",
                sectionKeys: ["5.8"],
                backup: "Lar Ch 3 · BFN-A U3",
                urls: [sectionURLs["5.8"]!]
            ),
        ],
        3: [
            .monday: MathReading(
                title: "Formula substitution",
                sectionKeys: ["2.3"],
                backup: "Lar Ch 3 · BFN-A U5",
                urls: [sectionURLs["2.3"]!]
            ),
            .tuesday: MathReading(
                title: "Graph reading",
                sectionKeys: ["2.1", "3.3"],
                backup: "Lar Ch 4 · BFN-A U6",
                urls: [sectionURLs["2.1"]!, sectionURLs["3.3"]!]
            ),
            .wednesday: MathReading(
                title: "W = Fd",
                sectionKeys: ["2.3"],
                backup: "Lar Ch 3 · BFN-A U5",
                urls: [sectionURLs["2.3"]!]
            ),
            .thursday: MathReading(
                title: "Concentration ratios",
                sectionKeys: ["5.8"],
                backup: "Lar Ch 2 · BFN-A U3",
                urls: [sectionURLs["5.8"]!]
            ),
            .friday: MathReading(
                title: "Mixed review",
                sectionKeys: ["1.2", "5.8", "2.3"],
                backup: "Lar Ch 1–4 · BFN-A",
                urls: [sectionURLs["1.2"]!, sectionURLs["5.8"]!, sectionURLs["2.3"]!]
            ),
        ],
        4: [
            .monday: MathReading(
                title: "Number review",
                sectionKeys: ["1.1"],
                backup: "Lar Ch 2 · BFN-A U2",
                urls: [sectionURLs["1.1"]!]
            ),
            .tuesday: MathReading(
                title: "Logic & probability",
                sectionKeys: ["13.7"],
                backup: "Lar Ch 13 · BFN-A U7",
                urls: [sectionURLs["13.7"]!]
            ),
            .wednesday: MathReading(
                title: "v = fλ",
                sectionKeys: ["2.3", "1.3"],
                backup: "Lar Ch 3 + Ch 11 · BFN-A U11",
                urls: [sectionURLs["2.3"]!, sectionURLs["1.3"]!]
            ),
            .thursday: MathReading(
                title: "Unit conversion review",
                sectionKeys: ["1.1", "1.2"],
                backup: "Lar Ch 1–2 · BFN-A U2",
                urls: [sectionURLs["1.1"]!, sectionURLs["1.2"]!]
            ),
            .friday: MathReading(
                title: "Formula plug-in",
                sectionKeys: ["2.3"],
                backup: "Lar Ch 3 · BFN-A U5",
                urls: [sectionURLs["2.3"]!]
            ),
        ],
        5: [
            .monday: MathReading(
                title: "Scientific notation",
                sectionKeys: ["1.1", "1.2"],
                backup: "Lar Ch 1 · BFN-A U4",
                urls: [sectionURLs["1.1"]!, sectionURLs["1.2"]!]
            ),
            .tuesday: MathReading(
                title: "Ratios",
                sectionKeys: ["5.8"],
                backup: "Lar Ch 2 · BFN-A U3",
                urls: [sectionURLs["5.8"]!]
            ),
            .wednesday: MathReading(
                title: "Graphs & slope",
                sectionKeys: ["2.1", "4.1", "3.3"],
                backup: "Lar Ch 4 · BFN-A U6",
                urls: [sectionURLs["2.1"]!, sectionURLs["4.1"]!, sectionURLs["3.3"]!]
            ),
            .thursday: MathReading(
                title: "Unit conversion",
                sectionKeys: ["1.1", "1.2"],
                backup: "Lar Ch 1–2 · BFN-A U2",
                urls: [sectionURLs["1.1"]!, sectionURLs["1.2"]!]
            ),
            .friday: MathReading(
                title: "PEMDAS & estimation",
                sectionKeys: ["1.1"],
                backup: "Lar Ch 2 · BFN-A U1",
                urls: [sectionURLs["1.1"]!]
            ),
        ],
        6: [
            .monday: MathReading(
                title: "Percent",
                sectionKeys: ["1.1"],
                backup: "Lar Ch 2 · BFN-A U3",
                urls: [sectionURLs["1.1"]!]
            ),
            .tuesday: MathReading(
                title: "Proportions",
                sectionKeys: ["5.8"],
                backup: "Lar Ch 3 · BFN-A U3",
                urls: [sectionURLs["5.8"]!]
            ),
            .wednesday: MathReading(
                title: "F = ma",
                sectionKeys: ["2.3"],
                backup: "Lar Ch 3 · BFN-A U5",
                urls: [sectionURLs["2.3"]!]
            ),
            .thursday: MathReading(
                title: "Exponents",
                sectionKeys: ["1.2", "6.1"],
                backup: "Lar Ch 8 · BFN-A U4",
                urls: [sectionURLs["1.2"]!, sectionURLs["6.1"]!]
            ),
            .friday: MathReading(
                title: "Body-scale ratios",
                sectionKeys: ["5.8"],
                backup: "Lar Ch 3 · BFN-A U3",
                urls: [sectionURLs["5.8"]!]
            ),
        ],
        7: [
            .monday: MathReading(
                title: "Formula substitution",
                sectionKeys: ["2.3"],
                backup: "Lar Ch 3 · BFN-A U5",
                urls: [sectionURLs["2.3"]!]
            ),
            .tuesday: MathReading(
                title: "Graph reading",
                sectionKeys: ["2.1", "3.3"],
                backup: "Lar Ch 4 · BFN-A U6",
                urls: [sectionURLs["2.1"]!, sectionURLs["3.3"]!]
            ),
            .wednesday: MathReading(
                title: "W = Fd",
                sectionKeys: ["2.3"],
                backup: "Lar Ch 3 · BFN-A U5",
                urls: [sectionURLs["2.3"]!]
            ),
            .thursday: MathReading(
                title: "Concentration ratios",
                sectionKeys: ["5.8"],
                backup: "Lar Ch 2 · BFN-A U3",
                urls: [sectionURLs["5.8"]!]
            ),
            .friday: MathReading(
                title: "Mixed review",
                sectionKeys: ["1.2", "5.8", "2.3"],
                backup: "Lar Ch 1–4 · BFN-A",
                urls: [sectionURLs["1.2"]!, sectionURLs["5.8"]!, sectionURLs["2.3"]!]
            ),
        ],
        8: [
            .monday: MathReading(
                title: "Number review",
                sectionKeys: ["1.1"],
                backup: "Lar Ch 2 · BFN-A U2",
                urls: [sectionURLs["1.1"]!]
            ),
            .tuesday: MathReading(
                title: "Logic & probability",
                sectionKeys: ["13.7"],
                backup: "Lar Ch 13 · BFN-A U7",
                urls: [sectionURLs["13.7"]!]
            ),
            .wednesday: MathReading(
                title: "v = fλ",
                sectionKeys: ["2.3", "1.3"],
                backup: "Lar Ch 3 + Ch 11 · BFN-A U11",
                urls: [sectionURLs["2.3"]!, sectionURLs["1.3"]!]
            ),
            .thursday: MathReading(
                title: "Unit conversion review",
                sectionKeys: ["1.1", "1.2"],
                backup: "Lar Ch 1–2 · BFN-A U2",
                urls: [sectionURLs["1.1"]!, sectionURLs["1.2"]!]
            ),
            .friday: MathReading(
                title: "Formula plug-in",
                sectionKeys: ["2.3"],
                backup: "Lar Ch 3 · BFN-A U5",
                urls: [sectionURLs["2.3"]!]
            ),
        ],
        9: [
            .monday: MathReading(
                title: "Scientific notation",
                sectionKeys: ["1.2"],
                backup: "Lar Ch 1 · BFN-A U4",
                urls: [sectionURLs["1.2"]!]
            ),
            .tuesday: MathReading(
                title: "Ratios",
                sectionKeys: ["5.8"],
                backup: "Lar Ch 2 · BFN-A U3",
                urls: [sectionURLs["5.8"]!]
            ),
            .wednesday: MathReading(
                title: "Graphs",
                sectionKeys: ["2.1", "3.3"],
                backup: "Lar Ch 4 · BFN-A U6",
                urls: [sectionURLs["2.1"]!, sectionURLs["3.3"]!]
            ),
            .thursday: MathReading(
                title: "Unit conversion",
                sectionKeys: ["1.1", "1.2"],
                backup: "Lar Ch 1–2 · BFN-A U2",
                urls: [sectionURLs["1.1"]!, sectionURLs["1.2"]!]
            ),
            .friday: MathReading(
                title: "Flash review",
                sectionKeys: ["1.2", "5.8"],
                backup: "Lar Ch 1–4 · BFN-A",
                urls: [sectionURLs["1.2"]!, sectionURLs["5.8"]!]
            ),
        ],
        10: [
            .monday: MathReading(
                title: "Formula substitution",
                sectionKeys: ["2.3"],
                backup: "Lar Ch 3 · BFN-A U5",
                urls: [sectionURLs["2.3"]!]
            ),
            .tuesday: MathReading(
                title: "Graph reading",
                sectionKeys: ["2.1", "3.3"],
                backup: "Lar Ch 4 · BFN-A U6",
                urls: [sectionURLs["2.1"]!, sectionURLs["3.3"]!]
            ),
            .wednesday: MathReading(
                title: "W = Fd",
                sectionKeys: ["2.3"],
                backup: "Lar Ch 3 · BFN-A U5",
                urls: [sectionURLs["2.3"]!]
            ),
            .thursday: MathReading(
                title: "Concentration ratios",
                sectionKeys: ["5.8"],
                backup: "Lar Ch 2 · BFN-A U3",
                urls: [sectionURLs["5.8"]!]
            ),
            .friday: MathReading(
                title: "Final review",
                sectionKeys: ["home"],
                backup: "Lar Ch 1–13 · BFN-A",
                urls: [sectionURLs["home"]!]
            ),
        ],
    ]

    static func mathReading(week: Int, day: Weekday) -> MathReading? {
        mathByWeekDay[week]?[day]
    }

    static func url(forChapter ch: Int) -> URL? { chapterURLs[ch] }
}
