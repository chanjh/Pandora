//
//  PDContextMenuManager.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/2/26.
//

import Foundation
import GCWebContainer

class PDContextMenuManager: NSObject {
    static let shared: PDContextMenuManager = PDContextMenuManager()
    
    private var contextMenu: [MenuItem] = []
    
    var tabsManager: IPandoraTabsManager? { PDManager.shared.delegate?.tabsManager }
    
    override init() {
        super.init()
        tabsManager?.addObserver(self)
    }

    func addMenu(id: String,
                 title: String,
                 senderId: String?,
                 action: @escaping GCWebView.MenuAction) {
        let menu = MenuItem(id: id,
                            title: title,
                            senderId: senderId,
                            action: action)
        let fn: GCWebView.MenuAction = { browser in
            action(browser)
            PDContextMenuManager.shared.onMenuClicked(in: browser, at: menu)
        }
        self.contextMenu.append(menu)
        tabsManager?.pool.forEach {
            if let uiMenu = $0.makeMenuItem(uid: id,
                                            title: title,
                                            action: fn) {
                $0.contextMenu.addMenu(uiMenu)
            }
        }
    }
}

extension PDContextMenuManager: PDTabsEventListerner {
    func onActivated(tabId: Int) {
    }
    
    func onRemoved(tabId: Int, removeInfo: TabRemoveInfo) {
    }
    
    func onUpdated(tabId: Int, changeInfo: TabChangeInfo) {
        if (!(changeInfo.audible ?? false)) {
            return
        }
        let webView: PDWebView? = tabsManager?.webView(in: tabId)
        contextMenu.forEach { menu in
            let fn: GCWebView.MenuAction = { browser in
                menu.action(browser)
                PDContextMenuManager.shared.onMenuClicked(in: browser, at: menu)
            }
            if let uiMenu = webView?.makeMenuItem(uid: menu.id,
                                                  title: menu.title,
                                                  action: fn) {
                webView?.contextMenu.addMenu(uiMenu)
            }
        }
    }
}


fileprivate extension PDContextMenuManager {
    func onMenuClicked(in browser: GCWebView?, at menu: MenuItem) {
        var tab: [String: Any] = [:]
        if let browser = browser {
            tab["id"] = browser.identifier
        }
        if let pandora = PDManager.shared.pandoras.first(where: { $0.id == menu.senderId }) {
            let runners = PDManager.shared.findPandoraRunner(pandora)
            runners.forEach {
                let infoStr = ["menuItemId": menu.senderId].ext.toString() ?? "{}"
                let tabStr = tab.ext.toString() ?? "{}"
                $0.jsEngine?.eventCenter.publish("CONTEXTMENU_ONCLICKED",
                                                 arguments: [infoStr, tabStr],
                                                 completion: nil)
            }
        }
    }
    class MenuItem {
        open var id: String
        open var title: String
        open var senderId: String?
        open var action: GCWebView.MenuAction
        
        public init(id: String,
                    title: String,
                    senderId: String?,
                    action: @escaping GCWebView.MenuAction) {
            self.id = id
            self.title = title
            self.action = action
            self.senderId = senderId
        }
    }
}
