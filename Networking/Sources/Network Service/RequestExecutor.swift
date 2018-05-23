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
    var errorParser: ErrorParsing { get }
    init(sessionManager: SessionManager, errorParser: ErrorParsing)
    func execute<RequestType: APIRequesting>(request: RequestType, successHandler: ((_ response: RequestType.ResponseType) -> Void)?,
                                             errorHandler: ErrorHandler?, requestHandler: RequestHandler?)
    
}

open class DefaultRequestExecutor: RequestExecutor {

    public private(set) var sessionManager: SessionManager
    public private(set) var errorParser: ErrorParsing
    
    // MARK: - Public -
    
    public required init(sessionManager: SessionManager, errorParser: ErrorParsing) {
        self.sessionManager = sessionManager
        self.errorParser = errorParser
    }
    
    open func execute<RequestType: APIRequesting>(request: RequestType, successHandler: ((_ response: RequestType.ResponseType) -> Void)?,
                                                  errorHandler: ErrorHandler?, requestHandler: RequestHandler?) {
        build(from: request, requestHandler: { [weak self] (alamofireRequest, error) in
            requestHandler?(alamofireRequest, error)
            guard let alamofireRequest = alamofireRequest else { return }
            alamofireRequest.responseJSON(completionHandler: { [weak self] (response) in
                self?.process(response: response, from: request, successHandler: successHandler, errorHandler: errorHandler)
            })
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
            self?.append(multipartFormData: multipartFormData, with: request)
        }, to: request.urlString, method: request.HTTPMethod, headers: request.headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                requestHandler?(upload, nil)
            case .failure(let error):
                requestHandler?(nil, error)
            }
        }
    }
    
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
    
    private func process<RequestType: APIRequesting>(response: DataResponse<Any>, from request: RequestType,
                                                     successHandler: ((_ response: RequestType.ResponseType) -> Void)?, errorHandler: ErrorHandler?) {
        switch response.result {
        case .success(let value):
            guard let networkError = errorParser.parseError(from: value as AnyObject) else {
                let response: RequestType.ResponseType = RequestType.ResponseType(JSON: value as AnyObject)
                successHandler?(response)
                return
            }
            errorHandler?(networkError)
        case .failure(let error):
            let networkError = NetworkError(error: error, statusCode: response.response?.statusCode)
            errorHandler?(networkError)
        }
    }
}
