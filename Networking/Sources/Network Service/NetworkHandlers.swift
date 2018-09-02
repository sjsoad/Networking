//
//  NetworkHandlers.swift
//  SKNetworkingLib
//
//  Created by Sergey Kostyan on 02.09.2018.
//

import Foundation

public struct NetworkHandlers<ResponseType: APIResponsing> {
    
    let successHandler: ((_ response: ResponseType) -> Void)?
    let executingHandler: RequestExecutingHandler?
    let errorHandler: ErrorHandler?
    let requestHandler: RequestHandler?
    
    public init(successHandler: ((_ response: ResponseType) -> Void)? = nil, executingHandler: RequestExecutingHandler? = nil,
                errorHandler: ErrorHandler? = nil, requestHandler: RequestHandler? = nil) {
        self.successHandler = successHandler
        self.executingHandler = executingHandler
        self.errorHandler = errorHandler
        self.requestHandler = requestHandler
    }
}
