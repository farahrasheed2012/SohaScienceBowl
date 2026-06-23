import SwiftUI
import UniformTypeIdentifiers
import AVFoundation

struct SettingsView: View {
    @Environment(AppState.self) private var appState

    @State private var showBackupImporter = false
    @State private var showBackupExporter = false
    @State private var showCoachSummaryExporter = false
    @State private var exportDocument: ProgressBackupFileDocument?
    @State private var coachSummaryDocument: CoachSummaryFileDocument?
    @State private var pendingBackup: ProgressBackup?
    @State private var showImportConfirm = false
    @State private var showBackupAlert = false
    @State private var backupAlertTitle = ""
    @State private var backupAlertMessage = ""
    @State private var showClearProgressConfirm = false
    @State private var showResetXPConfirm = false

    var body: some View {
        NavigationStack {
            List {
                appearanceSection
                sessionSection
                speechSection
                studyPlanSection
                backupSection
                clearProgressSection
                coachSummarySection
                importSection
                doeSection
                aboutSection
            }
            .navigationTitle("Settings")
            .largeNavigationBarTitle()
            #if os(macOS)
            .listStyle(.inset(alternatesRowBackgrounds: true))
            #endif
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
            .fileExporter(
                isPresented: $showCoachSummaryExporter,
                document: coachSummaryDocument,
                contentType: .plainText,
                defaultFilename: CoachSummaryService.defaultFilename()
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
            .alert("Clear all progress?", isPresented: $showClearProgressConfirm) {
                Button("Clear everything", role: .destructive) {
                    appState.clearAllProgress()
                    presentBackupAlert(
                        title: "Progress cleared",
                        message: "Drills, checklist, flash cards, notebook, encyclopedia history, textbook reading checkmarks, and imported questions were reset. Your appearance and study-plan settings were kept."
                    )
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This cannot be undone. Export a backup first if you want to keep a copy.\n\nKeeps: appearance, session timer, parent-reads-aloud, and calendar sync settings. Resets week & pass to today's date.")
            }
            .alert("Reset XP and streak?", isPresented: $showResetXPConfirm) {
                Button("Reset", role: .destructive) {
                    XPManager.shared.resetProgress()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Clears total XP and day streak only. Drill history and checklist are not affected.")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Sections

    private var appearanceSection: some View {
        Section {
            Picker("Appearance", selection: Bindable(appState).appAppearance) {
                ForEach(AppAppearance.allCases) { appearance in
                    Text(appearance.label).tag(appearance)
                }
            }
            #if os(macOS)
            .pickerStyle(.menu)
            #endif
        } footer: {
            Text("Dark (One Bee) uses large type and warm accents — the style from your original Science Bowl app.")
        }
    }

    private var sessionSection: some View {
        Section {
            Toggle("Show countdown timer during Study Session", isOn: Bindable(appState).showSessionTimer)
            Toggle("Parent reads toss-ups aloud", isOn: Bindable(appState).parentReadsAloud)
        } footer: {
            Text("When enabled, answers stay hidden until you tap Reveal — for verbal practice with a parent.")
        }
    }

    private var speechSection: some View {
        Section {
            Toggle("Read questions aloud", isOn: Bindable(appState).readQuestionsAloud)
            Toggle("Auto-read each new question", isOn: Bindable(appState).autoReadQuestions)
                .disabled(!appState.readQuestionsAloud)
            TextField("Student name (for praise)", text: Bindable(appState).studentName)
                .disabled(!appState.readQuestionsAloud)
            Picker("Speech speed", selection: Bindable(appState).speechRatePreset) {
                ForEach(SpeechRatePreset.allCases) { preset in
                    Text(preset.label).tag(preset)
                }
            }
            .disabled(!appState.readQuestionsAloud)
            Picker("Voice", selection: speechVoiceBinding) {
                ForEach(SpeechVoiceCatalog.pickerVoices, id: \.identifier) { voice in
                    Text(SpeechVoiceCatalog.displayName(for: voice)).tag(Optional(voice.identifier))
                }
            }
            .disabled(!appState.readQuestionsAloud)
            #if os(macOS)
            .pickerStyle(.menu)
            #endif
            if appState.readQuestionsAloud, let voice = currentSpeechVoice {
                Text("Using \(SpeechVoiceCatalog.displayName(for: voice))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Button {
                SpeechManager.shared.previewVoice(
                    voiceIdentifier: appState.speechVoiceIdentifier,
                    rate: appState.speechRate
                )
            } label: {
                Label("Preview voice", systemImage: "speaker.wave.2.fill")
            }
            .disabled(!appState.readQuestionsAloud)
            Picker("Flash card review pace", selection: Bindable(appState).flashCardReviewPace) {
                ForEach(FlashCardReviewPace.allCases) { pace in
                    Text(pace.label).tag(pace)
                }
            }
            #if os(macOS)
            .pickerStyle(.menu)
            #endif
        } header: {
            Text("Speech & review")
        } footer: {
            Text("Enhanced or Premium voices sound most natural. Download more under System Settings → Accessibility → Spoken Content → Voices. Use Preview voice to test before drilling.")
        }
    }

    private var currentSpeechVoice: AVSpeechSynthesisVoice? {
        guard let id = appState.speechVoiceIdentifier else {
            return SpeechVoiceCatalog.preferredEnglishVoice()
        }
        return AVSpeechSynthesisVoice(identifier: id) ?? SpeechVoiceCatalog.preferredEnglishVoice()
    }

    private var speechVoiceBinding: Binding<String?> {
        Binding(
            get: { appState.speechVoiceIdentifier ?? SpeechVoiceCatalog.preferredDefaultVoiceIdentifier },
            set: { appState.speechVoiceIdentifier = $0 }
        )
    }

    private var studyPlanSection: some View {
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
                    ForEach(1...12, id: \.self) { w in
                    Text("Week \(w) · \(SeedData.topics(for: w)[.chemistry] ?? "")").tag(w)
                }
            }
            .disabled(appState.autoSyncScheduleFromCalendar)
            #if os(macOS)
            .pickerStyle(.menu)
            #endif
            if appState.autoSyncScheduleFromCalendar {
                Button("Reset week to today's date") {
                    appState.resetScheduleToCalendar()
                }
            }
        } header: {
            Text("Study plan")
        } footer: {
            Text("\(ScheduleConstants.summerPlanLabel()). Tro, CB, and BFN books are backups when primary texts feel dense. Use Quiz tab for extra DOE practice anytime.")
        }
    }

    private var backupSection: some View {
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
    }

    private var clearProgressSection: some View {
        Section {
            Button(role: .destructive) {
                showResetXPConfirm = true
            } label: {
                Label("Reset XP and streak", systemImage: "star.slash")
            }
            Button(role: .destructive) {
                showClearProgressConfirm = true
            } label: {
                Label("Clear all progress", systemImage: "trash")
            }
        } header: {
            Text("Reset")
        } footer: {
            Text("Removes drill scores, checklist checks, flash cards, notebook entries, encyclopedia review history, weak-topic stats, badges, imported questions, and textbook reading checkmarks. Does not delete DOE PDFs or bundled content.")
        }
    }

    private var coachSummarySection: some View {
        Section {
            Button {
                coachSummaryDocument = CoachSummaryFileDocument(text: CoachSummaryService.generate(from: appState))
                showCoachSummaryExporter = true
            } label: {
                Label("Export coach summary", systemImage: "doc.text")
            }
        } header: {
            Text("Parent / coach")
        } footer: {
            Text("Plain-text snapshot: week theme, accuracy by subject, checklist progress, weak topics, and badges.")
        }
    }

    private var importSection: some View {
        Section {
            Text("Import PDF, CSV, or JSON files into your local question bank.")
                .font(.caption)
                .foregroundStyle(.secondary)
        } header: {
            Text("Import questions")
        }
    }

    private var doeSection: some View {
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
            Text("Bundled starter cache works offline immediately. First launch downloads Set 0 + Set 1 only; use Download all for the full bank. Use Quiz → DOE anytime for extra toss-up practice.")
        }
    }

    private var aboutSection: some View {
        Section {
            LabeledContent("Version", value: "1.1.0")
            LabeledContent("Built for", value: "Soha · NSB Middle School")
        } header: {
            Text("About")
        }
    }

    // MARK: - Backup helpers

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
                HStack {
                    Image(systemName: appState.doeStore.isDrillReady ? "checkmark.circle.fill" : "exclamationmark.circle")
                        .foregroundStyle(appState.doeStore.isDrillReady ? .green : .orange)
                    Text(appState.doeStore.drillReadinessLabel)
                        .font(.subheadline.weight(.medium))
                }
                Text("\(appState.doeStore.doeQuestions.count) total questions loaded")
                if appState.doeStore.usesBundledStarter {
                    Text("Bundled starter cache — download PDFs for the full bank")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text("PDFs: \(appState.doeStore.downloadedPDFCount)/\(max(appState.doeStore.totalPDFCount, appState.doeStore.downloadedPDFCount))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
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
        .inlineNavigationBarTitle()
    }
}
