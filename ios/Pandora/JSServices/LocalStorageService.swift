//
//  LocalStorageService.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/2/4.
//

import Foundation
import GCWebContainer

class LocalStorageService: PDBaseJSService, JSServiceHandler {
    var handleServices: [JSServiceType] {
        return [.localStorageSet, .localStorageGet, .localStorageClear]
    }

    func handle(message: JSServiceMessageInfo) {
        guard let params = message.params as? [String: Any] else {
            return
        }
        if message.serviceName == JSServiceType.localStorageSet.rawValue {
            params.forEach { LocalStorage.shared.set($1, forKey: $0) }
            if let callback = message.callback {
                webView?.jsEngine?.callFunction(callback,
                                                params: nil,
                                                in: nil,
                                                in: message.contentWorld,
                                                completion: nil)
            }
        } else if message.serviceName == JSServiceType.localStorageGet.rawValue {
            if let keys = params["keys"] as? [String], let callback = message.callback {
                var obj: [String: Any] = [:]
                keys.forEach { obj[$0] = LocalStorage.shared.object(forKey: $0) }
                webView?.jsEngine?.callFunction(callback, params: obj, in: nil, in: message.contentWorld, completion: nil)
            } else if let key = params["keys"] as? String, let callback = message.callback {
                if let obj = LocalStorage.shared.object(forKey: key) {
                    webView?.jsEngine?.callFunction(callback,
                                                    params: [key: obj],
                                                    in: nil,
                                                    in: message.contentWorld,
                                                    completion: nil)
                }
            }
        } else if message.serviceName == JSServiceType.localStorageClear.rawValue {
            LocalStorage.shared.clear()
            if let callback = message.callback {
                webView?.jsEngine?.callFunction(callback,
                                                params: nil,
                                                in: nil,
                                                in: message.contentWorld,
                                                completion: nil)
            }
        }
        // SyncStorage
        else if message.serviceName == JSServiceType.syncStorageSet.rawValue {
            params.forEach { SyncStorage.shared.set($1, forKey: $0) }
            if let callback = message.callback {
                webView?.jsEngine?.callFunction(callback,
                                                params: nil,
                                                in: nil,
                                                in: message.contentWorld,
                                                completion: nil)
            }
        } else if message.serviceName == JSServiceType.syncStorageGet.rawValue {
            if let keys = params["keys"] as? [String], let callback = message.callback {
                var obj: [String: Any] = [:]
                keys.forEach { obj[$0] = SyncStorage.shared.object(forKey: $0) }
                webView?.jsEngine?.callFunction(callback, params: obj, in: nil, in: message.contentWorld, completion: nil)
            } else if let key = params["keys"] as? String, let callback = message.callback {
                if let obj = SyncStorage.shared.object(forKey: key) {
                    webView?.jsEngine?.callFunction(callback,
                                                    params: [key: obj],
                                                    in: nil,
                                                    in: message.contentWorld,
                                                    completion: nil)
                }
            }
        } else if message.serviceName == JSServiceType.syncStorageClear.rawValue {
            SyncStorage.shared.clear()
            if let callback = message.callback {
                webView?.jsEngine?.callFunction(callback,
                                                params: nil,
                                                in: nil,
                                                in: message.contentWorld,
                                                completion: nil)
            }
        }
    }
}

extension JSServiceType {
    static let localStorageSet = JSServiceType("storage.local.set")
    static let localStorageGet = JSServiceType("storage.local.get")
    static let localStorageClear = JSServiceType("storage.local.clear")
    static let syncStorageSet = JSServiceType("storage.sync.set")
    static let syncStorageGet = JSServiceType("storage.sync.get")
    static let syncStorageClear = JSServiceType("storage.sync.clear")
}
