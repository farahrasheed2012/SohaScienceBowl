import AVFoundation

enum SpeechRatePreset: String, CaseIterable, Identifiable, Codable {
    case slow
    case normal
    case fast

    var id: String { rawValue }

    var label: String {
        switch self {
        case .slow: return "Slow"
        case .normal: return "Normal"
        case .fast: return "Fast"
        }
    }

    var rate: Float {
        switch self {
        case .slow: return 0.32
        case .normal: return 0.42
        case .fast: return 0.52
        }
    }
}

@MainActor
final class SpeechManager: NSObject {
    static let shared = SpeechManager()

    private let synthesizer = AVSpeechSynthesizer()

    override private init() {
        super.init()
        synthesizer.delegate = self
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }

    func speak(_ text: String, rate: Float = SpeechRatePreset.normal.rate, voiceIdentifier: String? = nil) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        stop()
        synthesizer.speak(makeUtterance(trimmed, rate: rate, voiceIdentifier: voiceIdentifier))
    }

    func speakQuestion(_ text: String, rate: Float = SpeechRatePreset.normal.rate, voiceIdentifier: String? = nil) {
        speak(SpeechTextSanitizer.speakable(text), rate: rate, voiceIdentifier: voiceIdentifier)
    }

    func speakAnswer(_ text: String, rate: Float = SpeechRatePreset.normal.rate, voiceIdentifier: String? = nil) {
        speak(SpeechTextSanitizer.speakable(text), rate: rate, voiceIdentifier: voiceIdentifier)
    }

    func speakQuestionWithChoices(
        question: String,
        choices: [(key: String, text: String)],
        rate: Float = SpeechRatePreset.normal.rate,
        voiceIdentifier: String? = nil
    ) {
        var parts = [SpeechTextSanitizer.speakable(question)]
        for choice in choices {
            parts.append("\(choice.key): \(SpeechTextSanitizer.speakable(choice.text))")
        }
        speak(parts.joined(separator: ". "), rate: rate, voiceIdentifier: voiceIdentifier)
    }

    func speakPraise(studentName: String) {
        let name = studentName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "champion" : studentName
        let phrases = [
            "Nice buzz, \(name)!",
            "Great job, \(name)!",
            "You got it, \(name)!",
            "Awesome, \(name)!",
            "Super star, \(name)!",
        ]
        speak(phrases.randomElement() ?? "Great job, \(name)!", rate: 0.44)
    }

    func speakEncouragement(studentName: String) {
        let name = studentName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "friend" : studentName
        let phrases = [
            "Good try, \(name). You'll get the next one.",
            "Keep going, \(name)!",
            "Almost — try the next one.",
        ]
        speak(phrases.randomElement() ?? "Keep going, \(name)!", rate: 0.4)
    }

    private func makeUtterance(_ text: String, rate: Float, voiceIdentifier: String?) -> AVSpeechUtterance {
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = rate
        utterance.pitchMultiplier = 1.05
        utterance.voice = SpeechVoiceCatalog.voice(identifier: voiceIdentifier)
        return utterance
    }
}

extension SpeechManager: AVSpeechSynthesizerDelegate {}
