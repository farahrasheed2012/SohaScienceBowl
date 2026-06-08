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
                    Text(ScheduleConstants.passLabel(for: appState.currentPass))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }

            Section {
                Picker("Week", selection: $selectedWeek) {
                    ForEach(1...10, id: \.self) { week in
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
                            TopicBrowserRow(block: block, pass: appState.currentPass)
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
                                    MathTopicBrowserRow(
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

private struct WeekVideoBlockLabel: View {
    let block: ScheduleVideoCatalog.DayBlockVideos
    let scienceBlocks: [StudyBlock]

    private var subtitle: String {
        if ScheduleVideoCatalog.isMathBlock(block.label),
           let reading = ScheduleOpenStaxCatalog.mathReading(week: block.week, day: block.day) {
            return "OSA · Lar · BFN-A · \(reading.title)"
        }
        if let subject = ScheduleVideoCatalog.scienceSubject(for: block.label),
           let studyBlock = scienceBlocks.first(where: { $0.day == block.day && $0.subject == subject }) {
            return studyBlock.bookLine(for: .pass1)
        }
        return block.label
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("\(block.day.shortName) · \(block.label)")
                .font(.subheadline.weight(.medium))
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            if !block.links.isEmpty {
                Text("\(block.links.count) optional video\(block.links.count == 1 ? "" : "s")")
                    .font(.caption2)
                    .foregroundStyle(PlatformColor.systemRed)
            }
        }
    }
}

private struct WeekVideoBlockReadingContent: View {
    let block: ScheduleVideoCatalog.DayBlockVideos
    let scienceBlocks: [StudyBlock]
    let activePass: StudyPass

    var body: some View {
        if ScheduleVideoCatalog.isMathBlock(block.label),
           let reading = ScheduleOpenStaxCatalog.mathReading(week: block.week, day: block.day) {
            StudyMathBookOptionsCard(reading: reading)
        } else if let subject = ScheduleVideoCatalog.scienceSubject(for: block.label),
                  let studyBlock = scienceBlocks.first(where: { $0.day == block.day && $0.subject == subject }) {
            StudyBookOptionsCard(block: studyBlock, activePass: activePass, compact: true)
        }
    }
}

private struct TopicBrowserRow: View {
    let block: StudyBlock
    let pass: StudyPass

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            SubjectBadge(subject: block.subject)
            VStack(alignment: .leading, spacing: 4) {
                Text(block.primaryTopic)
                    .font(.subheadline.weight(.semibold))
                Text("\(block.day.fullName) · \(ScheduleConstants.blockTimeLabel(day: block.day, subject: block.subject))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(block.bookLine(for: pass))
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.secondary)
                if !block.allBookOptions(activePass: pass).isEmpty {
                    Text("+\(block.allBookOptions(activePass: pass).count) reading options")
                        .font(.caption2)
                        .foregroundStyle(PlatformColor.systemBlue)
                }
                let videoCount = ScheduleVideoCatalog.scienceLinks(for: block).count
                if videoCount > 0 {
                    Label("\(videoCount) optional video\(videoCount == 1 ? "" : "s")", systemImage: "play.circle")
                        .font(.caption2)
                        .foregroundStyle(PlatformColor.systemRed)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

private struct MathTopicBrowserRow: View {
    let reading: ScheduleOpenStaxCatalog.MathReading
    let day: Weekday
    let week: Int

    private var videoCount: Int {
        ScheduleVideoCatalog.mathLinks(week: week, day: day).count
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("Math")
                .font(.caption2.weight(.bold))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(PlatformColor.systemPurple.opacity(0.15))
                .foregroundStyle(PlatformColor.systemPurple)
                .clipShape(Capsule())

            VStack(alignment: .leading, spacing: 4) {
                Text(reading.title)
                    .font(.subheadline.weight(.semibold))
                Text("\(day.fullName) · \(ScheduleConstants.mathBlockTimeLabel(day: day))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("OSA §\(reading.sectionKeys.filter { $0 != "home" }.joined(separator: " · §"))")
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.secondary)
                Text("Also OK: \(reading.larBackupLine) · Backup: \(ScheduleBFNCatalog.algebraOptionText(for: reading.title))")
                    .font(.caption2)
                    .foregroundStyle(PlatformColor.systemBlue)
                    .lineLimit(3)
                if videoCount > 0 {
                    Label("\(videoCount) optional video\(videoCount == 1 ? "" : "s")", systemImage: "play.circle")
                        .font(.caption2)
                        .foregroundStyle(PlatformColor.systemRed)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
