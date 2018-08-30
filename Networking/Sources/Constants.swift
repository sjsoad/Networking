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
public typealias NetworkError = (error: Error, code: Int?)

public typealias RequestHandler = (_ request: RequestClass?, _ error: Error?) -> Void
public typealias ErrorHandler = (_ error: NetworkError) -> Void
public typealias RequestExecutingHandler = (_ executing: Bool) -> Void


public enum StatusCode: Int {
    case unauthorized = 401
}

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
