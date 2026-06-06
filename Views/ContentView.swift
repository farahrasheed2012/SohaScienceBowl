import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.colorScheme) private var colorScheme

    private var theme: ThemePalette {
        AppAppearance.resolvedTheme(appearance: appState.appAppearance, systemColorScheme: colorScheme)
    }

    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "calendar")
                }

            EncyclopediaRootView()
                .tabItem {
                    Label("Learn", systemImage: "books.vertical.fill")
                }

            QuizRootView()
                .tabItem {
                    Label("Quiz", systemImage: "questionmark.circle.fill")
                }

            ProgressDashboardView()
                .tabItem {
                    Label("Progress", systemImage: "chart.bar.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .tint(theme.accent)
        .preferredColorScheme(appState.appAppearance.colorScheme)
        .environment(\.themePalette, theme)
    }
}
