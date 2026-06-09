import SwiftUI

/// Shared week schedule: daily blocks, books/chapters, optional videos, and quiz links.
struct WeekScheduleContent: View {
    @Environment(AppState.self) private var appState

    let week: Int
    var showWeekHeader: Bool = false

    private var scienceBlocks: [StudyBlock] {
        appState.scienceBlocks(for: week)
    }

    private var topicCount: Int {
        scienceBlocks.count + Weekday.allCases.filter {
            ScheduleOpenStaxCatalog.mathReading(week: week, day: $0) != nil
        }.count
    }

    var body: some View {
        Group {
            if showWeekHeader {
                Section {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Week \(week) · \(appState.weekTheme(for: week))")
                            .font(.headline)
                        Text("\(ScheduleConstants.weekDateRangeLabel(for: week)) · \(ScheduleConstants.passLabel(for: ScheduleConstants.studyPass(forWeek: week)))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }

            Section {
                NavigationLink(value: StudyNavigationRoute.planDrill(.thisWeek(week: week))) {
                    Label("Quiz all topics this week", systemImage: "bolt.circle.fill")
                }
            }

            ForEach(Weekday.allCases) { day in
                if dayHasContent(day) {
                    Section(day.fullName) {
                        if let block = scienceBlocks.first(where: { $0.day == day }) {
                            dayScienceBlock(block)
                        }

                        if let reading = ScheduleOpenStaxCatalog.mathReading(week: week, day: day) {
                            dayMathBlock(reading: reading, day: day)
                        }
                    }
                }
            }

            let weekVideos = ScheduleVideoCatalog.dayBlocks(for: week)
            if !weekVideos.isEmpty {
                Section("Reading & optional videos") {
                    Text("Books and chapters first; videos are extra.")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ForEach(weekVideos) { block in
                        if !block.links.isEmpty || hasReading(for: block) {
                            DisclosureGroup {
                                WeekVideoBlockReadingContent(
                                    block: block,
                                    scienceBlocks: scienceBlocks,
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
                                WeekVideoBlockLabel(block: block, scienceBlocks: scienceBlocks)
                            }
                        }
                    }
                }
            }

            if topicCount == 0 {
                Section {
                    Text("No topics scheduled for this week.")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func dayHasContent(_ day: Weekday) -> Bool {
        scienceBlocks.contains { $0.day == day }
            || ScheduleOpenStaxCatalog.mathReading(week: week, day: day) != nil
    }

    @ViewBuilder
    private func dayScienceBlock(_ block: StudyBlock) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                SubjectBadge(subject: block.subject)
                Text(ScheduleConstants.blockTimeLabel(day: block.day, subject: block.subject))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(block.primaryTopic)
                .font(.subheadline.weight(.semibold))

            StudyBlockReadingAndVideos(
                block: block,
                activePass: appState.currentPass,
                compact: true
            )

            HStack(spacing: 12) {
                NavigationLink(value: StudyNavigationRoute.topicDetail(block)) {
                    Text("Topic")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                NavigationLink(value: StudyNavigationRoute.studyMaterial(block)) {
                    Text("Study")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }

            NavigationLink(value: StudyNavigationRoute.planDrill(.dayBlock(block, week: week))) {
                Label("Quiz this block", systemImage: "bolt")
                    .font(.caption.weight(.medium))
            }
        }
        .padding(.vertical, 4)
        .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
        .listRowBackground(Color.clear)
    }

    @ViewBuilder
    private func dayMathBlock(reading: ScheduleOpenStaxCatalog.MathReading, day: Weekday) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Math")
                    .font(.caption2.weight(.bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(PlatformColor.systemPurple.opacity(0.15))
                    .foregroundStyle(PlatformColor.systemPurple)
                    .clipShape(Capsule())
                Text(ScheduleConstants.mathBlockTimeLabel(day: day))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(reading.title)
                .font(.subheadline.weight(.semibold))

            StudyMathReadingAndVideos(
                reading: reading,
                week: week,
                day: day
            )

            HStack(spacing: 12) {
                NavigationLink(value: StudyNavigationRoute.mathTopicDetail(MathTopicRef(week: week, day: day))) {
                    Text("Topic")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(.vertical, 4)
        .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
        .listRowBackground(Color.clear)
    }

    private func hasReading(for block: ScheduleVideoCatalog.DayBlockVideos) -> Bool {
        if ScheduleVideoCatalog.isMathBlock(block.label) {
            return ScheduleOpenStaxCatalog.mathReading(week: block.week, day: block.day) != nil
        }
        return scienceBlock(for: block) != nil
    }

    private func scienceBlock(for videoBlock: ScheduleVideoCatalog.DayBlockVideos) -> StudyBlock? {
        guard let subject = ScheduleVideoCatalog.scienceSubject(for: videoBlock.label) else { return nil }
        return scienceBlocks.first { $0.day == videoBlock.day && $0.subject == subject }
    }
}

struct WeekVideoBlockLabel: View {
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

struct WeekVideoBlockReadingContent: View {
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

struct WeekTopicBrowserRow: View {
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

struct WeekMathTopicBrowserRow: View {
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
