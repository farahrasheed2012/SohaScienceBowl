import SwiftUI

// MARK: - Colors (game dark theme — shared with TossUp)

enum GameColors {
    static let biology = Color(red: 0.18, green: 0.75, blue: 0.47)
    static let chemistry = Color(red: 0.40, green: 0.52, blue: 0.98)
    static let physics = Color(red: 1.00, green: 0.58, blue: 0.18)
    static let math = Color(red: 0.55, green: 0.45, blue: 0.95)

    static let appBackground = Color(red: 0.07, green: 0.07, blue: 0.10)
    static let cardSurface = Color(red: 0.13, green: 0.13, blue: 0.18)
    static let cardSurface2 = Color(red: 0.18, green: 0.18, blue: 0.24)

    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.60)
    static let textTertiary = Color.white.opacity(0.35)

    static let correct = biology
    static let incorrect = Color(red: 0.85, green: 0.25, blue: 0.25)
    static let xpGold = Color.yellow
    static let streakFlame = Color.orange
}

extension Subject {
    var gameColor: Color {
        switch self {
        case .biology: return GameColors.biology
        case .chemistry: return GameColors.chemistry
        case .physics: return GameColors.physics
        }
    }

    var gameIcon: String {
        switch self {
        case .biology: return "leaf.fill"
        case .chemistry: return "flask.fill"
        case .physics: return "bolt.fill"
        }
    }
}

// MARK: - Typography

enum GameFont {
    static func largeTitle(_ weight: Font.Weight = .bold) -> Font {
        .system(.largeTitle, design: .rounded, weight: weight)
    }

    static func title2(_ weight: Font.Weight = .semibold) -> Font {
        .system(.title2, design: .rounded, weight: weight)
    }

    static func headline(_ weight: Font.Weight = .semibold) -> Font {
        .system(.headline, design: .rounded, weight: weight)
    }

    static func body(_ weight: Font.Weight = .regular) -> Font {
        .system(.body, design: .rounded, weight: weight)
    }

    static func caption(_ weight: Font.Weight = .medium) -> Font {
        .system(.caption, design: .rounded, weight: weight)
    }

    static func title3(_ weight: Font.Weight = .semibold) -> Font {
        .system(.title3, design: .rounded, weight: weight)
    }
}

// MARK: - Modifiers

struct GameCard: ViewModifier {
    var color: Color = GameColors.cardSurface
    var padding: CGFloat = 16

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

extension View {
    func gameCard(color: Color = GameColors.cardSurface, padding: CGFloat = 16) -> some View {
        modifier(GameCard(color: color, padding: padding))
    }

    func subjectBleed(_ subject: Subject?) -> some View {
        background {
            if let subject {
                LinearGradient(
                    colors: [subject.gameColor.opacity(0.15), Color.clear],
                    startPoint: .top,
                    endPoint: .center
                )
                .ignoresSafeArea()
            }
        }
    }

    func pressScale(_ isPressed: Bool) -> some View {
        scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.25), value: isPressed)
    }
}

// MARK: - XP / Streak bar

struct XPStreakBar: View {
    let streak: Int
    let xp: Int

    var body: some View {
        HStack(spacing: 16) {
            Spacer()
            Label("\(streak)", systemImage: "flame.fill")
                .font(GameFont.caption(.semibold))
                .foregroundStyle(GameColors.streakFlame)
            Label("\(xp) XP", systemImage: "star.fill")
                .font(GameFont.caption(.semibold))
                .foregroundStyle(GameColors.xpGold)
        }
    }
}

// MARK: - Buzz button + countdown arc

struct BuzzButton: View {
    let subjectColor: Color
    let progress: CGFloat
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        ZStack {
            Circle()
                .stroke(subjectColor.opacity(0.15), lineWidth: 4)
                .frame(width: 232, height: 232)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(arcColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .frame(width: 232, height: 232)
                .animation(.linear(duration: 0.05), value: progress)

            Button(action: action) {
                Text("BUZZ ⚡")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(width: 200, height: 72)
                    .background(subjectColor)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .shadow(color: subjectColor.opacity(0.5), radius: 16, y: 6)
            }
            .buttonStyle(.plain)
            .scaleEffect(isPressed ? 0.93 : 1.0)
            .animation(.spring(response: 0.2), value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in isPressed = false }
            )
        }
    }

    private var arcColor: Color {
        progress < 0.3 ? GameColors.incorrect : subjectColor
    }
}

// MARK: - XP float animation

struct XPFloater: View {
    let amount: Int
    @Binding var isVisible: Bool

    var body: some View {
        if isVisible {
            Text("+\(amount) XP")
                .font(GameFont.headline(.bold))
                .foregroundStyle(GameColors.xpGold)
                .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
}

// MARK: - Coach greeting

enum CoachCopy {
    static func timeGreeting(name: String) -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        let salutation: String
        switch hour {
        case 5..<12: salutation = "Good morning"
        case 12..<17: salutation = "Good afternoon"
        default: salutation = "Good evening"
        }
        return "\(salutation), \(name)! 👋"
    }

    static func drillHeadline(correct: Int, total: Int) -> String {
        let ratio = total > 0 ? Double(correct) / Double(total) : 0
        switch ratio {
        case 1.0: return "Perfect Round! 🏆"
        case 0.8...: return "Great Round! 🎉"
        case 0.6...: return "Solid Work! 💪"
        case 0.4...: return "Getting There! 📈"
        default: return "Let's Keep Drilling 🔄"
        }
    }
}

// MARK: - Launch card

struct DrillLaunchCard: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let accent: Color
    var actionTitle: String = "Let's go →"
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label(title, systemImage: systemImage)
                .font(GameFont.title2())
                .foregroundStyle(accent)
            Text(subtitle)
                .font(GameFont.body())
                .foregroundStyle(GameColors.textSecondary)
            Button(action: action) {
                Text(actionTitle)
                    .font(GameFont.headline())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(accent)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .buttonStyle(.plain)
        }
        .gameCard(color: GameColors.cardSurface)
    }
}
