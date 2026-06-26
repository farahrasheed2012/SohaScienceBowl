import SwiftUI

enum POT6BookLibrary: String, CaseIterable, Identifiable, Hashable {
    case bfn = "BFN-A"
    case larson = "Larson"
    case openStax = "OpenStax"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .bfn: return BFNAlgebraCatalog.editionTitle
        case .larson: return MathAlgebraReadingCatalog.larsonTitle
        case .openStax: return MathAlgebraReadingCatalog.osaTitle
        }
    }

    var subtitle: String {
        switch self {
        case .bfn: return "ISBN \(BFNAlgebraCatalog.isbn) · main POT 6 book"
        case .larson: return "ISBN \(MathAlgebraReadingCatalog.larsonISBN) · print backup"
        case .openStax: return "Free online · Ch 2–6 mapped to POT topics"
        }
    }

    var icon: String {
        switch self {
        case .bfn: return "book.closed.fill"
        case .larson: return "book.fill"
        case .openStax: return "globe"
        }
    }
}

struct POT6BooksView: View {
    @Environment(\.themePalette) private var theme
    let initialLibrary: POT6BookLibrary
    @State private var selectedLibrary: POT6BookLibrary

    init(initialLibrary: POT6BookLibrary = .bfn) {
        self.initialLibrary = initialLibrary
        _selectedLibrary = State(initialValue: initialLibrary)
    }

    var body: some View {
        List {
            Picker("Book", selection: $selectedLibrary) {
                ForEach(POT6BookLibrary.allCases) { library in
                    Text(library.rawValue).tag(library)
                }
            }
            .pickerStyle(.segmented)
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))

            switch selectedLibrary {
            case .bfn:
                bfnContent
            case .larson:
                larsonContent
            case .openStax:
                openStaxContent
            }
        }
        .platformListStyle()
        .navigationTitle("Books & Materials")
        .inlineNavigationBarTitle()
    }

    @ViewBuilder
    private var bfnContent: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text(BFNAlgebraCatalog.editionTitle)
                    .font(.headline)
                Text("ISBN \(BFNAlgebraCatalog.isbn) · \(BFNAlgebraCatalog.chapterCount) chapters")
                    .font(.caption)
                    .foregroundStyle(theme.secondaryText)
                Text("Read each chapter: \(BFNAlgebraCatalog.chapterSectionGuide)")
                    .font(.caption)
                    .foregroundStyle(theme.secondaryText)
                Text("Full sections: \(BFNAlgebraCatalog.chapterSectionNames.joined(separator: " → "))")
                    .font(.caption2)
                    .foregroundStyle(theme.secondaryText)
            }
            .padding(.vertical, 4)
        }

        ForEach(BFNAlgebraCatalog.chaptersGroupedByUnit(), id: \.unit.id) { group in
            Section {
                ForEach(group.chapters) { chapter in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Ch \(chapter.number) — \(chapter.title)")
                            .font(.body)
                        Text("\(BFNAlgebraCatalog.pageLabel(forChapter: chapter.number)) · \(BFNAlgebraCatalog.chapterSectionGuide)")
                            .font(.caption)
                            .foregroundStyle(theme.secondaryText)
                    }
                    .padding(.vertical, 2)
                }
            } header: {
                Text("Unit \(group.unit.number) — \(group.unit.name)")
            }
        }
    }

    @ViewBuilder
    private var larsonContent: some View {
        Section {
            Text("\(MathAlgebraReadingCatalog.larsonTitle) (ISBN \(MathAlgebraReadingCatalog.larsonISBN))")
                .font(.subheadline)
                .foregroundStyle(theme.secondaryText)
        }

        Section("Chapters") {
            ForEach(MathAlgebraReadingCatalog.larsonChapters) { chapter in
                let sections = MathAlgebraReadingCatalog.larsonSections(inChapter: chapter.number)
                VStack(alignment: .leading, spacing: 4) {
                    Text(chapter.label)
                        .font(.body.weight(.medium))
                    if !sections.isEmpty {
                        Text(sections.map(\.label).joined(separator: " · "))
                            .font(.caption)
                            .foregroundStyle(theme.secondaryText)
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }

    @ViewBuilder
    private var openStaxContent: some View {
        Section {
            Link(destination: MathAlgebraReadingCatalog.osaBookHome) {
                Label("Open full book on openstax.org", systemImage: "arrow.up.right.square")
            }
            Text("Mapped sections appear on each topic in catch-up and Topics & Drills.")
                .font(.caption)
                .foregroundStyle(theme.secondaryText)
        }

        ForEach(MathAlgebraReadingCatalog.openStaxChapters2Through6) { chapter in
            Section {
                ForEach(chapter.sections) { section in
                    if let url = section.url {
                        Link(section.label, destination: url)
                    } else {
                        Text(section.label)
                            .foregroundStyle(theme.secondaryText)
                    }
                }
            } header: {
                Text("Ch \(chapter.number) — \(chapter.title)")
            }
        }
    }
}
