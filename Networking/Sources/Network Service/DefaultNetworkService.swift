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
    
    public required init(requestExecutor: RequestExecutor = DefaultRequestExecutor(), reAuthorizer: ReAuthorizable? = nil,
                         errorParser: ErrorParsable) {
        self.requestExecutor = requestExecutor
        self.reAuthorizer = reAuthorizer
        self.errorParser = errorParser
    }
    
    public func execute<RequestType: APIRequesting, ResponseType: APIResponsing>(_ request: RequestType,
                                                                                 with handlers: NetworkHandlers<ResponseType>?) {
            let requestHandler: RequestHandler = { result in
                handlers?.executingHandler?(result.isSuccess)
                handlers?.requestHandler?(result)
            }
            switch request.requestType {
            case .simple, .uploadData, .uploadURL, .uploadStream, .uploadMultipart:
                requestExecutor.dataRequest(from: request, requestHandler) { [weak self] (data) in
                    self.map({ $0.parse(data.result, response: data.response, from: request, with: handlers) })
                }
            case .downloadResuming, .downloadTo:
                requestExecutor.downloadRequest(from: request, requestHandler) { [weak self] (downloadData) in
                    self.map({ $0.parse(downloadData.result, response: downloadData.response, from: request, with: handlers) })
                }
            }
    }
    
    // MARK: - RequestManaging -
    
    public func pauseAllRequests(_ pause: Bool) {
        requestExecutor.pauseAllRequests(pause)
    }
    
    public func cancelAllRequests() {
        requestExecutor.cancelAllRequests()
    }
   
    public func cancel<RequestClass>(_ request: RequestClass) where RequestClass : UsedRequestClass {
        requestExecutor.cancel(request)
    }
    
    // MARK: - Private -
    
    private func parse<RequestType: APIRequesting, ResponseType: APIResponsing, ResultType>(_ result: Result<ResultType>,
                                                                                            response: HTTPURLResponse?,
                                                                                            from request: RequestType,
                                                                                            with handlers: NetworkHandlers<ResponseType>?) {
        handlers?.executingHandler?(false)
        switch result {
        case .success(let value):
            if let error = errorParser.parseError(from: value) {
                process(error, response?.statusCode, from: request, with: handlers)
            } else {
                let requestResponse = ResponseType(with: value as? ResponseType.InputValueType)
                requestResponse.result.map({ handlers?.successHandler?($0) })                
            }
        case .failure(let error):
            process(error, response?.statusCode, from: request, with: handlers)
        }
    }
    
    private func process<RequestType: APIRequesting, ResponseType: APIResponsing>(_ error: Error, _ code: Int?, from request: RequestType,
                                                                                  with handlers: NetworkHandlers<ResponseType>?) {
        if let code = code, let reAuthorizer = reAuthorizer, reAuthorizer.shouldReAuthAndRepeat(after: code) {
            pauseAllRequests(true)
            reAuthorizer.reAuthAndRepeat(request, completion: { [weak self] (reAuthorizedRequest) in
                guard let `self` = self else { return }
                self.pauseAllRequests(false)
                self.execute(reAuthorizedRequest, with: handlers)
            })
        } else {
            handlers?.errorHandler?(error)
        }
    }
    
}
