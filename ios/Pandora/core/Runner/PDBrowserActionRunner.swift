//
//  PDBrowserActionRunner.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/3/3.
//

import WebKit
import GCWebContainer

public class PDBrowserActionRunner: NSObject {
    private(set) var pandora: Pandora
    private(set) weak var webView: PDWebView?
//    private(set) var serviceConfig: PDServiceConfigImpl?
    
    init(pandora: Pandora, webView: PDWebView?) {
        self.pandora = pandora
        self.webView = webView
    }
    
    func run() {
        _injectChromeBridge()
        _injectManifest()
    }
    
    private func _injectManifest() {
        let data = ["type": "CONTENT", "id": pandora.id, "manifest": (pandora.manifest.raw ?? [:])] as [String : Any];
        let injectInfoScript = "window.chrome.__loader__";
        let paramsStrBeforeFix = data.ext.toString()
        let paramsStr = JSServiceUtil.fixUnicodeCtrlCharacters(paramsStrBeforeFix ?? "")
        let script = injectInfoScript + "(\(paramsStr))"
        let userScript = WKUserScript(source: script,
                                      injectionTime: .atDocumentStart,
                                      forMainFrameOnly: true)
        webView?.addUserScript(userScript: userScript)
    }
    
    private func _injectChromeBridge() {
        if let chrome = PDManager.pandoraJS {
            let userScript = WKUserScript(source: chrome,
                                          injectionTime: .atDocumentStart,
                                          forMainFrameOnly: true)
            webView?.configuration.userContentController.addUserScript(userScript)
        }
    }
}
