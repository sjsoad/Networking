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
    private let reAuthorizer: ReAuthorizable?
    private let errorParser: ErrorParsable
    
    // MARK: - Public -
    
    public required init(requestExecutor: RequestExecutor, reAuthorizer: ReAuthorizable? = nil, errorParser: ErrorParsable) {
        self.requestExecutor = requestExecutor
        self.reAuthorizer = reAuthorizer
        self.errorParser = errorParser
    }
    
    public func execute<RequestType: APIRequesting, ResponseType: APIResponsing>(_ request: RequestType,
                                                                                 with handlers: NetworkHandlers<ResponseType>?) {
        let requestHandler: RequestHandler = { (request, error) in
            handlers?.executingHandler?(request != nil)
            handlers?.requestHandler?(request, error)
        }
        switch request.requestType {
         case .simple, .uploadData, .uploadURL, .uploadStream:
            requestExecutor.dataRequest(from: request, requestHandler) { (data) in
                handlers?.executingHandler?(false)
                DispatchQueue.global().async { [weak self] in
                    guard let `self` = self else { return }
                    self.parse(data, from: request, with: handlers)
                }
            }
        case .downloadResuming, .downloadTo:
            requestExecutor.downloadRequest(from: request, requestHandler) { (downloadData) in
                handlers?.executingHandler?(false)
            }
        case .uploadMultipart:
            requestExecutor.multipartRequest(from: request, requestHandler) { (data) in
                handlers?.executingHandler?(false)
                DispatchQueue.global().async { [weak self] in
                    guard let `self` = self else { return }
                    self.parse(data, from: request, with: handlers)
                }
            }
        }
//        requestExecutor.execute(request, requestHandler: { (request, error) in
//            handlers?.executingHandler?(request != nil)
//            handlers?.requestHandler?(request, error)
//        }) { (data) in
//            handlers?.executingHandler?(false)
//            DispatchQueue.global().async { [weak self] in
//                guard let `self` = self else { return }
//                self.parse(data, from: request, with: handlers)
//            }
//        }
    }
    
    // MARK: - RequestManag ing -
    
    public func pauseAllRequests(_ pause: Bool) {
        requestExecutor.pauseAllRequests(pause)
    }
    
    public func cancelAllRequests() {
        requestExecutor.cancelAllRequests()
    }
    
    public func cancel(_ request: RequestClass) {
        requestExecutor.cancel(request)
    }
    
    // MARK: - Private -
    
    private func parse<RequestType: APIRequesting, ResponseType: APIResponsing>(_ data: DataResponse<Any>, from request: RequestType,
                                                                                with handlers: NetworkHandlers<ResponseType>?) {
        switch data.result {
        case .success(let value):
            guard let networkError = errorParser.parseError(from: value, httpURLResponse: data.response) else {
                let requestResponse = ResponseType(with: value)
                DispatchQueue.main.async { handlers?.successHandler?(requestResponse) }
                return
            }
            process(networkError, from: request, with: handlers)
        case .failure(let error):
            let networkError = (error: error, code: data.response?.statusCode)
            process(networkError, from: request, with: handlers)
        }
    }
    
    private func process<RequestType: APIRequesting, ResponseType: APIResponsing>(_ error: NetworkError, from request: RequestType,
                                                                                  with handlers: NetworkHandlers<ResponseType>?) {
        guard let reAuthorizer = reAuthorizer, reAuthorizer.shouldReAuthAndRepeat(after: error) else {
            DispatchQueue.main.async { handlers?.errorHandler?(error) }
            return }
        pauseAllRequests(true)
//        reAuthorizer.reAuthAndRepeat(request) { [weak self] (reAuthorizedRequest) in
//            guard let `self` = self else { return }
//            self.pauseAllRequests(false)
//            guard let reAuthorizedRequest = reAuthorizedRequest else {
//                DispatchQueue.main.async { handlers?.errorHandler?(error) }
//                return }
//            self.execute(reAuthorizedRequest, with: handlers)
//        }
    }
    
}
