import SwiftUI

struct SubjectBadge: View {
    let subject: Subject

    var color: Color {
        switch subject {
        case .biology: return PlatformColor.systemGreen
        case .chemistry: return PlatformColor.systemBlue
        case .physics: return PlatformColor.systemOrange
        }
    }

    var body: some View {
        Text(subject.rawValue)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
            .accessibilityLabel("\(subject.rawValue) subject")
    }
}

struct DOECategoryBadge: View {
    let category: DOECategory

    var color: Color {
        switch category {
        case .biology: return PlatformColor.systemGreen
        case .chemistry: return PlatformColor.systemBlue
        case .physics: return PlatformColor.systemOrange
        case .earthSpace: return PlatformColor.systemBrown
        case .energy: return PlatformColor.systemYellow
        case .math: return PlatformColor.systemPurple
        case .generalScience: return PlatformColor.systemTeal
        }
    }

    var body: some View {
        Text(category.rawValue)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}

struct QuestionCategoryBadge: View {
    let question: UnifiedQuestion

    var body: some View {
        if let subject = question.subject {
            SubjectBadge(subject: subject)
        } else {
            DOECategoryBadge(category: question.category)
        }
    }
}

struct StudyBlockCard: View {
    let block: StudyBlock
    let pass: StudyPass
    let timeLabel: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                SubjectBadge(subject: block.subject)
                Spacer()
                Text("\(block.day.shortName) · \(timeLabel)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(block.bookLine(for: pass))
                .font(.subheadline.weight(.semibold))

            Text(block.focus)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(3)

            if block.isFlashCardOnly {
                Label("Flash card mode", systemImage: "rectangle.on.rectangle")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else if pass == .pass2 {
                Text("Try DOE question first, then read.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(PlatformColor.secondaryGroupedBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .buttonStyle(.borderedProminent)
        .tint(PlatformColor.systemBlue)
    }
}
