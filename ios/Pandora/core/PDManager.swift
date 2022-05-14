//
//  PDManager.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2021/12/19.
//

import Foundation
import Zip
import GCWebContainer

public class PDManager {
    public static let shared = PDManager();
    private(set) var delegate: PandoraDelegate? = nil
    private var pandoraList: [Pandora] = [];
    
    public var pandoras: [Pandora] {
        return loaders.compactMap { return $0.pandora }
    }
    
    private(set) var loaders: [PDLoader] = [];
    private(set) var contentScriptRunners: [PDContentRunner] = [];
    private(set) var popupRunners: [PDPopUpRunner] = [];
    private(set) var backgroundRunners: [PDBackgroundRunner] = [];
    private(set) var browserActionRunner: [PDBrowserActionRunner] = []
    
    public func setPDDelegate(_ delegate: PandoraDelegate) {
        self.delegate = delegate
    }
    
    func loadPandora(path: URL, id: String) -> Pandora? {
        let loader = PDLoader(path, id: id)
        loaders.append(loader)
        if let pandora = loader.loadSync() {
//            pandoraList.append(contentsOf: pandoras)
            return pandora
        }
        return nil
    }
    
    // 把所有已经解压的扩展，加载到内容里
    public func loadAll() {
        let files = PDFileManager.getAllUnZipApps()
        files.forEach { filePath in
            if let url = URL(string: filePath),
                !loaders.contains(where: { $0.loadSync()?.id == url.lastPathComponent }) {
                let loader = PDLoader(url, id: url.lastPathComponent)
                loaders.append(loader)
                if let pandora = loader.loadSync() {
                    let runner = makeBackgroundRunner(pandora)
                    runner.run()
                }
            }
        }
    }
    
    public func tryToSetupAll() {
        // 从 IPA 中解压
        _loadInnerExtension()
        // todo: 上次解压失败的，重新开始解压
    }
    
    func makeBackgroundRunner(_ pandora: Pandora) -> PDBackgroundRunner {
//        if let runner = runners.first(where: { $0.pandora.id == pandora.id }) {
//            return runner
//        }
        let runner = PDBackgroundRunner(pandora: pandora)
        backgroundRunners.append(runner)
        return runner
    }
    
    func makePopUpRunner(_ pandora: Pandora) -> PDPopUpRunner {
//        if let runner = runners.first(where: { $0.pandora.id == pandora.id }) {
//            return runner
//        }
        let runner = PDPopUpRunner(pandora: pandora)
        popupRunners.append(runner)
        return runner
    }
    
    func makeContentRunner(_ webView: GCWebView) -> PDContentRunner {
        let runner = PDContentRunner(webView)
        contentScriptRunners.append(runner)
        return runner
    }
    
    func makeBrowserActionRunner(pandora: Pandora, webView: PDWebView?) -> PDBrowserActionRunner {
        let runner = PDBrowserActionRunner(pandora: pandora,
                                           webView: webView)
        browserActionRunner.append(runner)
        return runner
    }

    public func findBackgroundRunner(_ pandora: Pandora) -> PDBackgroundRunner? {
        return backgroundRunners.first(where: { $0.pandora.id == pandora.id })
    }
    
    // return Popup Runner and Background Runner
    func findPandoraRunner(_ pandora: Pandora) -> [PDWebView] {
        var res: [PDWebView] = []
        let bg = backgroundRunners.filter { $0.pandora.id == pandora.id }
        let pop = popupRunners.filter { $0.pandora.id == pandora.id }
        let browserAction = browserActionRunner.filter { $0.pandora.id == pandora.id }
        res.append(contentsOf: bg.compactMap({ $0.webView }))
        res.append(contentsOf: pop.compactMap({ $0.webView }))
        res.append(contentsOf: browserAction.compactMap({ $0.webView }))
        return res
    }
    
    func removePopUpRunner(_ runner: PDPopUpRunner) {
        popupRunners.removeAll {
            $0 == runner
        }
    }
    
    private func _loadInnerExtension() {
        if let bundlePath = Bundle(for: Self.self).path(forResource: "Extensions", ofType: "bundle"),
           let bundle = Bundle(path: bundlePath),
           let files = files(in: bundle.bundleURL) {
            files.forEach { fileName in
                PDFileManager.setupPandora(zipPath: bundle.url(forResource: fileName, withExtension: nil))
            }
        }
    }
    
    private func files(in directory: URL) -> [String]? {
        return try? FileManager.default.contentsOfDirectory(atPath: directory.relativePath)
    }
    
    private func unzip(zip: URL) -> URL? {
        return try? Zip.quickUnzipFile(zip)
    }
}

extension PDManager {
    var contentScripts: [String]? {
        var scripts: [String] = []
        loaders.forEach { loader in
            scripts.append(contentsOf: loader.contentScripts ?? [])
        }
        return scripts
    }
}
