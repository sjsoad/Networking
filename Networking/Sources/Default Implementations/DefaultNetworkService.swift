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
    private let taskExecutor: TaskExecuting
    
    // MARK: - Public -
    
    public required init(with sessionManager: SessionManager = SessionManager(), errorParser: ErrorParsable,
                         taskExecutor: TaskExecuting = DefaultTaskExecutor()) {
        self.sessionManager = sessionManager
        self.errorParser = errorParser
        self.taskExecutor = taskExecutor
    }
    
    public func execute<RequestType, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?)
        where RequestType: APIRequesting, ResponseType: APIResponsing, RequestType.ResponseType == ResponseType.ResponseType {
            privateBuild(request, with: handlers, nil, { [weak self] (task: RequestType.RequestType) in
                self.map({ $0.privateExecute(request, task, with: handlers, { [weak self] (response: RequestType.ResponseType) in
                    self.map({ $0.privateCheck(response, from: request, with: handlers) })
                }) })
            })
    }
    
    public func execute<RequestType, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?,
                                                   _ requestHandler: @escaping RequestHandler<RequestType.RequestType>)
        where RequestType : APIRequesting, ResponseType : APIResponsing {
            privateBuild(request, with: handlers, requestHandler, { task in
                
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

    // 1
    
    private func privateBuild<RequestType: APIRequesting, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?,
                                                                        _ requestHandler: RequestHandler<RequestType.RequestType>?,
                                                                        _ completion: @escaping (RequestType.RequestType) -> Void) {
        request.build(with: sessionManager, completion: { result in
            handlers?.executingHandler?(result.isSuccess)
            requestHandler?(result)
            guard case .success(let task) = result else { return }
            completion(task)
        })
    }
    
    // 2
    
    private func privateExecute<RequestType, ResponseType>(_ request: RequestType, _ task: RequestType.RequestType,
                                                           with handlers: NetworkHandlers<ResponseType>?,
                                                           _ completion: @escaping (RequestType.ResponseType) -> Void)
        where RequestType : APIRequesting, ResponseType : APIResponsing {
            request.execute(task, completion: { (result: Result<RequestType.ResponseType>) in
                handlers?.executingHandler?(false)
                switch result {
                case .success(let value):
                    completion(value)
                case .failure(let error):
                    handlers?.errorHandler?(error)
                }
            })
    }
    
    // 3
    
    private func privateCheck<RequestType, ResponseType>(_ response: ResponseType.ResponseType, from request: RequestType,
                                                         with handlers: NetworkHandlers<ResponseType>?)
        where RequestType : APIRequesting, ResponseType : APIResponsing, ResponseType.ResponseType == RequestType.ResponseType {
           request.check(response, with: errorParser, handlers: handlers)
    }
    
}
