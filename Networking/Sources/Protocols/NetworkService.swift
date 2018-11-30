//
//  NetworkService.swift
//  SKNetworkingLib
//
//  Created by Sergey on 28.08.2018.
//

import Alamofire

public protocol NetworkService: RequestManaging {
    
    init(with sessionManager: SessionManager, errorParser: ErrorParsable)
    
    func executeJSON<RequestType: APIDataRequesting, ResponseType: APIResponsing>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?)
    func executeJSON<RequestType: APIUploadRequesting, ResponseType: APIResponsing>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?)
    func executeJSON<RequestType: APIDownloadRequesting, ResponseType: APIResponsing>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?)
//   requestHandler + func executeJSON<RequestType: APIRequesting, ResponseType: APIResponsing>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?)
//    func executeData<RequestType: APIRequesting, ResponseType: APIResponsing>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?)
//   requestHandler + func executeData<RequestType: APIRequesting, ResponseType: APIResponsing>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?)
}
