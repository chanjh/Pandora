//
//  SyncStorage.swift
//  Pandora
//
//  Created by 陈嘉豪 on 2022/4/26.
//

import Foundation

class SyncStorage {
    
    static let shared = SyncStorage()
    private static let key: String = "PandoraSync_"
    
    func set(_ object: Any, forKey key: String) {
        let realKey = "\(SyncStorage.key)\(key)"
        UserDefaults.standard.set(object, forKey: realKey)
        save(realKey)
    }
    
    func object(forKey key: String) -> Any? {
        return UserDefaults.standard.object(forKey: "\(SyncStorage.key)\(key)")
    }
    
    func clear() {
        let allkey = "\(SyncStorage.key)allKeys"
        if let list = UserDefaults.standard.array(forKey: allkey) as? [String] {
            list.forEach {
                UserDefaults.standard.removeObject(forKey: $0)
            }
        }
        UserDefaults.standard.removeObject(forKey: allkey)
    }
    
    private func save(_ key: String) {
        let allkey = "\(SyncStorage.key)allKeys"
        var list = UserDefaults.standard.array(forKey: allkey) as? [String] ?? []
        if !list.contains(key) {
            list.append(key)
            UserDefaults.standard.set(list, forKey: allkey)
        }
    }
}
