import Foundation

enum Config {
    /// Reads ANTHROPIC_API_KEY from the app's Info.plist, which in turn should
    /// pull it from a build setting (e.g. an untracked Secrets.xcconfig) rather
    /// than a hardcoded string. See README.md for the full setup.
    static let anthropicAPIKey: String = {
        if let key = Bundle.main.object(forInfoDictionaryKey: "ANTHROPIC_API_KEY") as? String,
           !key.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
           !key.hasPrefix("$("),
           key != "sk-ant-your-key-here" {
            return key.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return ""
    }()

    static var hasValidAPIKey: Bool {
        !anthropicAPIKey.isEmpty
    }
}
