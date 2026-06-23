import SwiftUI

/// Fourteen-day Math POT 6 catch-up plan before Soha joins class (Jan–Jun 2026 missed topics).
struct POT6CatchUpView: View {
    @Environment(AppState.self) private var appState
    @State private var showMasterList = false
    @State private var showAlternateBooks = false
    @State private var showQuickCheck = true

    var body: some View {
        @Bindable var appState = appState

        NavigationStack {
            List {
                headerSection
                quickCheckSection
                ForEach(POT6CatchUpCatalog.dayPlans) { plan in
                    daySection(plan)
                }
                masterListSection
                alternateBooksSection
                resourcesSection
            }
            .platformListStyle()
            .navigationTitle("POT 6 Catch-Up")
            .largeNavigationBarTitle()
            .studyNavigationDestinations()
        }
    }

    private var headerSection: some View {
        let janJune = appState.pot6CatchUpJanJuneProgress
        let quickCheck = appState.pot6CatchUpPrerequisiteProgress
        let master = appState.pot6CatchUpMasterProgress

        return Section {
            VStack(alignment: .leading, spacing: 10) {
                Label("Math POT 6 · before first class", systemImage: "calendar.badge.clock")
                    .font(.headline)
                    .foregroundStyle(PlatformColor.systemPurple)

                Text("Catch up on Jan–June 2026 topics before joining \(POT6CatchUpCatalog.classSchedule). Start with **Quick check** if Accel II already covered basics; then work through the 14-day plan. Watch each T-code video and read **BFN-A**.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 16) {
                    progressPill(title: "Jan–Jun priority", done: janJune.done, total: janJune.total)
                    progressPill(title: "Quick check (optional)", done: quickCheck.done, total: quickCheck.total)
                    progressPill(title: "Full school list", done: master.done, total: master.total)
                }

                Text(POT6CatchUpCatalog.missedWindow)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("BFN-A sections per chapter: \(BFNAlgebraCatalog.chapterSectionGuide)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
        }
    }

    private var quickCheckSection: some View {
        Section {
            DisclosureGroup(isExpanded: $showQuickCheck) {
                quickCheckReadingBlock

                ForEach(POT6CatchUpCatalog.prerequisiteItems) { item in
                    topicRow(item, showPrerequisiteTag: false)
                }

                let topicIds = POT6CatchUpCatalog.prerequisitePracticeTopicIds
                if !topicIds.isEmpty {
                    NavigationLink {
                        EncyclopediaPracticeSetupView(mode: .multipleChoice, preferredTopicIds: topicIds)
                    } label: {
                        Label("Practice quick-check topics in Learn", systemImage: "books.vertical.fill")
                    }
                }
            } label: {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Quick check — POT 5 review (optional)")
                    Text("Systems, exponents, ratios, sequences · skip if Accel II solid")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Text("Not counted in Jan–Jun priority. Check a topic only when she can do homework-style problems without help.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var quickCheckReadingBlock: some View {
        let chapters = POT6CatchUpCatalog.prerequisiteBFNChapterNumbers
        let alt = POT6CatchUpCatalog.prerequisiteReadingOptions

        if !chapters.isEmpty || !alt.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                if !chapters.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("BFN-A", systemImage: "book.closed.fill")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(PlatformColor.systemOrange)

                        ForEach(BFNAlgebraCatalog.groupedChapters(chapters), id: \.unit.id) { group in
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Unit \(group.unit.number) — \(group.unit.name) · \(BFNAlgebraCatalog.pageLabel(forChapter: group.chapters.first!.number))")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)

                                ForEach(group.chapters) { chapter in
                                    Text("Ch \(chapter.number) — \(chapter.title)")
                                        .font(.caption)
                                }
                            }
                        }

                        Text("Sections: \(BFNAlgebraCatalog.chapterSectionGuide)")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                }

                if !alt.isEmpty {
                    alternateReadingDisclosure(alt, label: "Other books (Larson / OpenStax)")
                }
            }
            .padding(.vertical, 4)
        }
    }

    private func progressPill(title: String, done: Int, total: Int) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text("\(done)/\(total)")
                .font(.caption.weight(.semibold))
                .foregroundStyle(done == total ? PlatformColor.systemGreen : PlatformColor.systemPurple)
        }
    }

    private func daySection(_ plan: POT6CatchUpCatalog.DayPlan) -> some View {
        let bfnChapters = POT6CatchUpCatalog.bfnChapterNumbers(forDay: plan.day)

        return Section {
            dayReadingBlock(day: plan.day, chapterNumbers: bfnChapters)

            ForEach(plan.items) { item in
                topicRow(item, showPrerequisiteTag: false)
            }

            if !plan.items.isEmpty {
                let topicIds = POT6CatchUpCatalog.practiceTopicIds(forDay: plan.day)
                if !topicIds.isEmpty {
                    NavigationLink {
                        EncyclopediaPracticeSetupView(mode: .multipleChoice, preferredTopicIds: topicIds)
                    } label: {
                        Label("Practice day \(plan.day) in Learn", systemImage: "books.vertical.fill")
                    }
                }
            }
        } header: {
            VStack(alignment: .leading, spacing: 2) {
                Text("Day \(plan.day)")
                Text(plan.title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    @ViewBuilder
    private func dayReadingBlock(day: Int, chapterNumbers: [Int]) -> some View {
        let alt = POT6CatchUpCatalog.readingOptions(forDay: day)
        let hasBFN = !chapterNumbers.isEmpty
        let hasAlt = !alt.isEmpty

        if hasBFN || hasAlt {
            VStack(alignment: .leading, spacing: 10) {
                if hasBFN {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("BFN-A", systemImage: "book.closed.fill")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(PlatformColor.systemOrange)

                        ForEach(BFNAlgebraCatalog.groupedChapters(chapterNumbers), id: \.unit.id) { group in
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Unit \(group.unit.number) — \(group.unit.name) · \(BFNAlgebraCatalog.pageLabel(forChapter: group.chapters.first!.number))")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)

                                ForEach(group.chapters) { chapter in
                                    Text("Ch \(chapter.number) — \(chapter.title)")
                                        .font(.caption)
                                }
                            }
                        }

                        Text("Sections: \(BFNAlgebraCatalog.chapterSectionGuide)")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                }

                if hasAlt {
                    alternateReadingDisclosure(alt, label: "Other books for this day (Larson / OpenStax)")
                }
            }
            .padding(.vertical, 4)
        }
    }

    @ViewBuilder
    private func alternateReadingDisclosure(_ options: MathAlgebraReadingCatalog.ReadingOptions, label: String) -> some View {
        DisclosureGroup {
            alternateReadingContent(options)
        } label: {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(PlatformColor.systemBlue)
        }
    }

    @ViewBuilder
    private func alternateReadingContent(_ options: MathAlgebraReadingCatalog.ReadingOptions) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            if !options.larsonSections.isEmpty {
                Text("Larson (print book — ISBN \(MathAlgebraReadingCatalog.larsonISBN))")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                ForEach(options.larsonSections) { section in
                    Text(section.label)
                        .font(.caption)
                }
            }

            if !options.openStaxSections.isEmpty {
                Text("OpenStax (free online)")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                ForEach(options.openStaxSections) { section in
                    if let url = section.url {
                        Link(section.label, destination: url)
                            .font(.caption)
                    } else {
                        Text(section.label)
                            .font(.caption)
                    }
                }
            }
        }
    }

    private func topicRow(_ item: POT6CatchUpCatalog.Item, showPrerequisiteTag: Bool = true) -> some View {
        let alt = MathAlgebraReadingCatalog.readingOptions(
            bfnChapterNumbers: item.bfnChapters,
            potCode: item.potCode
        )

        return VStack(alignment: .leading, spacing: 6) {
            Button {
                appState.togglePOT6CatchUp(item.potCode)
            } label: {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: appState.isPOT6CatchUpDone(item.potCode) ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(appState.isPOT6CatchUpDone(item.potCode) ? PlatformColor.systemGreen : .secondary)
                        .font(.title3)
                        .padding(.top, 2)

                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 8) {
                            Text(item.potCode)
                                .font(.caption.weight(.bold).monospaced())
                                .foregroundStyle(PlatformColor.systemPurple)
                            if showPrerequisiteTag && item.isPrerequisite {
                                tagLabel("POT 5 review", color: PlatformColor.systemPurple)
                            } else if !item.isJanJune {
                                tagLabel("Later in year", color: PlatformColor.systemOrange)
                            }
                        }

                        Text(item.title)
                            .font(.body.weight(.medium))
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)

                        if !item.bfnChapters.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(item.bfnChapters, id: \.self) { chapterNumber in
                                    if let chapter = BFNAlgebraCatalog.chapter(chapterNumber),
                                       let unit = BFNAlgebraCatalog.unit(forChapter: chapterNumber) {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Unit \(unit.number) · \(unit.name)")
                                                .font(.caption2.weight(.semibold))
                                                .foregroundStyle(PlatformColor.systemOrange)
                                            Text("Ch \(chapter.number) — \(chapter.title) · \(BFNAlgebraCatalog.pageLabel(forChapter: chapterNumber))")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                            Text(BFNAlgebraCatalog.chapterSectionGuide)
                                                .font(.caption2)
                                                .foregroundStyle(.tertiary)
                                        }
                                    }
                                }
                            }
                        } else if item.catchUpDay == 11 {
                            Text("Geometry — use Math POT video + Learn practice (no BFN-A chapter)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        if item.isReviewMarker {
                            Text("Re-do unchecked topics from days 1–12 · 20–30 min Math POT homework style")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Spacer(minLength: 0)
                }
            }
            .buttonStyle(.plain)

            if !alt.isEmpty {
                alternateReadingDisclosure(alt, label: "Other books (Larson / OpenStax)")
                    .padding(.leading, 36)
            }
        }
    }

    private func tagLabel(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.caption2)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }

    private var masterListSection: some View {
        Section("Full school topic list") {
            DisclosureGroup(isExpanded: $showMasterList) {
                ForEach(POT6CatchUpCatalog.masterListItems) { item in
                    if item.catchUpDay == 0 {
                        topicRow(item, showPrerequisiteTag: true)
                    }
                }
            } label: {
                Text("Later-year topics (Jul–Dec in class)")
                    .font(.body.weight(.medium))
            }

            Text("\(POT6CatchUpCatalog.competitionOnlyCodes.count) competition-only codes (starred homework) are omitted — POT 6 BASIC skips those.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var alternateBooksSection: some View {
        Section {
            DisclosureGroup(isExpanded: $showAlternateBooks) {
                VStack(alignment: .leading, spacing: 12) {
                    Label("\(MathAlgebraReadingCatalog.larsonTitle) (ISBN \(MathAlgebraReadingCatalog.larsonISBN))", systemImage: "book.fill")
                        .font(.caption)

                    Link("\(MathAlgebraReadingCatalog.osaTitle) — openstax.org", destination: MathAlgebraReadingCatalog.osaBookHome)
                        .font(.caption)

                    Text("OpenStax Ch 2–6 — full section map")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)

                    ForEach(MathAlgebraReadingCatalog.openStaxChapters2Through6) { chapter in
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Ch \(chapter.number) — \(chapter.title)")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)
                            ForEach(chapter.sections) { section in
                                if let url = section.url {
                                    Link(section.label, destination: url)
                                        .font(.caption)
                                } else {
                                    Text(section.label)
                                        .font(.caption)
                                }
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
            } label: {
                Text("Alternate books (Larson & OpenStax)")
                    .font(.body.weight(.medium))
            }

            Text("Optional — BFN-A is the main book for POT 6. Expand for print or free online alternatives.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var resourcesSection: some View {
        Section("Resources") {
            Label("\(BFNAlgebraCatalog.editionTitle) (ISBN \(BFNAlgebraCatalog.isbn))", systemImage: "book.closed.fill")
            Label("Math POT topic videos — search by T-code on Google Drive (registration PDF)", systemImage: "play.rectangle.fill")
            Label("Evaluation: mathpotacademy.com/evaluation.html", systemImage: "person.fill.questionmark")
            Label("Email Frank Wang: mathpotwang@gmail.com", systemImage: "envelope.fill")
            Label("Topics tab → Mathematics → BFN-A full unit/chapter checklist", systemImage: "list.bullet.rectangle")
        }
        .font(.caption)
        .foregroundStyle(.secondary)
    }
}
