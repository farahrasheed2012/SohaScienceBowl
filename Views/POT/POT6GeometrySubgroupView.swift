import SwiftUI

struct POT6GeometrySubgroupView: View {
    @Environment(\.themePalette) private var theme
    let subgroup: POT6GeometrySubgroup
    private var mathProgress: MathProgressService { MathProgressService.shared }

    private var topics: [MathTopic] {
        mathProgress.geometryTrackTopics().filter { subgroup.topicCodes.contains($0.code) }
    }

    var body: some View {
        List {
            ForEach(topics) { topic in
                NavigationLink(value: StudyNavigationRoute.pot6Topic(code: topic.code)) {
                    topicRow(topic)
                }
            }
        }
        .platformListStyle()
        .navigationTitle(subgroup.rawValue)
        .largeNavigationBarTitle()
        .studyNavigationDestinations()
    }

    private func topicRow(_ topic: MathTopic) -> some View {
        HStack(spacing: 12) {
            Image(systemName: topic.masteryLevel.systemImage)
                .foregroundStyle(masteryColor(topic.masteryLevel))
            VStack(alignment: .leading, spacing: 4) {
                Text(topic.title)
                    .font(.body)
                Text(topic.code)
                    .font(.caption)
                    .foregroundStyle(theme.secondaryText)
            }
            Spacer()
            if mathProgress.attemptCount(for: topic.code) > 0 {
                Text("\(Int(topic.accuracyRate * 100))%")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(topic.accuracyRate >= 0.6 ? theme.success : theme.wrong)
            }
        }
        .padding(.vertical, 2)
    }

    private func masteryColor(_ level: MasteryLevel) -> Color {
        switch level {
        case .unseen: return theme.secondaryText
        case .learning: return PlatformColor.systemTeal.opacity(0.7)
        case .review: return PlatformColor.systemTeal
        case .mastered: return theme.success
        }
    }
}
