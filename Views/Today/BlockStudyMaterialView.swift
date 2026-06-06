import SwiftUI

/// Read-only study material for a block — chapter, focus, formulas, deep-dive.
struct BlockStudyMaterialView: View {
    @Environment(AppState.self) private var appState
    let block: StudyBlock

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    SubjectBadge(subject: block.subject)
                    Spacer()
                    Text(block.primaryTopic)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if let workflow = DeepDiveContent.passWorkflow(week: block.week, pass: appState.currentPass) {
                    materialSection(title: "How to use this block", body: workflow)
                }

                materialSection(title: "Reading assignment", body: block.bookLine(for: appState.currentPass))

                if let theme = DeepDiveContent.weekTheme(week: block.week, pass: appState.currentPass) {
                    Text(theme)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color(uiColor: .systemBlue))
                }

                materialSection(
                    title: "Focus",
                    body: DeepDiveContent.blockContent(for: block, pass: appState.currentPass) ?? block.focus
                )

                materialSection(title: "Formulas & key terms", body: block.formulasAndTerms)

                materialSection(title: "Know cold") {
                    ForEach(Array(appState.knowColdItems(for: block).enumerated()), id: \.offset) { _, item in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.prompt)
                                .font(.subheadline.weight(.semibold))
                            if !item.answer.isEmpty {
                                Text(item.answer)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                if block.day == .friday, let note = DeepDiveContent.fridayReviewNote(week: block.week) {
                    materialSection(title: "Friday review block", body: note)
                }

                NavigationLink {
                    StudySessionView(block: block, initialStage: .read)
                } label: {
                    Label("Open full study session", systemImage: "book.fill")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(16)
        }
        .navigationTitle("Study material")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func materialSection(title: String, body: String) -> some View {
        materialSection(title: title) {
            Text(body)
                .font(.body)
        }
    }

    private func materialSection(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
