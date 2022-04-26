//
//  LocalStorage.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/2/4.
//

import Foundation

class LocalStorage {
    
    static let shared = LocalStorage()
    private static let key: String = "Pandora_"
    
    func set(_ object: Any, forKey key: String) {
        let realKey = "\(LocalStorage.key)\(key)"
        UserDefaults.standard.set(object, forKey: realKey)
        save(realKey)
    }
    
    func object(forKey key: String) -> Any? {
        return UserDefaults.standard.object(forKey: "\(LocalStorage.key)\(key)")
    }
    
    func clear() {
        let allkey = "\(LocalStorage.key)allKeys"
        if let list = UserDefaults.standard.array(forKey: allkey) as? [String] {
            list.forEach {
                UserDefaults.standard.removeObject(forKey: $0)
            }
        }
        UserDefaults.standard.removeObject(forKey: allkey)
    }
    
    private func save(_ key: String) {
        let allkey = "\(LocalStorage.key)allKeys"
        var list = UserDefaults.standard.array(forKey: allkey) as? [String] ?? []
        if !list.contains(key) {
            list.append(key)
            UserDefaults.standard.set(list, forKey: allkey)
        }
    }
}
