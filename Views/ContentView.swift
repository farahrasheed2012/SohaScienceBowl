import SwiftUI

private enum MainTab: Hashable {
    case today, learn, quiz, progress, settings
}

struct ContentView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedTab: MainTab = .today

    private var theme: ThemePalette {
        AppAppearance.resolvedTheme(appearance: appState.appAppearance, systemColorScheme: colorScheme)
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "calendar")
                }
                .tag(MainTab.today)

            EncyclopediaRootView()
                .tabItem {
                    Label("Learn", systemImage: "books.vertical.fill")
                }
                .tag(MainTab.learn)

            QuizRootView()
                .tabItem {
                    Label("Quiz", systemImage: "questionmark.circle.fill")
                }
                .tag(MainTab.quiz)

            ProgressDashboardView()
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.fill")
                }
                .tag(MainTab.progress)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(MainTab.settings)
        }
        .tint(theme.accent)
        .preferredColorScheme(appState.appAppearance.colorScheme)
        .environment(\.themePalette, theme)
        #if os(macOS)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        #endif
    }
}
