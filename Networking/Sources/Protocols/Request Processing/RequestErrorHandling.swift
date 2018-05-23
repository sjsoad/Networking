//
//  RequestErrorHandlerProtocol.swift
//  GeoTouch
//
//  Created by Sergey on 14.03.17.
//  Copyright © 2017 Sergey. All rights reserved.
//

import Foundation
import SKAlertViewable

public protocol RequestErrorHandling: AlertViewable {
    
    var alertView: AlertViewable? { get }
    func requestErrorHandler<RequestType: APIRequesting>() -> ErrorHandler<RequestType>
    
}

public extension RequestErrorHandling where Self: NSObject {
    
    func requestErrorHandler<RequestType: APIRequesting>() -> ErrorHandler<RequestType> {
        return { [weak self] (networkError, failedRequest)  in
            guard let view = self?.alertView else { return }
            view.show(message: networkError.error.localizedDescription, state: .error)
        }
    }
    
}
