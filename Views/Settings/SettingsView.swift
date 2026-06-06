import SwiftUI
import UniformTypeIdentifiers

struct SettingsView: View {
    @Environment(AppState.self) private var appState

    @State private var showBackupImporter = false
    @State private var showBackupExporter = false
    @State private var exportDocument: ProgressBackupFileDocument?
    @State private var pendingBackup: ProgressBackup?
    @State private var showImportConfirm = false
    @State private var showBackupAlert = false
    @State private var backupAlertTitle = ""
    @State private var backupAlertMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Appearance", selection: Bindable(appState).appAppearance) {
                        ForEach(AppAppearance.allCases) { appearance in
                            Text(appearance.label).tag(appearance)
                        }
                    }
                } footer: {
                    Text("Dark (One Bee) uses large type and warm accents — the style from your original Science Bowl app.")
                }

                Section {
                    Toggle("Show countdown timer during Study Session", isOn: Bindable(appState).showSessionTimer)
                    Toggle("Parent reads toss-ups aloud", isOn: Bindable(appState).parentReadsAloud)
                } footer: {
                    Text("When enabled, answers stay hidden until you tap Reveal — for verbal practice with a parent.")
                }

                Section {
                    Toggle("Follow summer calendar", isOn: Bindable(appState).autoSyncScheduleFromCalendar)
                        .onChange(of: appState.autoSyncScheduleFromCalendar) { _, enabled in
                            if enabled {
                                appState.resetScheduleToCalendar()
                            }
                        }
                    Picker("Study week", selection: Binding(
                        get: { appState.currentWeek },
                        set: { appState.userDidSetWeek($0) }
                    )) {
                        ForEach(1...10, id: \.self) { w in
                            Text("Week \(w) · \(SeedData.topics(for: w)[.chemistry] ?? "")").tag(w)
                        }
                    }
                    .disabled(appState.autoSyncScheduleFromCalendar)
                    Picker("Current pass", selection: Binding(
                        get: { appState.currentPass },
                        set: { appState.userDidSetPass($0) }
                    )) {
                        ForEach(StudyPass.allCases) { p in
                            Text(p.label).tag(p)
                        }
                    }
                    .disabled(appState.autoSyncScheduleFromCalendar)
                    if appState.autoSyncScheduleFromCalendar {
                        Button("Reset week & pass to today's date") {
                            appState.resetScheduleToCalendar()
                        }
                    }
                } header: {
                    Text("Study plan")
                } footer: {
                    Text("With calendar sync on: Jun–Jul 3 = Pass 1 · Jul 6–Jul 31 = Pass 2 · Aug 3–14 = Pass 3. Turn off to set week and pass manually.")
                }

                Section {
                    Button {
                        prepareExport()
                    } label: {
                        Label("Export progress backup", systemImage: "square.and.arrow.up")
                    }

                    Button {
                        showBackupImporter = true
                    } label: {
                        Label("Import progress backup", systemImage: "square.and.arrow.down")
                    }
                } header: {
                    Text("Backup & restore")
                } footer: {
                    Text("Exports all progress to a JSON file — share via AirDrop, Files, or email. Import replaces current progress on this device. DOE PDFs are not included.")
                }

                Section {
                    Text("Import PDF, CSV, or JSON files into your local question bank.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } header: {
                    Text("Import questions")
                }

                Section {
                    doeStatusView

                    Button("Download all DOE PDFs") {
                        Task { await appState.downloadDOEQuestions(fullCatalog: true) }
                    }
                    .disabled(appState.doeStore.isDownloading || appState.isDOELoading)

                    Button("Download Set 1 + samples only") {
                        Task { await appState.downloadDOEQuestions(fullCatalog: false) }
                    }
                    .font(.caption)
                    .disabled(appState.doeStore.isDownloading || appState.isDOELoading)

                    Button("Re-parse downloaded PDFs") {
                        Task { await appState.loadDOEQuestions(forceReload: true) }
                    }
                    .disabled(appState.doeStore.isDownloading || appState.isDOELoading)
                } header: {
                    Text("DOE question bank")
                } footer: {
                    Text("PDFs save to the device. First launch auto-downloads all sets when none are present (~200 PDFs). Pass 2 plan quizzes lead with DOE questions.")
                }

                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.1.0")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Built for")
                        Spacer()
                        Text("Soha · NSB Middle School")
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .fileExporter(
                isPresented: $showBackupExporter,
                document: exportDocument,
                contentType: .json,
                defaultFilename: ProgressBackupService.defaultFilename()
            ) { result in
                if case .failure(let error) = result {
                    presentBackupAlert(title: "Export failed", message: error.localizedDescription)
                }
            }
            .fileImporter(
                isPresented: $showBackupImporter,
                allowedContentTypes: [.json]
            ) { result in
                handleImportResult(result)
            }
            .alert("Restore this backup?", isPresented: $showImportConfirm) {
                Button("Replace progress", role: .destructive) {
                    confirmImport()
                }
                Button("Cancel", role: .cancel) {
                    pendingBackup = nil
                }
            } message: {
                if let pendingBackup {
                    Text("\(ProgressBackupService.summary(for: pendingBackup))\n\nThis replaces all saved progress on this device.")
                }
            }
            .alert(backupAlertTitle, isPresented: $showBackupAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(backupAlertMessage)
            }
        }
    }

    private func prepareExport() {
        do {
            let data = try ProgressBackupService.encode(ProgressBackupService.makeBackup(from: appState))
            exportDocument = ProgressBackupFileDocument(data: data)
            showBackupExporter = true
        } catch {
            presentBackupAlert(title: "Export failed", message: error.localizedDescription)
        }
    }

    private func handleImportResult(_ result: Result<URL, Error>) {
        switch result {
        case .failure(let error):
            presentBackupAlert(title: "Import failed", message: error.localizedDescription)
        case .success(let url):
            importBackup(from: url)
        }
    }

    private func importBackup(from url: URL) {
        let accessed = url.startAccessingSecurityScopedResource()
        defer {
            if accessed { url.stopAccessingSecurityScopedResource() }
        }
        do {
            let data = try Data(contentsOf: url)
            let backup = try ProgressBackupService.decode(data)
            pendingBackup = backup
            showImportConfirm = true
        } catch {
            presentBackupAlert(title: "Import failed", message: error.localizedDescription)
        }
    }

    private func confirmImport() {
        guard let pendingBackup else { return }
        ProgressBackupService.apply(pendingBackup, to: appState)
        self.pendingBackup = nil
        presentBackupAlert(
            title: "Progress restored",
            message: ProgressBackupService.summary(for: pendingBackup)
        )
    }

    private func presentBackupAlert(title: String, message: String) {
        backupAlertTitle = title
        backupAlertMessage = message
        showBackupAlert = true
    }

    @ViewBuilder
    private var doeStatusView: some View {
        if appState.doeStore.isDownloading {
            VStack(alignment: .leading, spacing: 8) {
                ProgressView(value: appState.doeStore.downloadProgress)
                Text("Downloading \(appState.doeStore.downloadedPDFCount)/\(appState.doeStore.totalPDFCount) PDFs…")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        } else if appState.isDOELoading {
            HStack {
                ProgressView()
                Text("Parsing PDFs…")
                    .foregroundStyle(.secondary)
            }
        } else if appState.doeStore.isLoaded {
            VStack(alignment: .leading, spacing: 6) {
                Text("\(appState.doeStore.doeQuestions.count) total questions loaded")
                ForEach(appState.doeStore.categoryCounts(), id: \.category) { item in
                    HStack {
                        Text(item.category.rawValue)
                            .font(.caption)
                        Spacer()
                        Text("\(item.count)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        } else {
            Text(appState.doeStore.loadError ?? "Not loaded")
                .foregroundStyle(.secondary)
        }
    }
}

struct FormulaReferenceView: View {
    var body: some View {
        List {
            Section {
                ForEach(FormulaReference.physics) { f in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(f.text)
                            .font(.headline)
                        Text(f.use)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            } header: {
                Text("Physics")
            }

            Section {
                ForEach(FormulaReference.chemistry) { f in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(f.text)
                            .font(.headline)
                        Text(f.use)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            } header: {
                Text("Chemistry")
            }

            Section {
                ForEach(FormulaReference.biology) { f in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(f.text)
                            .font(.headline)
                        Text(f.use)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            } header: {
                Text("Biology")
            }

            Section {
                Text(FormulaReference.elements.joined(separator: ", "))
                    .font(.body)
            } header: {
                Text("First 20 elements")
            }

            Section {
                Text("H₂O · CO₂ · NaCl · C₆H₁₂O₆ · Na⁺ · Cl⁻ · O²⁻ · Ca²⁺")
            } header: {
                Text("Common compounds & ions")
            }

            Section {
                Text("meter (m) · kilogram (kg) · second (s) · kelvin (K) · mole (mol) · ampere (A)")
            } header: {
                Text("SI base units")
            }
        }
        .navigationTitle("Formula Reference")
        .navigationBarTitleDisplayMode(.inline)
    }
}
