import SwiftUI

/// iPhone (or second device) buzzer — connects to the Mac-hosted drill over local network.
struct BuzzerRemoteView: View {
    @State private var buzzer = BuzzerNetworkService.shared
    @State private var lastBuzz = Date.distantPast

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Text("Buzzer remote")
                    .font(.title2.weight(.semibold))
                Text(connectionLabel)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 24)

            Spacer()

            Button {
                guard Date().timeIntervalSince(lastBuzz) > 0.4 else { return }
                lastBuzz = Date()
                buzzer.sendBuzz()
                HapticFeedback.impact(.heavy)
            } label: {
                VStack(spacing: 12) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 48))
                    Text("BUZZ")
                        .font(.largeTitle.weight(.black))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 48)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!buzzer.isConnected)
            .padding(.horizontal, 24)

            Spacer()

            if buzzer.isBrowsing {
                Button("Disconnect") {
                    buzzer.stopAll()
                }
                .buttonStyle(.bordered)
            } else {
                Button("Find drill on this network") {
                    buzzer.startBrowsing()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(16)
        .navigationTitle("Buzzer")
        .inlineNavigationBarTitle()
        .onDisappear {
            buzzer.stopAll()
        }
    }

    private var connectionLabel: String {
        if buzzer.isConnected, let name = buzzer.connectedPeerName {
            return "Connected to \(name) — tap BUZZ during a drill"
        }
        if buzzer.isBrowsing {
            return "Looking for a Science Bowl drill host…"
        }
        return "Start a buzzer drill on Mac, then connect here"
    }
}
