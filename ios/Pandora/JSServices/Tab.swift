//
//  Tabs.swift
//  Pandora
//
//  Created by 陈嘉豪 on 2022/4/25.
//

import Foundation

public class Tab {
    var active: Bool? = nil
    var audible: Bool? = nil
    var autoDiscardable: Bool? = nil
    var discarded: Bool? = nil
    var favIconUrl: String? = nil
    var groupId: Int? = nil
    var height: Int? = nil
    var highlighted: Bool? = nil
    public var id: Int? = nil
    var incognito: Bool? = nil // todo, 不是可选
    var index: Int? = nil // todo, 不是可选
    var mutedInfo: Any? = nil; // todo
    var openerTabId: Int? = nil
    var pendingUrl: String? = nil
    var pinned: Bool? = nil // todo, 不是可选
    var sessionId: String? = nil
    var status: TabStatus? = nil
    var title: String? = nil
    public var url: String? = nil
    var windowId: Int? = nil // todo, 不是可选
    var width: Int? = nil
    weak var webView: PDWebView?
    
    public func toMap() -> Dictionary<String, Any> {
        return ["id": "\(id ?? 0)", "url": url ?? ""];
    }
    
    public func toJSONString() -> String {
        return "{id: \"\(id ?? 0)\", url: \"\(url ?? "")\"}"
    }
    
    public init(id: Int? ) {
        self.id = id
    }
}

public class TabRemoveInfo: NSObject {
    public let isWindowClosing: Bool;
    public let windowId: Bool;
    public init(isWindowClosing: Bool, windowId: Bool) {
        self.isWindowClosing = isWindowClosing
        self.windowId = windowId
        super.init()
    }
    public func toString() -> String {
        return "{}"
    }
}
public class TabChangeInfo: NSObject {
    public var audible: Bool? = nil
    public let autoDiscardable: Bool? = nil
    public let discarded: Bool? = nil
    public let favIconUrl: String? = nil
    public let groupId: Int? = nil
    public let mutedInfo: TabMutedInfo? = nil
    public let pinned: Bool? = nil
    public let status: TabStatus? = nil
    public let title: String? = nil
    public let url: String? = nil
    public override init() { }
}


public enum TabStatus {
    
}

public struct TabMutedInfo {
    enum Reason {
        case user;
        case capture;
        case `extension`;
    }
    let extensionId: String?
    let muted: Bool
    let reason: Reason?
}

public class TabQueryInfo: NSObject {
    public var active: Bool = true
    var audible: Bool? = nil
    var autoDiscardable: Bool? = nil
    var currentWindow: Bool? = nil
    var discarded: Bool? = nil
    var groupId: Int? = nil
    var highlighted: Bool? = nil
    var index: Int? = nil
    var lastFocusedWindow: Bool? = nil
    var muted: Bool? = nil
    var pinned: Bool? = nil
    var status: TabStatus? = nil
    var title: String? = nil
    var url: String? = nil // todo string|string[]
    var windowId: Int? = nil
    var windowType: Any? = nil
    
    public init(_ raw: Dictionary<String, Any>) {
        super.init()
    }
    
    public func toString() -> String {
        return "{}"
    }
}
