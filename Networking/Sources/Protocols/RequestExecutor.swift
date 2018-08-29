//
//  RequestExecutor.swift
//  SKNetworkingLib
//
//  Created by Sergey on 28.08.2018.
//

import Alamofire

public protocol RequestExecutor: RequestManaging {
    
    init(sessionManager: SessionManager)
    func execute<RequestType: APIRequesting>(_ request: RequestType, requestHandler: RequestHandler?, completion: @escaping (DataResponse<Any>) -> ())
    
}
