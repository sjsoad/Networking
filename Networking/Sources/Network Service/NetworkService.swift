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
    
    init(requestExecutor: RequestExecutor)
    func execut<RequestType: APIRequesting>(request: RequestType, handlers: NetworkHandlers<RequestType>?)
}

open class DefaultNetworkService: NetworkService {

    private var requestExecutor: RequestExecutor
    
    // MARK: - Public -
    
    public required init(requestExecutor: RequestExecutor) {
        self.requestExecutor = requestExecutor
    }
    
    open func execut<RequestType: APIRequesting>(request: RequestType, handlers: NetworkHandlers<RequestType>?) {
        handlers?.executingHandler?(true)
        requestExecutor.execute(request: request, successHandler: { (response) in
            handlers?.executingHandler?(false)
            handlers?.successHandler?(response)
        }, errorHandler: { (networkError) in
            handlers?.executingHandler?(false)
            handlers?.errorHandler?(networkError, request, handlers)
        }, requestHandler: { (request, error) in
            if request == nil {
                handlers?.executingHandler?(false)
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
    
}
