//
//  APIClient.swift
//  MyWeather
//
//  Created by Mac on 05.12.16.
//  Copyright © 2016 Sergey Kostyan. All rights reserved.
//

import Foundation
import Alamofire

public typealias ErrorHandler = (_ error: Error) -> Void
public typealias RepeatRequestHandler = (_ accessToken: String) -> Void
public typealias RequestHandler = (_ request: Request?) -> Void
public typealias RefreshTokenHandler = (_ refreshedHandler: RefreshedTokenHandler?, _ failure: ErrorHandler?) -> Void
public typealias RefreshedTokenHandler = (_ token: String) -> Void

private let unauthorizedErrorCode = 401

public protocol APIClientService {
    
    func executeRequest<RequestType: APIRequesting>(request: RequestType, success: ((_ response: RequestType.ResponseType) -> Void)?,
                                                    failure: ErrorHandler?, requestHandler: RequestHandler?)
    func executeMultipartRequest<T: APIMultipartRequesting>(request: RequestType, success: ((_ response: RequestType.ResponseType) -> Void)?,
                                                            failure: ErrorHandler?, requestHandler: RequestHandler?)
    func pauseAllRequests(pause: Bool)
    func cancelAllRequests()
    func cancel(task: URLSessionTask?)
}

open class APIClient {
    
    private var sessionManager: SessionManager!
    private var errorParsingService: ErrorParsing?
    
    public var refreshTokenHandler: RefreshTokenHandler?
    
    // MARK: - Init
    
    public init(sessionManager: SessionManager? = Alamofire.SessionManager.default, errorParsingService: ErrorParsing?) {
        self.sessionManager = sessionManager
        self.errorParsingService = errorParsingService
    }
    
    open func executeRequest<RequestType: APIRequesting>(request: RequestType, success: ((_ response: RequestType.ResponseType) -> Void)? = nil,
                                               failure: ErrorHandler? = nil, requestHandler: RequestHandler? = nil) {
        let alamofireRequest = sessionManager.request(request.path, method: request.HTTPMethod, parameters: request.parameters,
                                                      encoding: JSONEncoding.default, headers: request.headers)
        requestHandler?(alamofireRequest)
        alamofireRequest.responseJSON(completionHandler: { [weak self] (response) in
            if response.response?.statusCode == unauthorizedErrorCode, self?.refreshTokenHandler != nil {
                self?.refreshToken(failedRequest: request)
            } else {
                self?.process(response: response, from: request, success: success, failure: failure)
            }
        })
    }
    
    open func executeMultipartRequest<RequestType: APIMultipartRequesting>(request: RequestType,
                                                                           success: ((_ response: RequestType.ResponseType) -> Void)? = nil,
                                                                           failure: ErrorHandler? = nil, requestHandler: RequestHandler? = nil) {
        sessionManager.upload(multipartFormData: { [weak self] (multipartFormData) in
            self?.append(multipartFormData: multipartFormData, with: request)
        }, to: request.path, method: request.HTTPMethod, headers: request.headers) { [weak self] (result) in
            switch result {
            case .success(let upload, _, _):
                requestHandler?(upload)
                upload.responseJSON { [weak self] response in
                    if response.response?.statusCode == unauthorizedErrorCode, self?.refreshTokenHandler != nil {
                        self?.refreshToken(failedRequest: request)
                    } else {
                        self?.process(response: response, from: request, success: success, failure: failure)
                    }
                }
            case .failure(let error):
                requestHandler?(nil)
                failure?(error)
            }
        }
    }
    
    open func pauseAllRequests(pause: Bool) {
        sessionManager.session.delegateQueue.isSuspended = pause
    }
    
    open func cancelAllRequests() {
        sessionManager.session.invalidateAndCancel()
    }
    
    open func cancel(task: URLSessionTask?) {
        if let taskToCancel = task {
            taskToCancel.cancel()
        }
    }
    
    // MARK: - Utils -
    
    private func refreshToken<RequestType: APIBaseRequesting>(failedRequest: RequestType) {
//        refreshTokenHandler({ [weak self] (newToken) in
//            var repeatRequest = request
//            //                    repeatRequest.headers = API.headers(with: newToken)
//            self?.executeRequest(request: repeatRequest, success: success, failure: failure, requestHandler: requestHandler)
//            }, failure)
        
//        refreshTokenHandler({ [weak self] (newToken) in
//            var repeatRequest = request
//            //                            repeatRequest.headers = API.headers(with: newToken)
//            self?.executeMultipartRequest(request: repeatRequest, success: success, failure: failure, requestHandler: requestHandler)
//            }, failure)
    }
    
    private func append<RequestType: APIMultipartRequesting>(multipartFormData: MultipartFormData, with request: RequestType) {
        if let parameters = request.parameters {
            for (key, value) in parameters {
                if let data = "\(value)".data(using: String.Encoding.utf8) {
                    multipartFormData.append(data, withName: key as String)
                }
            }
        }
        multipartFormData.append(request.multipartData, withName: request.multipartKey, fileName: request.fileName, mimeType: request.mimeType)
    }
    
    private func process<RequestType: APIBaseRequesting>(response: DataResponse<Any>, from request: RequestType,
                                                         success: ((_ response: RequestType.ResponseType) -> Void)?, failure: ErrorHandler?) {
        switch response.result {
        case .success(let value):
            guard let error = errorParsingService?.parseError(from: value as AnyObject) else {
                let response: RequestType.ResponseType = RequestType.Response(JSON: value as AnyObject)
                success?(response)
                return
            }
            failure?(error)
        case .failure(let error):
            failure?(error)
        }
    }
    
}
