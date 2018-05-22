//
//  NetworkService.swift
//  Networking
//
//  Created by Sergey on 22.05.2018.
//  Copyright © 2018 Sergey Kostyan. All rights reserved.
//

import UIKit
import Alamofire

public protocol NetworkService {
    
    init(requestExecutingService: RequestExecutingService, errorParser: ErrorParsing)
    func execut<RequestType: APIRequesting>(request: RequestType, success: ((_ response: RequestType.ResponseType) -> Void)?,
                                            failure: ErrorHandler?, requestHandler: RequestHandler?)
    func pauseAllRequests(pause: Bool)
    func cancelAllRequests()
    func cancel(request: Request)
}

open class DefaultNetworkService: NetworkService {

    private var requestExecutingService: RequestExecutingService
    private var errorParser: ErrorParsing
    
    // MARK: - Public -
    
    public required init(requestExecutingService: RequestExecutingService, errorParser: ErrorParsing) {
        self.requestExecutingService = requestExecutingService
        self.errorParser = errorParser
    }
    
    open func execut<RequestType: APIRequesting>(request: RequestType, success: ((_ response: RequestType.ResponseType) -> Void)?,
                                                 failure: ErrorHandler?, requestHandler: RequestHandler?) {
        requestExecutingService.execute(request: request, responseHandler: { [weak self] (response) in
            self?.process(response: response, from: request, success: success, failure: failure)
            }, requestHandler: requestHandler)
    }
    
    open func pauseAllRequests(pause: Bool) {
        requestExecutingService.sessionManager.session.delegateQueue.isSuspended = pause
    }
    
    open func cancelAllRequests() {
        requestExecutingService.sessionManager.session.invalidateAndCancel()
    }
    
    open func cancel(request: Request) {
        request.cancel()
    }
    
    // MARK: - Private -
    
    private func process<RequestType: APIRequesting>(response: DataResponse<Any>, from request: RequestType,
                                                     success: ((_ response: RequestType.ResponseType) -> Void)?,
                                                     failure: ErrorHandler?) {
        switch response.result {
        case .success(let value):
            guard let error = errorParser.parseError(from: value as AnyObject) else {
                let response: RequestType.ResponseType = RequestType.ResponseType(JSON: value as AnyObject)
                success?(response)
                return
            }
            failure?(error, request)
        case .failure(let error):
            failure?(error, request)
        }
    }
    
}
