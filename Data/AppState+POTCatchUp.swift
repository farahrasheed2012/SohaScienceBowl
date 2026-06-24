import Foundation

extension AppState {
    private static let pot6CatchUpKey = "pot6CatchUpCompletedCodes"

    var pot6CatchUpCompletedCodes: Set<String> {
        get { Set(UserDefaults.standard.stringArray(forKey: Self.pot6CatchUpKey) ?? []) }
        set { UserDefaults.standard.set(Array(newValue).sorted(), forKey: Self.pot6CatchUpKey) }
    }

    func isPOT6CatchUpDone(_ code: String) -> Bool {
        pot6CatchUpCompletedCodes.contains(code)
    }

    func togglePOT6CatchUp(_ code: String) {
        var codes = pot6CatchUpCompletedCodes
        if codes.contains(code) {
            codes.remove(code)
        } else {
            codes.insert(code)
        }
        pot6CatchUpCompletedCodes = codes
    }

    func resetPOT6CatchUpProgress() {
        pot6CatchUpCompletedCodes = []
    }

    var pot6CatchUpJanJuneProgress: (done: Int, total: Int) {
        let codes = POT6CatchUpCatalog.janJuneSchoolCodes
        let done = codes.filter { pot6CatchUpCompletedCodes.contains($0) }.count
        return (done, codes.count)
    }

    var pot6CatchUpPrerequisiteProgress: (done: Int, total: Int) {
        let codes = POT6CatchUpCatalog.prerequisiteCodes
        let done = codes.filter { pot6CatchUpCompletedCodes.contains($0) }.count
        return (done, codes.count)
    }

    var pot6CatchUpMasterProgress: (done: Int, total: Int) {
        let codes = POT6CatchUpCatalog.allSchoolCodes
        let done = codes.filter { pot6CatchUpCompletedCodes.contains($0) }.count
        return (done, codes.count)
    }
}
