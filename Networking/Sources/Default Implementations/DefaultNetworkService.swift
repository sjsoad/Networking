//
//  DefaultNetworkService.swift
//  Networking
//
//  Created by Sergey on 22.05.2018.
//  Copyright © 2018 Sergey Kostyan. All rights reserved.
//

import Alamofire

open class DefaultNetworkService: NetworkService {

    private let sessionManager: SessionManager
    private let errorParser: ErrorParsable
    
    // MARK: - Public -
    
    public required init(with sessionManager: SessionManager = SessionManager(), errorParser: ErrorParsable) {
        self.sessionManager = sessionManager
        self.errorParser = errorParser
    }
    
    public func execute<RequestType, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?)
        where RequestType: APIRequesting, ResponseType: APIResponsing {
            sessionManager.buildRequest(from: request, with: { result in
                handlers?.executingHandler?(result.hasValue)
                let responseHandler: (Result<ResponseType.InputValueType>) -> Void = { [weak self] (result) in
                    self.map({ $0.parse(result, with: nil, from: request, with: handlers) })
                }
                result.alamofireRequest?.response(queue: nil, responseSerializer: <#T##DataResponseSerializerProtocol#>, completionHandler: <#T##(DataResponse<DataResponseSerializerProtocol.SerializedObject>) -> Void#>)
            })
    }
    
    // MARK: - RequestManaging -
    
    public func pauseAllRequests(_ pause: Bool) {
        sessionManager.session.delegateQueue.isSuspended = pause
    }
    
    public func cancelAllRequests() {
        sessionManager.session.invalidateAndCancel()
    }
    
    // MARK: - Private -
    
    private func parse<RequestType, ResponseType>(_ result: Result<ResponseType.InputValueType>, with response: HTTPURLResponse?,
                                                  from request: RequestType, with handlers: NetworkHandlers<ResponseType>?)
        where RequestType : APIRequesting, ResponseType : APIResponsing {
        handlers?.executingHandler?(false)
        switch result {
        case .success(let value):
            errorParser.parseError(from: value).map({ handlers?.errorHandler?($0) }) ??
                ResponseType(with: value).result.map({ handlers?.successHandler?($0) })
        case .failure(let error):
            handlers?.errorHandler?(error)
        }
    }
    
}
