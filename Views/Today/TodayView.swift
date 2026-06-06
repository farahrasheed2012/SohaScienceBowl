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
                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Week \(appState.currentWeek) · \(appState.weekTheme(for: appState.currentWeek))")
                            .font(.headline)
                        Text(ScheduleConstants.passLabel(for: appState.currentPass))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }

                if let block = appState.todayBlocks().first {
                    Section("Study today") {
                        studyActionRow(
                            title: "Read today's topic",
                            systemImage: "book.fill",
                            prominent: true
                        ) {
                            navigationPath.append(StudyNavigationRoute.studyMaterial(block))
                        } subtitle: {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(block.subject.rawValue) · \(block.primaryTopic)")
                                Text(block.bookLine(for: appState.currentPass))
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }

                        studyActionRow(
                            title: "Full study session (Read → Know cold → Quiz)",
                            systemImage: "text.book.closed.fill",
                            prominent: false
                        ) {
                            navigationPath.append(StudyNavigationRoute.fullSession(block))
                        }
                    }
                }

                Section("Today's blocks") {
                    if appState.todayBlocks().isEmpty {
                        Text("No science blocks scheduled for today.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(appState.todayBlocks()) { block in
                            VStack(alignment: .leading, spacing: 12) {
                                StudyBlockCard(
                                    block: block,
                                    pass: appState.currentPass,
                                    timeLabel: ScheduleConstants.blockTimeLabel(day: block.day, subject: block.subject)
                                )

                                Button {
                                    navigationPath.append(StudyNavigationRoute.studyMaterial(block))
                                } label: {
                                    Text("Read study material")
                                        .font(.subheadline.weight(.semibold))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                }
                                .buttonStyle(.borderedProminent)

                                HStack(spacing: 12) {
                                    Button {
                                        navigationPath.append(StudyNavigationRoute.fullSession(block))
                                    } label: {
                                        Text("Full session")
                                            .font(.subheadline.weight(.semibold))
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
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
                                            .font(.subheadline.weight(.semibold))
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
                                    }
                                    .buttonStyle(.bordered)
                                }
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
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
                        Text("Weeks 1–10 · Biology, Chemistry, Physics · read or quiz any topic")
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

                    studyActionRow(
                        title: "Browse all topics",
                        systemImage: "books.vertical.fill",
                        prominent: false
                    ) {
                        navigationPath.append(StudyNavigationRoute.topicBrowser(initialWeek: nil))
                    }
                }

                Section("Buzzer drills today") {
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
            .navigationTitle("Today")
            .navigationBarTitleDisplayMode(.large)
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
