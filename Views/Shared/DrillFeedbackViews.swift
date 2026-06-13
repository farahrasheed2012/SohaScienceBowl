import SwiftUI

struct DrillAnswerFeedback: Equatable {
    var correct: Bool
    var headline: String
    var explanationTopic: NSBTopic?

    static func == (lhs: DrillAnswerFeedback, rhs: DrillAnswerFeedback) -> Bool {
        lhs.correct == rhs.correct && lhs.headline == rhs.headline && lhs.explanationTopic?.id == rhs.explanationTopic?.id
    }
}

@MainActor
enum DrillFeedbackMessages {
    static func praise(for studentName: String) -> String {
        let name = studentName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Soha" : studentName
        let phrases = [
            "Nice buzz, \(name)!",
            "Great job, \(name)!",
            "You got it, \(name)!",
            "Awesome, \(name)!",
            "Super star, \(name)!",
        ]
        return phrases.randomElement() ?? "Great job, \(name)!"
    }

    static func encouragement(for studentName: String) -> String {
        let name = studentName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Soha" : studentName
        let phrases = [
            "Good try, \(name). You'll get the next one.",
            "Keep going, \(name)!",
            "Almost — try the next one.",
        ]
        return phrases.randomElement() ?? "Keep going, \(name)!"
    }

    static func onCorrect(appState: AppState) {
        QuestionSpeechHelper.speakPraiseIfNeeded(appState: appState)
    }

    static func onIncorrect(appState: AppState) {
        QuestionSpeechHelper.speakEncouragementIfNeeded(appState: appState)
    }

    @MainActor
    static func makeFeedback(correct: Bool, question: UnifiedQuestion, appState: AppState) -> DrillAnswerFeedback {
        if correct {
            return DrillAnswerFeedback(
                correct: true,
                headline: praise(for: appState.studentName),
                explanationTopic: nil
            )
        }
        return DrillAnswerFeedback(
            correct: false,
            headline: encouragement(for: appState.studentName),
            explanationTopic: appState.encyclopedia.topic(forQuestion: question)
        )
    }
}

struct DrillFeedbackBanner: View {
    let feedback: DrillAnswerFeedback

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: feedback.correct ? "hand.thumbsup.fill" : "heart.fill")
                .foregroundStyle(feedback.correct ? .green : .orange)
            Text(feedback.headline)
                .font(.headline.weight(.semibold))
                .foregroundStyle(feedback.correct ? .green : .orange)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background((feedback.correct ? Color.green : Color.orange).opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .accessibilityLabel(feedback.headline)
    }
}

struct DrillTopicExplanationCard: View {
    @Environment(\.themePalette) private var theme

    let topic: NSBTopic

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Learn: \(topic.title)", systemImage: "book.fill")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(theme.accent)

            Text(topic.whatIsIt)
                .font(.subheadline)
                .foregroundStyle(theme.primaryText)
                .fixedSize(horizontal: false, vertical: true)

            if !topic.howItWorks.isEmpty {
                Text(topic.howItWorks)
                    .font(.caption)
                    .foregroundStyle(theme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let trap = topic.nsbTraps.first {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                    Text(trap)
                        .font(.caption.weight(.medium))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(14)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .background(theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct DrillAnswerFeedbackPanel: View {
    let feedback: DrillAnswerFeedback
    let nextLabel: String
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            DrillFeedbackBanner(feedback: feedback)

            if let topic = feedback.explanationTopic {
                DrillTopicExplanationCard(topic: topic)
            } else if !feedback.correct {
                Text("Review the answer above, then keep going.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Button(nextLabel, action: onNext)
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }
}
