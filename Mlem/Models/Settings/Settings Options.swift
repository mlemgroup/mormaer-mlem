import Foundation

/// SettingsOptions is the protocol you should conform to in order to use the `SelectableSettingsItem`.
/// See the PostFormat implementation as an example.
protocol SettingsOptions: Codable, CaseIterable, Hashable, Identifiable {
    var label: String { get }
}
