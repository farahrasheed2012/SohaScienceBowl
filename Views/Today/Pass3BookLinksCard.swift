import SwiftUI

/// Review / flash-card blocks — one-tap primary + backup book links when stuck.
struct StuckBookLinksCard: View {
    let block: StudyBlock
    let activePass: StudyPass

    private var options: [StudyBookOption] {
        block.allBookOptions(activePass: activePass)
            .filter { $0.role == .primary || $0.role == .backup }
    }

    var body: some View {
        if !options.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Label("Open book if stuck", systemImage: "book.closed.fill")
                    .font(.headline)

                Text("Try from memory first — open the assigned § section only when you need it.")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                ForEach(options) { option in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(option.role.displayLabel)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                        Text(option.text)
                            .font(.subheadline.weight(.medium))

                        if !option.links.isEmpty {
                            ForEach(option.links) { link in
                                Link(destination: link.url) {
                                    Label(link.label, systemImage: "safari")
                                        .font(.caption)
                                }
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }

                NavigationLink {
                    BlockStudyMaterialView(block: block)
                } label: {
                    Label("Full study material", systemImage: "text.book.closed")
                        .font(.subheadline.weight(.semibold))
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(PlatformColor.secondaryGroupedBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
    }
}
