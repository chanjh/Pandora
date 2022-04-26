//
//  PDPopUpViewController.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/2/9.
//

import SnapKit

open class PDPopUpViewController: UIViewController {
    let pandora: Pandora
    private(set) weak var runner: PDPopUpRunner?
    
    public init(_ pandora: Pandora) {
        self.pandora = pandora
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        runner = PDManager.shared.makePopUpRunner(pandora)
        if let popupPage = runner?.run(),
           let url = pandora.popupFilePath {
            view.addSubview(popupPage)
            popupPage.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            popupPage.loadFileURL(url, allowingReadAccessTo: url)
        }
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let runner = runner {
            PDManager.shared.removePopUpRunner(runner)
        }
    }
}
