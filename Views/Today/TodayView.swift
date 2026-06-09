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
                        }
                    }
                } else {
                    Text("Weekend — use Browse all topics for books, chapters, and videos.")
                        .foregroundStyle(.secondary)
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
