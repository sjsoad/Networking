//
//  RequestExecutor.swift
//  Networking
//
//  Created by Sergey on 22.05.2018.
//  Copyright © 2018 Sergey Kostyan. All rights reserved.
//

import Alamofire

public protocol RequestExecutor: RequestManaging {
    
    var sessionManager: SessionManager { get }
    init(sessionManager: SessionManager)
    func execute<RequestType: APIRequesting>(request: RequestType, requestHandler: RequestHandler?, completion: @escaping (DataResponse<Any>) -> ())
    
}

open class DefaultRequestExecutor: RequestExecutor {

    public private(set) var sessionManager: SessionManager
    
    // MARK: - Public -
    
    public required init(sessionManager: SessionManager = SessionManager.default) {
        self.sessionManager = sessionManager
    }
    
    open func execute<RequestType: APIRequesting>(request: RequestType, requestHandler: RequestHandler?, completion: @escaping (DataResponse<Any>) -> ()) {
        build(from: request, requestHandler: { (alamofireRequest, error) in
            requestHandler?(alamofireRequest, error)
            alamofireRequest?.responseJSON(completionHandler: completion)
        })
    }
    
    open func pauseAllRequests(pause: Bool) {
        sessionManager.session.delegateQueue.isSuspended = pause
    }
    
    open func cancelAllRequests() {
        sessionManager.session.invalidateAndCancel()
    }
    
    open func cancel(request: RequestClass) {
        request.cancel()
    }
    
    // MARK: - Private -
    
    private func build<RequestType: APIRequesting>(from request: RequestType, requestHandler: ((UploadRequest?, Error?) -> Void)?) {
        sessionManager.upload(multipartFormData: { [weak self] (multipartFormData) in
            self?.append(multipartFormData: multipartFormData, from: request)
        }, to: request.urlString, method: request.HTTPMethod, headers: request.headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                requestHandler?(upload, nil)
            case .failure(let error):
                requestHandler?(nil, error)
            }
        }
    }
    
    private func append<RequestType: APIRequesting>(multipartFormData: MultipartFormData, from request: RequestType) {
        request.parameters?.forEach({ (key, value) in
            guard let data = "\(value)".data else { return }
            multipartFormData.append(data, withName: key)
        })
        guard let multipartData = request.multipartData, let multipartKey = request.multipartKey, let fileName = request.fileName,
            let mimeType = request.mimeType else { return }
        multipartFormData.append(multipartData, withName: multipartKey, fileName: fileName, mimeType: mimeType)
    }
    
}
