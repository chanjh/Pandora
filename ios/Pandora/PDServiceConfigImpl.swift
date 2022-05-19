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

extension PDServiceConfigImpl: PandoraWebUIConfig,
                               WebContainerModelConfig {
    var webView: GCWebView { pdWebView }
    var navigator: WebContainerNavigator? { PDManager.shared.delegate?.runnerDelegate }
    var cookie: WebContainerCookieHandler? { WebContainerCookieImpl.shared }
    var actionBar: PandoraActionBarHandler? { PDManager.shared.delegate?.actionBarManager }
}

protocol PandoraWebUIConfig: WebContainerUIConfig {
    var actionBar: PandoraActionBarHandler? { get }
}

extension PandoraWebUIConfig {
    var actionBar: PandoraActionBarHandler? { nil }
}

public protocol PandoraActionBarHandler {
    func setTitle(_ text: String, pandoraId: String)
    func setIcon(_ base64: String, pandoraId: String)
}
