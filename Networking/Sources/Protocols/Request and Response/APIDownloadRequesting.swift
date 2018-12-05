//
//  APIDownloadRequesting.swift
//  SKNetworkingLib
//
//  Created by Sergey Kostyan on 12/4/18.
//

import Foundation
import Alamofire

public protocol APIDownloadRequesting: APIRequesting where RequestType == DownloadRequest {
    var requestType: DownloadRequestType { get }
}

public extension APIDownloadRequesting {
    
    public func build(with sessionManager: SessionManager, handler: @escaping RequestHandler<RequestType>) {
        switch requestType {
        case .downloadResuming(let data, let destination):
            let downloadRequest = sessionManager.download(resumingWith: data, to: destination)
            handler(.success(downloadRequest))
        case .downloadTo(let parameters, let destination):
            let downloadRequest = sessionManager.download(urlString, method: HTTPMethod, parameters: parameters,
                                                          headers: headers, to: destination)
            handler(.success(downloadRequest))
        }
    }
    
    public func execute<ResponseType>(with executor: TaskExecuting, _ task: RequestType, handler: @escaping ResultHandler<ResponseType>) {
        executor.execute(task, with: handler)
    }
    
}

