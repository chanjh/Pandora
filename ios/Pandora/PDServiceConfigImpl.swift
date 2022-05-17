//
//  PDServiceConfigImpl.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/1/20.
//

import Foundation
import UIKit
import GCWebContainer

class PDServiceConfigImpl {
    private let pdWebView: PDWebView
    init(_ webView: PDWebView) {
        self.pdWebView = webView
    }
}

extension PDServiceConfigImpl: WebContainerUIConfig,
                               WebContainerModelConfig {
    var webView: GCWebView { pdWebView }
    var navigator: WebContainerNavigator? { PDManager.shared.delegate?.runnerDelegate }
    var cookie: WebContainerCookieHandler? { WebContainerCookieImpl.shared }
}
