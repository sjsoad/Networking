//
//  NetworkService.swift
//  SKNetworkingLib
//
//  Created by Sergey on 28.08.2018.
//

import Alamofire

public protocol NetworkService: RequestManaging {
    
    init(requestExecutor: RequestExecutor, errorParser: ErrorParsing)
    func execute<RequestType: APIRequesting, ResponseType: APIResponsing>(request: RequestType, handlers: NetworkHandlers<RequestType, ResponseType>?)
}
