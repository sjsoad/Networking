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
    
    // MARK: - JSON -
    
    public func executeJSON<RequestType, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?)
        where RequestType : APIDataRequesting, ResponseType : APIResponsing {
            sessionManager.build(from: request, with: { result in
                handlers?.executingHandler?(result.isSuccess)
                guard case .success(let task) = result else { return }
                task.responseJSON(completionHandler: { [weak self] response in
                    self.map({ $0.parse(response.result, with: handlers) })
                })
            })
    }
    
    public func executeJSON<RequestType, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?)
        where RequestType : APIUploadRequesting, ResponseType : APIResponsing {
            sessionManager.build(from: request, with: { result in
                handlers?.executingHandler?(result.isSuccess)
                guard case .success(let task) = result else { return }
                task.responseJSON(completionHandler: { [weak self] response in
                    self.map({ $0.parse(response.result, with: handlers) })
                })
            })
    }
    
    public func executeJSON<RequestType, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?)
        where RequestType : APIDownloadRequesting, ResponseType : APIResponsing {
            sessionManager.build(from: request, with: { result in
                handlers?.executingHandler?(result.isSuccess)
                guard case .success(let task) = result else { return }
                task.responseJSON(completionHandler: { [weak self] response in
                    self.map({ $0.parse(response.result, with: handlers) })
                })
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
    
    private func parse<ResponseType>(_ result: Result<Any>, with handlers: NetworkHandlers<ResponseType>?)
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
    
}
