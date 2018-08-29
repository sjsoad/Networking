//
//  DefaultNetworkService.swift
//  Networking
//
//  Created by Sergey on 22.05.2018.
//  Copyright © 2018 Sergey Kostyan. All rights reserved.
//

import Alamofire

open class DefaultNetworkService: NetworkService {

    private let requestExecutor: RequestExecutor
    private let errorParser: ErrorParsing
    
    // MARK: - Public -
    
    public required init(requestExecutor: RequestExecutor, errorParser: ErrorParsing) {
        self.requestExecutor = requestExecutor
        self.errorParser = errorParser
    }
    
    public func execute<RequestType: APIRequesting, ResponseType: APIResponsing>(request: RequestType,
                                                                               handlers: NetworkHandlers<RequestType, ResponseType>?) {
        requestExecutor.execute(request, requestHandler: { (request, error) in
            handlers?.executingHandler?(request != nil)
            handlers?.requestHandler?(request, error)
        }) { (data) in
            handlers?.executingHandler?(false)
            DispatchQueue.global().async { [weak self] in
                guard let `self` = self else { return }
                self.process(data, request: request, handlers: handlers) }
        }
    }
    
    // MARK: - RequestManaging -
    
    public func pauseAllRequests(pause: Bool) {
        requestExecutor.pauseAllRequests(pause: pause)
    }
    
    public func cancelAllRequests() {
        requestExecutor.cancelAllRequests()
    }
    
    public func cancel(request: RequestClass) {
        requestExecutor.cancel(request: request)
    }
    
    // MARK: - Private -
    
    private func process<RequestType: APIRequesting, ResponseType: APIResponsing>(_ data: DataResponse<Any>, request: RequestType,
                                                                                  handlers: NetworkHandlers<RequestType, ResponseType>?) {
        switch data.result {
        case .success(let value):
            guard let networkError = errorParser.parseError(from: value, httpURLResponse: data.response) else {
                let requestResponse = ResponseType(JSON: value)
                DispatchQueue.main.async { handlers?.successHandler?(requestResponse) }
                return
            }
            DispatchQueue.main.async { handlers?.errorHandler?(networkError, request, handlers) }
        case .failure(let error):
            let networkError = (error: error, code: data.response?.statusCode)
            DispatchQueue.main.async { handlers?.errorHandler?(networkError, request, handlers) }
        }
    }
    
}
