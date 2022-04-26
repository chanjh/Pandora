//
//  PDFileManager.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/1/3.
//

import Foundation
import Zip

public class PDFileManager {
    static let setupedKey = "k_Pandora_DidSetup_key"
    static let unzipPath = "Pandora_UNZIP"
}
// load
extension PDFileManager {
    // 查找所有已经解压的扩展路径
    static func getAllUnZipApps() -> [String] {
        let document = try? FileManager.default.url(for: .documentDirectory,
                                                          in: .userDomainMask,
                                                          appropriateFor: nil,
                                                          create: false)
        let path = "\(document?.path ?? "")/\(unzipPath)"
        let files: [String] = (try? FileManager.default.contentsOfDirectory(atPath: "\(path)")) ?? []
        return files.map { "\(path)/\($0)" }
    }
}
// setup
extension PDFileManager {
    public static func setupPandora(zipPath: URL?) {
        guard let filePath = zipPath else {
            return;
        }
        if _findIfCompleteSetup(source: filePath.path) {
            return;
        }
        let document = try? FileManager.default.url(for: .documentDirectory,
                                                          in: .userDomainMask,
                                                          appropriateFor: nil,
                                                          create: false)
        var uuid = UUID().uuidString
        uuid.removeAll { $0 == "-" }
        if let destination = URL(string: "\(document?.path ?? "")/\(unzipPath)/\(uuid)"),
           ((try? Zip.unzipFile(filePath,
                                destination: destination,
                                overwrite: true,
                                password: nil,
                                progress: nil,
                                fileOutputHandler: nil)) != nil) {
            if let pandora = PDManager.shared.loadPandora(path: destination, id: uuid) {
                let runner = PDManager.shared.makeBackgroundRunner(pandora)
                runner.run()
                _didCompleteSetup(uuid: uuid, pandora: pandora, source: filePath.path)
            } else {
                try? FileManager.default.removeItem(atPath: destination.path)
            }
        }
    }
    
    private static func _findIfCompleteSetup(source: String) -> Bool {
//        let setuped = UserDefaults.standard.dictionary(forKey: setupedKey) as? Dictionary<String, Dictionary<String, String>> ?? [:]
//        return setuped.contains { $1["source"] == source }
        return false
    }
    // FIXME: source path 在编译完了之后都会变化
    private static func _didCompleteSetup(uuid: String, pandora: Pandora, source: String) {
        try? FileManager.default.removeItem(atPath: source)
//        let info = [
//            uuid: [
//                "name": pandora.manifest.name,
//                "version": pandora.manifest.version,
//                "source": source,
//            ]
//        ] as Dictionary<String,Any>
//        let setuped = UserDefaults.standard.dictionary(forKey: setupedKey) ?? [:]
//        let current = setuped.merging(info) { (_, new) in new }
//        UserDefaults.standard.set(current, forKey: setupedKey)
    }
}
