//
//  PDWebView.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/1/6.self.type = type
//

import WebKit
import GCWebContainer

public enum PDWebViewType {
    case content;
    case browserAction(String);
    case background(String);
    case popup(String);
    
    var isContent: Bool {
        switch self {
        case .content: return true
        default: return false
        }
    }
}

open class PDWebView: GCWebView {
    let type: PDWebViewType;
    private(set) var contentScriptRunner: PDContentRunner?
    
    public init(frame: CGRect = .zero,
                type: PDWebViewType = .content,
                model: WebContainerModelConfig? = nil,
                ui: WebContainerUIConfig? = nil) {
        self.type = type
        super.init(frame: frame,
                   model: model,
                   ui: ui,
                   configuration: Self._makeWKWebConfig(type: type))
    }
    
    init(frame: CGRect = .zero,
         type: PDWebViewType = .content,
         serviceConfig: PDServiceConfigImpl) {
        self.type = type
        super.init(frame: frame,
                   model: serviceConfig,
                   ui: serviceConfig,
                   configuration: Self._makeWKWebConfig(type: type))
    }
    
    private static func _makeWKWebConfig(type: PDWebViewType) -> WKWebViewConfiguration {
        let webViewConfiguration = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        webViewConfiguration.userContentController = contentController
        if !type.isContent {
            // 支持跨域请求
            webViewConfiguration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
            webViewConfiguration.setValue(true, forKey: "allowUniversalAccessFromFileURLs")
        }
        let schemeHandler: [String: WKURLSchemeHandler] = [PDURLSchemeHandler.scheme: PDURLSchemeHandler()]
        schemeHandler.forEach({ (key, value) in
            webViewConfiguration.setURLSchemeHandler(value, forURLScheme: key)
        })
        return webViewConfiguration
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open
    override func onInit() {
        super.onInit()
        actionHandler.addObserver(self)
        _registerJSHandler()
        if case .browserAction(_) = type {
            
        } else {
            _injectAllContentJS()
        }
    }
    
    func pd_addChromeBridge() {
        if let bundlePath = Bundle(for: Self.self).path(forResource: "Pandora", ofType: "bundle"),
           let path = Bundle(path: bundlePath)?.path(forResource: "pandora", ofType: "js"),
           let chrome = try? String(contentsOfFile: path) {
            let userScript = WKUserScript(source: chrome,
                                          injectionTime: .atDocumentStart,
                                          forMainFrameOnly: true)
            configuration.userContentController.addUserScript(userScript)
        }
    }
    
    private func _injectAllContentJS() {
//        pd_addChromeBridge()
        if case .content = type {
            contentScriptRunner = PDManager.shared.makeContentRunner(self)
            contentScriptRunner?.run()
        }
    }
    
    private func _registerJSHandler() {
        jsServiceManager?.register(handler: TabsService(self, ui: ui, model: model))
        jsServiceManager?.register(handler: RuntimeService(self, ui: ui, model: model))
        jsServiceManager?.register(handler: LocalStorageService(self, ui: ui, model: model))
        jsServiceManager?.register(handler: BookmarkService(self, ui: ui, model: model))
        jsServiceManager?.register(handler: ContextMenuService(self, ui: ui, model: model))
        jsServiceManager?.register(handler: DownloadService(self, ui: ui, model: model))
        jsServiceManager?.register(handler: CookiesService(self, ui: ui, model: model))
        jsServiceManager?.register(handler: BrowserActionService(self, ui: ui, model: model))
    }
}

extension PDWebView {
    open override
    func load(_ request: URLRequest) -> WKNavigation? {
        if let url = request.url,
           url.scheme == PDURLSchemeHandler.scheme {
            let document = try? FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: false)
            let unzip = "file://\(document?.path ?? "")/\(PDFileManager.unzipPath)/"
            let res = url.absoluteString.replacingOccurrences(of: "\(PDURLSchemeHandler.scheme)://", with: unzip, options: .literal, range: nil)
            if let fileUrl = URL(string: res), let unzipUrl = URL(string: unzip),
               let pandora = PDManager.shared.pandoras.first(where: { $0.id == url.host }) {
                let runner = PDManager.shared.makeBrowserActionRunner(pandora: pandora,
                                                                      webView: self)
                runner.run()
                willLoadRequest()
                return loadFileURL(fileUrl, allowingReadAccessTo: unzipUrl)
            }
        }
        willLoadRequest()
        return super.load(request)
    }
}

extension PDWebView: GCWebViewActionObserver {
    // todo
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        let data = ["type": "BACKGROUND", "id": pandora.id ?? "", "manifest": (pandora.manifest.raw ?? [:])] as [String : Any];
//        let injectInfoScript = "window.chrome.__loader__";
//        bgRunner?.jsEngine?.callFunction(injectInfoScript, params: data as [String : Any], completion: nil)
//
//        let onInstalledScript = "window.gc.bridge.eventCenter.publish('PD_EVENT_RUNTIME_ONINSTALLED');";
//        bgRunner?.evaluateJavaScript(onInstalledScript, completionHandler: nil)
    }
}
