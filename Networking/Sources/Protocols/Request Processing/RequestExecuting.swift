//
//  RequestExecuting.swift
//  GeoTouch
//
//  Created by Sergey on 14.03.17.
//  Copyright © 2017 Sergey. All rights reserved.
//

import Foundation
import SKActivityViewable

public protocol RequestExecuting where Self: NSObject {
    
    var activityView: ActivityViewable? { get }
    func requestExecutingHandler() -> RequestExecutingHandler
    
}

public extension RequestExecuting {
    
    func requestExecutingHandler() -> RequestExecutingHandler {
        return { [weak self] (executing) in
            guard executing else {
                self?.activityView?.hideActivity()
                return }
            self?.activityView?.showActivity()
        }
    }
    
}
