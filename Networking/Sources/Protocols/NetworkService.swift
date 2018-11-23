//
//  NetworkService.swift
//  SKNetworkingLib
//
//  Created by Sergey on 28.08.2018.
//

import Alamofire

public protocol NetworkService: RequestManaging {
    
    init(requestExecutor: RequestExecutor, errorParser: ErrorParsable)
    func execute<RequestType: APIRequesting, ResponseType: APIResponsing>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?)
    
}
