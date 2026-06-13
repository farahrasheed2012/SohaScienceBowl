import AVFoundation

enum SpeechVoiceCatalog {
    static let previewSampleQuestion = "What subatomic particle carries a negative charge?"

    /// Best installed English voice — prefers Premium/Enhanced en-US, then any Enhanced.
    static var preferredDefaultVoiceIdentifier: String? {
        preferredEnglishVoice()?.identifier
    }

    static func preferredEnglishVoice() -> AVSpeechSynthesisVoice? {
        rankedEnglishVoices().first
    }

    /// Voices for Settings, best quality first; hides compact voices when Enhanced exist.
    static var pickerVoices: [AVSpeechSynthesisVoice] {
        let ranked = rankedEnglishVoices()
        let highQuality = ranked.filter { $0.quality != .default }
        return highQuality.isEmpty ? ranked : highQuality
    }

    static func voice(identifier: String?) -> AVSpeechSynthesisVoice {
        if let identifier,
           let voice = AVSpeechSynthesisVoice(identifier: identifier) {
            return voice
        }
        if let preferred = preferredEnglishVoice() {
            return preferred
        }
        return AVSpeechSynthesisVoice(language: "en-US")
            ?? AVSpeechSynthesisVoice.speechVoices().first!
    }

    static func displayName(for voice: AVSpeechSynthesisVoice) -> String {
        let tier = qualityLabel(voice.quality)
        return "\(voice.name) · \(tier) (\(voice.language))"
    }

    static func qualityLabel(_ quality: AVSpeechSynthesisVoiceQuality) -> String {
        switch quality {
        case .premium: return "Premium"
        case .enhanced: return "Enhanced"
        default: return "Standard"
        }
    }

    private static func rankedEnglishVoices() -> [AVSpeechSynthesisVoice] {
        AVSpeechSynthesisVoice.speechVoices()
            .filter { $0.language.hasPrefix("en") }
            .sorted { rank($0) > rank($1) }
    }

    private static func rank(_ voice: AVSpeechSynthesisVoice) -> Int {
        var score = 0
        switch voice.quality {
        case .premium: score += 100
        case .enhanced: score += 80
        default: score += 10
        }
        if voice.language == "en-US" { score += 20 }
        else if voice.language.hasPrefix("en-") { score += 10 }
        return score
    }
}
