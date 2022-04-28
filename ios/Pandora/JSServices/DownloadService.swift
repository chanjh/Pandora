//
//  DownloadService.swift
//  Pandora
//
//  Created by 陈嘉豪 on 2022/4/26.
//

import Foundation
import GCWebContainer

class DownloadService: PDBaseJSService, JSServiceHandler {
    var handleServices: [JSServiceType] {
        return [.download]
    }
    
    func handle(message: JSServiceMessageInfo) {
        if message.serviceName == JSServiceType.download.rawValue {
            guard let params = message.params as? Dictionary<String, Any>,
                  let pdId = findSenderId(on: message) else {
                return
            }
            
            let sandbox = Sandbox(pdId)
            if let base64 = params["base64"] as? String {
                sandbox.saveBase64(base64, params["filename"] as? String) { [weak self] in
                    // todo: UUID
                    self?._callback(for: message, with: UUID().uuidString)
                }
            }
            else if let urlStr = params["url"] as? String {
                sandbox.download(url: urlStr, params["filename"] as? String) { [weak self] in
                    // todo: UUID
                    self?._callback(for: message, with: UUID().uuidString)
                }
            }
        }
    }
    
    private func _callback(for message: JSServiceMessageInfo, with downloadId: String) {
        if let callback = message.callback {
            let jsScript = "\(callback)(\"\(downloadId)\")"
            webView?.jsEngine?.callJsString(jsScript, in: nil, in: message.contentWorld, completionHandler: nil)
        }
    }
}

extension JSServiceType {
    static let download   = JSServiceType("downloads.download")
}
