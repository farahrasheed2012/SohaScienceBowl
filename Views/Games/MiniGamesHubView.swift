import SwiftUI

struct MiniGamesHubView: View {
    private let columns = [GridItem(.adaptive(minimum: 160), spacing: 14)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Quick science breaks — 1 to 5 minutes each.")
                    .font(GameFont.body())
                    .foregroundStyle(GameColors.textSecondary)

                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(MiniGameRoute.allCases) { game in
                        NavigationLink(value: game) {
                            hubCard(for: game)
                        }
                        #if os(macOS)
                        .buttonStyle(.borderless)
                        #else
                        .buttonStyle(.plain)
                        #endif
                    }
                }
            }
            .padding()
        }
        .background(GameColors.appBackground.ignoresSafeArea())
        .navigationTitle("Mini-Games")
        .largeNavigationBarTitle()
        .gamesNavigationDestinations()
    }

    private func hubCard(for game: MiniGameRoute) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: game.systemImage)
                .font(.title2)
                .foregroundStyle(game.accent.gameColor)
            Text(game.title)
                .font(GameFont.headline())
                .foregroundStyle(GameColors.textPrimary)
                .multilineTextAlignment(.leading)
            Text(game.subtitle)
                .font(GameFont.caption())
                .foregroundStyle(GameColors.textSecondary)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, minHeight: 130, alignment: .leading)
        .gameCard(color: GameColors.cardSurface)
        .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
