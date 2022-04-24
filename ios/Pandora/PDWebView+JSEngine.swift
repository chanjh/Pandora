//
//  PDWebView+JSEngine.swift
//  GCWebContainerDemo
//
//  Created by 陈嘉豪 on 2022/2/27.
//

import Foundation
import GCWebContainer

extension JSEngine {
    
    var eventCenter: EventCenter {
        set { objc_setAssociatedObject(self, &JSEngine.eventCenterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
        get {
            guard let value = objc_getAssociatedObject(self, &JSEngine.eventCenterKey) as? EventCenter else {
                let obj = EventCenter(self)
                self.eventCenter = obj
                return obj
            }
            return value
        }
    }
    private static var eventCenterKey: UInt8 = 0
    
    class EventCenter {
        static let eventPrefix = "PD_EVENT_"
        static let publicFn = "window.gc.bridge.eventCenter.publish"
        private weak var engine: JSEngine?
        init(_ engine: JSEngine) {
            self.engine = engine
        }
        func publish(_ event: String,
                     arguments: [String],
                     completion: ((_ info: Any?, _ error: Error?) -> Void)? = nil) {
            var arg = ["\"\(Self.eventPrefix+event)\""]
            arg.append(contentsOf: arguments)
            engine?.callFunction(Self.publicFn, arguments: arg, completion: completion)
        }
    }
}
