//
//  UserDefaultsService.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 24.12.2023.
//

import Foundation

enum LocalStorageKey: String, CaseIterable {
    case isFirstOpen
    case selectedLanguage
    case beepSelected
    case vibrationSelected
    case countScans
    case countCreates
    case startDidTap
    case tutorialPassed
}

protocol LocalStorageService {
    func set(_ value: Any?, key: LocalStorageKey)
    func get(key: LocalStorageKey) -> Any?
    func getBool(key: LocalStorageKey) -> Bool
    func getString(key: LocalStorageKey) -> String?
    func get<T>(key: LocalStorageKey) -> T? where T : Decodable
    func get<T>(key: LocalStorageKey, defaultValue: T) -> T where T : Decodable
    func set<T>(key: LocalStorageKey, value: T) where T : Codable
}

final class UserDefaultsService: LocalStorageService {
    static let shared = UserDefaultsService()
    private let defaults = UserDefaults.standard

    func set(_ value: Any?, key: LocalStorageKey) {
        defaults.setValue(value, forKey: key.rawValue)
    }
    
    func set<T>(key: LocalStorageKey, value: T) where T : Codable {
        defaults.set(try! JSONEncoder().encode(value), forKey: key.rawValue)
    }

    func get(key: LocalStorageKey) -> Any? {
        return defaults.value(forKey: key.rawValue)
    }
    
    func get<T>(key: LocalStorageKey) -> T? where T : Decodable {
        guard let data = defaults.object(forKey: key.rawValue) as? Data else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    func get<T>(key: LocalStorageKey, defaultValue: T) -> T where T : Decodable {
        guard let data = defaults.object(forKey: key.rawValue) as? Data else { return defaultValue }
        return (try? JSONDecoder().decode(T.self, from: data)) ?? defaultValue
    }

    func getBool(key: LocalStorageKey) -> Bool {
        return defaults.bool(forKey: key.rawValue)
    }

    func getString(key: LocalStorageKey) -> String? {
        return defaults.string(forKey: key.rawValue)
    }
}
