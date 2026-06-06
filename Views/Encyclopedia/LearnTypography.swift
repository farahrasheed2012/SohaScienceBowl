import SwiftUI

// MARK: - Learn section card (One Bee reading style)

struct LearnSectionCard<Content: View>: View {
    @Environment(\.themePalette) private var theme

    let title: String
    var systemImage: String? = nil
    var accent: Color? = nil
    @ViewBuilder var content: () -> Content

    private var accentColor: Color { accent ?? theme.accent }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: ThemePalette.captionSize, weight: .semibold))
                        .foregroundStyle(accentColor)
                        .frame(width: 32, height: 32)
                        .background(accentColor.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                Text(title)
                    .font(.system(size: ThemePalette.titleSize, weight: .bold))
                    .foregroundStyle(theme.primaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            content()
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: ThemePalette.cornerRadius))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Body text tuned for long-form reading

struct LearnBodyText: View {
    @Environment(\.themePalette) private var theme
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            ForEach(Array(StudyTextChunk.parse(text).enumerated()), id: \.offset) { _, chunk in
                switch chunk {
                case .paragraph(let body):
                    Text(body)
                        .font(.system(size: ThemePalette.bodySize))
                        .foregroundStyle(theme.primaryText)
                        .lineSpacing(8)
                        .fixedSize(horizontal: false, vertical: true)
                case .bullets(let items):
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                            HStack(alignment: .top, spacing: 12) {
                                Text("•")
                                    .font(.system(size: ThemePalette.bodySize, weight: .bold))
                                    .foregroundStyle(theme.accent)
                                    .padding(.top, 2)
                                Text(item)
                                    .font(.system(size: ThemePalette.bodySize))
                                    .foregroundStyle(theme.primaryText)
                                    .lineSpacing(7)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct LearnKeyTermRow: View {
    @Environment(\.themePalette) private var theme
    let term: String
    let definition: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(term)
                .font(.system(size: ThemePalette.bodySize, weight: .semibold))
                .foregroundStyle(theme.primaryText)
            Text(definition)
                .font(.system(size: ThemePalette.captionSize))
                .foregroundStyle(theme.secondaryText)
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct LearnTopicHeaderCard: View {
    @Environment(\.themePalette) private var theme
    let title: String
    let subject: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: ThemePalette.largeTitleSize, weight: .bold))
                .foregroundStyle(theme.primaryText)
                .fixedSize(horizontal: false, vertical: true)
            Text(subject)
                .font(.system(size: ThemePalette.captionSize, weight: .medium))
                .foregroundStyle(theme.secondaryText)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: ThemePalette.cornerRadius))
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}
