//
//  KeychainManager.swift
//  QRCodeApp
//
//  Created by Kyrylo Chernov on 27.12.2023.
//

import Foundation
import KeychainSwift

class KeychainManager {
    static let shared = KeychainManager()
    
    let keychain = KeychainSwift()
    
    private lazy var jsonDecoder: JSONDecoder = {
        JSONDecoder()
    }()
    
    private lazy var jsonEncoder: JSONEncoder = {
        JSONEncoder()
    }()
    
    private init() {}
    
    func set<T: Encodable>(key: LocalStorageKey, value: T) throws {
        let data = try jsonEncoder.encode(value)
        keychain.set(data, forKey: key.rawValue)
    }
    
    func get<T: Decodable>(key: LocalStorageKey) throws -> T? {
        guard let data = keychain.getData(key.rawValue) else { return nil }
        let object = try jsonDecoder.decode(T.self, from: data)
        return object
    }
    
    func get<T:Decodable>(key: LocalStorageKey, defaultValue: T) throws -> T {
        let object: T = try get(key: key) ?? defaultValue
        return object
    }
}
