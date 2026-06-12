import SwiftUI

private enum MainTab: String, Hashable, CaseIterable, Identifiable {
    case today, weeks, calendar, topics, learn, mathCounts, mentalMath, quiz, progress, settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .today: return "Today"
        case .weeks: return "Weeks"
        case .calendar: return "Calendar"
        case .topics: return "Topics"
        case .learn: return "Learn"
        case .mathCounts: return "MathCounts"
        case .mentalMath: return "Mental Math"
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
        case .mathCounts: return "function"
        case .mentalMath: return "bolt.fill"
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
        case .mathCounts: MathCountsRootView()
        case .mentalMath: MentalMathRootView()
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
            .navigationTitle("Science Bowl Coach")
            .navigationSplitViewColumnWidth(min: 200, ideal: 230, max: 280)
        } detail: {
            selectedTab.rootView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(PlatformColor.groupedBackground)
        }
        .navigationSplitViewStyle(.balanced)
        .frame(minWidth: 1000, minHeight: 700)
        .tint(theme.accent)
        .preferredColorScheme(appState.appAppearance.colorScheme)
        .environment(\.themePalette, theme)
    }
    #endif
}
