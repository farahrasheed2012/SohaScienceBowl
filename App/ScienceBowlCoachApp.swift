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
                #if os(macOS)
                .frame(minWidth: 820, minHeight: 640)
                #endif
        }
        #if os(macOS)
        .defaultSize(width: 960, height: 720)
        #endif
    }
}
