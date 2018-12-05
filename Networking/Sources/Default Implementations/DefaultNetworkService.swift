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
        where RequestType: APIRequesting, ResponseType : APIResponsing {
            privateBuild(request, with: handlers, nil, { [weak self] (task: RequestType.RequestType) in
                self?.privateExecute(task, with: handlers, { (result: ResponseType.ResponseType) in
                    print("executed")
                })
//                self.map({ $0.privateExecute(task, request, with: handlers, { [weak self] result in
//                    self.map({ $0.privateParse(result, with: handlers) })
//                }) })
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
            request.build(with: sessionManager, handler: { result in
                handlers?.executingHandler?(result.isSuccess)
                requestHandler?(result)
                guard case .success(let task) = result else { return }
                completion(task)
            })
    }
    
    // 2
    
    private func privateExecute<RequestType, ResponseType>(_ task: RequestType,  with handlers: NetworkHandlers<ResponseType>?,
                                                           _ completion: @escaping (ResponseType.ResponseType) -> Void)
        where RequestType : Request, ResponseType : APIResponsing {
            taskExecutor.execute(task, with: { (result: Result<Any>) in
                handlers?.executingHandler?(false)
                switch result {
                case .success(let value):
                    break
//                    completion(value)
                case .failure(let error):
                    handlers?.errorHandler?(error)
                }
            })
//            request.execute(with: taskExecutor, task, handler: { (result: Result<ResponseType.ResponseType>) in
//                handlers?.executingHandler?(false)
//                switch result {
//                case .success(let value):
//                    completion(value)
//                case .failure(let error):
//                    handlers?.errorHandler?(error)
//                }
//            })
    }
    
    // 3
    
    private func privateParse<ResponseType>(_ value: ResponseType.ResponseType, with handlers: NetworkHandlers<ResponseType>?)
        where ResponseType : APIResponsing {
            DefaultResponseParser().parse(value, with: errorParser, and: handlers)
    }
    
}
