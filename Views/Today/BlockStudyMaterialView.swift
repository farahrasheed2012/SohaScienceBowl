import SwiftUI

/// Read-only study material for a block — chapter, focus, formulas, deep-dive.
struct BlockStudyMaterialView: View {
    let block: StudyBlock

    var body: some View {
        ScrollView {
            StudyMaterialScrollContent(block: block)
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .padding(.bottom, 8)
        }
        .background(PlatformColor.groupedBackground)
        .navigationTitle("Study material")
        .inlineNavigationBarTitle()
        .safeAreaInset(edge: .bottom) {
            NavigationLink {
                StudySessionView(block: block, initialStage: .read)
            } label: {
                Label("Open full study session", systemImage: "text.book.closed.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(.bar)
        }
    }
}
