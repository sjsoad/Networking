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
            privateExecuteJSON(request, with: handlers, nil)
    }
    
    public func executeJSON<RequestType, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?,
                                                       _ requestHandler: @escaping DataRequestHandler)
        where RequestType : APIDataRequesting, ResponseType : APIResponsing {
        privateExecuteJSON(request, with: handlers, requestHandler)
    }
    
    public func executeJSON<RequestType, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?)
        where RequestType : APIUploadRequesting, ResponseType : APIResponsing {
            privateExecuteJSON(request, with: handlers, nil)
    }
    
    public func executeJSON<RequestType, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?,
                                                       _ requestHandler: @escaping UploadRequestHandler)
        where RequestType : APIUploadRequesting, ResponseType : APIResponsing {
        privateExecuteJSON(request, with: handlers, requestHandler)
    }
    
    public func executeJSON<RequestType, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?)
        where RequestType : APIDownloadRequesting, ResponseType : APIResponsing {
            privateExecuteJSON(request, with: handlers, nil)
    }
    
    public func executeJSON<RequestType, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?,
                                                       _ requestHandler: @escaping DownloadRequestHandler)
        where RequestType : APIDownloadRequesting, ResponseType : APIResponsing {
            privateExecuteJSON(request, with: handlers, requestHandler)
    }
    
    // MARK: - Data -
    
    public func executeData<RequestType, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?)
        where RequestType : APIDataRequesting, ResponseType : APIResponsing {
        privateExecuteData(request, with: handlers, nil)
    }
    
    public func executeData<RequestType, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?,
                                                       _ requestHandler: @escaping DataRequestHandler)
        where RequestType : APIDataRequesting, ResponseType : APIResponsing {
        privateExecuteData(request, with: handlers, requestHandler)
    }
    
    public func executeData<RequestType, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?)
        where RequestType : APIUploadRequesting, ResponseType : APIResponsing {
        privateExecuteData(request, with: handlers, nil)
    }
    
    public func executeData<RequestType, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?,
                                                       _ requestHandler: @escaping UploadRequestHandler)
        where RequestType : APIUploadRequesting, ResponseType : APIResponsing {
        privateExecuteData(request, with: handlers, requestHandler)
    }
    
    public func executeData<RequestType, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?)
        where RequestType : APIDownloadRequesting, ResponseType : APIResponsing {
        privateExecuteData(request, with: handlers, nil)
    }
    
    public func executeData<RequestType, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?,
                                                       _ requestHandler: @escaping DownloadRequestHandler)
        where RequestType : APIDownloadRequesting, ResponseType : APIResponsing {
        privateExecuteData(request, with: handlers, requestHandler)
    }
    
    
    // MARK: - RequestManaging -
    
    public func pauseAllRequests(_ pause: Bool) {
        sessionManager.session.delegateQueue.isSuspended = pause
    }
    
    public func cancelAllRequests() {
        sessionManager.session.invalidateAndCancel()
    }
    
    // MARK: - Private -
    
    // JSON
    
    private func privateExecuteJSON<RequestType, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?,
                                                               _ requestHandler: DataRequestHandler?)
        where RequestType : APIDataRequesting, ResponseType : APIResponsing {
            sessionManager.build(from: request, with: { result in
                handlers?.executingHandler?(result.isSuccess)
                requestHandler?(result)
                guard case .success(let task) = result else { return }
                task.responseJSON(completionHandler: { [weak self] response in
                    self.map({ $0.parseJSON(response.result, with: handlers) })
                })
            })
    }
    
    private func privateExecuteJSON<RequestType, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?,
                                                               _ requestHandler: UploadRequestHandler?)
        where RequestType : APIUploadRequesting, ResponseType : APIResponsing {
            sessionManager.build(from: request, with: { result in
                handlers?.executingHandler?(result.isSuccess)
                requestHandler?(result)
                guard case .success(let task) = result else { return }
                task.responseJSON(completionHandler: { [weak self] response in
                    self.map({ $0.parseJSON(response.result, with: handlers) })
                })
            })
    }
    
    private func privateExecuteJSON<RequestType, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?,
                                                               _ requestHandler: DownloadRequestHandler?)
        where RequestType : APIDownloadRequesting, ResponseType : APIResponsing {
            sessionManager.build(from: request, with: { result in
                handlers?.executingHandler?(result.isSuccess)
                requestHandler?(result)
                guard case .success(let task) = result else { return }
                task.responseJSON(completionHandler: { [weak self] response in
                    self.map({ $0.parseJSON(response.result, with: handlers) })
                })
            })
    }
    
    // Data
    
    private func privateExecuteData<RequestType, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?,
                                                               _ requestHandler: DataRequestHandler?)
        where RequestType : APIDataRequesting, ResponseType : APIResponsing {
            sessionManager.build(from: request, with: { result in
                handlers?.executingHandler?(result.isSuccess)
                requestHandler?(result)
                guard case .success(let task) = result else { return }
                task.responseData(completionHandler: { [weak self] response in
                    self.map({ $0.parseData(response.result, with: handlers) })
                })
            })
    }
    
    private func privateExecuteData<RequestType, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?,
                                                               _ requestHandler: UploadRequestHandler?)
        where RequestType : APIUploadRequesting, ResponseType : APIResponsing {
            sessionManager.build(from: request, with: { result in
                handlers?.executingHandler?(result.isSuccess)
                requestHandler?(result)
                guard case .success(let task) = result else { return }
                task.responseData(completionHandler: { [weak self] response in
                    self.map({ $0.parseData(response.result, with: handlers) })
                })
            })
    }
    
    private func privateExecuteData<RequestType, ResponseType>(_ request: RequestType, with handlers: NetworkHandlers<ResponseType>?,
                                                               _ requestHandler: DownloadRequestHandler?)
        where RequestType : APIDownloadRequesting, ResponseType : APIResponsing {
            sessionManager.build(from: request, with: { result in
                handlers?.executingHandler?(result.isSuccess)
                requestHandler?(result)
                guard case .success(let task) = result else { return }
                task.responseData(completionHandler: { [weak self] response in
                    self.map({ $0.parseData(response.result, with: handlers) })
                })
            })
    }
    
    // Parsing
    
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
