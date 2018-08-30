//
//  DefaultRequestExecutor.swift
//  Networking
//
//  Created by Sergey on 22.05.2018.
//  Copyright © 2018 Sergey Kostyan. All rights reserved.
//

import Alamofire

open class DefaultRequestExecutor: RequestExecutor {

    private let sessionManager: SessionManager
    
    // MARK: - Public -
    
    public required init(sessionManager: SessionManager = SessionManager.default) {
        self.sessionManager = sessionManager
    }
    
    public func execute<RequestType: APIRequesting>(_ request: RequestType, requestHandler: RequestHandler?,
                                                  completion: @escaping (DataResponse<Any>) -> ()) {
        build(from: request, requestHandler: { (alamofireRequest, error) in
            requestHandler?(alamofireRequest, error)
            alamofireRequest?.responseJSON(completionHandler: completion)
        })
//        sessionManager.download(<#T##url: URLConvertible##URLConvertible#>, method: <#T##HTTPMethod#>, parameters: <#T##Parameters?#>, encoding: <#T##ParameterEncoding#>, headers: <#T##HTTPHeaders?#>, to: <#T##DownloadRequest.DownloadFileDestination?##DownloadRequest.DownloadFileDestination?##(URL, HTTPURLResponse) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions)#>)
//        sessionManager.download(resumingWith: <#T##Data#>, to: <#T##DownloadRequest.DownloadFileDestination?##DownloadRequest.DownloadFileDestination?##(URL, HTTPURLResponse) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions)#>)
//        sessionManager.upload(<#T##data: Data##Data#>, to: <#T##URLConvertible#>, method: <#T##HTTPMethod#>, headers: <#T##HTTPHeaders?#>)
//        sessionManager.upload(<#T##fileURL: URL##URL#>, to: <#T##URLConvertible#>, method: <#T##HTTPMethod#>, headers: <#T##HTTPHeaders?#>)
//        sessionManager.upload(<#T##stream: InputStream##InputStream#>, to: <#T##URLConvertible#>, method: <#T##HTTPMethod#>, headers: <#T##HTTPHeaders?#>)
//        sessionManager.upload(multipartFormData: <#T##(MultipartFormData) -> Void#>, to: <#T##URLConvertible#>, encodingCompletion: <#T##((SessionManager.MultipartFormDataEncodingResult) -> Void)?##((SessionManager.MultipartFormDataEncodingResult) -> Void)?##(SessionManager.MultipartFormDataEncodingResult) -> Void#>)
//        sessionManager.request(<#T##url: URLConvertible##URLConvertible#>, method: <#T##HTTPMethod#>, parameters: <#T##Parameters?#>, encoding: <#T##ParameterEncoding#>, headers: <#T##HTTPHeaders?#>)
    }
    
    // MARK: - RequestManaging -
    
    public func pauseAllRequests(_ pause: Bool) {
        sessionManager.session.delegateQueue.isSuspended = pause
    }
    
    public func cancelAllRequests() {
        sessionManager.session.invalidateAndCancel()
    }
    
    public func cancel(_ request: RequestClass) {
        request.cancel()
    }
    
    // MARK: - Private -
    
    private func build<RequestType: APIRequesting>(from request: RequestType, requestHandler: ((UploadRequest?, Error?) -> Void)?) {
        sessionManager.upload(multipartFormData: { [weak self] (multipartFormData) in
            self?.append(multipartFormData, from: request)
        }, to: request.urlString, method: request.HTTPMethod, headers: request.headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                requestHandler?(upload, nil)
            case .failure(let error):
                requestHandler?(nil, error)
            }
        }
    }
    
    private func append<RequestType: APIRequesting>(_ multipartFormData: MultipartFormData, from request: RequestType) {
        request.parameters?.forEach({ (key, value) in
            guard let data = "\(value)".data else { return }
            multipartFormData.append(data, withName: key)
        })
        guard let multipartData = request.multipartData, let multipartKey = request.multipartKey, let fileName = request.fileName,
            let mimeType = request.mimeType else { return }
        multipartFormData.append(multipartData, withName: multipartKey, fileName: fileName, mimeType: mimeType)
    }
    
}
