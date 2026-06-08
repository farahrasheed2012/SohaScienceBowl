import SwiftUI

/// Browse all curriculum topics by week and subject; open study material or quiz from each topic.
struct TopicBrowserView: View {
    @Environment(AppState.self) private var appState

    var initialWeek: Int? = nil

    @State private var selectedWeek: Int = 1
    @State private var subjectFilter: Subject? = nil

    private var filteredBlocks: [StudyBlock] {
        appState.scienceBlocks(for: selectedWeek).filter { block in
            subjectFilter == nil || block.subject == subjectFilter
        }
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

            Section("\(filteredBlocks.count) topics — books & chapters") {
                if filteredBlocks.isEmpty {
                    Text("No topics for this filter.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(filteredBlocks) { block in
                        NavigationLink(value: StudyNavigationRoute.topicDetail(block)) {
                            TopicBrowserRow(block: block, pass: appState.currentPass)
                        }
                    }
                }
            }

            let weekVideos = ScheduleVideoCatalog.dayBlocks(for: selectedWeek)
            if !weekVideos.isEmpty {
                Section("Week \(selectedWeek) optional videos") {
                    Text("Read the book chapters above first — videos are extra.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    ForEach(weekVideos) { block in
                        if !block.links.isEmpty {
                            DisclosureGroup {
                                ForEach(block.links) { link in
                                    ScheduleVideoLinkRow(link: link, subtitle: link.note)
                                }
                            } label: {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("\(block.day.shortName) · \(block.label)")
                                        .font(.subheadline.weight(.medium))
                                    Text("\(block.links.count) video\(block.links.count == 1 ? "" : "s")")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
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
