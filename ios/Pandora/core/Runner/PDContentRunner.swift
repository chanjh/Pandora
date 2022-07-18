//
//  PDContentRunner.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/2/10.
//

import WebKit
import GCWebContainer

public class PDContentRunner {
    weak var webView: GCWebView?
    public private(set) var pandoras: [Pandora] = []
    
    init(_ webView: GCWebView) {
        self.webView = webView
    }
    
    func run() {
        PDManager.shared.loaders.forEach { loader in
            if let pandora = loader.pandora {
                pandoras.append(pandora)
                let contentWorld = WKContentWorld.world(name: pandora.id)
                // - webkit.messageHandler
                if let jsManager = webView?.jsServiceManager {
                    webView?.configuration.userContentController.add(jsManager,
                                                                     contentWorld: contentWorld,
                                                                     name: JSServiceManager.scriptMessageName)
                }
                // - chrome.js
                _injectChromeBridge(contentWorld)
                // - manifest info
                _injectManifest(pandora)
                if let contentScripts = pandora.manifest.contentScripts {
                    contentScripts.forEach { scriptInfo in
                        // - Content Script
                        scriptInfo.js?.forEach({ js in
                            if let content = loader.fileContent(at: js) {
                                let userScript = WKUserScript(source: content,
                                                              injectionTime: .atDocumentEnd,
                                                              forMainFrameOnly: true,
                                                              in: contentWorld)
                                webView?.addUserScript(userScript: userScript)
                            }
                        })
                        // - Content CSS
                        scriptInfo.css?.forEach({ css in
                            if let script = loader.fileContent(at: css) {
                                _injectCSS(script, at: contentWorld)
                            }
                        })
                    }
                }
            }
        }
    }
    
    private func _injectCSS(_ css: String, at contentWorld: WKContentWorld) {
        guard let plainData = css.data(using: .utf8)?.base64EncodedString(options: []) else {
            return;
        }
        let cssStyle = """
            javascript:(function() {
            var parent = document.getElementsByTagName('head').item(0);
            var style = document.createElement('style');
            style.type = 'text/css';
            style.innerHTML = window.atob('\(plainData)');
            parent.appendChild(style)})()
        """
        let userScript = WKUserScript(source: cssStyle,
                                      injectionTime: .atDocumentEnd,
                                      forMainFrameOnly: true,
                                      in: contentWorld)
        webView?.addUserScript(userScript: userScript)
    }
    
    private func _injectManifest(_ pandora: Pandora) {
        let data = ["type": "CONTENT", "id": pandora.id, "manifest": (pandora.manifest.raw ?? [:])] as [String : Any];
        let injectInfoScript = "window.chrome.__loader__";
        let paramsStrBeforeFix = data.ext.toString()
        let paramsStr = JSServiceUtil.fixUnicodeCtrlCharacters(paramsStrBeforeFix ?? "")
        let script = injectInfoScript + "(\(paramsStr))"
        let contentWorld = WKContentWorld.world(name: pandora.id)
        let userScript = WKUserScript(source: script,
                                      injectionTime: .atDocumentStart,
                                      forMainFrameOnly: true,
                                      in: contentWorld)
        webView?.addUserScript(userScript: userScript)
    }
    
    private func _injectChromeBridge(_ contentWorld: WKContentWorld) {
        if let chrome = PDManager.pandoraJS {
            let userScript = WKUserScript(source: chrome,
                                          injectionTime: .atDocumentStart,
                                          forMainFrameOnly: true,
                                          in: contentWorld)
            webView?.addUserScript(userScript: userScript)
        }
    }
}
