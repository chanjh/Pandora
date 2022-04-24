//
//  PDManifestV2.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/2/14.
//

import Foundation

struct PDManifestV2 { }

struct PDBackgroundInfoV2 {
    let worker: [String]
    init?(_ background: Dictionary<String, Any>?) {
        if let worker = background?["scripts"] as? [String] {
            self.worker = worker
            return
        }
        return nil
    }
}
