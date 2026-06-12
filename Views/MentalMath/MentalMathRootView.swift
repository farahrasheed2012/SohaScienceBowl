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
                        Text("20 shuffled problems per round. Get \(Int(MentalMathStore.passThreshold * 100))% or higher to unlock the next level.")
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

                Section("Timer") {
                    Picker("Per-problem limit", selection: Binding(
                        get: { mentalMath.timedMode },
                        set: { mentalMath.setTimedMode($0) }
                    )) {
                        ForEach(MentalMathTimedMode.allCases) { mode in
                            Text(mode.label).tag(mode)
                        }
                    }
                    .pickerStyle(.menu)
                    Text("Live session timer always runs. Optional countdown marks unanswered problems wrong when time runs out.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
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

                if !mentalMath.sessionHistory.isEmpty {
                    Section("Recent runs") {
                        ForEach(mentalMath.sessionHistory.prefix(5)) { run in
                            recentRunRow(run)
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

    private func recentRunRow(_ run: MentalMathDrillResult) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(run.operation.rawValue) · L\(run.level)")
                    .font(.subheadline.weight(.medium))
                Text(run.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(run.correct)/\(run.total)")
                    .font(.subheadline.weight(.semibold))
                Text(MentalMathFormatting.duration(run.elapsedSeconds))
                    .font(.caption)
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
        let best = appState.mentalMath.best(for: operation, level: level)
        return HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Level \(level)")
                    .font(.body.weight(.semibold))
                Text(operation.levelTitle(level))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                if let best {
                    HStack(spacing: 8) {
                        if let time = best.formattedBestTime {
                            Label(time, systemImage: "trophy.fill")
                        }
                        if best.bestCorrect > 0 {
                            Label("\(best.bestCorrect)/\(MentalMathEngine.problemsPerSession)", systemImage: "star.fill")
                        }
                        if best.attempts > 0 {
                            Text("\(best.passes)/\(best.attempts) passed")
                        }
                    }
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                }
            }
            Spacer()
            if !unlocked {
                Image(systemName: "lock.fill")
                    .font(.caption)
            }
        }
    }
}
