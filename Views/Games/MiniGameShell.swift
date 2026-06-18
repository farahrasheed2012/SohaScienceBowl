import SwiftUI

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
    }
}
