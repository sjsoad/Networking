//
//  DefaultRequestExecutor.swift
//  Networking
//
//  Created by Sergey on 22.05.2018.
//  Copyright © 2018 Sergey Kostyan. All rights reserved.
//

import Alamofire

public class DefaultRequestExecutor: RequestExecutor {
    
    private let sessionManager: SessionManager
    
    // MARK: - Public -
    
    public required init(sessionManager: SessionManager = SessionManager()) {
        self.sessionManager = sessionManager
    }
    
    public func dataRequest<RequestType: APIRequesting>(from request: RequestType, _ requestHandler: RequestHandler?,
                                                        with completion: @escaping DataResponseHandler) {
        var dataRequest: DataRequest!
        switch request.requestType {
        case .simple(let parameters):
            dataRequest = sessionManager.request(request.urlString, method: request.HTTPMethod, parameters: parameters,
                                                 encoding: JSONEncoding.default, headers: request.headers)
        case .uploadData(let data):
            dataRequest = sessionManager.upload(data, to: request.urlString, method: request.HTTPMethod, headers: request.headers)
        case .uploadURL(let url):
            dataRequest = sessionManager.upload(url, to: request.urlString, method: request.HTTPMethod, headers: request.headers)
        case .uploadStream(let stream):
            dataRequest = sessionManager.upload(stream, to: request.urlString, method: request.HTTPMethod, headers: request.headers)
        case .uploadMultipart(let parameters, let multipartParameters):
            sessionManager.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(with: parameters)
                multipartFormData.appen(with: multipartParameters)
            }, to: request.urlString, method: request.HTTPMethod, headers: request.headers, encodingCompletion: { (result) in
                switch result {
                case .success(let upload, _, _):
                    requestHandler?(.success(upload))
                    upload.responseJSON(completionHandler: completion)
                case .failure(let error):
                    requestHandler?(.failure(error))
                }
            })
        default:
            print("\(request.requestType) is ignored. Not data request")
        }
        requestHandler?(.success(dataRequest))
        dataRequest.responseJSON(completionHandler: completion)
    }
    
    public func downloadRequest<RequestType: APIRequesting>(from request: RequestType, _ requestHandler: RequestHandler?,
                                                            with completion: @escaping DownloadResponseHandler) {
        var downloadRequest: DownloadRequest!
        switch request.requestType {
        case .downloadResuming(let data, let destination):
            downloadRequest = sessionManager.download(resumingWith: data, to: destination)
        case .downloadTo(let parameters, let destination):
            downloadRequest = sessionManager.download(request.urlString, method: request.HTTPMethod, parameters: parameters,
                                                      headers: request.headers, to: destination)
        default:
            print("\(request.requestType) is ignored. Not download request")
        }
        requestHandler?(.success(downloadRequest))
        downloadRequest.responseData(completionHandler: completion)
        
    }
    
    // MARK: - RequestManaging -
    
    public func pauseAllRequests(_ pause: Bool) {
        sessionManager.session.delegateQueue.isSuspended = pause
    }
    
    public func cancelAllRequests() {
        sessionManager.session.invalidateAndCancel()
    }
    
    public func cancel<RequestClass>(_ request: RequestClass) where RequestClass : UsedRequestClass {
        request.cancel()
    }
    
}
