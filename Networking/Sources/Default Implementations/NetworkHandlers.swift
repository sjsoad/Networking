//
//  NetworkHandlers.swift
//  SKNetworkingLib
//
//  Created by Sergey Kostyan on 02.09.2018.
//

import Foundation

public class NetworkHandlers<ResponseType: APIResponsing> {
    
    let successHandler: ((_ response: ResponseType.ResultValueType) -> Void)?
    let executingHandler: RequestExecutingHandler?
    let errorHandler: ErrorHandler?
    
    public init(successHandler: ((_ response: ResponseType.ResultValueType) -> Void)? = nil, executingHandler: RequestExecutingHandler? = nil,
                errorHandler: ErrorHandler? = nil) {
        self.successHandler = successHandler
        self.executingHandler = executingHandler
        self.errorHandler = errorHandler
    }
}
