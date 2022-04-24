//
//  PDManifest.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2021/12/19.
//

import Foundation

public struct PDManifest {
    static let supportedVersion = 2
    public let name: String
    let version: String
    let manifestVersion: Int
    let background: PDBackgroundInfo?
    let backgroundV2: PDBackgroundInfoV2?
    let action: Dictionary<String, Any>?
    let contentScripts: Array<PDContentScriptInfo>?
    let raw: Dictionary<String, Any>?
    let option: PDOptionsInfo?
    public let pageAction: PDActionInfo?
    public let browserAction: PDActionInfo?
    let accessibleResource: PDWebAccessibleResource?
    
    init?(_ fileContent: String) {
        if let data = fileContent.data(using: .utf8),
           let manifestContent = try? JSONSerialization.jsonObject(with: data,
                                                                   options : .allowFragments) as? Dictionary<String,Any>,
           let name = manifestContent["name"] as? String,
           let version = manifestContent["version"] as? String,
           let manifestVersion = manifestContent["manifest_version"] as? Int,
           manifestVersion >= Self.supportedVersion {
            self.raw = manifestContent
            self.name = name
            self.version = version
            self.manifestVersion = manifestVersion
            self.background = PDBackgroundInfo(manifestContent["background"] as? Dictionary<String, Any>)
            self.backgroundV2 = PDBackgroundInfoV2(manifestContent["background"] as? Dictionary<String, Any>)
            self.action = manifestContent["action"] as? Dictionary<String, Any>
            // options page
            if let opInfo = manifestContent["options_ui"] as? Dictionary<String, Any> {
                self.option = PDOptionsInfo(opInfo)
            } else if let opInfo = manifestContent["options_page"] as? String {
                self.option = PDOptionsInfo(opInfo)
            } else {
                self.option = nil
            }
            let contents = manifestContent["content_scripts"] as? [Dictionary<String, Any>]
            self.contentScripts = contents?.compactMap({ PDContentScriptInfo($0) })
            if let pageActionDict = manifestContent["page_action"] as? Dictionary<String, Any> {
                self.pageAction = PDActionInfo(pageActionDict)
            } else {
                self.pageAction = nil
            }
            if let browserActionDict = manifestContent["browser_action"] as? Dictionary<String, Any> {
                self.browserAction = PDActionInfo(browserActionDict)
            } else {
                self.browserAction = nil
            }
            self.accessibleResource = PDWebAccessibleResource(manifestContent["web_accessible_resources"] as? Array<String>)
            return
        }
        return nil
    }
}

//"content_scripts": [
//    {
//        "matches": ["https://*.nytimes.com/*"],
//        "exclude_matches": ["*://*/*business*"],
//        "include_globs": ["*nytimes.com/???s/*"],
//        "exclude_globs": ["*science*"],
//        "css": ["my-styles.css"],
//        "js": ["content-script.js"],
//        "all_frames": true,
//    }
//],
// todo: 可选值等
struct PDContentScriptInfo {
    let matches: Array<String>?
    let excludeMatches: Array<String>?
    let includeGlobs: Array<String>?
    let excludeGlobs: Array<String>?
    let run_at: PDRunAtType?
    let css: Array<String>?
    let js: Array<String>?
    let allFrame: Bool?
    
    init?(_ content: Dictionary<String, Any>?) {
        self.matches = content?["matches"] as? [String]
        self.excludeMatches = content?["exclude_matches"] as? [String]
        self.includeGlobs = content?["include_globs"] as? [String]
        self.excludeGlobs = content?["exclude_globs"] as? [String]
        self.run_at = .idle // content?["run_at"]
        self.css = content?["css"] as? [String]
        self.js = content?["js"] as? [String]
        self.allFrame =  (content?["all_frames"] as? Bool) ?? true
    }
}

//"background": {
//  "service_worker": "background.js",
//  "type": "module"
//}
struct PDBackgroundInfo {
    let worker: String
    let type: String?
    init?(_ background: Dictionary<String, Any>?) {
        if let worker = background?["service_worker"] as? String {
            self.worker = worker
            self.type = background?["type"] as? String
            return
        }
        return nil
    }
}

enum PDRunAtType: String {
    case idle = "document_idle"
    case start = "document_start"
    case end = "document_end"
}

//"default_icon": {              // optional
//  "16": "images/icon16.png",   // optional
//  "24": "images/icon24.png",   // optional
//  "32": "images/icon32.png"    // optional
//},
//"default_title": "Click Me",   // optional, shown in tooltip
//"default_popup": "popup.html"  // optional
public struct PDActionInfo {
    public let title: String?
    public let popup: String?
    public let icon: Dictionary<String, Any>?
    
    init(_ pageAction: Dictionary<String, Any>) {
        self.title = pageAction["default_title"] as? String
        self.popup = pageAction["default_popup"] as? String
        self.icon = pageAction["default_icon"] as? Dictionary<String, Any>
    }
}


struct PDOptionsInfo {
    let page: String
    let openInTab: Bool?
    init(_ v1: String) {
        self.page = v1
        self.openInTab = nil
    }
    
    init?(_ v2: Dictionary<String, Any>) {
        if let page = v2["page"] as? String {
            self.page = page
            self.openInTab = v2["open_in_tab"] as? Bool
            return
        }
        return nil
    }
}

// web_accessible_resources
struct PDWebAccessibleResource {
    let resourcesPath: Array<String>
    init?(_ v2: Array<String>?) {
        if let paths = v2 {
            self.resourcesPath = paths
        } else {
            return nil
        }
    }
    
//    init(_ v3: Dictionary<String, Dictionary<String, Any>>) {
//    }
}
