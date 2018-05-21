//
//  RequestExecutingViewProtocol.swift
//  GeoTouch
//
//  Created by Sergey on 14.03.17.
//  Copyright © 2017 Sergey. All rights reserved.
//

import UIKit
import SKActivityViewable

public typealias RequestExecutingHandler = (_ executing: Bool) -> Void

public protocol RequestExecuting {
    
    func activityView() -> ActivityViewable?
    func requestExecutingHandler() -> RequestExecutingHandler
    
}

extension RequestExecuting where Self: NSObject {
    
    public func requestExecutingHandler() -> RequestExecutingHandler {
        return { [weak self] (executing) in
            guard let strongSelf = self,
                let view = strongSelf.activityView() else { return }
            if executing {
                view.showActivity()
            } else {
                view.hideActivity()
            }
        }
    }
    
}
