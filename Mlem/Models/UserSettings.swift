//
//  UserSettings.swift
//  Mlem
//
//  Created by Taylor Geisse on 6/16/23.
//

import Foundation
import SwiftUI

struct UserSettings {
    let shouldShowWebsitePreviews = Setting(key: "shouldShowWebsitePreviews", defaultValue: true)
    let shouldShowWebsiteFaviconAtAll = Setting(key: "shouldShowWebsiteFaviconAtAll", defaultValue: true)
    let shouldShowWebsiteHost = Setting(key: "shouldShowWebsiteHost", defaultValue: true)
    let shouldShowWebsiteFavicons = Setting(key: "shouldShowWebsiteFavicons", defaultValue: true)
    
    let shouldShowCompactPosts = Setting(key: "shouldShowCompactPosts", defaultValue: false)
    
    let shouldShowUserAvatars = Setting(key: "shouldShowUserAvatars", defaultValue: true)
    let shouldShowCommunityIcons = Setting(key: "shouldShowCommunityIcons", defaultValue: true)
    let shouldShowCommunityHeaders = Setting(key: "shouldShowCommunityHeaders", defaultValue: false)
    
    let voteComplexStyle = Setting(key: "voteComplexStyle", defaultValue: VoteComplexStyle.standard)
    
    let defaultCommentSorting = Setting(key: "defaultCommentSorting", defaultValue: CommentSortTypes.top)
    
    let hasUndergoneLegacyAccountDeletion_debug_3 = Setting(key: "hasUndergoneLegacyAccountDeletion_debug_3", defaultValue: false)
    
    static let shared = UserSettings()
    private init() {}
    
    struct Setting<Value> {
        let key: String
        let defaultValue: Value
        
        init(key: String, defaultValue: Value) {
            self.key = key
            self.defaultValue = defaultValue
        }
        
        init(key: String) where Value: ExpressibleByNilLiteral {
            self.key = key
            self.defaultValue = nil
        }
    }
}


// MARK: - AppStorage Extension for Non-Optionals
@available(iOS 14, macOS 11, macCatalyst 14, tvOS 14, watchOS 7, *)
extension AppStorage where Value == String {
    init(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults? = nil) {
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.init(wrappedValue: setting.defaultValue,
                  setting.key,
                  store: store)
    }
}

@available(iOS 14, macOS 11, macCatalyst 14, tvOS 14, watchOS 7, *)
extension AppStorage where Value: RawRepresentable, Value.RawValue == Int {
    init(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults? = nil) {
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.init(wrappedValue: setting.defaultValue,
                  setting.key,
                  store: store)
    }
}

@available(iOS 14, macOS 11, macCatalyst 14, tvOS 14, watchOS 7, *)
extension AppStorage where Value == Data {
    init(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults? = nil) {
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.init(wrappedValue: setting.defaultValue,
                  setting.key,
                  store: store)
    }
}

@available(iOS 14, macOS 11, macCatalyst 14, tvOS 14, watchOS 7, *)
extension AppStorage where Value == Int {
    init(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults? = nil) {
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.init(wrappedValue: setting.defaultValue,
                  setting.key,
                  store: store)
    }
}

@available(iOS 14, macOS 11, macCatalyst 14, tvOS 14, watchOS 7, *)
extension AppStorage where Value: RawRepresentable, Value.RawValue == String {
    init(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults? = nil) {
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.init(wrappedValue: setting.defaultValue,
                  setting.key,
                  store: store)
    }
}

@available(iOS 14, macOS 11, macCatalyst 14, tvOS 14, watchOS 7, *)
extension AppStorage where Value == URL {
    init(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults? = nil) {
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.init(wrappedValue: setting.defaultValue,
                  setting.key,
                  store: store)
    }
}

@available(iOS 14, macOS 11, macCatalyst 14, tvOS 14, watchOS 7, *)
extension AppStorage where Value == Double {
    init(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults? = nil) {
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.init(wrappedValue: setting.defaultValue,
                  setting.key,
                  store: store)
    }
}

@available(iOS 14, macOS 11, macCatalyst 14, tvOS 14, watchOS 7, *)
extension AppStorage where Value == Bool {
    init(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults? = nil) {
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.init(wrappedValue: setting.defaultValue,
                  setting.key,
                  store: store)
    }
}

// MARK: - AppStorage Extension for ExpressibleByNilLiteral
@available(iOS 14, macOS 11, macCatalyst 14, tvOS 14, watchOS 7, *)
extension AppStorage where Value == Int? {
    init(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults? = nil) {
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.init(setting.key,
                  store: store)
    }
}

@available(iOS 14, macOS 11, macCatalyst 14, tvOS 14, watchOS 7, *)
extension AppStorage where Value == String? {
    init(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults? = nil) {
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.init(setting.key,
                  store: store)
    }
}

@available(iOS 14, macOS 11, macCatalyst 14, tvOS 14, watchOS 7, *)
extension AppStorage where Value == Double? {
    init(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults? = nil) {
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.init(setting.key,
                  store: store)
    }
}

@available(iOS 15, macOS 12, macCatalyst 15, tvOS 15, watchOS 8, *)
extension AppStorage {
    init<R>(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults? = nil)
    where Value == R?, R: RawRepresentable, R.RawValue == Int
    {
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.init(setting.key,
                  store: store)
    }
}

@available(iOS 15, macOS 12, macCatalyst 15, tvOS 15, watchOS 8, *)
extension AppStorage {
    init<R>(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults? = nil)
    where Value == R?, R: RawRepresentable, R.RawValue == String
    {
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.init(setting.key,
                  store: store)
    }
}

@available(iOS 14, macOS 11, macCatalyst 14, tvOS 14, watchOS 7, *)
extension AppStorage where Value == Data? {
    init(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults? = nil) {
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.init(setting.key,
                  store: store)
    }
}

@available(iOS 14, macOS 11, macCatalyst 14, tvOS 14, watchOS 7, *)
extension AppStorage where Value == Bool? {
    init(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults? = nil) {
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.init(setting.key,
                  store: store)
    }
}

@available(iOS 14, macOS 11, macCatalyst 14, tvOS 14, watchOS 7, *)
extension AppStorage where Value == URL? {
    init(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults? = nil) {
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.init(setting.key,
                  store: store)
    }
}

@available(iOS 17, macOS 14, macCatalyst 17, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension AppStorage {
    init<RowValue>(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults? = nil)
    where Value == TableColumnCustomization<RowValue>, RowValue: Identifiable
    {
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.init(wrappedValue: setting.defaultValue,
                  setting.key,
                  store: store)
    }
}

// MARK: - UserDefault property wrapper for use in non-SwiftUI code
@propertyWrapper
class UserDefault<Value> {
    private var defaultValue: Value
    private var key: String
    private var container: UserDefaults
    
    private var getter: () -> Value = {
        fatalError("UserDefault getter was not replaced during initialization")
        // return UserDefaults.standard.object(forKey: "willBeOverriden") as! Value
    }
    private var setter: (Value) -> Void = { _ in
        fatalError("UserDefault setter was not replaced during initialization")
    }
    
    var wrappedValue: Value {
        get { getter() }
        set { setter(newValue) }
    }
    
    // MARK: - Non-optional inits for supported types
    init(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults = .standard)
    where Value == String {
        
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.defaultValue = setting.defaultValue
        self.key = setting.key
        self.container = store
        
        getter = { self.container.string(forKey: self.key) ?? self.defaultValue }
        setter = { self.container.set($0, forKey: self.key) }
    }
    
    init(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults = .standard)
    where Value: RawRepresentable {
        
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.defaultValue = setting.defaultValue
        self.key = setting.key
        self.container = store
        
        getter = {
            guard let rawValue = self.container.object(forKey: self.key) as? Value.RawValue else { return self.defaultValue }
            return Value(rawValue: rawValue) ?? self.defaultValue
        }
        setter = { self.container.set($0.rawValue, forKey: self.key) }
    }
    
    init(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults = .standard)
    where Value == Data {
        
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.defaultValue = setting.defaultValue
        self.key = setting.key
        self.container = store
        
        getter = { self.container.data(forKey: self.key) ?? self.defaultValue }
        setter = { self.container.set($0, forKey: self.key) }
    }
    
    init(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults = .standard)
    where Value == Int {
        
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.defaultValue = setting.defaultValue
        self.key = setting.key
        self.container = store
        
        getter = { self.container.object(forKey: self.key) as? Int ?? self.defaultValue }
        setter = { self.container.set($0, forKey: self.key) }
    }
    
    init(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults = .standard)
    where Value == URL {
        
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.defaultValue = setting.defaultValue
        self.key = setting.key
        self.container = store
        
        getter = { self.container.url(forKey: self.key) ?? self.defaultValue }
        setter = { self.container.set($0, forKey: self.key) }
    }
    
    init(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults = .standard)
    where Value == Double {
        
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.defaultValue = setting.defaultValue
        self.key = setting.key
        self.container = store
        
        getter = { self.container.object(forKey: self.key) as? Double ?? self.defaultValue }
        setter = { self.container.set($0, forKey: self.key) }
    }
    
    init(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults = .standard)
    where Value == Bool {
        
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.defaultValue = setting.defaultValue
        self.key = setting.key
        self.container = store
        
        getter = { self.container.object(forKey: self.key) as? Bool ?? self.defaultValue }
        setter = { self.container.set($0, forKey: self.key) }
    }
    
    // MARK: - Optional (ExpressibleByNilLiteral) initiatilzers
    init(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults = .standard)
    where Value == Int? {
        
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.defaultValue = setting.defaultValue
        self.key = setting.key
        self.container = store
        
        getter = { self.container.object(forKey: self.key) as? Value ?? self.defaultValue }
        setter = { self.container.set($0, forKey: self.key) }
    }
    
    init(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults = .standard)
    where Value == String? {
        
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.defaultValue = setting.defaultValue
        self.key = setting.key
        self.container = store
        
        getter = { self.container.object(forKey: self.key) as? Value ?? self.defaultValue }
        setter = { self.container.set($0, forKey: self.key) }
    }
    
    init(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults = .standard)
    where Value == Double? {
        
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.defaultValue = setting.defaultValue
        self.key = setting.key
        self.container = store
        
        getter = { self.container.object(forKey: self.key) as? Value ?? self.defaultValue }
        setter = { self.container.set($0, forKey: self.key) }
    }
    
    init<R>(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults = .standard)
    where Value == R?, R: RawRepresentable {
        
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.defaultValue = setting.defaultValue
        self.key = setting.key
        self.container = store
        
        getter = {
            guard let rawVal = self.container.object(forKey: self.key) as? R.RawValue else { return self.defaultValue }
            return R(rawValue: rawVal) ?? self.defaultValue
        }
        setter = {
            self.container.set($0?.rawValue, forKey: self.key)
        }
    }
    
    init(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults = .standard)
    where Value == Data? {
        
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.defaultValue = setting.defaultValue
        self.key = setting.key
        self.container = store
        
        getter = { self.container.object(forKey: self.key) as? Value ?? self.defaultValue }
        setter = { self.container.set($0, forKey: self.key) }
    }
    
    init(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults = .standard)
    where Value == Bool? {
        
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.defaultValue = setting.defaultValue
        self.key = setting.key
        self.container = store
        
        getter = { self.container.object(forKey: self.key) as? Value ?? self.defaultValue }
        setter = { self.container.set($0, forKey: self.key) }
    }
    
    init(_ settingKeyPath: KeyPath<UserSettings, UserSettings.Setting<Value>>, store: UserDefaults = .standard)
    where Value == URL? {
        
        let setting = UserSettings.shared[keyPath: settingKeyPath]
        
        self.defaultValue = setting.defaultValue
        self.key = setting.key
        self.container = store
        
        getter = { self.container.object(forKey: self.key) as? Value ?? self.defaultValue }
        setter = { self.container.set($0, forKey: self.key) }
    }
}
