//
//  RequestErrorHandling.swift
//  GeoTouch
//
//  Created by Sergey on 14.03.17.
//  Copyright © 2017 Sergey. All rights reserved.
//

import Foundation
import SKAlertViewable

public protocol RequestErrorHandling where Self: NSObject {
    
    var alertView: AlertViewable? { get }
    func handleError(_ error: Error)
    
}

public extension RequestErrorHandling {
    
    func handleError(_ error: Error) {
        alertView?.show(message: error.localizedDescription, dismissAfter: 3)
    }
    
}
