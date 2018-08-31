//
//  DefaultRequestExecutor.swift
//  Networking
//
//  Created by Sergey on 22.05.2018.
//  Copyright © 2018 Sergey Kostyan. All rights reserved.
//

import Alamofire

public struct DefaultRequestExecutor: RequestExecutor {
    
    private let sessionManager: SessionManager
    
    // MARK: - Public -
    
    public init(sessionManager: SessionManager = SessionManager.default) {
        self.sessionManager = sessionManager
    }
    
    public func dataRequest<RequestType: APIRequesting>(from request: RequestType, _ requestHandler: RequestHandler?,
                                                        with completion: @escaping DataResponseHandler) {
        var dataRequest: DataRequest? = nil
        switch request.requestType {
        case .simple(let parameters):
            dataRequest = sessionManager.request(request.urlString, method: request.HTTPMethod, parameters: parameters, headers: request.headers)
        case .uploadData(let data):
            dataRequest = sessionManager.upload(data, to: request.urlString, method: request.HTTPMethod, headers: request.headers)
        case .uploadURL(let url):
            dataRequest = sessionManager.upload(url, to: request.urlString, method: request.HTTPMethod, headers: request.headers)
        case .uploadStream(let stream):
            dataRequest = sessionManager.upload(stream, to: request.urlString, method: request.HTTPMethod, headers: request.headers)
        default:
            print("\(request.requestType) is ignored. Not data request")
        }
        dataRequest?.responseJSON(completionHandler: completion)
        requestHandler?(dataRequest, nil)
    }
    
    public func downloadRequest<RequestType: APIRequesting>(from request: RequestType, _ requestHandler: RequestHandler?,
                                                            with completion: @escaping DownloadResponseHandler) {
        var downloadRequest: DownloadRequest? = nil
        switch request.requestType {
        case .downloadResuming(let data, let destination):
            downloadRequest = sessionManager.download(resumingWith: data, to: destination)
        case .downloadTo(let parameters, let destination):
            downloadRequest = sessionManager.download(request.urlString, method: request.HTTPMethod, parameters: parameters, headers: request.headers,
                                                      to: destination)
        default:
            print("\(request.requestType) is ignored. Not download request")
        }
        downloadRequest?.responseJSON(completionHandler: completion)
        requestHandler?(downloadRequest, nil)
    }
    
    public func multipartRequest<RequestType: APIRequesting>(from request: RequestType, _ requestHandler: RequestHandler?,
                                                             with completion: @escaping DataResponseHandler) {
        switch request.requestType {
        case .uploadMultipart(let parameters, let multipartParameters):
            sessionManager.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(with: parameters)
                multipartFormData.appen(with: multipartParameters)
            }, to: request.urlString, method: request.HTTPMethod, headers: request.headers) { (result) in
                switch result {
                case .success(let upload, _, _):
                    requestHandler?(upload, nil)
                    upload.responseJSON(completionHandler: completion)
                case .failure(let error):
                    requestHandler?(nil, error)
                }
            }
        default:
            print("\(request.requestType) is ignored. Not multipart request")
        }
    }
    
    // MARK: - RequestManaging -
    
    public func pauseAllRequests(_ pause: Bool) {
        sessionManager.session.delegateQueue.isSuspended = pause
    }
    
    public func cancelAllRequests() {
        sessionManager.session.invalidateAndCancel()
    }
    
    public func cancel(_ request: RequestClass) {
        request.cancel()
    }
    
}
