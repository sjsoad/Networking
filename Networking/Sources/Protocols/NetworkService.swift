//
//  NetworkService.swift
//  SKNetworkingLib
//
//  Created by Sergey on 28.08.2018.
//

import Alamofire

public protocol NetworkService: RequestManaging {
    
    init(with sessionManager: SessionManager, errorParser: ErrorParsable)
    
    // MARK: - JSON -
    
    func executeJSON<RequestType: APIDataRequesting, ResponseType: APIResponsing>(_ request: RequestType,
                                                                                  with handlers: NetworkHandlers<ResponseType>?)
    func executeJSON<RequestType: APIDataRequesting, ResponseType: APIResponsing>(_ request: RequestType,
                                                                                  with handlers: NetworkHandlers<ResponseType>?,
                                                                                  _ requestHandler: @escaping DataRequestHandler)
    
    func executeJSON<RequestType: APIUploadRequesting, ResponseType: APIResponsing>(_ request: RequestType,
                                                                                    with handlers: NetworkHandlers<ResponseType>?)
    func executeJSON<RequestType: APIUploadRequesting, ResponseType: APIResponsing>(_ request: RequestType,
                                                                                    with handlers: NetworkHandlers<ResponseType>?,
                                                                                    _ requestHandler: @escaping UploadRequestHandler)
    
    func executeJSON<RequestType: APIDownloadRequesting, ResponseType: APIResponsing>(_ request: RequestType,
                                                                                      with handlers: NetworkHandlers<ResponseType>?)
    func executeJSON<RequestType: APIDownloadRequesting, ResponseType: APIResponsing>(_ request: RequestType,
                                                                                      with handlers: NetworkHandlers<ResponseType>?,
                                                                                      _ requestHandler: @escaping DownloadRequestHandler)
    
    // MARK: - Data -
    
    func executeData<RequestType: APIDataRequesting, ResponseType: APIResponsing>(_ request: RequestType,
                                                                                  with handlers: NetworkHandlers<ResponseType>?)
    func executeData<RequestType: APIDataRequesting, ResponseType: APIResponsing>(_ request: RequestType,
                                                                                  with handlers: NetworkHandlers<ResponseType>?,
                                                                                  _ requestHandler: @escaping DataRequestHandler)
    
    func executeData<RequestType: APIUploadRequesting, ResponseType: APIResponsing>(_ request: RequestType,
                                                                                    with handlers: NetworkHandlers<ResponseType>?)
    func executeData<RequestType: APIUploadRequesting, ResponseType: APIResponsing>(_ request: RequestType,
                                                                                    with handlers: NetworkHandlers<ResponseType>?,
                                                                                    _ requestHandler: @escaping UploadRequestHandler)
    
    func executeData<RequestType: APIDownloadRequesting, ResponseType: APIResponsing>(_ request: RequestType,
                                                                                      with handlers: NetworkHandlers<ResponseType>?)
    func executeData<RequestType: APIDownloadRequesting, ResponseType: APIResponsing>(_ request: RequestType,
                                                                                      with handlers: NetworkHandlers<ResponseType>?,
                                                                                      _ requestHandler: @escaping DownloadRequestHandler)
    
}
