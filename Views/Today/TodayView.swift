import SwiftUI

struct TodayView: View {
    @Environment(AppState.self) private var appState
    @State private var navigationPath = NavigationPath()

    private var isFriday: Bool {
        Weekday.from(Date()) == .friday
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
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
                                .foregroundStyle(.secondary)
                            Text(next.duration)
                                .font(.caption)
                                .foregroundStyle(.secondary)
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
                    }
                }

                if appState.studyStreakDays > 0 || !appState.earnedBadges().isEmpty {
                    Section("Streaks & badges") {
                        if appState.studyStreakDays > 0 {
                            Label("\(appState.studyStreakDays)-day study streak", systemImage: "flame.fill")
                                .foregroundStyle(.orange)
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
                        }
                    }
                }

                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Week \(appState.currentWeek) · \(appState.weekTheme(for: appState.currentWeek))")
                            .font(.headline)
                        Text(ScheduleConstants.passLabel(for: appState.currentPass))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(appState.doeStore.drillReadinessLabel)
                            .font(.caption)
                            .foregroundStyle(appState.doeStore.isDrillReady ? .green : .secondary)
                    }
                    .padding(.vertical, 4)
                }

                if !appState.flashCardsDueToday.isEmpty || !appState.weakTopics.isEmpty {
                    Section("Today's review") {
                        if !appState.flashCardsDueToday.isEmpty {
                            Text("\(appState.flashCardsDueToday.count) flash cards due")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        if let weak = appState.weakTopics.first {
                            Text("Weakest: \(weak.topic) (\(Int(weak.accuracy * 100))%)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        studyActionRow(
                            title: "Review weak areas",
                            systemImage: "arrow.counterclockwise.circle.fill",
                            prominent: false
                        ) {
                            navigationPath.append(StudyNavigationRoute.weakAreaReview)
                        }
                    }
                }

                if let weekday = Weekday.from(Date()) {
                    ForEach(appState.todayBlocks()) { block in
                        Section("\(block.subject.rawValue) · \(block.primaryTopic)") {
                            StudyBlockReadingAndVideos(
                                block: block,
                                activePass: appState.currentPass,
                                compact: true
                            )
                            .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                            .listRowBackground(Color.clear)

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
                        }
                    }

                    if let mathReading = ScheduleOpenStaxCatalog.mathReading(
                        week: appState.currentWeek,
                        day: weekday
                    ) {
                        Section("Math · \(mathReading.title)") {
                            StudyMathReadingAndVideos(
                                reading: mathReading,
                                week: appState.currentWeek,
                                day: weekday
                            )
                            .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                            .listRowBackground(Color.clear)

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
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }

                    if let cross = ScheduleCrossCategory.block(for: appState.currentWeek, day: weekday) {
                        Section("\(cross.nsbSubject.rawValue) · \(cross.title)") {
                            Text(cross.subtitle)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
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
                        }
                    }
                } else if let weekend = appState.weekendSuggestion() {
                    Section("Weekend · optional") {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(weekend.title)
                                .font(.headline)
                            Text(weekend.subtitle)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
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
                    }
                }

                if ElementData.shouldPromoteElementPractice(
                    week: appState.currentWeek,
                    blocks: appState.blocks(for: appState.currentWeek, pass: appState.currentPass)
                ) {
                    Section("Element symbols (H–Ca)") {
                        Text("\(appState.elementMasteredCount) / \(ElementData.first20.count) mastered · checklist completes at 18")
                            .font(.caption)
                            .foregroundStyle(.secondary)

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
                    }
                }

                Section("Texas Regional Sprint") {
                    studyActionRow(
                        title: "Regional Sprint packs",
                        systemImage: "flag.fill",
                        prominent: false
                    ) {
                        navigationPath.append(StudyNavigationRoute.regionalSprint)
                    } subtitle: {
                        Text("Phyla · IUPAC · gas laws · pedigrees · centripetal — 11 packs")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
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
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Practice the plan") {
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
                                .foregroundStyle(.secondary)
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
                }

                Section("Buzzer drills today") {
                    studyActionRow(
                        title: "iPhone buzzer remote",
                        systemImage: "iphone.gen3.radiowaves.left.and.right",
                        prominent: false
                    ) {
                        navigationPath.append(StudyNavigationRoute.buzzerRemote)
                    } subtitle: {
                        Text("Connect phone on same Wi‑Fi during a buzzer drill")
                            .font(.caption)
                            .foregroundStyle(.secondary)
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
                                .foregroundStyle(.secondary)
                            }
                        }
                    } else {
                        Text("Buzzer drills run on weekdays during free time.")
                            .foregroundStyle(.secondary)
                    }
                }

                if isFriday {
                    Section("Friday review") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Planning block 4:40 – 5:40 PM")
                                .font(.headline)
                            Text("Score the week · weak spots · 5 toss-up + bonus chains")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            let summary = appState.fridaySummary()
                            if !summary.weakest.isEmpty {
                                Text("Weakest topics: \(summary.weakest.joined(separator: ", "))")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
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
            .platformListStyle()
            .navigationTitle("Today")
            .largeNavigationBarTitle()
            .studyNavigationDestinations()
            .onAppear {
                appState.refreshScheduleFromCalendar()
            }
        }
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
    }
}
