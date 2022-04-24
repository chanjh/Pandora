//
//  Service.swift
//  ReadFlow
//
//  Created by Gill on 2020/1/27.
//  Copyright © 2020 陈嘉豪. All rights reserved.
//

import UIKit
import GCWebContainer

class ContextMenuService: PDBaseJSService, JSServiceHandler {
    var handleServices: [JSServiceType] {
        return [.setContextMenu, .clearContextMenu]
    }
    
    func handle(message: JSServiceMessageInfo) {
        if message.serviceName == JSServiceType.setContextMenu.rawValue {
            _handleSetContextMenu(message: message, callback: message.callback)
        } else if message.serviceName == JSServiceType.clearContextMenu.rawValue {
        }
    }

    private func _handleSetContextMenu(message: JSServiceMessageInfo, callback: String?) {
        guard let params = message.params as? [String: Any] else {
            return
        }
        var id = params["id"] as? String ?? UUID().uuidString
        id.removeAll { $0 == "-" }
        let title = params["title"] as? String ?? ""
        let onClick = params["onclickCallback"] as? String // 通过框架处理过的 callback 参数
        let selector = makeSelector(id: id, message: message, callback: onClick)
        let senderId = params["extensionId"] as? String ?? findSenderId(on: message)
        
        PDContextMenuManager.shared.addMenu(id: id,
                                            title: title,
                                            senderId: senderId,
                                            action: selector)
    }
    
    private func makeSelector(id: String, message: JSServiceMessageInfo, callback: String?) -> GCWebView.MenuAction {
        return { [weak self] browser in
            guard let `self` = self else { return }
            // todo params
            if let callback = callback {
                self.webView?.jsEngine?.callFunction(callback, params: [:], completion: nil)
            }
        }
    }
}

extension JSServiceType {
    static let setContextMenu   = JSServiceType("util.contextMenu.set")
    static let clearContextMenu = JSServiceType("util.contextMenu.clear")
}

struct OnClickedData {
    let chekced: Bool?
    let editable: Bool
    let frameId: Int?
    let frameUrl: String?
    let linkUrl: String?
    let mediaType: String?
    let menuItemId: Any? // (String|Int) https://stackoverflow.com/questions/41063722/in-swift-can-you-constrain-a-generic-to-two-types-string-and-int
    let pageUrl: String?
    let parentMenuItemId: Any? // string | int
    let selectionText: String?
    let srcUrl: String?
    let wasChecked: Bool?
    
    func toMap() -> [String: Any] {
        return [:]
    }
}
