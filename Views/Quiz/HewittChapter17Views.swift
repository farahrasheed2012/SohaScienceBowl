import SwiftUI

struct HewittChapter17RootView: View {
    @Environment(AppState.self) private var appState

    private var questionCount: Int {
        appState.encyclopedia.questionCount(for: HewittChapter17Catalog.topicId)
    }

    var body: some View {
        List {
            Section {
                Text(HewittChapter17Catalog.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text("\(questionCount) questions · toss-up + bonus pairs")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("Sections") {
                ForEach(HewittChapter17Catalog.sections, id: \.id) { section in
                    let count = appState.encyclopedia.questions(
                        forTopicIds: [HewittChapter17Catalog.topicId],
                        limit: 100,
                        type: nil
                    ).filter { $0.subtopic.contains("§\(section.id)") }.count
                    HStack {
                        Text("§\(section.id)")
                            .font(.caption.monospaced())
                            .foregroundStyle(.secondary)
                        Text(section.title)
                        Spacer()
                        Text("\(count)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section {
                NavigationLink(value: StudyNavigationRoute.encyclopediaTopic(id: HewittChapter17Catalog.topicId)) {
                    Label("Read topic article", systemImage: "book.fill")
                }
                NavigationLink(value: StudyNavigationRoute.encyclopediaPractice(.tossUpBonus, topicIds: [HewittChapter17Catalog.topicId])) {
                    Label("Toss-up & bonus practice", systemImage: "timer")
                }
                NavigationLink(value: StudyNavigationRoute.encyclopediaPractice(.multipleChoice, topicIds: [HewittChapter17Catalog.topicId])) {
                    Label("Multiple choice practice", systemImage: "list.bullet.rectangle")
                }
                NavigationLink(value: StudyNavigationRoute.planDrill(.hewittChapter17)) {
                    Label("Start timed drill", systemImage: "bolt.fill")
                        .font(.headline)
                }
            }
        }
        .navigationTitle(HewittChapter17Catalog.title)
        .inlineNavigationBarTitle()
    }
}
