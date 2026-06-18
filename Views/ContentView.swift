import SwiftUI

private enum MainTab: String, Hashable, CaseIterable, Identifiable {
    case today, weeks, calendar, topics, learn, elements, mathCounts, mentalMath, games, quiz, progress, settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .today: return "Today"
        case .weeks: return "Weeks"
        case .calendar: return "Calendar"
        case .topics: return "Topics"
        case .learn: return "Learn"
        case .elements: return "Elements"
        case .mathCounts: return "MathCounts"
        case .mentalMath: return "Mental Math"
        case .games: return "Games"
        case .quiz: return "Quiz"
        case .progress: return "Progress"
        case .settings: return "Settings"
        }
    }

    var systemImage: String {
        switch self {
        case .today: return "sun.max.fill"
        case .weeks: return "calendar.badge.clock"
        case .calendar: return "calendar"
        case .topics: return "list.bullet.rectangle"
        case .learn: return "books.vertical.fill"
        case .elements: return "tablecells.fill"
        case .mathCounts: return "function"
        case .mentalMath: return "bolt.fill"
        case .games: return "gamecontroller.fill"
        case .quiz: return "questionmark.circle.fill"
        case .progress: return "chart.bar.fill"
        case .settings: return "gearshape.fill"
        }
    }

    @ViewBuilder
    var rootView: some View {
        switch self {
        case .today: TodayView()
        case .weeks: WeeksRootView()
        case .calendar: CalendarRootView()
        case .topics: NSBTopicsRootView()
        case .learn: EncyclopediaRootView()
        case .elements: PeriodicTableRootView()
        case .mathCounts: MathCountsRootView()
        case .mentalMath: MentalMathRootView()
        case .games:
            NavigationStack {
                MiniGamesHubView()
            }
        case .quiz: QuizRootView()
        case .progress: ProgressDashboardView()
        case .settings: SettingsView()
        }
    }
}

struct ContentView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedTab: MainTab = .today
    #if os(macOS)
    @State private var miniGameCapturesKeyboard = false
    #endif

    private var theme: ThemePalette {
        AppAppearance.resolvedTheme(appearance: appState.appAppearance, systemColorScheme: colorScheme)
    }

    var body: some View {
        #if os(macOS)
        macLayout
        #else
        iosLayout
        #endif
    }

    // MARK: - iOS — bottom tab bar

    #if os(iOS)
    private var iosLayout: some View {
        TabView(selection: $selectedTab) {
            ForEach(MainTab.allCases) { tab in
                tab.rootView
                    .tabItem {
                        Label(tab.title, systemImage: tab.systemImage)
                    }
                    .tag(tab)
            }
        }
        .tint(theme.accent)
        .preferredColorScheme(appState.appAppearance.colorScheme)
        .environment(\.themePalette, theme)
    }
    #endif

    #if os(macOS)
    // MARK: - macOS — sidebar + large detail pane (not iPhone tab bar)

    private var macLayout: some View {
        NavigationSplitView {
            List(selection: $selectedTab) {
                Section("Science Bowl Coach") {
                    ForEach(MainTab.allCases) { tab in
                        Label(tab.title, systemImage: tab.systemImage)
                            .tag(tab)
                    }
                }
            }
            .listStyle(.sidebar)
            .focusable(!miniGameCapturesKeyboard)
            .navigationTitle("Science Bowl Coach")
            .navigationSplitViewColumnWidth(min: 200, ideal: 230, max: 280)
        } detail: {
            selectedTab.rootView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(theme.surface)
        }
        .navigationSplitViewStyle(.balanced)
        .onPreferenceChange(MiniGameKeyboardCaptureKey.self) { miniGameCapturesKeyboard = $0 }
        .frame(minWidth: 1000, minHeight: 700)
        .tint(theme.accent)
        .preferredColorScheme(appState.appAppearance.colorScheme)
        .environment(\.themePalette, theme)
    }
    #endif
}
