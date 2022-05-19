//
//  PandoraDelegate.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/4/18.
//

import Foundation
import GCWebContainer

public protocol PandoraDelegate {
    var runnerDelegate: PandoraRunnerDelegate? { get }
    var bookMark: IPandoraBookmark? { get }
    var storage: IPandoraStorage? { get }
//    var contextMenu: IPandoraContextMenu? { get }
    var tabsManager: IPandoraTabsManager? { get }
    var actionBarManager: IPandoraActionBarManger? { get }
}

public extension PandoraDelegate {
    var runnerDelegate: PandoraRunnerDelegate? { nil }
    var bookMark: IPandoraBookmark? { nil }
    var storage: IPandoraStorage? { nil }
//    var contextMenu: IPandoraContextMenu? { nil }
    var tabsManager: IPandoraTabsManager? { nil }
    var actionBarManager: IPandoraActionBarManger? { nil }
}

public protocol PandoraRunnerDelegate: WebContainerNavigator { }

//protocol IPandoraContextMenu { }

public protocol IPandoraActionBarManger: PandoraActionBarHandler { }

public protocol IPandoraTabsManager {
    var pool: [PDWebView] { get }
    func addObserver(_ observer: PDTabsEventListerner)
    func removeObserver(_ observer: PDTabsEventListerner)
    func tabInfo(in identifier: Int) -> Tab?
    func webView(in identifier: Int) -> PDWebView?
    func remove(tab identifier: Int)
    func query(_ query: TabQueryInfo) -> [Tab]
}

public protocol IPandoraBookmark {
    
}

public protocol IPandoraStorage {
    func set(_ object: Any, forKey key: String)
    func object(forKey key: String) -> Any?
    func clear()
}

@objc public protocol PDTabsEventListerner: NSObjectProtocol {
    // Fires when the active tab in a window changes
    func onActivated(tabId: Int);
    // Fired when a tab is updated.
    func onUpdated(tabId: Int, changeInfo: TabChangeInfo);
    // Fired when a tab is closed.
    func onRemoved(tabId: Int, removeInfo: TabRemoveInfo);
}
