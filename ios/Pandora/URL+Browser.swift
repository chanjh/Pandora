//
//  URL+Browser.swift
//  BrowserKit
//
//  Created by 陈嘉豪 on 2022/7/14.
//

import Foundation

public extension URL {
    var isExtensionUrl: Bool {
        return scheme == PDURLSchemeHandler.scheme && PDManager.shared.pandoras.contains(where: { $0.id == host })
    }
}
