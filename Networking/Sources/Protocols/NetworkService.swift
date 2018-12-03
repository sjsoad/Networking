//
//  NetworkService.swift
//  SKNetworkingLib
//
//  Created by Sergey on 28.08.2018.
//

import Alamofire

public protocol NetworkService: RequestManaging {
    
    init(with sessionManager: SessionManager, errorParser: ErrorParsable)
    
    
    func execute<RequestType: APIDataRequesting, ResponseType: APIResponsing>(_ request: RequestType,
                                                                              with handlers: NetworkHandlers<ResponseType>?)
    func execute<RequestType: APIDataRequesting, ResponseType: APIResponsing>(_ request: RequestType,
                                                                              with handlers: NetworkHandlers<ResponseType>?,
                                                                              _ requestHandler: @escaping DataRequestHandler)
    
    func execute<RequestType: APIUploadRequesting, ResponseType: APIResponsing>(_ request: RequestType,
                                                                                with handlers: NetworkHandlers<ResponseType>?)
    func execute<RequestType: APIUploadRequesting, ResponseType: APIResponsing>(_ request: RequestType,
                                                                                with handlers: NetworkHandlers<ResponseType>?,
                                                                                _ requestHandler: @escaping UploadRequestHandler)
    
    func execute<RequestType: APIDownloadRequesting, ResponseType: APIResponsing>(_ request: RequestType,
                                                                                  with handlers: NetworkHandlers<ResponseType>?)
    func execute<RequestType: APIDownloadRequesting, ResponseType: APIResponsing>(_ request: RequestType,
                                                                                  with handlers: NetworkHandlers<ResponseType>?,
                                                                                  _ requestHandler: @escaping DownloadRequestHandler)
    
}
