import SwiftUI

struct NSBTopicReadingLinesView: View {
    let lines: [NSBTopicReadingLine]
    var compact: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: compact ? 6 : 10) {
            if lines.isEmpty {
                Text("No book mapping yet for this topic.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(lines) { line in
                    NSBTopicReadingLineRow(line: line, compact: compact)
                }
            }
        }
    }
}

struct NSBTopicReadingLineRow: View {
    let line: NSBTopicReadingLine
    var compact: Bool = false

    private var roleColor: Color {
        switch line.role {
        case "primary": return PlatformColor.systemBlue
        case "pass1", "pass2": return PlatformColor.systemIndigo
        case "alsoOK": return PlatformColor.systemTeal
        case "backup": return PlatformColor.systemOrange
        default: return Color.secondary
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                Text(NSBTopicReadingCatalog.roleLabel(for: line.role))
                    .font(.caption2.weight(.bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(roleColor.opacity(0.14))
                    .foregroundStyle(roleColor)
                    .clipShape(Capsule())

                Text(line.bookCode)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            Text("\(NSBTopicReadingCatalog.bookTitle(for: line.bookCode)) · \(line.label)")
                .font(compact ? .caption : .subheadline)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(compact ? 8 : 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(PlatformColor.tertiaryGroupedBackground)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct NSBTopicReadingsDetailView: View {
    @Environment(AppState.self) private var appState
    let topic: NSBTopic

    private var readings: [NSBTopicReadingLine] {
        NSBTopicReadingCatalog.readings(for: topic.id)
    }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 6) {
                    Text(topic.subject)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Text(topic.title)
                        .font(.title2.weight(.semibold))
                }
                .padding(.vertical, 4)
            }

            Section {
                Text("Mapped from Soha’s summer books (Mod/Tro/FLS/CB/OSB/Expl/OSA/Lar/BFN) and DOE Tips & Resources. Earth/Energy topics use DOE textbook names — use your book’s index when no chapter number is listed.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("Books & chapters") {
                NSBTopicReadingLinesView(lines: readings)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowBackground(Color.clear)
            }

            Section {
                NavigationLink(value: StudyNavigationRoute.encyclopediaTopic(id: topic.id)) {
                    Label("Open full study article", systemImage: "book.fill")
                }
            }
        }
        .navigationTitle(topic.title)
        .inlineNavigationBarTitle()
        .studyNavigationDestinations()
    }
}
