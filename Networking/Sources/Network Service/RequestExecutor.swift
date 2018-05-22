//
//  RequestExecutor.swift
//  Networking
//
//  Created by Sergey on 22.05.2018.
//  Copyright © 2018 Sergey Kostyan. All rights reserved.
//

import UIKit
import Alamofire

public protocol RequestExecutor: RequestManaging {
    
    var sessionManager: SessionManager { get }
    init(sessionManager: SessionManager)
    func execute<RequestType: APIRequesting>(request: RequestType, responseHandler: @escaping (DataResponse<Any>) -> Void,
                                             requestHandler: RequestHandler?)
    
}

open class DefaultRequestExecutor: RequestExecutor {

    public private(set) var sessionManager: SessionManager
    
    // MARK: - Public -
    
    public required init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
    
    open func execute<RequestType: APIRequesting>(request: RequestType, responseHandler: @escaping (DataResponse<Any>) -> Void,
                                                  requestHandler: RequestHandler?) {
        sessionManager.upload(multipartFormData: { [weak self] (multipartFormData) in
            self?.append(multipartFormData: multipartFormData, with: request)
        }, to: request.urlString, method: request.HTTPMethod, headers: request.headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                requestHandler?(upload, nil)
                upload.responseJSON(completionHandler: responseHandler)
            case .failure(let error):
                requestHandler?(nil, error)
            }
        }
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
    
    private func append<RequestType: APIRequesting>(multipartFormData: MultipartFormData, with request: RequestType) {
        if let parameters = request.parameters {
            for (key, value) in parameters {
                if let data = "\(value)".data(using: String.Encoding.utf8) {
                    multipartFormData.append(data, withName: key as String)
                }
            }
        }
        //        multipartFormData.append(request.multipartData, withName: request.multipartKey, fileName: request.fileName, mimeType: request.mimeType)
    }
}
