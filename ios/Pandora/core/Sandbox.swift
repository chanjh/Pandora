//
//  Sandbox.swift
//  Pandora
//
//  Created by 陈嘉豪 on 2022/4/26.
//

import Foundation

class Sandbox {
    private let pandoraId: String
    private let downloader: PDDownloader = PDDownloader()
    static let sandboxDirectoryName = "Pandora_SANDBOX"
    
    var sandboxPath: String? {
        if let document = try? FileManager.default.url(for: .documentDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: true) {
            let path = "\(document.path)/\(Self.sandboxDirectoryName)/\(pandoraId)"
            if let url = URL(string: "file://"+path) {
                do {
                    try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
                    return path
                } catch (_) {
                    return nil
                }
            }
        }
        return nil
    }
    
    init(_ pandoraId: String) {
        self.pandoraId = pandoraId
    }
    
    func download(url: String, _ name: String? = nil, callback: VoidCallback? = nil) {
        guard let sandboxPath = sandboxPath else {
            callback?()
            return
        }
        downloader.download(url: url, name, to: sandboxPath, callback: callback)
    }
    
    func saveBase64(_ body: String, _ name: String? = nil, callback: VoidCallback? = nil) {
        downloader.saveBase64(body, name, to: sandboxPath, callback: callback)
    }
}
