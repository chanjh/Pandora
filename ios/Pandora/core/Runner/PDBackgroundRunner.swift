//
//  PDBackgroundRunner.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/2/10.
//

import WebKit
import GCWebContainer

public class PDBackgroundRunner: NSObject {
    public private(set) var pandora: Pandora
    public private(set) var webView: PDWebView?
    private(set) var serviceConfig: PDServiceConfigImpl?
    
    init(pandora: Pandora) {
        self.pandora = pandora
    }
    
    func run() {
        _prepareBackgroundWebView()
        _injectChromeBridge()
        _injectManifest()
        
//        _fireOnInstalledEvent()
        
        if let backgroundScript = pandora.background {
            _runBackgroundScript(backgroundScript)
        } else if let backgroundScripts = pandora.backgrounds {
            backgroundScripts.forEach { _runBackgroundScript($0) }
        }
        _runWebView()
    }
    
    func fireOnInstalledEvent() {
        let key = "k_Pandora_DidLoadedPandoraProject_key"
        var list = UserDefaults.standard.array(forKey: key) as? [String] ?? []
        if !list.contains(where: { $0 == "\(pandora.id)-\(pandora.manifest.version)" }) {
            list.append("\(pandora.id)-\(pandora.manifest.version)")
            UserDefaults.standard.set(list, forKey: key)
            _onInstall()
        }
    }
    
    private func _prepareBackgroundWebView() {
        let bgWebView = PDWebView(frame: CGRect(x: 0, y: 0, width: 1, height: 1),
                                  type: .background(pandora.id))
        let serviceConfig = PDServiceConfigImpl(bgWebView)
        self.serviceConfig = serviceConfig
        self.webView = bgWebView
        bgWebView.model = serviceConfig
        bgWebView.ui = serviceConfig
//        bgWebView.actionHandler.addObserver(self)
    }
    
    private func _runWebView() {
        guard let webView = webView else {
            return
        }

        // todo
        UIApplication.shared.keyWindow?.addSubview(webView)
        if let bundlePath = Bundle(for: Self.self).path(forResource: "Pandora", ofType: "bundle"),
           let path = Bundle(path: bundlePath)?.path(forResource: "background", ofType: "html"),
           let url = URL(string: "file://\(path)")  {
            webView.loadFileURL(url, allowingReadAccessTo: url)
        }
    }
    
    // todo: 判断是否符合运行条件
    private func _runBackgroundScript(_ script: String) {
        let userScript = WKUserScript(source: script,
                                      injectionTime: .atDocumentEnd,
                                      forMainFrameOnly: true)
        webView?.addUserScript(userScript: userScript)
    }
    
    private func _injectManifest() {
        let data = ["type": "BACKGROUND", "id": pandora.id, "manifest": (pandora.manifest.raw ?? [:])] as [String : Any];
        let injectInfoScript = "window.chrome.__loader__";
        let paramsStrBeforeFix = data.ext.toString()
        let paramsStr = JSServiceUtil.fixUnicodeCtrlCharacters(paramsStrBeforeFix ?? "")
        let script = injectInfoScript + "(\(paramsStr))"
        _runBackgroundScript(script)
    }
    
    
    private func _onInstall() {
        let onInstalledScript = "window.gc.bridge.eventCenter.publish('PD_EVENT_RUNTIME_ONINSTALLED');"
        _runBackgroundScript(onInstalledScript)
    }
    
    private func _injectChromeBridge() {
        if let bundlePath = Bundle(for: Self.self).path(forResource: "Pandora", ofType: "bundle"),
           let path = Bundle(path: bundlePath)?.path(forResource: "pandora", ofType: "js"),
           let chrome = try? String(contentsOfFile: path) {
            let userScript = WKUserScript(source: chrome,
                                          injectionTime: .atDocumentStart,
                                          forMainFrameOnly: true)
            webView?.addUserScript(userScript: userScript)
        }
    }
}
