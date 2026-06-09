import SwiftUI

/// Official DOE middle school NSB categories + in-app study topic index (not an official DOE subtopic list).
struct NSBTopicsRootView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Middle School NSB covers six official question categories defined by the U.S. Department of Energy.")
                            .font(.subheadline)

                        Text("DOE does not publish a numbered subtopic syllabus. Questions are drawn from middle school science and math textbooks — see recommended resources under each category.")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Label(MSNSBOfficialCatalog.regionalContentLevel, systemImage: "book.closed")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Link(destination: MSNSBOfficialCatalog.rulesPDFURL) {
                            Label("DOE Rules 2026 (Rule 3-1)", systemImage: "doc.text")
                                .font(.caption.weight(.medium))
                        }
                    }
                    .padding(.vertical, 4)
                }

                Section("Official question categories (DOE Rules §3-1)") {
                    ForEach(MSNSBOfficialCatalog.categories) { category in
                        NavigationLink(value: NSBTopicsRoute.category(category.id)) {
                            categoryRow(category)
                        }
                    }
                }

                Section("DOE resources") {
                    Link(destination: MSNSBOfficialCatalog.tipsURL) {
                        Label("Tips & Resources — textbooks & study level", systemImage: "safari")
                    }
                    Link(destination: MSNSBOfficialCatalog.sampleQuestionsURL) {
                        Label("Middle School Sample Questions", systemImage: "safari")
                    }
                    Link(destination: MSNSBOfficialCatalog.faqURL) {
                        Label("NSB FAQ", systemImage: "safari")
                    }
                }
            }
            .navigationTitle("NSB Topics")
            .largeNavigationBarTitle()
            .navigationDestination(for: NSBTopicsRoute.self) { route in
                switch route {
                case .category(let id):
                    if let category = MSNSBOfficialCatalog.category(for: id) {
                        NSBCategoryDetailView(category: category)
                    }
                case .topicReadings(let topicId):
                    if let topic = appState.encyclopedia.topic(byId: topicId) {
                        NSBTopicReadingsDetailView(topic: topic)
                    }
                }
            }
        }
    }

    private func categoryRow(_ category: MSNSBOfficialCatalog.Category) -> some View {
        let studyCount = topicCount(for: category)
        let reading = TextbookReadingCatalog.progressSummary(
            forCategoryId: category.id,
            store: appState.textbookReading
        )
        return HStack(spacing: 12) {
            Text(category.emoji)
                .font(.title2)
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(.body.weight(.semibold))
                if let faq = category.faqGrouping {
                    Text("MS FAQ: \(faq)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text("\(studyCount) in-app study guide\(studyCount == 1 ? "" : "s")")
                    .font(.caption2)
                    .foregroundStyle(PlatformColor.systemBlue)
                if reading.total > 0, let label = TextbookReadingCatalog.progressLabel(
                    forCategoryId: category.id,
                    store: appState.textbookReading
                ) {
                    Text(label)
                        .font(.caption2)
                        .foregroundStyle(reading.completed == reading.total ? PlatformColor.systemGreen : .secondary)
                }
            }
        }
        .padding(.vertical, 2)
    }

    private func topicCount(for category: MSNSBOfficialCatalog.Category) -> Int {
        category.encyclopediaSubjects.reduce(0) { partial, subject in
            partial + appState.encyclopedia.topics(for: subject).count
        }
    }
}

private enum NSBTopicsRoute: Hashable {
    case category(String)
    case topicReadings(String)
}

struct NSBCategoryDetailView: View {
    @Environment(AppState.self) private var appState
    let category: MSNSBOfficialCatalog.Category

    private var studyTopics: [NSBTopic] {
        category.encyclopediaSubjects
            .flatMap { appState.encyclopedia.topics(for: $0) }
            .sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
    }

    private var readingProgress: (completed: Int, total: Int) {
        TextbookReadingCatalog.progressSummary(forCategoryId: category.id, store: appState.textbookReading)
    }

    private var readingProgressHint: String {
        switch category.id {
        case "biology":
            return "Reading checkboxes track Focus on Life Science. Expand a chapter to check off sections (1.1, 1.2, …)."
        default:
            return "Reading checkboxes track Hewitt (Conceptual Physical Science Explorations). Expand a chapter to check off individual sections."
        }
    }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(category.emoji)
                            .font(.largeTitle)
                        Text(category.name)
                            .font(.title2.weight(.bold))
                    }

                    Text("Official competition category — DOE National Science Bowl Rules 2026, Rule 3-1.")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if readingProgress.total > 0 {
                        TextbookReadingProgressHeader(
                            completed: readingProgress.completed,
                            total: readingProgress.total
                        )
                        Text(readingProgressHint)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }

            if !category.samplePacketLabels.isEmpty {
                Section("MS sample question labels") {
                    Text("Official middle school sample packets on the DOE website tag questions with these subject headers (alongside the six Rule 3-1 categories).")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    ForEach(category.samplePacketLabels, id: \.self) { label in
                        Text(label)
                            .font(.subheadline.weight(.medium))
                    }
                }
            }

            Section("DOE recommended study resources") {
                Text("From DOE Tips & Resources — Middle School table. Questions are sourced from textbooks like these.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                ForEach(category.recommendedResources, id: \.self) { resource in
                    Text(resource)
                        .font(.subheadline)
                }
                Link("Open DOE Tips & Resources", destination: MSNSBOfficialCatalog.tipsURL)
                    .font(.caption.weight(.medium))
            }

            Section("Content level (DOE)") {
                Text(MSNSBOfficialCatalog.regionalContentLevel)
                    .font(.subheadline)
                Text(MSNSBOfficialCatalog.nationalContentLevel)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if category.id == "chemistry" {
                chemistryReferenceSection
                explTextbookSection(partIDs: ["p3"], footerNote: "Hewitt Part Three — optional chemistry skim after Mod/Tro on the summer schedule.")
            }

            if category.id == "physics" {
                explTextbookSection(
                    partIDs: ["intro", "p1", "p2"],
                    includeAppendices: true,
                    footerNote: "Hewitt — summer physics primary (Parts One–Two + appendices)."
                )
            }

            if category.id == "earth-space" {
                explTextbookSection(partIDs: ["p4", "p5"], footerNote: "Hewitt Parts Four–Five — earth and astronomy.")
            }

            if category.id == "biology" {
                flsTextbookSection
                biologyReferenceSection
            }

            Section {
                Text("These study guides are in the Learn tab. They are not an official DOE topic checklist — use them to explore ideas within this category.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("In-app study guides (\(studyTopics.count))")
            }

            Section {
                ForEach(studyTopics) { topic in
                    NavigationLink(value: NSBTopicsRoute.topicReadings(topic.id)) {
                        topicStudyRow(topic)
                    }
                }
            }
        }
        .navigationTitle(category.name)
        .inlineNavigationBarTitle()
        .studyNavigationDestinations()
    }

    private func topicStudyRow(_ topic: NSBTopic) -> some View {
        let readings = NSBTopicReadingCatalog.readings(for: topic.id)
        return VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(topic.title)
                    .font(.subheadline.weight(.semibold))
                Spacer(minLength: 8)
                if appState.encyclopedia.reviewedTopicIds.contains(topic.id) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(PlatformColor.systemGreen)
                        .font(.caption)
                }
            }

            if let primary = readings.first {
                Text("\(NSBTopicReadingCatalog.bookTitle(for: primary.bookCode)) · \(primary.label)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Text("\(readings.count) book option(s)")
                .font(.caption2)
                .foregroundStyle(PlatformColor.systemBlue)
        }
        .padding(.vertical, 2)
    }

    @ViewBuilder
    private var chemistryReferenceSection: some View {
        Section("Also on the summer schedule (no checkboxes)") {
            Text("Pass 1 primary: \(ChemistryTextbookCatalog.modTitle)")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("Ch 2 Measurements · Ch 3 Atoms · Ch 5 Periodic Law · Ch 7 Formulas · Ch 8 Reactions · Ch 10 States · Ch 12 Solutions · Ch 14 Acids & Bases")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("Pass 2 primary: \(ChemistryTextbookCatalog.troTitle)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top, 4)
            Text("Ch 2 Measurement · Ch 3 Matter · Ch 4 Atoms · Ch 5 Bonding · Ch 7 Reactions · Ch 9 Periodic trends · Ch 13–14 Solutions & acids/bases")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var biologyReferenceSection: some View {
        Section("Pass 2 alternate (no checkboxes)") {
            Text("\(CampbellBiologyCatalog.editionTitle) — deeper biology reference for Pass 2; reading progress is tracked in Focus on Life Science above.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var flsTextbookSection: some View {
        let completed = FocusOnLifeScienceCatalog.chapters.filter {
            appState.textbookReading.isChapterComplete(
                chapterId: TextbookReadingCatalog.flsChapterID(number: $0.number),
                sectionIds: $0.sections.map { TextbookReadingCatalog.flsSectionID($0.id) }
            )
        }.count
        Section {
            ForEach(FocusOnLifeScienceCatalog.chaptersGroupedByUnit, id: \.unit.id) { group in
                Section {
                    ForEach(group.chapters, id: \.number) { chapter in
                        TextbookExpandableChapterRow(chapter: chapter)
                    }
                } header: {
                    Text(group.unit.name)
                }
            }
        } header: {
            Text(FocusOnLifeScienceCatalog.editionTitle)
        } footer: {
            Text("Pass 1 biology — California Science Explorer edition. Expand chapters for section checkboxes. \(completed)/\(FocusOnLifeScienceCatalog.chapters.count) chapters read.")
        }
    }

    @ViewBuilder
    private func explTextbookSection(
        partIDs: [String],
        includeAppendices: Bool = false,
        footerNote: String
    ) -> some View {
        let groups = ConceptualPhysicalScienceExplorationsCatalog.chaptersGroupedByPart(
            filterPartIDs: Set(partIDs)
        )
        let trackable = TextbookReadingCatalog.chapters(forCategoryId: category.id)
            .filter { $0.id.hasPrefix("Expl-") }
        let completed = trackable.filter {
            appState.textbookReading.isChapterComplete(chapterId: $0.id, sectionIds: $0.sectionIds)
        }.count

        Section {
            ForEach(groups, id: \.part.id) { group in
                Section {
                    ForEach(group.chapters, id: \.number) { chapter in
                        TextbookExplChapterRow(
                            chapterNumber: chapter.number,
                            chapterTitle: chapter.title,
                            sections: chapter.sections
                        )
                    }
                } header: {
                    Text(group.part.name)
                }
            }

            if includeAppendices {
                Section("Appendices") {
                    ForEach(ConceptualPhysicalScienceExplorationsCatalog.appendices, id: \.letter) { appendix in
                        TextbookSimpleChapterRow(
                            chapterId: TextbookReadingCatalog.explAppendixID(letter: appendix.letter),
                            label: "Appendix \(appendix.letter) — \(appendix.title)"
                        )
                    }
                }
            }
        } header: {
            Text(ConceptualPhysicalScienceExplorationsCatalog.editionTitle)
        } footer: {
            Text("\(footerNote) Expand a chapter to check off sections. \(completed)/\(trackable.count) Hewitt chapters read.")
        }
    }
}
