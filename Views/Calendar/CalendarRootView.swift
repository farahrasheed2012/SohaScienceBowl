import SwiftUI

struct CalendarRootView: View {
    @Environment(AppState.self) private var appState
    @State private var selectedDocument: ScheduleHTMLResources.Document = .summerWhiteboard
    @State private var selectedWeek: Int = 1

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                documentPicker

                if selectedDocument.supportsWeekNavigation {
                    weekJumpBar
                }

                if let url = ScheduleHTMLResources.url(for: selectedDocument) {
                    HTMLWebView(
                        url: url,
                        scrollToWeek: selectedDocument.supportsWeekNavigation ? selectedWeek : nil
                    )
                } else {
                    ContentUnavailableView(
                        "Schedule file missing",
                        systemImage: "doc.questionmark",
                        description: Text("Run Scripts/sync_schedule_html.py and rebuild the app.")
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Calendar")
            .toolbar {
                if selectedDocument.supportsWeekNavigation {
                    ToolbarItem(placement: .navigation) {
                        Menu {
                            ForEach(1...10, id: \.self) { week in
                                Button {
                                    selectedWeek = week
                                } label: {
                                    if week == selectedWeek {
                                        Label(weekMenuLabel(week), systemImage: "checkmark")
                                    } else {
                                        Text(weekMenuLabel(week))
                                    }
                                }
                            }
                        } label: {
                            Label("Week \(selectedWeek)", systemImage: "list.number")
                        }
                    }

                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            selectedWeek = appState.currentWeek
                        } label: {
                            Label("This week", systemImage: "calendar.badge.clock")
                        }
                        .help("Jump to week \(appState.currentWeek)")
                    }
                }

                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        ForEach(ScheduleHTMLResources.Document.allCases) { doc in
                            Button {
                                selectedDocument = doc
                            } label: {
                                Label(doc.title, systemImage: doc.systemImage)
                            }
                        }
                    } label: {
                        Label("Schedules", systemImage: "doc.on.doc")
                    }
                }

                #if os(macOS)
                ToolbarItem(placement: .automatic) {
                    Button {
                        ScheduleHTMLResources.openExternally(selectedDocument)
                    } label: {
                        Label("Open in Browser", systemImage: "safari")
                    }
                    .help("Open in Safari for printing (⌘P)")
                }
                #endif
            }
            .onAppear {
                appState.refreshScheduleFromCalendar()
                selectedWeek = appState.currentWeek
            }
            .onChange(of: selectedDocument) { _, doc in
                if doc.supportsWeekNavigation {
                    selectedWeek = appState.currentWeek
                }
            }
        }
    }

    private var documentPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(ScheduleHTMLResources.Document.allCases) { doc in
                    Button {
                        selectedDocument = doc
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Label(doc.title, systemImage: doc.systemImage)
                                .font(.subheadline.weight(.semibold))
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                            Text(doc.subtitle)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                        }
                        .frame(width: 168, alignment: .leading)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(doc == selectedDocument ? Color.accentColor.opacity(0.15) : PlatformColor.secondaryGroupedBackground)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .strokeBorder(doc == selectedDocument ? Color.accentColor : Color.clear, lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(PlatformColor.groupedBackground)
    }

    private var weekJumpBar: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Jump to week")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                Text(ScheduleConstants.weekDateRangeLabel(for: selectedWeek))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 8) {
                ForEach(1...10, id: \.self) { week in
                    weekButton(week)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(PlatformColor.secondaryGroupedBackground)
    }

    private func weekButton(_ week: Int) -> some View {
        let isSelected = week == selectedWeek
        let isCurrent = week == appState.currentWeek

        return Button {
            selectedWeek = week
        } label: {
            VStack(spacing: 2) {
                Text("\(week)")
                    .font(.body.weight(.semibold))
                    .monospacedDigit()
                if isCurrent {
                    Text("now")
                        .font(.system(size: 9, weight: .medium))
                        .textCase(.uppercase)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(isSelected ? Color.accentColor : PlatformColor.tertiaryGroupedBackground)
            )
            .foregroundStyle(isSelected ? Color.white : Color.primary)
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .strokeBorder(isCurrent && !isSelected ? Color.accentColor.opacity(0.6) : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Week \(week), \(ScheduleConstants.weekDateRangeLabel(for: week))")
    }

    private func weekMenuLabel(_ week: Int) -> String {
        "Week \(week) · \(ScheduleConstants.weekDateRangeLabel(for: week))"
    }
}
