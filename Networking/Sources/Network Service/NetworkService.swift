//
//  NetworkService.swift
//  Networking
//
//  Created by Sergey on 22.05.2018.
//  Copyright © 2018 Sergey Kostyan. All rights reserved.
//

import UIKit
import Alamofire

public protocol NetworkService: RequestManaging {
    
    init(requestExecutor: RequestExecutor, errorParser: ErrorParsing)
    func execut<RequestType: APIRequesting>(request: RequestType, handlers: NetworkHandlers<RequestType>?)
}

open class DefaultNetworkService: NetworkService {

    private var requestExecutor: RequestExecutor
    private var errorParser: ErrorParsing
    
    // MARK: - Public -
    
    public required init(requestExecutor: RequestExecutor, errorParser: ErrorParsing) {
        self.requestExecutor = requestExecutor
        self.errorParser = errorParser
    }
    
    open func execut<RequestType: APIRequesting>(request: RequestType, handlers: NetworkHandlers<RequestType>?) {
        handlers?.requestExecutingHandler?(true)
        requestExecutor.execute(request: request, responseHandler: { (response) in
            
        }, requestHandler: { (request, error) in
            if request == nil {
                handlers?.requestExecutingHandler?(false)
            }
            handlers?.requestHandler?(request, error)
        })
    }
    
    open func pauseAllRequests(pause: Bool) {
        requestExecutor.pauseAllRequests(pause: pause)
    }
    
    open func cancelAllRequests() {
        requestExecutor.cancelAllRequests()
    }
    
    open func cancel(request: RequestClass) {
        requestExecutor.cancel(request: request)
    }
    
    // MARK: - Private -
    
    private func process<RequestType: APIRequesting>(response: DataResponse<Any>, from request: RequestType,
                                                     success: ((_ response: RequestType.ResponseType) -> Void)?,
                                                     failure: ErrorHandler?) {
        switch response.result {
        case .success(let value):
            guard let networkError = errorParser.parseError(from: value as AnyObject) else {
                let response: RequestType.ResponseType = RequestType.ResponseType(JSON: value as AnyObject)
                success?(response)
                return
            }
            failure?(networkError)
        case .failure(let error):
            let networkError = NetworkError(error: error, statusCode: response.response?.statusCode)
            failure?(networkError)
        }
    }
    
}
