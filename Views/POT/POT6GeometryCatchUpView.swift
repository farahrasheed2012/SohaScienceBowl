import SwiftUI

/// Eight-day POT 6 geometry plan — mirrors summer calendar weeks 7–12.
struct POT6GeometryCatchUpView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        List {
            headerSection
            ForEach(POT6GeometryCatalog.dayPlans) { plan in
                daySection(plan)
            }
            allTopicsSection
            resourcesSection
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .navigationTitle("Geometry Plan")
        .largeNavigationBarTitle()
        .studyNavigationDestinations()
    }

    private var headerSection: some View {
        let progress = appState.pot6GeometryPlanProgress

        return Section {
            VStack(alignment: .leading, spacing: 10) {
                Label("POT 6 Geometry · 8-day plan", systemImage: "triangle.fill")
                    .font(.headline)
                    .foregroundStyle(PlatformColor.systemTeal)

                Text("Check off each geometry T-code. Tap a topic for **Larson, OpenStax, notes & drills** — or use **POT 6 Geo → Topics**.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 16) {
                    progressPill(title: "Plan progress", done: progress.done, total: progress.total)
                    progressPill(
                        title: "Mastery",
                        done: MathProgressService.shared.geometryTrackTopics().filter { $0.masteryLevel == .mastered }.count,
                        total: POT6GeometryCatalog.schoolCodes.count
                    )
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
                .foregroundStyle(done == total ? PlatformColor.systemGreen : PlatformColor.systemTeal)
        }
    }

    private func daySection(_ plan: POT6GeometryCatalog.DayPlan) -> some View {
        Section {
            ForEach(plan.potCodes, id: \.self) { code in
                topicRow(code: code)
            }

            NavigationLink {
                EncyclopediaPracticeSetupView(
                    mode: .multipleChoice,
                    preferredTopicIds: POT6GeometryCatalog.practiceTopicIds(forDay: plan.day)
                )
            } label: {
                Label("Practice day \(plan.day) in Learn", systemImage: "books.vertical.fill")
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

    private func topicRow(code: String) -> some View {
        let title = POT6TopicRegistry.topic(for: code)?.title ?? code
        let isDone = appState.isPOT6CatchUpDone(code)
        let mastery = MathProgressService.shared.topic(for: code)?.masteryLevel ?? .unseen

        return HStack(alignment: .top, spacing: 12) {
            Button {
                appState.togglePOT6CatchUp(code)
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
            .accessibilityLabel(isDone ? "Mark \(code) not done" : "Mark \(code) done")

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text(code)
                        .font(.caption.weight(.bold).monospaced())
                        .foregroundStyle(PlatformColor.systemTeal)
                    Image(systemName: mastery.systemImage)
                        .font(.caption)
                        .foregroundStyle(mastery == .mastered ? PlatformColor.systemGreen : .secondary)
                }

                NavigationLink(value: StudyNavigationRoute.pot6Topic(code: code)) {
                    Text(title)
                        .font(.body.weight(.medium))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        .padding(.vertical, 2)
    }

    private var allTopicsSection: some View {
        Section("All geometry topics") {
            ForEach(POT6GeometryCatalog.schoolCodes, id: \.self) { code in
                if let topic = POT6TopicRegistry.topic(for: code) {
                    NavigationLink(value: StudyNavigationRoute.pot6Topic(code: code)) {
                        HStack {
                            Text(topic.title)
                            Spacer()
                            Text(code)
                                .font(.caption.monospaced())
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }

    private var resourcesSection: some View {
        Section("Resources") {
            Link(destination: POT6Resources.topicVideosURL) {
                Label("Topic videos (search T-code)", systemImage: "play.rectangle.fill")
            }
            NavigationLink(value: StudyNavigationRoute.pot6Books(.larson)) {
                Label("Larson Algebra 1 — Ch 11 geometry", systemImage: "book.fill")
            }
            NavigationLink(value: StudyNavigationRoute.pot6Books(.openStax)) {
                Label("OpenStax — coordinate geometry sections", systemImage: "globe")
            }
            Text("BFN-A has no geometry unit — book mappings are on each topic page.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
