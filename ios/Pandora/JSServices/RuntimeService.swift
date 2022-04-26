//
//  RuntimeService.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/1/2.
//

import WebKit
import GCWebContainer

class RuntimeService: PDBaseJSService, JSServiceHandler {
    var handleServices: [JSServiceType] {
        return [.runtimeGetPlatformInfo,
                .runtimeSendMessage,
                .runtimeSendResponse,
                .runtimeOpenOptionsPage]
    }
    func handle(message: JSServiceMessageInfo) {
        guard let params = message.params as? [String: Any] else {
            return
        }
        if message.serviceName == JSServiceType.runtimeGetPlatformInfo.rawValue,
           let callback = message.callback {
            let platformInfo = [
                "arch": "", // todo: https://developer.chrome.com/docs/extensions/reference/runtime/#type-PlatformOs
                "nacl_arch": "",
                "os": "mac", // NOTE: Return mac
            ]
            webView?.jsEngine?.callFunction(callback, params: platformInfo, completion: nil)
        } else if message.serviceName == JSServiceType.runtimeSendMessage.rawValue {
            let extensionId = params["extensionId"] as? String ?? findSenderId(on: message)
            if let pandora = PDManager.shared.pandoras.first(where: { $0.id == extensionId }) {
                let runners = PDManager.shared.findPandoraRunner(pandora)
                runners.forEach {
                    let senderId = findSenderId(on: message) ?? ""
                    // todo: 是 param 还是 message
                    let data: [String: Any] = ["param": params, "callback": message.callback ?? "", "senderId": senderId]
                    let paramsStrBeforeFix = data.ext.toString()
                    let paramsStr = JSServiceUtil.fixUnicodeCtrlCharacters(paramsStrBeforeFix ?? "")
                    let onMsgScript = "window.gc.bridge.eventCenter.publish('PD_EVENT_RUNTIME_ONMESSAGE', \(paramsStr));";
                    
                    $0.evaluateJavaScript(onMsgScript, completionHandler: nil)
                }
            }
        } else if message.serviceName == JSServiceType.runtimeSendResponse.rawValue {
            let sendResponseFn = {(param:  [String: Any],
                                   webView: GCWebView?,
                                   contentWorld: WKContentWorld?) -> Void in
                guard let data: [String: Any] = params["response"] as? [String: Any],
                      let callback = message.callback else {
                    return
                }
                if let contentWorld = contentWorld {
                    webView?.jsEngine?.callFunction(callback,
                                                    params: data,
                                                    in: nil,
                                                    in: contentWorld,
                                                    completion: nil)
                } else {
                    webView?.jsEngine?.callFunction(callback,
                                                    params: data,
                                                    completion: nil)
                }
            }
            let extensionId = params["extensionId"] as? String
            if let pandora = PDManager.shared.pandoras.first(where: { $0.id == extensionId }) {
                let runners = PDManager.shared.findPandoraRunner(pandora)
                runners.forEach {
                    sendResponseFn(params, $0, nil)
                }
            }
            PDManager.shared.contentScriptRunners.forEach { runner in
                runner.pandoras.forEach { pd in
                    if pd.id == extensionId, runner.webView?.url?.scheme != "file" {
                        let contentWorld = WKContentWorld.world(name: pd.id)
                        sendResponseFn(params, runner.webView, contentWorld)
                    }
                }
            }
            
        } else if message.serviceName == JSServiceType.runtimeOpenOptionsPage.rawValue {
            if let senderId = findSenderId(on: message),
               let pandora = PDManager.shared.pandoras.first(where: { $0.id == senderId }),
                let optionURL = pandora.optionPageFilePath {
                // todo: open_in_tab
                _ = ui?.navigator?.openURL(OpenURLOptions(url: optionURL))
                if let callback = message.callback {
                    // todo: if error
                    webView?.jsEngine?.callFunction(callback, params: nil, completion: nil)
                }
            }
        }
    }
}

extension JSServiceType {
    static let runtimeSendMessage = JSServiceType("runtime.sendMessage")
    static let runtimeSendResponse = JSServiceType("runtime.sendResponse") // todo: 是不是可以合并这个 JSAPI
    static let runtimeGetPlatformInfo = JSServiceType("runtime.getPlatformInfo")
    static let runtimeOpenOptionsPage = JSServiceType("runtime.openOptionsPage")
}
