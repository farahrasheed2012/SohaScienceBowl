import SwiftUI

private struct MemoryCard: Identifiable, Equatable {
    let id: String
    let pairID: String
    let label: String
    let isFormula: Bool
    var isFaceUp = false
    var isMatched = false
}

struct MoleculeMatchGameView: View {
    @State private var cards: [MemoryCard] = []
    @State private var flippedIDs: [String] = []
    @State private var moves = 0
    @State private var matchedPairs = 0
    @State private var lockInput = false
    @State private var won = false

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 4)

    var body: some View {
        MiniGameShell(
            title: "Molecule Match",
            accent: Subject.chemistry.gameColor,
            correct: matchedPairs,
            missed: max(0, moves - matchedPairs),
            showScore: true
        ) {
            VStack(spacing: 16) {
                HStack {
                    Text("Pairs: \(matchedPairs)/\(GameContent.moleculePairs.count)")
                        .font(GameFont.caption())
                        .foregroundStyle(GameColors.textSecondary)
                    Spacer()
                    Text("Moves: \(moves)")
                        .font(GameFont.caption())
                        .foregroundStyle(GameColors.textSecondary)
                }

                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(cards) { card in
                        cardView(card)
                    }
                }

                if won {
                    VStack(spacing: 10) {
                        Text("All matched! 🧪")
                            .font(GameFont.headline())
                            .foregroundStyle(GameColors.correct)
                        Button("Play again") { startGame() }
                            .buttonStyle(.borderedProminent)
                    }
                    .gameCard()
                }
            }
        }
        .onAppear { startGame() }
    }

    private func cardView(_ card: MemoryCard) -> some View {
        let faceUp = card.isFaceUp || card.isMatched
        return Button {
            flip(card)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(faceUp ? GameColors.cardSurface2 : GameColors.chemistry)
                    .aspectRatio(0.75, contentMode: .fit)
                if faceUp {
                    Text(card.label)
                        .font(card.isFormula ? GameFont.headline() : GameFont.caption())
                        .foregroundStyle(GameColors.textPrimary)
                        .multilineTextAlignment(.center)
                        .padding(6)
                        .minimumScaleFactor(0.7)
                } else {
                    Image(systemName: "flask.fill")
                        .font(.title2)
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(card.isMatched || card.isFaceUp || lockInput || won)
        .rotation3DEffect(.degrees(faceUp ? 0 : 180), axis: (x: 0, y: 1, z: 0))
        .animation(.spring(response: 0.35), value: faceUp)
    }

    private func flip(_ card: MemoryCard) {
        guard let idx = cards.firstIndex(where: { $0.id == card.id }) else { return }
        cards[idx].isFaceUp = true
        flippedIDs.append(card.id)

        if flippedIDs.count == 2 {
            moves += 1
            lockInput = true
            evaluatePair()
        }
    }

    private func evaluatePair() {
        guard flippedIDs.count == 2,
              let first = cards.first(where: { $0.id == flippedIDs[0] }),
              let second = cards.first(where: { $0.id == flippedIDs[1] }) else { return }

        if first.pairID == second.pairID, first.id != second.id {
            markMatched(first.pairID)
            matchedPairs += 1
            flippedIDs = []
            lockInput = false
            if matchedPairs == GameContent.moleculePairs.count {
                won = true
                XPManager.shared.awardCustom(points: 20)
            }
        } else {
            Task {
                try? await Task.sleep(nanoseconds: 700_000_000)
                hideFlipped()
            }
        }
    }

    private func markMatched(_ pairID: String) {
        for i in cards.indices where cards[i].pairID == pairID {
            cards[i].isMatched = true
            cards[i].isFaceUp = true
        }
    }

    private func hideFlipped() {
        for i in cards.indices where flippedIDs.contains(cards[i].id) {
            cards[i].isFaceUp = false
        }
        flippedIDs = []
        lockInput = false
    }

    private func startGame() {
        var deck: [MemoryCard] = []
        for pair in GameContent.moleculePairs {
            deck.append(MemoryCard(id: "\(pair.id)-f", pairID: pair.id, label: pair.formula, isFormula: true))
            deck.append(MemoryCard(id: "\(pair.id)-n", pairID: pair.id, label: pair.name, isFormula: false))
        }
        cards = deck.shuffled()
        flippedIDs = []
        moves = 0
        matchedPairs = 0
        lockInput = false
        won = false
    }
}
