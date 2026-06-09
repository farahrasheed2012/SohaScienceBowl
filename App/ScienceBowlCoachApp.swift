import SwiftUI

@main
struct ScienceBowlCoachApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
                .task {
                    await appState.loadDOEQuestions()
                }
        }
        #if os(macOS)
        .defaultSize(width: 1280, height: 840)
        .windowResizability(.contentMinSize)
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
        #endif
    }
}
