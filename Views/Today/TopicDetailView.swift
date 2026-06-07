import SwiftUI

/// Topic hub — preview then open study material, full session, or quiz.
struct TopicDetailView: View {
    @Environment(AppState.self) private var appState
    let block: StudyBlock

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        SubjectBadge(subject: block.subject)
                        Spacer()
                        Text("Week \(block.week)")
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(PlatformColor.secondaryFill)
                            .clipShape(Capsule())
                    }

                    Text(block.primaryTopic)
                        .font(.title2.weight(.semibold))

                    Label(
                        "\(block.day.fullName) · \(ScheduleConstants.blockTimeLabel(day: block.day, subject: block.subject))",
                        systemImage: "clock"
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                    Text(block.bookLine(for: appState.currentPass))
                        .font(.subheadline)

                    if let theme = DeepDiveContent.weekTheme(week: block.week, pass: appState.currentPass) {
                        Text(theme)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(PlatformColor.systemBlue)
                    }
                }
                .padding(.vertical, 4)
            }

            Section("Focus preview") {
                StudyMaterialBodyText(text: block.focus)
                    .listRowInsets(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
            }

            Section("Study & practice") {
                NavigationLink(value: StudyNavigationRoute.studyMaterial(block)) {
                    Label {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Read study material")
                                .font(.headline)
                            Text("Schedule focus, deep dive, formulas, know cold")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "book.fill")
                            .foregroundStyle(PlatformColor.systemBlue)
                    }
                }

                NavigationLink(value: StudyNavigationRoute.fullSession(block)) {
                    Label {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Full study session")
                                .font(.headline)
                            Text("Read → Know cold → Sample toss-ups")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "text.book.closed.fill")
                            .foregroundStyle(PlatformColor.systemGreen)
                    }
                }

                NavigationLink(value: StudyNavigationRoute.planDrill(.dayBlock(block, week: block.week))) {
                    Label {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Quiz this topic")
                                .font(.headline)
                            Text("Plan-aligned toss-ups · DOE + curriculum")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    } icon: {
                        Image(systemName: "bolt.fill")
                            .foregroundStyle(PlatformColor.systemOrange)
                    }
                }
            }

            let related = appState.encyclopedia.relatedTopics(for: block)
            if !related.isEmpty {
                Section("Encyclopedia articles") {
                    ForEach(related) { topic in
                        NavigationLink(value: StudyNavigationRoute.encyclopediaTopic(id: topic.id)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(topic.title)
                                    .font(.subheadline.weight(.semibold))
                                Text(topic.subject)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }

            if !block.formulasAndTerms.isEmpty {
                Section("Formulas & key terms") {
                    Text(block.formulasAndTerms)
                        .font(.subheadline)
                }
            }
        }
        .navigationTitle(block.primaryTopic)
        .inlineNavigationBarTitle()
        .studyNavigationDestinations()
    }
}
