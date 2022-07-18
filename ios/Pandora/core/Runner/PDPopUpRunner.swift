//
//  PDPopUpRunner.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/2/10.
//

import WebKit
import GCWebContainer

class PDPopUpRunner: NSObject {
    private(set) var pandora: Pandora
    private(set) var webView: PDWebView?
    private(set) var serviceConfig: PDServiceConfigImpl?
    
    init(pandora: Pandora) {
        self.pandora = pandora
    }
    
    func run() -> PDWebView {
        let pageWebView = PDWebView(frame: .zero,
                                    type: .popup(pandora.id))
        let serviceConfig = PDServiceConfigImpl(pageWebView)
        self.serviceConfig = serviceConfig
        self.webView = pageWebView
        pageWebView.model = serviceConfig
        pageWebView.ui = serviceConfig
        pageWebView.actionHandler.addObserver(self)
        _injectChromeBridge(pageWebView)
        return pageWebView
    }
    
    private func _injectChromeBridge(_ webView: PDWebView) {
        if let chrome = PDManager.pandoraJS {
            let userScript = WKUserScript(source: chrome,
                                          injectionTime: .atDocumentStart,
                                          forMainFrameOnly: true)
            webView.configuration.userContentController.addUserScript(userScript)
        }
    }
}


extension PDPopUpRunner: GCWebViewActionObserver {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let data = ["type": "BACKGROUND", "id": pandora.id, "manifest": (pandora.manifest.raw ?? [:])] as [String : Any];
        let injectInfoScript = "window.chrome.__loader__";
        (webView as? PDWebView)?.jsEngine?.callFunction(injectInfoScript, params: data as [String : Any], completion: nil)
        
//        let onInstalledScript = "window.gc.bridge.eventCenter.publish('PD_EVENT_RUNTIME_ONINSTALLED');";
//        webView.evaluateJavaScript(onInstalledScript, completionHandler: nil)
    }
}
