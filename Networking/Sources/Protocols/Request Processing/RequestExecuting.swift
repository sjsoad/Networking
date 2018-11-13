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
    func handleExecuting(_ executing: Bool)
    
}

public extension RequestExecuting {
    
    func handleExecuting(_ executing: Bool) {
        if executing {
            activityView?.showActivity()
        } else {
            activityView?.hideActivity()
        }
    }
    
}
