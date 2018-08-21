//
//  NetworkService.swift
//  Networking
//
//  Created by Sergey on 22.05.2018.
//  Copyright © 2018 Sergey Kostyan. All rights reserved.
//

import Alamofire

public protocol NetworkService: RequestManaging {
    
    init(requestExecutor: RequestExecutor, errorParser: ErrorParsing)
    func execute<RequestType: APIRequesting>(request: RequestType, handlers: NetworkHandlers<RequestType>?)
}

open class DefaultNetworkService: NetworkService {

    private var requestExecutor: RequestExecutor
    private var errorParser: ErrorParsing
    
    // MARK: - Public -
    
    public required init(requestExecutor: RequestExecutor, errorParser: ErrorParsing) {
        self.requestExecutor = requestExecutor
        self.errorParser = errorParser
    }
    
    open func execute<RequestType: APIRequesting>(request: RequestType, handlers: NetworkHandlers<RequestType>?) {
        handlers?.executingHandler?(true)
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
    
    private func process<ResponseType: APIResponsing>(response: DataResponse<Any>) -> (ResponseType?, NetworkError?) {
        var requestResponse: ResponseType?
        var networkError: NetworkError?
        switch response.result {
        case .success(let value):
            networkError = errorParser.parseError(from: value, httpURLResponse: response.response)
            requestResponse = ResponseType(JSON: value)
        case .failure(let error):
            networkError = NetworkError(error: error, statusCode: response.response?.statusCode)
        }
        return (requestResponse, networkError)
    }
    
}
