import SwiftUI

/// Shared POT 6 accent — works in light and dark mode.
enum MathAccent {
    static let color = GameColors.math
}

struct MathCard: ViewModifier {
    @Environment(\.themePalette) private var theme
    var padding: CGFloat = 16

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(theme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: ThemePalette.cornerRadius, style: .continuous))
    }
}

extension View {
    func mathCard(padding: CGFloat = 16) -> some View {
        modifier(MathCard(padding: padding))
    }
}
