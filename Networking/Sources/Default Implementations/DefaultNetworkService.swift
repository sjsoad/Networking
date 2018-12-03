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
            privateBuild(request, with: handlers, nil)
    }
    
    public func execute<RequestType, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?,
                                                   _ requestHandler: @escaping RequestHandler<RequestType.RequestType>)
        where RequestType : APIRequesting, ResponseType : APIResponsing {
            privateBuild(request, with: handlers, requestHandler)
    }
    
    // MARK: - RequestManaging -
    
    public func pauseAllRequests(_ pause: Bool) {
        sessionManager.session.delegateQueue.isSuspended = pause
    }
    
    public func cancelAllRequests() {
        sessionManager.session.invalidateAndCancel()
    }
    
    // MARK: - Private -

    private func privateBuild<RequestType, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?,
                                                           _ requestHandler: RequestHandler<RequestType.RequestType>?)
        where RequestType : APIRequesting, ResponseType : APIResponsing {
            DefaultRequestBuilder<RequestType>().build(with: sessionManager, from: request, handler: { [weak self] result in
                handlers?.executingHandler?(result.isSuccess)
                requestHandler?(result)
                guard case .success(let task) = result else { return }
                self?.privateExecute(task, request, with: handlers)
            })
    }
    
    private func privateExecute<RequestType, ResponseType>(_ task: RequestType.RequestType, _ request: RequestType,
                                                           with handlers: NetworkHandlers<ResponseType>?)
        where RequestType : APIRequesting, ResponseType : APIResponsing {
            DefaultTaskExecuter<RequestType.RequestType, ResponseType.ResponseType>().execute(task, for: request, completion: { [weak self] result in
                handlers?.executingHandler?(false)
                switch result {
                case .success(let value):
                    break
                case .failure(let error):
                    handlers?.errorHandler?(error)
                }
            })
    }
    
}

