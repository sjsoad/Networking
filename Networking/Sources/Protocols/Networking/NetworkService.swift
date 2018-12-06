//
//  NetworkService.swift
//  SKNetworkingLib
//
//  Created by Sergey on 28.08.2018.
//

import Alamofire

public protocol NetworkService: RequestManaging {
    
    init(with sessionManager: SessionManager, errorParser: ErrorParsable, taskExecutor: TaskExecuting)
    
    func execute<RequestType: APIRequesting, ResponseType: APIResponsing>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?)
        where RequestType.ResponseType == ResponseType.ResponseType
    func execute<RequestType: APIRequesting, ResponseType: APIResponsing>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?,
                                                                          _ requestHandler: @escaping RequestHandler<RequestType.RequestType>)
        where RequestType.ResponseType == ResponseType.ResponseType
    
}