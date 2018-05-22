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
    
    var activityView: ActivityViewable? { get }
    func requestExecutingHandler() -> RequestExecutingHandler
    
}

public extension RequestExecuting where Self: NSObject {
    
    func requestExecutingHandler() -> RequestExecutingHandler {
        return { [weak self] (executing) in
            guard let view = self?.activityView else { return }
            if executing {
                view.showActivity()
            } else {
                view.hideActivity()
            }
        }
    }
    
}
