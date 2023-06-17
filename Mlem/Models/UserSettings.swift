//
//  UserSettings.swift
//  Mlem
//
//  Created by Taylor Geisse on 6/16/23.
//  Source and credit: https://www.avanderlee.com/swift/appstorage-explained/
//  Adapted by Taylor to support Enums, Optionals, and constraints to only property list supported types.
//

import Foundation
import Combine
import SwiftUI

final class Preferences {
    static let standard = Preferences(userDefaults: .standard)
    fileprivate let userDefaults: UserDefaults
    
    /// Sends through the changed key path whenever a change occurs.
    var preferencesChangedSubject = PassthroughSubject<AnyKeyPath, Never>()
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - Defined UserDefaults Preferences
    @UserDefault("shouldShowWebsitePreviews") var shouldShowWebsitePreviews = true
    @UserDefault("shouldShowWebsiteFaviconAtAll") var shouldShowWebsiteFaviconAtAll = true
    @UserDefault("shouldShowWebsiteHost") var shouldShowWebsiteHost = true
    @UserDefault("shouldShowWebsiteFavicons") var shouldShowWebsiteFavicons = true
    
    @UserDefault("shouldShowCompactPosts") var shouldShowCompactPosts = false
    
    @UserDefault("shouldShowUserAvatars") var shouldShowUserAvatars = true
    @UserDefault("shouldShowCommunityIcons") var shouldShowCommunityIcons = true
    @UserDefault("shouldShowCommunityHeaders") var shouldShowCommunityHeaders = false
    
    @UserDefault("voteComplexStyle") var voteComplexStyle = VoteComplexStyle.standard
    @UserDefault("defaultCommentSorting") var defaultCommentSorting = CommentSortTypes.top
    
    @UserDefault("hasUndergoneLegacyAccountDeletion_debug_3") var hasUndergoneLegacyAccountDeletion_debug_3 = false
}

@propertyWrapper
struct Preference<Value>: DynamicProperty {
    @ObservedObject private var preferenceObserver: PublisherObservableObject
    private let keyPath: ReferenceWritableKeyPath<Preferences, Value>
    private let preferences: Preferences
    
    init(_ keyPath: ReferenceWritableKeyPath<Preferences, Value>, preferences: Preferences = .standard) {
        self.keyPath = keyPath
        self.preferences = preferences
        
        let publisher = preferences
                            .preferencesChangedSubject
                            .filter { $0 == keyPath }
                            .map { _ in () }
                            .eraseToAnyPublisher()
        
        self.preferenceObserver = .init(publisher: publisher)
    }
    
    var wrappedValue: Value {
        get { preferences[keyPath: keyPath] }
        nonmutating set { preferences[keyPath: keyPath] = newValue }
    }
    
    var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
    
    var publisher: ObservableObjectPublisher { preferenceObserver.objectWillChange }
}

final class PublisherObservableObject: ObservableObject {
    var subscriber: AnyCancellable?
    
    init(publisher: AnyPublisher<Void, Never>) {
        subscriber = publisher.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
}

@available(iOS 2.0, OSX 10.0, tvOS 9.0, watchOS 2.0, *)
@propertyWrapper
struct UserDefault<Value> {
    private var getter: (UserDefaults) -> Value
    private var setter: (UserDefaults, Value) -> Void
    
    @available(*, unavailable)
    var wrappedValue: Value {
        get { fatalError("Wrapped value should not be used.") }
        set { fatalError("Wrapped value should not be used.") }
    }
    
    // MARK: - Enum support for UserDefault
    init(wrappedValue defaultValue: Value, _ key: String) where Value: RawRepresentable {
        getter = {
            guard let rawValue = $0.object(forKey: key) as? Value.RawValue else { return defaultValue }
            return Value(rawValue: rawValue) ?? defaultValue
        }
        
        setter = { $0.set($1.rawValue, forKey: key) }
    }
    
    init<R>(wrappedValue defaultValue: Value = nil, _ key: String) where Value == R?, R: RawRepresentable {
        getter = {
            guard let rawValue = $0.object(forKey: key) as? R.RawValue else { return defaultValue }
            return R(rawValue: rawValue) ?? defaultValue
        }
        
        setter = { $0.set($1?.rawValue, forKey: key) }
    }
    
    // MARK: - Initializers for supported types
    init(wrappedValue defaultValue: Value, _ key: String) where Value: PropertyListValue {
        getter = { $0.object(forKey: key) as? Value ?? defaultValue }
        setter = { $0.set($1, forKey: key) }
    }
    
    init<R>(wrappedValue defaultValue: Value = nil, _ key: String) where Value == R?, R: PropertyListValue {
        getter = { $0.object(forKey: key) as? R ?? defaultValue }
        setter = { $0.set($1, forKey: key) }
    }
    
    public static subscript(
        _enclosingInstance instance: Preferences,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<Preferences, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<Preferences, Self>
    ) -> Value {
        get {
            instance[keyPath: storageKeyPath].getter(instance.userDefaults)
        }
        set {
            instance[keyPath: storageKeyPath].setter(instance.userDefaults, newValue)
            instance.preferencesChangedSubject.send(wrappedKeyPath)
        }
    }
}

public protocol PropertyListValue {}

extension NSData: PropertyListValue {}
extension Data: PropertyListValue {}

extension NSString: PropertyListValue {}
extension String: PropertyListValue {}

extension NSURL: PropertyListValue {}
extension URL: PropertyListValue {}

extension NSDate: PropertyListValue {}
extension Date: PropertyListValue {}

extension NSNumber: PropertyListValue {}
extension Bool: PropertyListValue {}
extension Int: PropertyListValue {}
extension Int8: PropertyListValue {}
extension Int16: PropertyListValue {}
extension Int32: PropertyListValue {}
extension Int64: PropertyListValue {}
extension UInt: PropertyListValue {}
extension UInt8: PropertyListValue {}
extension UInt16: PropertyListValue {}
extension UInt32: PropertyListValue {}
extension UInt64: PropertyListValue {}
extension Double: PropertyListValue {}
extension Float: PropertyListValue {}
#if os(macOS)
extension Float80: PropertyListValue {}
#endif

extension Array: PropertyListValue where Element: PropertyListValue {}
extension Dictionary: PropertyListValue where Key == String, Value: PropertyListValue {}
