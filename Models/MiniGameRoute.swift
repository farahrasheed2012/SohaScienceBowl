import Foundation

/// Typed routes for mini-game navigation from the hub.
enum MiniGameRoute: String, Hashable, CaseIterable, Identifiable {
    case scienceWordle
    case trueOrFalseBlitz
    case elementBlitz
    case moleculeMatch
    case cellBuilder

    var id: String { rawValue }

    var title: String {
        switch self {
        case .scienceWordle: return "Science Wordle"
        case .trueOrFalseBlitz: return "True or False Blitz"
        case .elementBlitz: return "Element Blitz"
        case .moleculeMatch: return "Molecule Match"
        case .cellBuilder: return "Cell Builder"
        }
    }

    var subtitle: String {
        switch self {
        case .scienceWordle: return "Guess the 5-letter science term"
        case .trueOrFalseBlitz: return "Rapid true/false fact checks"
        case .elementBlitz: return "90-second element sprint"
        case .moleculeMatch: return "Flip cards — formula ↔ name"
        case .cellBuilder: return "Drag organelles into place"
        }
    }

    var systemImage: String {
        switch self {
        case .scienceWordle: return "square.grid.3x3.fill"
        case .trueOrFalseBlitz: return "hand.thumbsup.fill"
        case .elementBlitz: return "atom"
        case .moleculeMatch: return "rectangle.on.rectangle.angled"
        case .cellBuilder: return "circle.grid.cross.fill"
        }
    }

    var accent: Subject {
        switch self {
        case .scienceWordle: return .physics
        case .trueOrFalseBlitz: return .biology
        case .elementBlitz: return .chemistry
        case .moleculeMatch: return .chemistry
        case .cellBuilder: return .biology
        }
    }
}
