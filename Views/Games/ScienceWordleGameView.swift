import SwiftUI

enum WordleLetterState: Equatable {
    case empty
    case filled(Character)
    case correct
    case present
    case absent
}

struct ScienceWordleGameView: View {
    @Environment(AppState.self) private var appState

    private let maxGuesses = 6
    private let wordLength = 5

    @State private var targetWord = GameContent.dailyWordleWord()
    @State private var guesses: [[Character]] = []
    @State private var currentGuess = ""
    @State private var letterStates: [[WordleLetterState]] = []
    @State private var gameOver = false
    @State private var won = false
    @State private var shakeRow = false

    var body: some View {
        MiniGameShell(
            title: "Science Wordle",
            accent: Subject.physics.gameColor,
            correct: won ? 1 : 0,
            missed: gameOver && !won ? 1 : 0,
            showScore: gameOver
        ) {
            VStack(spacing: 20) {
                Text("Guess the 5-letter science term")
                    .font(GameFont.caption())
                    .foregroundStyle(GameColors.textSecondary)

                gridView
                    .modifier(ShakeEffect(animating: shakeRow))

                if gameOver {
                    endPanel
                } else {
                    keyboardView
                }
            }
        }
        .onAppear { resetGame(useDaily: true) }
    }

    private var gridView: some View {
        VStack(spacing: 8) {
            ForEach(0..<maxGuesses, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(0..<wordLength, id: \.self) { col in
                        letterTile(row: row, col: col)
                    }
                }
            }
        }
    }

    private func letterTile(row: Int, col: Int) -> some View {
        let state = tileState(row: row, col: col)
        return ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(tileColor(for: state))
                .frame(width: 52, height: 52)
            Text(tileLetter(row: row, col: col))
                .font(GameFont.title2(.bold))
                .foregroundStyle(state == .empty ? GameColors.textPrimary : .white)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(GameColors.textTertiary, lineWidth: state == .empty ? 1.5 : 0)
        )
    }

    private func tileState(row: Int, col: Int) -> WordleLetterState {
        guard row < letterStates.count, col < letterStates[row].count else {
            if row == guesses.count, col < currentGuess.count {
                return .filled(currentGuess[currentGuess.index(currentGuess.startIndex, offsetBy: col)])
            }
            return .empty
        }
        return letterStates[row][col]
    }

    private func tileLetter(row: Int, col: Int) -> String {
        if row < guesses.count, col < guesses[row].count {
            return String(guesses[row][col])
        }
        if row == guesses.count, col < currentGuess.count {
            let idx = currentGuess.index(currentGuess.startIndex, offsetBy: col)
            return String(currentGuess[idx])
        }
        return ""
    }

    private func tileColor(for state: WordleLetterState) -> Color {
        switch state {
        case .empty, .filled: return GameColors.cardSurface2
        case .correct: return GameColors.correct
        case .present: return GameColors.xpGold.opacity(0.85)
        case .absent: return GameColors.textTertiary.opacity(0.5)
        }
    }

    private var keyboardView: some View {
        VStack(spacing: 8) {
            wordInputRow
            HStack(spacing: 10) {
                Button("ENTER") { submitGuess() }
                    .font(GameFont.caption(.bold))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(GameColors.chemistry)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .disabled(currentGuess.count != wordLength)
                Button("DELETE") { deleteLetter() }
                    .font(GameFont.caption(.bold))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(GameColors.cardSurface2)
                    .foregroundStyle(GameColors.textPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
            letterRows
        }
        #if os(macOS)
        .buttonStyle(.borderless)
        #endif
    }

    private var wordInputRow: some View {
        Group {
            #if os(iOS)
            TextField("Type guess", text: $currentGuess)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
            #else
            TextField("Type guess", text: $currentGuess)
                .textFieldStyle(.roundedBorder)
            #endif
        }
        .onChange(of: currentGuess) { _, newValue in
            let filtered = String(newValue.uppercased().filter { $0.isLetter }.prefix(wordLength))
            if filtered != newValue { currentGuess = filtered }
        }
        .onSubmit { submitGuess() }
    }

    private var letterRows: some View {
        let rows = ["QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"]
        return VStack(spacing: 6) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 4) {
                    ForEach(Array(row), id: \.self) { ch in
                        Button(String(ch)) { appendLetter(ch) }
                            .font(GameFont.caption(.semibold))
                            .frame(width: 30, height: 36)
                            .background(keyColor(for: ch))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                }
            }
        }
        .buttonStyle(.plain)
        #if os(macOS)
        .buttonStyle(.borderless)
        #endif
    }

    private func keyColor(for letter: Character) -> Color {
        var best: WordleLetterState = .empty
        for (rowIndex, row) in letterStates.enumerated() {
            for (col, state) in row.enumerated() {
                guard col < guesses[rowIndex].count, guesses[rowIndex][col] == letter else { continue }
                switch state {
                case .correct: return GameColors.correct
                case .present where best != .correct: best = .present
                case .absent where best == .empty: best = .absent
                default: break
                }
            }
        }
        switch best {
        case .correct: return GameColors.correct
        case .present: return GameColors.xpGold.opacity(0.85)
        case .absent: return GameColors.textTertiary.opacity(0.5)
        default: return GameColors.cardSurface2
        }
    }

    private var endPanel: some View {
        VStack(spacing: 12) {
            Text(won ? "You got it! 🎉" : "Answer: \(targetWord)")
                .font(GameFont.headline())
                .foregroundStyle(won ? GameColors.correct : GameColors.incorrect)
            HStack(spacing: 12) {
                Button("Play again") { resetGame(useDaily: false) }
                    .buttonStyle(.borderedProminent)
                Button("New daily") { resetGame(useDaily: true) }
                    .buttonStyle(.bordered)
            }
        }
        .gameCard()
    }

    private func appendLetter(_ letter: Character) {
        guard !gameOver, currentGuess.count < wordLength else { return }
        currentGuess.append(letter)
    }

    private func deleteLetter() {
        guard !currentGuess.isEmpty else { return }
        currentGuess.removeLast()
    }

    private func submitGuess() {
        guard currentGuess.count == wordLength, !gameOver else { return }
        let guess = Array(currentGuess)
        guard GameContent.wordleBank.contains(currentGuess) || isValidGuess(currentGuess) else {
            withAnimation { shakeRow.toggle() }
            return
        }
        let states = evaluateGuess(guess, against: Array(targetWord))
        guesses.append(guess)
        letterStates.append(states)
        currentGuess = ""

        if String(guess) == targetWord {
            won = true
            gameOver = true
            XPManager.shared.awardCustom(points: 15)
            DrillFeedbackMessages.onCorrect(appState: appState)
        } else if guesses.count >= maxGuesses {
            gameOver = true
            DrillFeedbackMessages.onIncorrect(appState: appState)
        }
    }

    private func isValidGuess(_ word: String) -> Bool {
        // Allow element names and curated bank; also allow any 5-letter alpha for flexibility.
        word.allSatisfy(\.isLetter) && word.count == wordLength
    }

    private func evaluateGuess(_ guess: [Character], against target: [Character]) -> [WordleLetterState] {
        var result = Array(repeating: WordleLetterState.absent, count: wordLength)
        var targetCounts: [Character: Int] = [:]
        for ch in target { targetCounts[ch, default: 0] += 1 }

        for i in 0..<wordLength {
            if guess[i] == target[i] {
                result[i] = .correct
                targetCounts[guess[i], default: 0] -= 1
            }
        }
        for i in 0..<wordLength where result[i] != .correct {
            if targetCounts[guess[i], default: 0] > 0 {
                result[i] = .present
                targetCounts[guess[i], default: 0] -= 1
            }
        }
        return result
    }

    private func resetGame(useDaily: Bool) {
        targetWord = useDaily ? GameContent.dailyWordleWord() : GameContent.randomWordleWord()
        guesses = []
        letterStates = []
        currentGuess = ""
        gameOver = false
        won = false
    }
}

private struct ShakeEffect: GeometryEffect {
    var animating: Bool
    var amount: CGFloat = 8

    var animatableData: CGFloat {
        get { animating ? 1 : 0 }
        set { _ = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        let offset = sin(animatableData * .pi * 4) * amount
        return ProjectionTransform(CGAffineTransform(translationX: offset, y: 0))
    }
}
