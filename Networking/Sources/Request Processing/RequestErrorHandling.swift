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
    
    func alertView() -> AlertViewable?
    func requestErrorHandler() -> ErrorHandler
    
}

extension RequestErrorHandling where Self: NSObject {
    
    public  func requestErrorHandler() -> ErrorHandler {
        return { [weak self] error in
            guard let view = self?.alertView() else { return }
            view.show(message: error.localizedDescription, state: .error)
        }
    }
    
}
