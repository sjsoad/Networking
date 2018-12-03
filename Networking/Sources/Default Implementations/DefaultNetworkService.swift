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
        where RequestType : APIRequesting, ResponseType : APIResponsing {
            privateExecute(request, with: handlers, nil)
    }
    
    public func execute<RequestType, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?,
                                                   _ requestHandler: @escaping RequestHandler<RequestType.RequestType>)
        where RequestType : APIRequesting, ResponseType : APIResponsing {
            privateExecute(request, with: handlers, requestHandler)
    }
    
    // MARK: - RequestManaging -
    
    public func pauseAllRequests(_ pause: Bool) {
        sessionManager.session.delegateQueue.isSuspended = pause
    }
    
    public func cancelAllRequests() {
        sessionManager.session.invalidateAndCancel()
    }
    
    // MARK: - Private -

    private func privateExecute<RequestType, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?,
                                                           _ requestHandler: RequestHandler<RequestType.RequestType>?)
        where RequestType : APIRequesting, ResponseType : APIResponsing {
            DefaultRequestBuilder<RequestType>().build(with: sessionManager, from: request, handler: { result in
                handlers?.executingHandler?(result.isSuccess)
                requestHandler?(result)
                guard case .success(let task) = result else { return }
                DefaultTaskExecuter<RequestType.RequestType>().execute(task, for: request)
            })
    }
    
    private func parseJSON<ResponseType>(_ result: Result<Any>, with handlers: NetworkHandlers<ResponseType>?)
        where ResponseType : APIResponsing {
            handlers?.executingHandler?(false)
            switch result {
            case .success(let value):
                errorParser.parseError(from: value).map({ handlers?.errorHandler?($0) }) ??
                    ResponseType(with: value as? ResponseType.InputValueType).result.map({ handlers?.successHandler?($0) })
            case .failure(let error):
                handlers?.errorHandler?(error)
            }
    }

    private func parseData<ResponseType>(_ result: Result<Data>, with handlers: NetworkHandlers<ResponseType>?)
        where ResponseType : APIResponsing {
            handlers?.executingHandler?(false)
            switch result {
            case .success(let value):
                ResponseType(with: value as? ResponseType.InputValueType).result.map({ handlers?.successHandler?($0) })
            case .failure(let error):
                handlers?.errorHandler?(error)
            }
    }
    
}

