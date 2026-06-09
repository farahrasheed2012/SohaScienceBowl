import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

enum PlatformColor {
    static var systemBlue: Color { color(.systemBlue) }
    static var systemGreen: Color { color(.systemGreen) }
    static var systemOrange: Color { color(.systemOrange) }
    static var systemYellow: Color { color(.systemYellow) }
    static var systemTeal: Color { color(.systemTeal) }
    static var systemPurple: Color { color(.systemPurple) }
    static var systemRed: Color { color(.systemRed) }
    static var systemIndigo: Color { color(.systemIndigo) }
    static var systemBrown: Color { color(.systemBrown) }

    static var groupedBackground: Color {
        #if os(iOS)
        Color(uiColor: .systemGroupedBackground)
        #else
        Color(nsColor: .windowBackgroundColor)
        #endif
    }

    static var secondaryGroupedBackground: Color {
        #if os(iOS)
        Color(uiColor: .secondarySystemGroupedBackground)
        #else
        Color(nsColor: .controlBackgroundColor)
        #endif
    }

    static var tertiaryGroupedBackground: Color {
        #if os(iOS)
        Color(uiColor: .tertiarySystemGroupedBackground)
        #else
        Color(nsColor: .textBackgroundColor)
        #endif
    }

    static var secondaryFill: Color {
        #if os(iOS)
        Color(uiColor: .secondarySystemFill)
        #else
        Color(nsColor: .controlBackgroundColor)
        #endif
    }

    static var tertiaryFill: Color {
        #if os(iOS)
        Color(uiColor: .tertiarySystemFill)
        #else
        Color(nsColor: .unemphasizedSelectedContentBackgroundColor)
        #endif
    }

    #if os(iOS)
    private static func color(_ uiColor: UIColor) -> Color { Color(uiColor: uiColor) }
    #else
    private static func color(_ nsColor: NSColor) -> Color { Color(nsColor: nsColor) }
    #endif
}

extension View {
    @ViewBuilder
    func inlineNavigationBarTitle() -> some View {
        #if os(iOS)
        navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }

    @ViewBuilder
    func largeNavigationBarTitle() -> some View {
        #if os(iOS)
        navigationBarTitleDisplayMode(.large)
        #else
        self
        #endif
    }

    @ViewBuilder
    func pagedStudyTabStyle() -> some View {
        #if os(iOS)
        tabViewStyle(.page(indexDisplayMode: .never))
        #else
        tabViewStyle(.automatic)
        #endif
    }

    @ViewBuilder
    func platformTextAutocapitalizationWords() -> some View {
        #if os(iOS)
        textInputAutocapitalization(.words)
        #else
        self
        #endif
    }

    /// Wider readable column on Mac; full width on iPhone.
    @ViewBuilder
    func macReadableWidth(_ maxWidth: CGFloat = 900) -> some View {
        #if os(macOS)
        frame(maxWidth: maxWidth)
        .frame(maxWidth: .infinity)
        #else
        self
        #endif
    }

    @ViewBuilder
    func platformListStyle() -> some View {
        #if os(macOS)
        listStyle(.inset(alternatesRowBackgrounds: true))
        #else
        self
        #endif
    }
}
