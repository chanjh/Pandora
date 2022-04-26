//
//  BookmarkService.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/2/4.
//

import Foundation
import GCWebContainer

class BookmarkService: PDBaseJSService, JSServiceHandler {
    var handleServices: [JSServiceType] {
        return [.bookmarksCreate,
                .bookmarksGetTree,
                .bookmarksRemove,
                .bookmarksUpdate]
    }

    func handle(message: JSServiceMessageInfo) {
        guard let params = message.params as? [String: Any] else {
            return
        }
        if message.serviceName == JSServiceType.bookmarksCreate.rawValue {
            
        }
    }
}

extension JSServiceType {
    static let bookmarksCreate = JSServiceType("bookmarks.create")
    static let bookmarksGetTree = JSServiceType("bookmarks.getTree")
    static let bookmarksRemove = JSServiceType("bookmarks.remove")
    static let bookmarksUpdate = JSServiceType("bookmarks.update")
}
