//
//  RequestExecuting.swift
//  GeoTouch
//
//  Created by Sergey on 14.03.17.
//  Copyright © 2017 Sergey. All rights reserved.
//

import Foundation
import SKActivityViewable

public protocol RequestExecuting {
    
    var activityView: ActivityViewable? { get }
    func requestExecutingHandler() -> RequestExecutingHandler
    
}

public extension RequestExecuting where Self: NSObject {
    
    func requestExecutingHandler() -> RequestExecutingHandler {
        return { [weak self] (executing) in
            guard executing else {
                self?.activityView?.showActivity()
                return }
            self?.activityView?.hideActivity()
        }
    }
    
}
