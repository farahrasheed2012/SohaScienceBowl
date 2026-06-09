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
                Section(ChemistryTextbookCatalog.modTitle) {
                    Text("Pass 1 chemistry primary — summer schedule rotation.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Ch 2 Measurements · Ch 3 Atoms · Ch 5 Periodic Law · Ch 7 Formulas · Ch 8 Reactions · Ch 10 States · Ch 12 Solutions · Ch 14 Acids & Bases")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section(ChemistryTextbookCatalog.troTitle) {
                    Text("Pass 2 chemistry primary — deeper review on the same topics.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Ch 2 Measurement · Ch 3 Matter · Ch 4 Atoms · Ch 5 Bonding · Ch 7 Reactions · Ch 9 Periodic trends · Ch 13–14 Solutions & acids/bases")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                explTextbookSection(partIDs: ["p3"])
            }

            if category.id == "physics" {
                explTextbookSection(partIDs: ["intro", "p1", "p2"])
            }

            if category.id == "earth-space" {
                explTextbookSection(partIDs: ["p4", "p5"])
            }

            if category.id == "biology" {
                Section("Focus on Life Science (Prentice Hall)") {
                    Text("Pass 1 biology alternate — California Science Explorer edition.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    ForEach(FocusOnLifeScienceCatalog.chaptersGroupedByUnit, id: \.unit.id) { group in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(group.unit.name)
                                .font(.subheadline.weight(.semibold))
                            ForEach(group.chapters, id: \.number) { chapter in
                                Text("Ch \(chapter.number) — \(chapter.title)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Campbell Concepts & Connections 7e") {
                    Text("Pass 2 biology alternate — units and chapters from your 7th edition table of contents.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    ForEach(CampbellBiologyCatalog.chaptersGroupedByUnit, id: \.unit.id) { group in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(group.unit.name)
                                .font(.subheadline.weight(.semibold))
                            ForEach(group.chapters, id: \.number) { chapter in
                                Text("Ch \(chapter.number) — \(chapter.title)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
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
    private func explTextbookSection(partIDs: [String]) -> some View {
        let groups = ConceptualPhysicalScienceExplorationsCatalog.chaptersGroupedByPart(
            filterPartIDs: Set(partIDs)
        )
        Section(ConceptualPhysicalScienceExplorationsCatalog.editionTitle) {
            Text("Summer physics primary and also-OK chemistry/earth/space reference — parts, chapters, and sections from your table of contents.")
                .font(.caption)
                .foregroundStyle(.secondary)
            ForEach(groups, id: \.part.id) { group in
                VStack(alignment: .leading, spacing: 6) {
                    Text(group.part.name)
                        .font(.subheadline.weight(.semibold))
                    ForEach(group.chapters, id: \.number) { chapter in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Ch \(chapter.number) — \(chapter.title)")
                                .font(.caption.weight(.medium))
                            ForEach(chapter.sections, id: \.id) { section in
                                Text("\(section.id) \(section.title)")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
                .padding(.vertical, 4)
            }
            if partIDs.contains("intro") || partIDs.contains("p1") {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Appendices")
                        .font(.subheadline.weight(.semibold))
                    ForEach(ConceptualPhysicalScienceExplorationsCatalog.appendices, id: \.letter) { appendix in
                        Text("Appendix \(appendix.letter) — \(appendix.title)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}
