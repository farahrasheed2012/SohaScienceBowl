import SwiftUI

struct TodayView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.themePalette) private var theme
    @Environment(\.colorScheme) private var colorScheme
    @State private var navigationPath = NavigationPath()

    private var isDarkCoach: Bool {
        switch appState.appAppearance {
        case .dark: return true
        case .warmLight: return false
        case .system: return colorScheme == .dark
        }
    }

    private var isFriday: Bool {
        Weekday.from(Date()) == .friday
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                gameHeaderSection

                if let next = appState.nextUpItem() {
                    Section {
                        VStack(alignment: .leading, spacing: 10) {
                            Label("Next up", systemImage: "arrow.right.circle.fill")
                                .font(.headline)
                                .foregroundStyle(Color.accentColor)
                            Text(next.title)
                                .font(.title3.weight(.semibold))
                            Text(next.subtitle)
                                .font(.subheadline)
                                .foregroundStyle(isDarkCoach ? theme.secondaryText : .secondary)
                            Text(next.duration)
                                .font(.caption)
                                .foregroundStyle(isDarkCoach ? theme.secondaryText : .secondary)
                            if let route = next.route {
                                Button {
                                    navigationPath.append(route)
                                } label: {
                                    Text("Start now")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                        .padding(.vertical, 4)
                        .todayListRow(isDarkCoach: isDarkCoach, theme: theme)
                    }
                }

                if appState.studyStreakDays > 0 || !appState.earnedBadges().isEmpty {
                    Section {
                        if appState.studyStreakDays > 0 {
                            Label("\(appState.studyStreakDays)-day study streak", systemImage: "flame.fill")
                                .foregroundStyle(.orange)
                                .todayListRow(isDarkCoach: isDarkCoach, theme: theme)
                        }
                        let badges = appState.earnedBadges()
                        if !badges.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(badges) { badge in
                                        Label(badge.title, systemImage: badge.systemImage)
                                            .font(.caption.weight(.semibold))
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .background(PlatformColor.tertiaryFill)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                            .todayListRow(isDarkCoach: isDarkCoach, theme: theme)
                        }
                    } header: {
                        coachSectionHeader("Streaks & badges")
                    }
                }

                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Week \(appState.currentWeek) · \(appState.weekTheme(for: appState.currentWeek))")
                            .font(.headline)
                        if ScheduleSplitTrack.isChemOnlyWeek(calendarWeek: appState.currentWeek) {
                            Text("Split track: Chem only weeks 1–2 — bio & phys right-shifted (start Jun 22 at Week 1)")
                                .font(.caption)
                                .foregroundStyle(.orange)
                        } else if appState.currentWeek == ScheduleSplitTrack.bioPhysStartCalendarWeek {
                            Text("Split track: First bio/phys day — Bio Week 1 · Phys Week 1 content")
                                .font(.caption)
                                .foregroundStyle(Color.accentColor)
                        }
                        Text(ScheduleConstants.passLabel(for: appState.currentPass))
                            .font(.subheadline)
                            .foregroundStyle(isDarkCoach ? theme.secondaryText : .secondary)
                        Text(MSNSBStudyScope.introShort)
                            .font(.caption)
                            .foregroundStyle(isDarkCoach ? theme.secondaryText : .secondary)
                        Text(appState.doeStore.drillReadinessLabel)
                            .font(.caption)
                            .foregroundStyle(appState.doeStore.isDrillReady ? .green : (isDarkCoach ? theme.secondaryText : .secondary))
                    }
                    .padding(.vertical, 4)
                    .todayListRow(isDarkCoach: isDarkCoach, theme: theme)
                }

                if !appState.flashCardsDueToday.isEmpty || !appState.weakTopics.isEmpty {
                    Section {
                        if !appState.flashCardsDueToday.isEmpty {
                            Text("\(appState.flashCardsDueToday.count) flash cards due")
                                .font(.caption)
                                .foregroundStyle(isDarkCoach ? theme.secondaryText : .secondary)
                                .todayListRow(isDarkCoach: isDarkCoach, theme: theme)
                        }
                        if let weak = appState.weakTopics.first {
                            Text("Weakest: \(weak.topic) (\(Int(weak.accuracy * 100))%)")
                                .font(.caption)
                                .foregroundStyle(isDarkCoach ? theme.secondaryText : .secondary)
                                .todayListRow(isDarkCoach: isDarkCoach, theme: theme)
                        }
                        studyActionRow(
                            title: "Review weak areas",
                            systemImage: "arrow.counterclockwise.circle.fill",
                            prominent: false
                        ) {
                            navigationPath.append(StudyNavigationRoute.weakAreaReview)
                        }
                    } header: {
                        coachSectionHeader("Today's review")
                    }
                }

                if let weekday = Weekday.from(Date()) {
                    ForEach(appState.todayBlocks()) { block in
                        Section {
                            StudyBlockReadingAndVideos(
                                block: block,
                                activePass: appState.currentPass,
                                compact: true
                            )
                            .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                            .todayListRow(isDarkCoach: isDarkCoach, theme: theme, clear: true)

                            Button {
                                navigationPath.append(StudyNavigationRoute.studyMaterial(block))
                            } label: {
                                Label("Open full study material", systemImage: "book.fill")
                                    .font(.subheadline.weight(.semibold))
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)

                            HStack(spacing: 12) {
                                Button {
                                    navigationPath.append(StudyNavigationRoute.fullSession(block))
                                } label: {
                                    Text("Full session")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.bordered)

                                Button {
                                    navigationPath.append(
                                        StudyNavigationRoute.planDrill(
                                            .todayBlock(block, week: appState.currentWeek)
                                        )
                                    )
                                } label: {
                                    Text("Quiz only")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.bordered)
                            }
                            .todayListRow(isDarkCoach: isDarkCoach, theme: theme)
                        } header: {
                            coachSectionHeader("\(block.subject.rawValue) · \(block.primaryTopic)")
                        }
                    }

                    if let mathReading = ScheduleOpenStaxCatalog.mathReading(
                        week: appState.currentWeek,
                        day: weekday
                    ) {
                        Section {
                            StudyMathReadingAndVideos(
                                reading: mathReading,
                                week: appState.currentWeek,
                                day: weekday
                            )
                            .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                            .todayListRow(isDarkCoach: isDarkCoach, theme: theme, clear: true)

                            studyActionRow(
                                title: "Math quiz",
                                systemImage: "function",
                                prominent: false
                            ) {
                                navigationPath.append(
                                    StudyNavigationRoute.planDrill(
                                        .mathQuiz(week: appState.currentWeek, day: weekday)
                                    )
                                )
                            } subtitle: {
                                Text("Toss-ups from today's math topic")
                                    .font(.caption)
                                    .foregroundStyle(isDarkCoach ? theme.secondaryText : .secondary)
                            }
                        } header: {
                            coachSectionHeader("Math · \(mathReading.title)")
                        }
                    }

                    if let cross = ScheduleCrossCategory.block(for: appState.currentWeek, day: weekday) {
                        Section {
                            Text(cross.subtitle)
                                .font(.subheadline)
                                .foregroundStyle(isDarkCoach ? theme.secondaryText : .secondary)
                                .todayListRow(isDarkCoach: isDarkCoach, theme: theme)
                            studyActionRow(
                                title: "Read topic",
                                systemImage: "book.fill",
                                prominent: false
                            ) {
                                navigationPath.append(StudyNavigationRoute.encyclopediaTopic(id: cross.encyclopediaTopicId))
                            }
                            studyActionRow(
                                title: "Practice questions",
                                systemImage: "bolt.fill",
                                prominent: false
                            ) {
                                navigationPath.append(
                                    StudyNavigationRoute.encyclopediaPractice(
                                        .tossUpBonus,
                                        topicIds: cross.topicIds
                                    )
                                )
                            }
                        } header: {
                            coachSectionHeader("\(cross.nsbSubject.rawValue) · \(cross.title)")
                        }
                    }
                } else if let weekend = appState.weekendSuggestion() {
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(weekend.title)
                                .font(.headline)
                            Text(weekend.subtitle)
                                .font(.subheadline)
                                .foregroundStyle(isDarkCoach ? theme.secondaryText : .secondary)
                            if let route = weekend.route {
                                studyActionRow(
                                    title: "Start optional study",
                                    systemImage: "leaf.fill",
                                    prominent: false
                                ) {
                                    navigationPath.append(route)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                        .todayListRow(isDarkCoach: isDarkCoach, theme: theme)

                        if let saturday = ScheduleCrossCategory.saturdaySuggestion(for: appState.currentWeek) {
                            studyActionRow(
                                title: saturday.title,
                                systemImage: "globe.americas.fill",
                                prominent: false
                            ) {
                                navigationPath.append(StudyNavigationRoute.encyclopediaTopic(id: saturday.encyclopediaTopicId))
                            } subtitle: {
                                Text(saturday.subtitle)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        studyActionRow(
                            title: "Browse all topics",
                            systemImage: "books.vertical.fill",
                            prominent: false
                        ) {
                            navigationPath.append(StudyNavigationRoute.topicBrowser(initialWeek: nil))
                        }
                    } header: {
                        coachSectionHeader("Weekend · optional")
                    }
                }

                if ElementData.shouldPromoteElementPractice(
                    week: appState.currentWeek,
                    blocks: appState.scienceBlocks(for: appState.currentWeek)
                ) {
                    Section {
                        Text("\(appState.elementMasteredCount) / \(ElementData.first20.count) mastered · checklist completes at 18")
                            .font(.caption)
                            .foregroundStyle(isDarkCoach ? theme.secondaryText : .secondary)
                            .todayListRow(isDarkCoach: isDarkCoach, theme: theme)

                        studyActionRow(
                            title: "Element flash cards",
                            systemImage: "rectangle.on.rectangle",
                            prominent: false
                        ) {
                            navigationPath.append(StudyNavigationRoute.elementFlashCards)
                        }

                        studyActionRow(
                            title: "Element drill",
                            systemImage: "atom",
                            prominent: false
                        ) {
                            navigationPath.append(StudyNavigationRoute.periodicTableDrill)
                        }

                        studyActionRow(
                            title: "Periodic table reference",
                            systemImage: "tablecells",
                            prominent: false
                        ) {
                            navigationPath.append(StudyNavigationRoute.periodicTableReference)
                        }
                    } header: {
                        coachSectionHeader("Element symbols (H–Ca)")
                    }
                }

                Section {
                    studyActionRow(
                        title: "Regional Sprint packs",
                        systemImage: "flag.fill",
                        prominent: false
                    ) {
                        navigationPath.append(StudyNavigationRoute.regionalSprint)
                    } subtitle: {
                        Text("Phyla · IUPAC · gas laws · pedigrees · centripetal — 11 packs")
                            .font(.caption)
                            .foregroundStyle(isDarkCoach ? theme.secondaryText : .secondary)
                    }
                } header: {
                    coachSectionHeader("Texas Regional Sprint")
                }

                Section {
                    studyActionRow(
                        title: "Browse all topics",
                        systemImage: "books.vertical.fill",
                        prominent: false
                    ) {
                        navigationPath.append(StudyNavigationRoute.topicBrowser(initialWeek: nil))
                    } subtitle: {
                        Text("Same as Weeks tab · filter by subject")
                            .font(.caption)
                            .foregroundStyle(isDarkCoach ? theme.secondaryText : .secondary)
                    }
                    .todayListRow(isDarkCoach: isDarkCoach, theme: theme)
                }

                Section {
                    if let block = appState.todayBlocks().first {
                        studyActionRow(
                            title: "Quiz today's block",
                            systemImage: "bolt.circle.fill",
                            prominent: false
                        ) {
                            navigationPath.append(
                                StudyNavigationRoute.planDrill(
                                    .todayBlock(block, week: appState.currentWeek)
                                )
                            )
                        } subtitle: {
                            Text("Questions only — read the topic first")
                                .font(.caption)
                                .foregroundStyle(isDarkCoach ? theme.secondaryText : .secondary)
                        }
                    }

                    studyActionRow(
                        title: "Quiz this week",
                        systemImage: "calendar.circle.fill",
                        prominent: false
                    ) {
                        navigationPath.append(
                            StudyNavigationRoute.planDrill(.thisWeek(week: appState.currentWeek))
                        )
                    }
                } header: {
                    coachSectionHeader("Practice the plan")
                }

                Section {
                    studyActionRow(
                        title: "iPhone buzzer remote",
                        systemImage: "iphone.gen3.radiowaves.left.and.right",
                        prominent: false
                    ) {
                        navigationPath.append(StudyNavigationRoute.buzzerRemote)
                    } subtitle: {
                        Text("Connect phone on same Wi‑Fi during a buzzer drill")
                            .font(.caption)
                            .foregroundStyle(isDarkCoach ? theme.secondaryText : .secondary)
                    }

                    if let weekday = Weekday.from(Date()) {
                        ForEach(ScheduleConstants.buzzerSlots.filter { $0.weekday == weekday }) { slot in
                            studyActionRow(
                                title: slot.label,
                                systemImage: "bolt.fill",
                                prominent: false
                            ) {
                                navigationPath.append(
                                    StudyNavigationRoute.planDrill(
                                        .buzzer(slot: slot, week: appState.currentWeek)
                                    )
                                )
                            } subtitle: {
                                HStack {
                                    if slot.isMixed {
                                        Text("Mixed Bio · Chem · Phys")
                                    } else if let subject = slot.subjects.first {
                                        SubjectBadge(subject: subject)
                                    }
                                    Text(slot.duration)
                                }
                                .font(.caption)
                                .foregroundStyle(isDarkCoach ? theme.secondaryText : .secondary)
                            }
                        }
                    } else {
                        Text("Buzzer drills run on weekdays during free time.")
                            .foregroundStyle(isDarkCoach ? theme.secondaryText : .secondary)
                            .todayListRow(isDarkCoach: isDarkCoach, theme: theme)
                    }
                } header: {
                    coachSectionHeader("Buzzer drills today")
                }

                if isFriday {
                    Section {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Planning block 4:40 – 5:40 PM")
                                .font(.headline)
                            Text("Score the week · weak spots · 5 toss-up + bonus chains")
                                .font(.subheadline)
                                .foregroundStyle(isDarkCoach ? theme.secondaryText : .secondary)
                            let summary = appState.fridaySummary()
                            if !summary.weakest.isEmpty {
                                Text("Weakest topics: \(summary.weakest.joined(separator: ", "))")
                                    .font(.caption)
                                    .foregroundStyle(isDarkCoach ? theme.secondaryText : .secondary)
                            }
                            studyActionRow(
                                title: "Friday review quiz (full week)",
                                systemImage: "checkmark.circle",
                                prominent: false
                            ) {
                                navigationPath.append(
                                    StudyNavigationRoute.planDrill(.thisWeek(week: appState.currentWeek))
                                )
                            }
                        }
                        .padding(.vertical, 4)
                        .todayListRow(isDarkCoach: isDarkCoach, theme: theme)
                    } header: {
                        coachSectionHeader("Friday review")
                    }
                }

                Section {
                    studyActionRow(
                        title: "Formula reference",
                        systemImage: "function",
                        prominent: false
                    ) {
                        navigationPath.append(StudyNavigationRoute.formulaReference)
                    }
                }
            }
            .todayListStyle(isDarkCoach: isDarkCoach, theme: theme)
            .navigationTitle("Today")
            .largeNavigationBarTitle()
            .studyNavigationDestinations()
            .onAppear {
                appState.refreshScheduleFromCalendar()
            }
        }
    }

    private var gameHeaderSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    Text(CoachCopy.timeGreeting(name: appState.studentName))
                        .font(GameFont.title2())
                        .foregroundStyle(theme.primaryText)
                    Spacer()
                    XPStreakBar(
                        streak: max(appState.studyStreakDays, XPManager.shared.currentStreak),
                        xp: XPManager.shared.totalXP
                    )
                }
                Text(coachNudge)
                    .font(GameFont.caption())
                    .foregroundStyle(theme.secondaryText)
            }
            .listRowBackground(theme.cardBackground)
            .listRowInsets(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
        }
    }

    private var coachNudge: String {
        let streak = max(appState.studyStreakDays, XPManager.shared.currentStreak)
        if streak > 0 {
            return "You're on a \(streak)-day streak. Don't break it today."
        }
        return "Game on — start a drill and earn XP."
    }

    private func coachSectionHeader(_ title: String) -> some View {
        Text(title)
            .font(isDarkCoach ? GameFont.caption(.semibold) : .subheadline)
            .foregroundStyle(isDarkCoach ? theme.secondaryText : .secondary)
            .textCase(nil)
    }

    @ViewBuilder
    private func studyActionRow(
        title: String,
        systemImage: String,
        prominent: Bool,
        action: @escaping () -> Void,
        @ViewBuilder subtitle: () -> some View = { EmptyView() }
    ) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 4) {
                Label(title, systemImage: systemImage)
                    .font(prominent ? .headline : .body)
                subtitle()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .todayListRow(isDarkCoach: isDarkCoach, theme: theme)
    }
}

// MARK: - Today list chrome (dark coach theme vs warm light)

private extension View {
    @ViewBuilder
    func todayListStyle(isDarkCoach: Bool, theme: ThemePalette) -> some View {
        if isDarkCoach {
            self
                #if os(macOS)
                .listStyle(.plain)
                #else
                .listStyle(.insetGrouped)
                #endif
                .scrollContentBackground(.hidden)
                .background(theme.surface)
                .foregroundStyle(theme.primaryText)
                .tint(theme.accent)
        } else {
            self
                .platformListStyle()
        }
    }

    @ViewBuilder
    func todayListRow(isDarkCoach: Bool, theme: ThemePalette, clear: Bool = false) -> some View {
        if isDarkCoach {
            if clear {
                self.listRowBackground(Color.clear)
            } else {
                self.listRowBackground(theme.cardBackground)
            }
        } else {
            self
        }
    }
}
