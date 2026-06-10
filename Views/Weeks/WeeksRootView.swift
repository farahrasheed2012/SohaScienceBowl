import SwiftUI

struct WeeksRootView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("10-week summer plan · Jun 8 – Aug 14, 2026")
                            .font(.subheadline)
                        Text(ScheduleConstants.passLabel(for: appState.currentPass))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("Mon–Fri science blocks + daily math · assigned § sections first, videos optional")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }

                Section("All weeks") {
                    ForEach(1...10, id: \.self) { week in
                        NavigationLink(value: week) {
                            weekRow(week)
                        }
                    }
                }
            }
            .navigationTitle("Weeks")
            .largeNavigationBarTitle()
            .navigationDestination(for: Int.self) { week in
                WeekDetailView(week: week)
            }
            .studyNavigationDestinations()
            .onAppear {
                appState.refreshScheduleFromCalendar()
            }
        }
    }

    private func weekRow(_ week: Int) -> some View {
        let blocks = appState.scienceBlocks(for: week)
        let mathDays = Weekday.allCases.filter {
            ScheduleOpenStaxCatalog.mathReading(week: week, day: $0) != nil
        }.count
        let isCurrent = week == appState.currentWeek

        return HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text("Week \(week)")
                        .font(.body.weight(.semibold))
                    if isCurrent {
                        Text("Current")
                            .font(.caption2.weight(.bold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(PlatformColor.systemGreen.opacity(0.15))
                            .foregroundStyle(PlatformColor.systemGreen)
                            .clipShape(Capsule())
                    }
                }

                Text(appState.weekTheme(for: week))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text("\(ScheduleConstants.weekDateRangeLabel(for: week)) · \(ScheduleConstants.passLabel(for: ScheduleConstants.studyPass(forWeek: week)))")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("\(blocks.count) science · \(mathDays) math")
                    .font(.caption2)
                    .foregroundStyle(PlatformColor.systemBlue)
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, 2)
    }
}

struct WeekDetailView: View {
    @Environment(AppState.self) private var appState
    let week: Int

    var body: some View {
        List {
            WeekScheduleContent(week: week, showWeekHeader: true)
        }
        .navigationTitle("Week \(week)")
        .inlineNavigationBarTitle()
        .studyNavigationDestinations()
        .toolbar {
            if week != appState.currentWeek {
                ToolbarItem(placement: .primaryAction) {
                    Button("Set as current") {
                        appState.userDidSetWeek(week)
                    }
                }
            }
        }
    }
}
