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
    func requestErrorHandler() -> ErrorHandler
    
}

public extension RequestErrorHandling {
    
    func requestErrorHandler() -> ErrorHandler {
        return { [weak self] (networkError) in
            self?.alertView?.show(message: networkError.error.localizedDescription, dismissAfter: 3)
        }
    }
    
}
