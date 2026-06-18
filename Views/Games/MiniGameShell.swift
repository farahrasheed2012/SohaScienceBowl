import SwiftUI

/// When true, a pushed mini-game is active and the macOS sidebar must not receive letter keys.
struct MiniGameKeyboardCaptureKey: PreferenceKey {
    static var defaultValue = false
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = value || nextValue()
    }
}

extension View {
    func capturesMiniGameKeyboard() -> some View {
        preference(key: MiniGameKeyboardCaptureKey.self, value: true)
    }
}

/// Shared chrome for mini-games: dark background, score bar, title.
struct MiniGameShell<Content: View>: View {
    let title: String
    let accent: Color
    var correct: Int = 0
    var missed: Int = 0
    var showScore: Bool = true
    @ViewBuilder let content: () -> Content

    var body: some View {
        ZStack {
            GameColors.appBackground.ignoresSafeArea()
            VStack(spacing: 16) {
                if showScore {
                    HStack {
                        Text(title)
                            .font(GameFont.headline())
                            .foregroundStyle(GameColors.textPrimary)
                        Spacer()
                        DrillScorePill(correct: correct, missed: missed)
                    }
                }
                content()
            }
            .padding()
        }
        .navigationTitle(title)
        .inlineNavigationBarTitle()
    }
}

extension View {
    func gamesNavigationDestinations() -> some View {
        navigationDestination(for: MiniGameRoute.self) { route in
            Group {
                switch route {
                case .scienceWordle:
                    ScienceWordleGameView()
                case .trueOrFalseBlitz:
                    TrueOrFalseBlitzGameView()
                case .elementBlitz:
                    ElementBlitzGameView()
                case .moleculeMatch:
                    MoleculeMatchGameView()
                case .cellBuilder:
                    CellBuilderGameView()
                }
            }
            .capturesMiniGameKeyboard()
        }
    }
}
