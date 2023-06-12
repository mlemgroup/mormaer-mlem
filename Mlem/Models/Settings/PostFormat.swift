import Foundation

enum PostFormat: String, SettingsOptions {
    var id: Self {
        return self
    }

    case small = "Small"
    case compact = "Compact"
    case regular = "Regular"

    var label: String {
        get {
            self.rawValue
        }
    }
}
