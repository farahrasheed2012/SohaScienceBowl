import SwiftUI

/// Main Math POT 6 hub — catch-up plan, books, topics, drills, and class resources.
struct POT6RootView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.themePalette) private var theme
    private var mathProgress: MathProgressService { MathProgressService.shared }

    var body: some View {
        NavigationStack {
            List {
                headerSection
                studyPlanSection
                booksSection
                categoriesSection
                if !mathProgress.weakTopics.isEmpty {
                    weakAreasSection
                }
                if !mathProgress.dueForReview.isEmpty {
                    dueForReviewSection
                }
                resourcesSection
            }
            .platformListStyle()
            .navigationTitle("POT 6")
            .largeNavigationBarTitle()
            .studyNavigationDestinations()
        }
    }

    private var headerSection: some View {
        let algebraCodes = Set(POT6AlgebraCatalog.schoolCodes)
        let algebraTopics = mathProgress.mergedTopics().filter { algebraCodes.contains($0.code) }
        let mastered = algebraTopics.filter { $0.masteryLevel == .mastered }.count
        let total = algebraCodes.count
        let progress = total > 0 ? Double(mastered) / Double(total) : 0
        let janJune = appState.pot6CatchUpJanJuneProgress

        return Section {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Math POT 6")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(theme.primaryText)
                        Text("\(mastered) / \(total) algebra topics mastered")
                            .font(.subheadline)
                            .foregroundStyle(theme.secondaryText)
                        Text(POT6Resources.classSchedule)
                            .font(.caption)
                            .foregroundStyle(theme.secondaryText)
                    }
                    Spacer()
                    ZStack {
                        Circle()
                            .stroke(MathAccent.color.opacity(0.25), lineWidth: 6)
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(MathAccent.color, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                        Text("\(Int(progress * 100))%")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(MathAccent.color)
                    }
                    .frame(width: 56, height: 56)
                }

                HStack(spacing: 16) {
                    Label("\(mathProgress.mathXPTotal) Math XP", systemImage: "star.fill")
                        .foregroundStyle(.orange)
                    Label("\(mathProgress.mathStreakDays) day streak", systemImage: "flame.fill")
                        .foregroundStyle(.orange)
                    Label("\(janJune.done)/\(janJune.total) catch-up", systemImage: "calendar.badge.clock")
                        .foregroundStyle(janJune.done == janJune.total ? theme.success : PlatformColor.systemPurple)
                }
                .font(.caption.weight(.semibold))
            }
            .padding(.vertical, 4)
        }
    }

    private var studyPlanSection: some View {
        let janJune = appState.pot6CatchUpJanJuneProgress
        let master = appState.pot6CatchUpMasterProgress

        return Section {
            NavigationLink(value: StudyNavigationRoute.pot6CatchUp) {
                HStack(spacing: 12) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.title3)
                        .foregroundStyle(PlatformColor.systemPurple)
                        .frame(width: 28)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("13-Day Catch-Up Plan")
                            .font(.body.weight(.semibold))
                        Text("T-code videos · BFN-A chapters · checkboxes")
                            .font(.caption)
                            .foregroundStyle(theme.secondaryText)
                    }
                    Spacer()
                    Text("\(janJune.done)/\(janJune.total)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(janJune.done == janJune.total ? theme.success : PlatformColor.systemPurple)
                }
            }

            NavigationLink(value: StudyNavigationRoute.pot6DailyDrill) {
                Label("Daily Math Block", systemImage: "play.circle.fill")
            }

            NavigationLink(value: StudyNavigationRoute.pot6GeometryCatchUp) {
                HStack(spacing: 12) {
                    Image(systemName: "triangle.fill")
                        .font(.title3)
                        .foregroundStyle(Color.teal)
                        .frame(width: 28)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("POT 6 Geometry (separate track)")
                            .font(.body.weight(.semibold))
                        Text("8-day plan · not on summer algebra calendar")
                            .font(.caption)
                            .foregroundStyle(theme.secondaryText)
                    }
                }
            }

            HStack {
                Text("Full school topic list")
                Spacer()
                Text("\(master.done)/\(master.total)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(theme.secondaryText)
            }
            .font(.subheadline)
            .foregroundStyle(theme.secondaryText)
        } header: {
            Text("Study Plan")
        } footer: {
            Text(POT6Resources.missedWindow)
        }
    }

    private var booksSection: some View {
        Section("Books & Materials") {
            NavigationLink(value: StudyNavigationRoute.pot6Books(.bfn)) {
                bookRow(
                    icon: "book.closed.fill",
                    title: BFNAlgebraCatalog.bookCode,
                    subtitle: "\(BFNAlgebraCatalog.chapterCount) chapters · \(BFNAlgebraCatalog.chapterSectionGuide)",
                    tint: PlatformColor.systemOrange
                )
            }

            NavigationLink(value: StudyNavigationRoute.pot6Books(.larson)) {
                bookRow(
                    icon: "book.fill",
                    title: "Larson Algebra 1",
                    subtitle: "Print backup · ISBN \(MathAlgebraReadingCatalog.larsonISBN)",
                    tint: PlatformColor.systemBlue
                )
            }

            NavigationLink(value: StudyNavigationRoute.pot6Books(.openStax)) {
                bookRow(
                    icon: "globe",
                    title: "OpenStax Algebra & Trig",
                    subtitle: "Free online · linked sections per topic",
                    tint: Color.teal
                )
            }

            Link(destination: POT6Resources.topicVideosURL) {
                bookRow(
                    icon: "play.rectangle.fill",
                    title: "Math POT Topic Videos",
                    subtitle: "Google Drive · search by T-code",
                    tint: PlatformColor.systemRed
                )
            }
        }
    }

    private func bookRow(icon: String, title: String, subtitle: String, tint: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(tint)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(theme.primaryText)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(theme.secondaryText)
            }
        }
        .padding(.vertical, 2)
    }

    private var categoriesSection: some View {
        Section {
            ForEach(POT6Category.allCases.filter { $0 != .geometry }) { category in
                NavigationLink(value: StudyNavigationRoute.pot6Category(category)) {
                    categoryRow(category)
                }
            }
        } header: {
            Text("Topics & Drills")
        } footer: {
            Text("Algebra, coordinate geometry, quadratics, stats & probability — \(POT6AlgebraCatalog.schoolCodes.count) school topics on the summer calendar (weeks 4–10). Geometry is in **POT 6 Geo**.")
        }
    }

    private func categoryRow(_ category: POT6Category) -> some View {
        let topics = POT6TopicRegistry.schoolTopics.filter { $0.pot6Category == category }
        let merged = mathProgress.mergedTopics().filter { $0.pot6Category == category && !$0.isCompetitionOnly }
        let mastered = merged.filter { $0.masteryLevel == .mastered }.count
        let accuracy = mathProgress.categoryAccuracy(category)
        let ringProgress = topics.isEmpty ? 0 : Double(mastered) / Double(topics.count)

        return HStack(spacing: 12) {
            Image(systemName: category.icon)
                .font(.title3)
                .foregroundStyle(MathAccent.color)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 2) {
                Text(category.rawValue)
                    .font(.body.weight(.semibold))
                Text("\(mastered) / \(topics.count) mastered")
                    .font(.caption)
                    .foregroundStyle(theme.secondaryText)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(Int(ringProgress * 100))%")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(MathAccent.color)
                if accuracy > 0 {
                    Text("\(Int(accuracy * 100))% acc.")
                        .font(.caption2)
                        .foregroundStyle(theme.secondaryText)
                }
            }
        }
        .padding(.vertical, 2)
    }

    private var weakAreasSection: some View {
        Section("Weak Areas") {
            ForEach(mathProgress.weakTopics.prefix(3)) { topic in
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
            ForEach(mathProgress.dueForReview.prefix(5)) { topic in
                NavigationLink(value: StudyNavigationRoute.pot6Topic(code: topic.code)) {
                    HStack {
                        Text(topic.title)
                        Spacer()
                        Image(systemName: "arrow.clockwise.circle")
                            .foregroundStyle(MathAccent.color)
                    }
                }
            }
        }
    }

    private var resourcesSection: some View {
        Section("Class & Help") {
            Link(destination: POT6Resources.academyURL) {
                Label("Math POT Academy", systemImage: "safari")
            }
            Link(destination: POT6Resources.evaluationURL) {
                Label("Book an evaluation", systemImage: "person.fill.questionmark")
            }
            Link(destination: URL(string: "mailto:\(POT6Resources.instructorEmail)")!) {
                Label("Email Frank Wang", systemImage: "envelope.fill")
            }
            Link(destination: URL(string: "mailto:\(POT6Resources.homeworkEmail)")!) {
                Label("Submit homework (PDF)", systemImage: "paperplane.fill")
            }
            Label("Topics tab → Mathematics → BFN-A chapter checklist", systemImage: "list.bullet.rectangle")
                .font(.caption)
                .foregroundStyle(theme.secondaryText)
        }
    }
}
