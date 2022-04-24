//
//  PDURLSchemeHandler.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/2/27.
//

import WebKit
import UniformTypeIdentifiers

public class PDURLSchemeHandler: NSObject, WKURLSchemeHandler {
    
    public static var scheme = "chrome-extension"
    
    public func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        guard let url = urlSchemeTask.request.url else {
            return
        }
        let pdId = url.host
        let pandora = PDManager.shared.pandoras.first { $0.id == pdId }
        var path = pandora?.pdPath
        path?.appendPathComponent(url.path)
        // TODO: check web_accessible_resources in manifest file
        
        if let data = FileManager.default.contents(atPath: path?.absoluteString ?? "") {
            let response = URLResponse(url: url,
                                       mimeType: mimeTypeFor(urlSchemeTask.request),
                                       expectedContentLength: data.count,
                                       textEncodingName: nil)
            urlSchemeTask.didReceive(response)
            urlSchemeTask.didReceive(data)
            urlSchemeTask.didFinish()
        }
    }
    
    public func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        
    }
    
    private func mimeTypeFor(_ request: URLRequest) -> String? {
        guard let pathExtension = request.url?.pathExtension else {
            return nil
        }
        return UTType(filenameExtension: pathExtension)?.preferredMIMEType
    }

}
