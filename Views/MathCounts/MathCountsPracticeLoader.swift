import SwiftUI

/// Generates questions on appear so the root list does not build every session up front.
struct MathCountsDailyPracticeLoader: View {
    @Environment(AppState.self) private var appState

    @State private var questions: [MathCountsQuestion] = []

    var body: some View {
        Group {
            if questions.isEmpty {
                ProgressView("Preparing today's practice…")
            } else {
                MathCountsSessionView(
                    questions: questions,
                    level: appState.mathCounts.currentLevel
                )
            }
        }
        .navigationTitle("Daily Practice")
        .inlineNavigationBarTitle()
        .task {
            guard questions.isEmpty else { return }
            questions = appState.mathCounts.questionsForToday()
        }
    }
}

struct MathCountsTopicDrillLoader: View {
    @Environment(AppState.self) private var appState
    let topic: MathCountsTopicArea

    @State private var questions: [MathCountsQuestion] = []

    var body: some View {
        Group {
            if questions.isEmpty {
                ProgressView("Loading \(topic.rawValue)…")
            } else {
                MathCountsSessionView(
                    questions: questions,
                    level: appState.mathCounts.currentLevel,
                    isTopicDrill: true
                )
            }
        }
        .navigationTitle(topic.rawValue)
        .inlineNavigationBarTitle()
        .task {
            guard questions.isEmpty else { return }
            questions = appState.mathCounts.questionsForTopic(topic)
        }
    }
}
