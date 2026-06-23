import SwiftUI

/// Browse all curriculum topics by week and subject; open study material or quiz from each topic.
struct TopicBrowserView: View {
    @Environment(AppState.self) private var appState

    var initialWeek: Int? = nil

    @State private var selectedWeek: Int = 1
    @State private var subjectFilter: Subject? = nil

    private var weekScienceBlocks: [StudyBlock] {
        appState.scienceBlocks(for: selectedWeek)
    }

    private var filteredScienceBlocks: [StudyBlock] {
        weekScienceBlocks.filter { block in
            subjectFilter == nil || block.subject == subjectFilter
        }
    }

    private var filteredMathDays: [Weekday] {
        Weekday.allCases.filter { day in
            ScheduleOpenStaxCatalog.mathReading(week: selectedWeek, day: day) != nil
        }
    }

    private var showMathTopics: Bool {
        subjectFilter == nil
    }

    private var topicCount: Int {
        filteredScienceBlocks.count + (showMathTopics ? filteredMathDays.count : 0)
    }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Week \(selectedWeek) · \(appState.weekTheme(for: selectedWeek))")
                        .font(.headline)
                    Text("\(ScheduleConstants.weekDateRangeLabel(for: selectedWeek)) · \(ScheduleConstants.passLabel(for: appState.currentPass))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }

            Section {
                Picker("Week", selection: $selectedWeek) {
                    ForEach(1...12, id: \.self) { week in
                        Text("Week \(week)").tag(week)
                    }
                }

                Picker("Subject", selection: $subjectFilter) {
                    Text("All").tag(Optional<Subject>.none)
                    ForEach(Subject.allCases) { subject in
                        Text(subject.rawValue).tag(Optional(subject))
                    }
                }
                .pickerStyle(.segmented)
            }

            Section {
                NavigationLink(value: StudyNavigationRoute.planDrill(.thisWeek(week: selectedWeek))) {
                    Label("Quiz all topics this week", systemImage: "bolt.circle.fill")
                }
            }

            Section("\(topicCount) topics — books & chapters") {
                if topicCount == 0 {
                    Text("No topics for this filter.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(filteredScienceBlocks) { block in
                        NavigationLink(value: StudyNavigationRoute.topicDetail(block)) {
                            WeekTopicBrowserRow(block: block, pass: appState.currentPass)
                        }
                    }

                    if showMathTopics {
                        ForEach(filteredMathDays) { day in
                            if let reading = ScheduleOpenStaxCatalog.mathReading(week: selectedWeek, day: day) {
                                NavigationLink(
                                    value: StudyNavigationRoute.mathTopicDetail(
                                        MathTopicRef(week: selectedWeek, day: day)
                                    )
                                ) {
                                    WeekMathTopicBrowserRow(
                                        reading: reading,
                                        day: day,
                                        week: selectedWeek
                                    )
                                }
                            }
                        }
                    }
                }
            }

            let weekVideos = ScheduleVideoCatalog.dayBlocks(for: selectedWeek)
            if !weekVideos.isEmpty {
                Section("Week \(selectedWeek) — reading & optional videos") {
                    Text("Books and chapters first; videos are extra.")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ForEach(weekVideos) { block in
                        if !block.links.isEmpty || hasReading(for: block) {
                            DisclosureGroup {
                                WeekVideoBlockReadingContent(
                                    block: block,
                                    scienceBlocks: weekScienceBlocks,
                                    activePass: appState.currentPass
                                )

                                if !block.links.isEmpty {
                                    Divider()
                                        .padding(.vertical, 4)

                                    ForEach(block.links) { link in
                                        ScheduleVideoLinkRow(link: link, subtitle: link.note)
                                    }
                                }
                            } label: {
                                WeekVideoBlockLabel(block: block, scienceBlocks: weekScienceBlocks)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Browse topics")
        .inlineNavigationBarTitle()
        .studyNavigationDestinations()
        .onAppear {
            selectedWeek = initialWeek ?? appState.currentWeek
        }
    }

    private func hasReading(for block: ScheduleVideoCatalog.DayBlockVideos) -> Bool {
        if ScheduleVideoCatalog.isMathBlock(block.label) {
            return ScheduleOpenStaxCatalog.mathReading(week: block.week, day: block.day) != nil
        }
        return scienceBlock(for: block) != nil
    }

    private func scienceBlock(for videoBlock: ScheduleVideoCatalog.DayBlockVideos) -> StudyBlock? {
        guard let subject = ScheduleVideoCatalog.scienceSubject(for: videoBlock.label) else { return nil }
        return weekScienceBlocks.first { $0.day == videoBlock.day && $0.subject == subject }
    }
}
