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
public typealias ErrorHandler = (_ error: NetworkError) -> Void

public enum NetworkErrorCode: Int {
    case unauthorized = 401
}

public struct NetworkHandlers<RequestType: APIRequesting> {
    
    var successHandler: ((_ response: RequestType.ResponseType) -> Void)?
    var executingHandler: RequestExecutingHandler?
    var errorHandler: ErrorHandler?
    var requestHandler: RequestHandler?
    
    init(successHandler: ((_ response: RequestType.ResponseType) -> Void)?, executingHandler: RequestExecutingHandler?,
         errorHandler: ErrorHandler?, requestHandler: RequestHandler?) {
        self.successHandler = successHandler
        self.executingHandler = executingHandler
        self.errorHandler = errorHandler
        self.requestHandler = requestHandler
    }
}
