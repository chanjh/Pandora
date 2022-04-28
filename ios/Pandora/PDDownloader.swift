//
//  PDDownloader.swift
//  Pandora
//
//  Created by 陈嘉豪 on 2022/4/26.
//

import Foundation
import Tiercel

typealias VoidCallback = () -> Void
class PDDownloader {
    lazy var sessionManager: SessionManager = {
        var configuration = SessionConfiguration()
        configuration.allowsCellularAccess = true
        let manager = SessionManager("default", configuration: configuration)
        return manager
    }()
    
    init() { }
    
    func download(url: String, _ name: String? = nil, to path: String? = nil, callback: VoidCallback? = nil) {
        let task = sessionManager.download(url, fileName: name)
        task?.progress(onMainQueue: true) { (task) in
            let progress = task.progress.fractionCompleted
            print("下载中, 进度：\(progress)")
        }.success { (task) in
            print("下载完成")
            guard let path = path,
                  let from = URL(string: task.filePath),
                  let to = URL(string: "file://" + path + "/" + (name ?? UUID().uuidString)) else {
                callback?()
                return;
            }
            callback?()
            try? FileManager.default.moveItem(at: from, to: to)
        }.failure { (task) in
            callback?()
            print("下载失败")
        }
    }
    
    func saveBase64(_ body: String, _ name: String? = nil, to path: String? = nil, callback: VoidCallback? = nil) {
        let filenameSplits = body.split(separator: ";", maxSplits: 1, omittingEmptySubsequences: false)
//        let filename = String(filenameSplits[0])
        let filename = name ?? UUID().uuidString
        let dataSplits = filenameSplits[1].split(separator: ",", maxSplits: 1, omittingEmptySubsequences: false)
        
        let data = Data(base64Encoded: String(dataSplits[1]))
        if (data == nil) {
            debugPrint("Could not construct data from base64")
            return
        }
        
        let pathUrl = URL(string: "file://"+(path ?? "")) ?? FileManager.default.temporaryDirectory
        let localFileURL = pathUrl.appendingPathComponent(filename.removingPercentEncoding ?? filename)
        
        do {
            try data!.write(to: localFileURL);
            callback?()
        } catch {
            debugPrint(error)
            callback?()
            return
        }
    }
}
