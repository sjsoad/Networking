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
//        switch request.requestType {
//        case .simple, .uploadData, .uploadURL, .uploadStream:
//            dataRequest(from: request, requestHandler, with: completion)
//        case .uploadMultipart: break
//        case .downloadResuming(let data, let destination):
//            let request = sessionManager.download(resumingWith: data, to: destination)
//            requestHandler?(request, nil)
//        case .downloadTo(let parameters, let destination):
//            let request = sessionManager.download(request.urlString, method: request.HTTPMethod, parameters: parameters, headers: request.headers,
//                                                  to: destination)
//            requestHandler?(request, nil)
//        }
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
    
    private func dataRequest<RequestType: APIRequesting>(from request: RequestType, _ requestHandler: RequestHandler?,
                                                         with completion: @escaping DataResponseHandler) {
        var dataRequest: DataRequest? = nil
        switch request.requestType {
        case .simple(let parameters):
            dataRequest = sessionManager.request(request.urlString, method: request.HTTPMethod, parameters: parameters, headers: request.headers)
        case .uploadData(let data):
            dataRequest = sessionManager.upload(data, to: request.urlString, method: request.HTTPMethod, headers: request.headers)
        case .uploadURL(let url):
            dataRequest = sessionManager.upload(url, to: request.urlString, method: request.HTTPMethod, headers: request.headers)
        case .uploadStream(let stream):
            dataRequest = sessionManager.upload(stream, to: request.urlString, method: request.HTTPMethod, headers: request.headers)
        default:
            print("\(request.requestType) is ignored. Not data request")
        }
        dataRequest?.responseJSON(completionHandler: completion)
        requestHandler?(dataRequest, nil)
    }
    
    private func downloadRequest<RequestType: APIRequesting>(from request: RequestType, _ requestHandler: RequestHandler?,
                                                             with completion: @escaping DownloadResponseHandler) {
        var downloadRequest: DownloadRequest? = nil
        switch request.requestType {
        case .downloadResuming(let data, let destination):
            downloadRequest = sessionManager.download(resumingWith: data, to: destination)
        case .downloadTo(let parameters, let destination):
            downloadRequest = sessionManager.download(request.urlString, method: request.HTTPMethod, parameters: parameters, headers: request.headers,
                                                  to: destination)
        default:
            print("\(request.requestType) is ignored. Not download request")
        }
        downloadRequest?.responseJSON(completionHandler: completion)
        requestHandler?(downloadRequest, nil)
    }
    
//    private func append<RequestType: APIRequesting>(_ multipartFormData: MultipartFormData, from request: RequestType) {
//        request.parameters?.forEach({ (key, value) in
//            guard let data = "\(value)".data else { return }
//            multipartFormData.append(data, withName: key)
//        })
//        guard let multipartData = request.multipartData, let multipartKey = request.multipartKey, let fileName = request.fileName,
//            let mimeType = request.mimeType else { return }
//        multipartFormData.append(multipartData, withName: multipartKey, fileName: fileName, mimeType: mimeType)
//    }
    
}
