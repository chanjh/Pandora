//
//  BrowserActionService.swift
//  GCWebContainer
//
//  Created by 陈嘉豪 on 2022/5/18.
//

import Foundation
import GCWebContainer

class BrowserActionService: PDBaseJSService, JSServiceHandler {
    var handleServices: [JSServiceType] {
        return [.browserActionSetTitle, .browserActionSetIcon]
    }
    
    func handle(message: JSServiceMessageInfo) {
        guard let params = message.params as? [String: Any] else {
            return
        }
        if message.serviceName == JSServiceType.browserActionSetTitle.rawValue,
           let title = params["title"] as? String,
           let id = findSenderId(on: message) {
            pdUI?.actionBar?.setTitle(title, pandoraId: id)
        } else if message.serviceName == JSServiceType.browserActionSetIcon.rawValue,
                  let id = findSenderId(on: message) {
            pdUI?.actionBar?.setTitle("", pandoraId: id)
        }
        
    }

}
extension JSServiceType {
    static let browserActionSetTitle    = JSServiceType("browserAction.setTitle")
    static let browserActionSetIcon = JSServiceType("browserAction.setIcon")
}
