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
    
    var parameterEncoding: ParameterEncoding { return URLEncoding.default }
    
    public func build(with sessionManager: SessionManager, completion: @escaping RequestHandler<RequestType>) {
        switch requestType {
        case .downloadResuming(let data, let destination):
            let downloadRequest = sessionManager.download(resumingWith: data, to: destination)
            completion(.success(downloadRequest))
        case .downloadTo(let parameters, let destination):
            let downloadRequest = sessionManager.download(urlString, method: HTTPMethod, parameters: parameters, encoding: parameterEncoding,
                                                          headers: headers, to: destination)
            completion(.success(downloadRequest))
        }
    }
    
}

public extension APIDownloadRequesting where ResponseType == Any {
    
    public func execute(_ task: RequestType, completion: @escaping ResultHandler<ResponseType>) {
        task.responseJSON(completionHandler: { completion($0.result) })
    }
    
}

public extension APIDownloadRequesting where ResponseType == Data {
    
    public func execute(_ task: RequestType, completion: @escaping ResultHandler<ResponseType>) {
        task.responseData(completionHandler: { completion($0.result) })
    }
    
}
