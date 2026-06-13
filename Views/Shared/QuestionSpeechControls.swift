import SwiftUI

struct QuestionSpeechBar: View {
    @Environment(AppState.self) private var appState

    let questionText: String
    var answerText: String? = nil
    var showAnswerButton: Bool = false
    var choiceTexts: [(key: String, text: String)] = []

    var body: some View {
        if appState.readQuestionsAloud {
            HStack(spacing: 12) {
                Button { replayQuestion(includeChoices: false) } label: {
                    Label("Listen", systemImage: "speaker.wave.2.fill")
                }

                if !choiceTexts.isEmpty {
                    Button { replayQuestion(includeChoices: true) } label: {
                        Label("Choices", systemImage: "list.bullet")
                    }
                }

                Button { replayQuestion(includeChoices: false) } label: {
                    Label("Replay", systemImage: "arrow.clockwise")
                }
                #if os(iOS)
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.35).onEnded { _ in
                        replayQuestion(includeChoices: !choiceTexts.isEmpty)
                    }
                )
                #endif

                if showAnswerButton, let answerText, !answerText.isEmpty {
                    Button {
                        SpeechManager.shared.speakAnswer(
                            answerText,
                            rate: appState.speechRate,
                            voiceIdentifier: appState.speechVoiceIdentifier
                        )
                    } label: {
                        Label("Answer", systemImage: "text.bubble.fill")
                    }
                }

                Spacer()

                #if os(macOS)
                Text("Space to replay")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                #endif
            }
            .font(.subheadline.weight(.semibold))
            .buttonStyle(.bordered)
            .padding(.horizontal, 16)
        }
    }

    private func replayQuestion(includeChoices: Bool) {
        if includeChoices, !choiceTexts.isEmpty {
            SpeechManager.shared.speakQuestionWithChoices(
                question: questionText,
                choices: choiceTexts,
                rate: appState.speechRate,
                voiceIdentifier: appState.speechVoiceIdentifier
            )
        } else {
            SpeechManager.shared.speakQuestion(
                questionText,
                rate: appState.speechRate,
                voiceIdentifier: appState.speechVoiceIdentifier
            )
        }
    }
}

extension View {
    /// Auto-read on appear/change, stop on disappear, Space replays on macOS when enabled.
    func questionSpeech(
        questionText: String?,
        speechToken: some Hashable,
        autoRead: Bool = true,
        spaceReplayEnabled: Bool = true,
        choiceTexts: [(key: String, text: String)] = []
    ) -> some View {
        modifier(
            QuestionSpeechModifier(
                questionText: questionText,
                speechToken: speechToken,
                autoRead: autoRead,
                spaceReplayEnabled: spaceReplayEnabled,
                choiceTexts: choiceTexts
            )
        )
    }
}

private struct QuestionSpeechModifier<Token: Hashable>: ViewModifier {
    @Environment(AppState.self) private var appState

    let questionText: String?
    let speechToken: Token
    var autoRead: Bool
    var spaceReplayEnabled: Bool
    var choiceTexts: [(key: String, text: String)]

    func body(content: Content) -> some View {
        content
            .onAppear { triggerAutoRead() }
            .onChange(of: speechToken) { _, _ in triggerAutoRead() }
            .onDisappear { SpeechManager.shared.stop() }
            #if os(macOS)
            .onKeyPress(.space) {
                guard spaceReplayEnabled, appState.readQuestionsAloud, let questionText else { return .ignored }
                replay(includeChoices: false)
                return .handled
            }
            #endif
    }

    private func triggerAutoRead() {
        guard autoRead, appState.readQuestionsAloud, appState.autoReadQuestions, let questionText else { return }
        SpeechManager.shared.speakQuestion(
            questionText,
            rate: appState.speechRate,
            voiceIdentifier: appState.speechVoiceIdentifier
        )
    }

    private func replay(includeChoices: Bool) {
        guard let questionText else { return }
        if includeChoices, !choiceTexts.isEmpty {
            SpeechManager.shared.speakQuestionWithChoices(
                question: questionText,
                choices: choiceTexts,
                rate: appState.speechRate,
                voiceIdentifier: appState.speechVoiceIdentifier
            )
        } else {
            SpeechManager.shared.speakQuestion(
                questionText,
                rate: appState.speechRate,
                voiceIdentifier: appState.speechVoiceIdentifier
            )
        }
    }
}

@MainActor
enum QuestionSpeechHelper {
    static func autoReadIfNeeded(_ text: String, appState: AppState, includeChoices: [(key: String, text: String)] = []) {
        guard appState.readQuestionsAloud, appState.autoReadQuestions else { return }
        if includeChoices.isEmpty {
            SpeechManager.shared.speakQuestion(
                text,
                rate: appState.speechRate,
                voiceIdentifier: appState.speechVoiceIdentifier
            )
        } else {
            SpeechManager.shared.speakQuestionWithChoices(
                question: text,
                choices: includeChoices,
                rate: appState.speechRate,
                voiceIdentifier: appState.speechVoiceIdentifier
            )
        }
    }

    static func speakPraiseIfNeeded(appState: AppState) {
        guard appState.readQuestionsAloud else { return }
        SpeechManager.shared.speakPraise(studentName: appState.studentName)
    }

    static func speakEncouragementIfNeeded(appState: AppState) {
        guard appState.readQuestionsAloud else { return }
        SpeechManager.shared.speakEncouragement(studentName: appState.studentName)
    }
}
