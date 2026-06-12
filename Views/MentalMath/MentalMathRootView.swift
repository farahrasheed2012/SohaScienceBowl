import SwiftUI

struct MentalMathRootView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var mentalMath = appState.mentalMath

        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Rocket-style fluency drills")
                            .font(.headline)
                        Text("20 problems per round. Get \(Int(MentalMathStore.passThreshold * 100))% or higher to unlock the next level.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        HStack(spacing: 16) {
                            Label("\(mentalMath.currentStreak) streak", systemImage: "flame.fill")
                            if mentalMath.totalProblemsAnswered > 0 {
                                Label("\(Int(Double(mentalMath.totalCorrect) / Double(mentalMath.totalProblemsAnswered) * 100))% all-time", systemImage: "chart.bar.fill")
                            }
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }

                Section("Pick a track") {
                    ForEach(MentalMathOperation.allCases) { operation in
                        NavigationLink {
                            MentalMathTrackView(operation: operation)
                        } label: {
                            trackRow(operation: operation, mentalMath: mentalMath)
                        }
                    }
                }

            }
            .platformListStyle()
            .navigationTitle("Mental Math")
            .largeNavigationBarTitle()
        }
    }

    private func trackRow(operation: MentalMathOperation, mentalMath: MentalMathStore) -> some View {
        let lvl = mentalMath.level(for: operation)
        return HStack(spacing: 14) {
            Text(operation.emoji)
                .font(.title2)
                .frame(width: 36)
            VStack(alignment: .leading, spacing: 2) {
                Text(operation.rawValue)
                    .font(.body.weight(.semibold))
                Text("Level \(lvl): \(operation.levelTitle(lvl))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if let acc = mentalMath.accuracy(for: operation) {
                Text("\(Int(acc * 100))%")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct MentalMathTrackView: View {
    @Environment(AppState.self) private var appState
    let operation: MentalMathOperation

    var body: some View {
        List {
            Section {
                Text(operation.rawValue)
                    .font(.title2.weight(.bold))
                Text("Current level: \(appState.mentalMath.level(for: operation)) of \(operation.levelCount)")
                    .foregroundStyle(.secondary)
            }

            Section("Levels") {
                ForEach(1...operation.levelCount, id: \.self) { level in
                    let unlocked = level <= appState.mentalMath.level(for: operation)
                    if unlocked {
                        NavigationLink {
                            MentalMathDrillView(operation: operation, level: level)
                        } label: {
                            levelRow(level: level, unlocked: true)
                        }
                    } else {
                        levelRow(level: level, unlocked: false)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle(operation.rawValue)
        .inlineNavigationBarTitle()
    }

    private func levelRow(level: Int, unlocked: Bool) -> some View {
        HStack {
            Text("Level \(level)")
                .font(.body.weight(.semibold))
            Text(operation.levelTitle(level))
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            if !unlocked {
                Image(systemName: "lock.fill")
                    .font(.caption)
            }
        }
    }
}
