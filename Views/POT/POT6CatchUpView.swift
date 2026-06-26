import SwiftUI

/// Thirteen-day Math POT 6 catch-up plan before Soha joins class (Jan–Jun 2026 missed topics).
struct POT6CatchUpView: View {
    @Environment(AppState.self) private var appState
    @State private var showMasterList = false

    var body: some View {
        @Bindable var appState = appState

        List {
            headerSection
            booksSection
            ForEach(POT6CatchUpCatalog.dayPlans) { plan in
                daySection(plan)
            }
            masterListSection
            resourcesSection
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .navigationTitle("POT 6 Catch-Up")
        .largeNavigationBarTitle()
        .studyNavigationDestinations()
    }

    private var headerSection: some View {
        let janJune = appState.pot6CatchUpJanJuneProgress
        let master = appState.pot6CatchUpMasterProgress

        return Section {
            VStack(alignment: .leading, spacing: 10) {
                Label("Math POT 6 · before first class", systemImage: "calendar.badge.clock")
                    .font(.headline)
                    .foregroundStyle(PlatformColor.systemPurple)

                Text("Catch up on Jan–June 2026 POT 6 **algebra** topics. Each T-code lists **BFN-A**, **Larson**, and **OpenStax** below. Tap the title for notes & drills. Geometry → **POT 6 Geo**.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 16) {
                    progressPill(title: "Jan–Jun priority", done: janJune.done, total: janJune.total)
                    progressPill(title: "Full school list", done: master.done, total: master.total)
                }

                Text(POT6CatchUpCatalog.missedWindow)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
        }
    }

    private var booksSection: some View {
        Section("Books") {
            NavigationLink(value: StudyNavigationRoute.pot6Books(.bfn)) {
                Label {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(BFNAlgebraCatalog.bookCode)
                            .font(.body.weight(.semibold))
                        Text("Main book · ISBN \(BFNAlgebraCatalog.isbn)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                } icon: {
                    Image(systemName: "book.closed.fill")
                        .foregroundStyle(PlatformColor.systemOrange)
                }
            }

            NavigationLink(value: StudyNavigationRoute.pot6Books(.larson)) {
                Label {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Larson Algebra 1")
                            .font(.body.weight(.semibold))
                        Text("Print backup · ISBN \(MathAlgebraReadingCatalog.larsonISBN)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                } icon: {
                    Image(systemName: "book.fill")
                        .foregroundStyle(PlatformColor.systemBlue)
                }
            }

            NavigationLink(value: StudyNavigationRoute.pot6Books(.openStax)) {
                Label {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("OpenStax Algebra & Trig")
                            .font(.body.weight(.semibold))
                        Text("Free online · § sections linked per topic")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                } icon: {
                    Image(systemName: "globe")
                        .foregroundStyle(Color.teal)
                }
            }
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
        Section {
            ForEach(plan.items) { item in
                topicRow(item)
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

    private func topicRow(_ item: POT6CatchUpCatalog.Item) -> some View {
        let isDone = appState.isPOT6CatchUpDone(item.potCode)

        return VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top, spacing: 12) {
                Button {
                    appState.togglePOT6CatchUp(item.potCode)
                } label: {
                    Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(isDone ? PlatformColor.systemGreen : .secondary)
                        .font(.title3)
                        .frame(width: 28, height: 28)
                }
                #if os(macOS)
                .buttonStyle(.borderless)
                #else
                .buttonStyle(.plain)
                #endif
                .accessibilityLabel(isDone ? "Mark \(item.potCode) not done" : "Mark \(item.potCode) done")

                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Text(item.potCode)
                            .font(.caption.weight(.bold).monospaced())
                            .foregroundStyle(PlatformColor.systemPurple)
                        if !item.isJanJune {
                            tagLabel("Later in year", color: PlatformColor.systemOrange)
                        }
                    }

                    if item.isReviewMarker {
                        Text(item.title)
                            .font(.body.weight(.medium))
                            .foregroundStyle(.primary)
                        Text("Re-do unchecked topics from earlier days")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else if POT6TopicRegistry.topic(for: item.potCode) != nil {
                        NavigationLink(value: StudyNavigationRoute.pot6Topic(code: item.potCode)) {
                            Text(item.title)
                                .font(.body.weight(.medium))
                                .foregroundStyle(.primary)
                                .multilineTextAlignment(.leading)
                        }
                    } else {
                        Text(item.title)
                            .font(.body.weight(.medium))
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)
                    }

                    if !item.isReviewMarker || item.potCode.hasPrefix("MIX") {
                        POT6TopicReadingSummaryView(potCode: item.potCode)
                    }
                }

                Spacer(minLength: 0)
            }

            if !item.isReviewMarker, POT6TopicRegistry.topic(for: item.potCode) != nil {
                NavigationLink(value: StudyNavigationRoute.pot6Topic(code: item.potCode)) {
                    Label("Concept notes & drills", systemImage: "sum")
                        .font(.caption.weight(.semibold))
                }
                .padding(.leading, 36)
            }
        }
        .padding(.vertical, 2)
        .listRowBackground(Color.clear)
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
                        topicRow(item)
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

    private var resourcesSection: some View {
        Section("Resources") {
            Button("Reset POT 6 checkboxes") {
                appState.resetPOT6CatchUpProgress()
            }
            #if os(macOS)
            .buttonStyle(.borderless)
            #endif
            .font(.caption)

            Text("Checkboxes are saved on this Mac. Green circle = marked done. Tap the circle only — not the whole row.")
                .font(.caption)
                .foregroundStyle(.secondary)

            Label("Math POT topic videos — search by T-code on Google Drive (registration PDF)", systemImage: "play.rectangle.fill")
            Label("Evaluation: mathpotacademy.com/evaluation.html", systemImage: "person.fill.questionmark")
            Label("Email Frank Wang: mathpotwang@gmail.com", systemImage: "envelope.fill")
            Label("POT 6 → Topics & Drills for BFN / Larson / OpenStax per topic", systemImage: "list.bullet.rectangle")
        }
        .font(.caption)
        .foregroundStyle(.secondary)
    }
}
