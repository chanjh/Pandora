//
//  PDLoader.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2021/12/19.
//

import Foundation
import Zip

public class PDLoader {
    let path: URL
    let id: String
    let pandora: Pandora?
    private let filesInPath: [String]
    
    init(_ path: URL, id: String) {
        self.path = path
        self.id = id
        self.filesInPath = (try? FileManager.default.contentsOfDirectory(atPath: path.relativePath)) ?? []
        self.pandora = Pandora(path, id: id)
    }
    
    func loadSync() -> Pandora? { return pandora }
    
    var popupHTML: String? {
        let pd = loadSync()
        if let popup = pd?.manifest.action?["default_popup"] as? String {
            return fileContent(at: popup)
        }
        return nil;
    }
    
    public var popupFilePath: String? {
        let pd = loadSync()
        if let popup = pd?.manifest.action?["default_popup"] as? String {
            return filesInPath.first { $0 == popup }
        }
        return nil
    }
    
    var backgroundScript: String? {
        // todo: 从 manifest 里面拿
        return fileContent(at: PDFileNameType.background.rawValue)
    }
    
    var contentScripts: [String]? {
        let pd = loadSync()
        if let contentScripts = pd?.manifest.contentScripts {
            var scripts: [String] = []
            contentScripts.forEach { scriptInfo in
                scriptInfo.js?.forEach({ js in
                    if let content = fileContent(at: js) {
                        scripts.append(content)
                    }
                })
            }
            return scripts
        }
        
        return nil
    }
    
    var manifest: String? {
        return fileContent(at: PDFileNameType.manifest.rawValue)
    }
    
    func fileContent(at fileName: String) -> String? {
        let filePath = fileName.starts(with: "/") ? fileName : "/" + fileName
        if let data = FileManager.default.contents(atPath: path.relativePath + filePath) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}

enum PDFileNameType: String {
    case background = "background.js"
    case manifest = "manifest.json"
}
