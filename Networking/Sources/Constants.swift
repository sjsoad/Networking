//
//  Constants.swift
//  Networking
//
//  Created by Sergey on 22.05.2018.
//  Copyright © 2018 Sergey Kostyan. All rights reserved.
//

import Foundation
import Alamofire

public typealias RequestClass = Request
public typealias Method = Alamofire.HTTPMethod

public typealias RequestHandler = (_ request: RequestClass?, _ error: Error?) -> Void
public typealias ErrorHandler<RequestType: APIRequesting> = (_ error: NetworkError, _ failedRequest: RequestType, _ handlers: NetworkHandlers<RequestType>?) -> Void
public typealias RequestExecutingHandler = (_ executing: Bool) -> Void

public struct NetworkHandlers<RequestType: APIRequesting> {
    
    let successHandler: ((_ response: RequestType.ResponseType) -> Void)?
    let executingHandler: RequestExecutingHandler?
    let errorHandler: ErrorHandler<RequestType>?
    let requestHandler: RequestHandler?
    
    public init(successHandler: ((_ response: RequestType.ResponseType) -> Void)? = nil, executingHandler: RequestExecutingHandler? = nil,
         errorHandler: ErrorHandler<RequestType>? = nil, requestHandler: RequestHandler? = nil) {
        self.successHandler = successHandler
        self.executingHandler = executingHandler
        self.errorHandler = errorHandler
        self.requestHandler = requestHandler
    }
}
