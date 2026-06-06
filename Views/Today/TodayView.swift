import SwiftUI

struct TodayView: View {
    @Environment(AppState.self) private var appState

    private var isFriday: Bool {
        Weekday.from(Date()) == .friday
    }

    var body: some View {
        NavigationStack {
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
                        NavigationLink {
                            BlockStudyMaterialView(block: block)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Label("Read today's topic", systemImage: "book.fill")
                                    .font(.headline)
                                Text("\(block.subject.rawValue) · \(block.primaryTopic)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(block.bookLine(for: appState.currentPass))
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        NavigationLink {
                            StudySessionView(block: block, initialStage: .read)
                        } label: {
                            Label("Full study session (Read → Know cold → Quiz)", systemImage: "text.book.closed.fill")
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

                                VStack(spacing: 10) {
                                    NavigationLink {
                                        BlockStudyMaterialView(block: block)
                                    } label: {
                                        Text("Read study material")
                                            .font(.subheadline.weight(.semibold))
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
                                    }
                                    .buttonStyle(.borderedProminent)

                                    HStack(spacing: 12) {
                                        NavigationLink {
                                            StudySessionView(block: block, initialStage: .read)
                                        } label: {
                                            Text("Full session")
                                                .font(.subheadline.weight(.semibold))
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 10)
                                        }
                                        .buttonStyle(.bordered)

                                        NavigationLink {
                                            PlanDrillView(request: .todayBlock(block, week: appState.currentWeek))
                                        } label: {
                                            Text("Quiz only")
                                                .font(.subheadline.weight(.semibold))
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, 10)
                                        }
                                        .buttonStyle(.bordered)
                                    }
                                }
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                    }
                }

                Section("Practice the plan") {
                    if let block = appState.todayBlocks().first {
                        NavigationLink {
                            PlanDrillView(request: .todayBlock(block, week: appState.currentWeek))
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Label("Quiz today's block", systemImage: "bolt.circle.fill")
                                Text("Questions only — read the topic first")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }

                    NavigationLink {
                        PlanDrillView(request: .thisWeek(week: appState.currentWeek))
                    } label: {
                        Label("Quiz this week", systemImage: "calendar.circle.fill")
                    }

                    NavigationLink {
                        WeekPlanView()
                    } label: {
                        Label("See full week topics", systemImage: "list.bullet.rectangle")
                    }
                }

                Section("Buzzer drills today") {
                    if let weekday = Weekday.from(Date()) {
                        ForEach(ScheduleConstants.buzzerSlots.filter { $0.weekday == weekday }) { slot in
                            NavigationLink {
                                PlanDrillView(request: .buzzer(slot: slot, week: appState.currentWeek))
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(slot.label)
                                            .font(.subheadline)
                                        HStack {
                                            if slot.isMixed {
                                                Text("Mixed Bio · Chem · Phys")
                                                    .font(.caption)
                                                    .foregroundStyle(.secondary)
                                            } else {
                                                SubjectBadge(subject: slot.subject)
                                            }
                                            Text(slot.duration)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    Spacer()
                                    Image(systemName: "bolt.fill")
                                        .foregroundStyle(Color(uiColor: .systemBlue))
                                        .accessibilityHidden(true)
                                }
                                .padding(.vertical, 4)
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
                            NavigationLink {
                                PlanDrillView(request: .thisWeek(week: appState.currentWeek))
                            } label: {
                                Label("Friday review quiz (full week)", systemImage: "checkmark.circle")
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section {
                    NavigationLink("Formula reference") {
                        FormulaReferenceView()
                    }
                }
            }
            .navigationTitle("Today")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                appState.refreshScheduleFromCalendar()
            }
        }
    }
}
