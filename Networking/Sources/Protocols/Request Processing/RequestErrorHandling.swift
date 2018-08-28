//
//  RequestErrorHandling.swift
//  GeoTouch
//
//  Created by Sergey on 14.03.17.
//  Copyright © 2017 Sergey. All rights reserved.
//

import Foundation
import SKAlertViewable

public protocol RequestErrorHandling: AlertViewable {
    
    var alertView: AlertViewable? { get }
    func requestErrorHandler<RequestType: APIRequesting, ResponseType: APIResponsing>() -> ErrorHandler<RequestType, ResponseType>
    
}

public extension RequestErrorHandling where Self: NSObject {
    
    func requestErrorHandler<RequestType: APIRequesting, ResponseType: APIResponsing>() -> ErrorHandler<RequestType, ResponseType> {
        return { [weak self] (networkError, failedRequest, handlers) in
            self?.alertView?.show(message: networkError.error.localizedDescription, for: .error)
        }
    }
    
}
