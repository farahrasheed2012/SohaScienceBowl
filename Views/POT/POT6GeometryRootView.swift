import SwiftUI

/// Math POT 6 geometry hub — 8-day plan, subgroups, drills, and class resources.
struct POT6GeometryRootView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.themePalette) private var theme
    private var mathProgress: MathProgressService { MathProgressService.shared }

    private var geometryTopics: [MathTopic] {
        mathProgress.geometryTrackTopics()
    }

    private var mastered: Int {
        geometryTopics.filter { $0.masteryLevel == .mastered }.count
    }

    private var total: Int {
        geometryTopics.count
    }

    private var planProgress: (done: Int, total: Int) {
        appState.pot6GeometryPlanProgress
    }

    var body: some View {
        NavigationStack {
            List {
                headerSection
                studyPlanSection
                subgroupsSection
                if !geometryWeakTopics.isEmpty {
                    weakAreasSection
                }
                if !geometryDueForReview.isEmpty {
                    dueForReviewSection
                }
                resourcesSection
            }
            .platformListStyle()
            .navigationTitle("POT 6 Geometry")
            .largeNavigationBarTitle()
            .studyNavigationDestinations()
        }
    }

    private var geometryWeakTopics: [MathTopic] {
        mathProgress.weakTopics.filter { POT6GeometryCatalog.schoolCodes.contains($0.code) }
    }

    private var geometryDueForReview: [MathTopic] {
        mathProgress.dueForReview.filter { POT6GeometryCatalog.schoolCodes.contains($0.code) }
    }

    private var headerSection: some View {
        let progress = total > 0 ? Double(mastered) / Double(total) : 0

        return Section {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("POT 6 Geometry")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(theme.primaryText)
                        Text("\(mastered) / \(total) geometry topics mastered")
                            .font(.subheadline)
                            .foregroundStyle(theme.secondaryText)
                        Text("Larson Ch 11 · POT 6 Geo tab only")
                            .font(.caption)
                            .foregroundStyle(theme.secondaryText)
                    }
                    Spacer()
                    ZStack {
                        Circle()
                            .stroke(PlatformColor.systemTeal.opacity(0.25), lineWidth: 6)
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(PlatformColor.systemTeal, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                        Text("\(Int(progress * 100))%")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(PlatformColor.systemTeal)
                    }
                    .frame(width: 56, height: 56)
                }

                HStack(spacing: 16) {
                    Label("\(planProgress.done)/\(planProgress.total) plan", systemImage: "calendar.badge.clock")
                        .foregroundStyle(planProgress.done == planProgress.total ? theme.success : PlatformColor.systemTeal)
                }
                .font(.caption.weight(.semibold))
            }
            .padding(.vertical, 4)
        }
    }

    private var studyPlanSection: some View {
        Section {
            NavigationLink(value: StudyNavigationRoute.pot6GeometryCatchUp) {
                HStack(spacing: 12) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.title3)
                        .foregroundStyle(PlatformColor.systemTeal)
                        .frame(width: 28)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(POT6GeometryCatalog.planTitle)
                            .font(.body.weight(.semibold))
                        Text("T-code videos · Larson Ch 11 · checkboxes")
                            .font(.caption)
                            .foregroundStyle(theme.secondaryText)
                    }
                    Spacer()
                    Text("\(planProgress.done)/\(planProgress.total)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(planProgress.done == planProgress.total ? theme.success : PlatformColor.systemTeal)
                }
            }

            NavigationLink(value: StudyNavigationRoute.pot6GeometryDailyDrill) {
                Label("Daily Geometry Drill", systemImage: "play.circle.fill")
            }
        } header: {
            Text("Study Plan")
        } footer: {
            Text(POT6GeometryCatalog.planSubtitle)
        }
    }

    private var subgroupsSection: some View {
        Section {
            ForEach(POT6GeometrySubgroup.allCases) { subgroup in
                NavigationLink(value: StudyNavigationRoute.pot6GeometrySubgroup(subgroup)) {
                    subgroupRow(subgroup)
                }
            }
        } header: {
            Text("Topics & Drills")
        } footer: {
            Text("\(total) school geometry topics — T310 through T347 plus 6HW37 and T292 (circles).")
        }
    }

    private func subgroupRow(_ subgroup: POT6GeometrySubgroup) -> some View {
        let topics = geometryTopics.filter { subgroup.topicCodes.contains($0.code) }
        let subgroupMastered = topics.filter { $0.masteryLevel == .mastered }.count
        let ringProgress = topics.isEmpty ? 0 : Double(subgroupMastered) / Double(topics.count)

        return HStack(spacing: 12) {
            Image(systemName: subgroup.icon)
                .font(.title3)
                .foregroundStyle(PlatformColor.systemTeal)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 2) {
                Text(subgroup.rawValue)
                    .font(.body.weight(.semibold))
                Text("\(subgroupMastered) / \(topics.count) mastered")
                    .font(.caption)
                    .foregroundStyle(theme.secondaryText)
            }
            Spacer()
            Text("\(Int(ringProgress * 100))%")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(PlatformColor.systemTeal)
        }
        .padding(.vertical, 2)
    }

    private var weakAreasSection: some View {
        Section("Weak Areas") {
            ForEach(geometryWeakTopics.prefix(3)) { topic in
                NavigationLink(value: StudyNavigationRoute.pot6Topic(code: topic.code)) {
                    HStack {
                        Text(topic.title)
                        Spacer()
                        Text("\(Int(topic.accuracyRate * 100))%")
                            .foregroundStyle(theme.wrong)
                    }
                }
            }
        }
    }

    private var dueForReviewSection: some View {
        Section("Due for Review") {
            ForEach(geometryDueForReview.prefix(5)) { topic in
                NavigationLink(value: StudyNavigationRoute.pot6Topic(code: topic.code)) {
                    HStack {
                        Text(topic.title)
                        Spacer()
                        Image(systemName: "arrow.clockwise.circle")
                            .foregroundStyle(PlatformColor.systemTeal)
                    }
                }
            }
        }
    }

    private var resourcesSection: some View {
        Section("Books & Help") {
            NavigationLink(value: StudyNavigationRoute.pot6Books(.larson)) {
                Label("Larson Algebra 1 — Ch 11", systemImage: "book.fill")
            }
            Link(destination: POT6Resources.topicVideosURL) {
                Label("Math POT Topic Videos", systemImage: "play.rectangle.fill")
            }
            Link(destination: POT6Resources.academyURL) {
                Label("Math POT Academy", systemImage: "safari")
            }
            Link(destination: URL(string: "mailto:\(POT6Resources.instructorEmail)")!) {
                Label("Email Frank Wang", systemImage: "envelope.fill")
            }
        }
    }
}
