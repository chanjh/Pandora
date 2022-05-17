//
//  CookiesService.swift
//  GCWebContainer
//
//  Created by 陈嘉豪 on 2022/5/16.
//

import Foundation
import GCWebContainer

class CookiesService: PDBaseJSService, JSServiceHandler {
    var handleServices: [JSServiceType] {
        return [.cookiesGet, .cookiesGetAll]
    }
    
    func handle(message: JSServiceMessageInfo) {
        if message.serviceName == JSServiceType.cookiesGet.rawValue {
            guard let params = message.params as? [String: Any],
                    let name = params["name"] as? String,
                    let url = params["url"] as? String else {
                return
            }
            model?.cookie?.get(name: name, url: url, { [weak self] in
                if let cookie = $0 {
                    guard let callback = message.callback, let dict = $0?.toMap() else {
                        return
                    }
                    self?.webView?.configuration.websiteDataStore.httpCookieStore.setCookie(cookie, completionHandler: {  [weak self] in
                            self?.webView?.jsEngine?.callFunction(callback,
                                                                  params: dict,
                                                                  in: nil,
                                                                  in: message.contentWorld, completion: nil)
                    })
                }
            })
        }
    }

}
extension JSServiceType {
    static let cookiesGet    = JSServiceType("cookies.get")
    static let cookiesGetAll = JSServiceType("cookies.getAll")
}
