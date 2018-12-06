//
//  APIUploadRequesting.swift
//  SKNetworkingLib
//
//  Created by Sergey Kostyan on 12/4/18.
//

import Foundation
import Alamofire

public protocol APIUploadRequesting: APIRequesting where RequestType == UploadRequest {
    var requestType: UploadRequestType { get }
}

public extension APIUploadRequesting {
    
    public func build(with sessionManager: SessionManager, completion: @escaping RequestHandler<RequestType>) {
        switch requestType {
        case .uploadData(let data):
            let uploadRequest = sessionManager.upload(data, to: urlString, method: HTTPMethod, headers: headers)
            completion(.success(uploadRequest))
        case .uploadURL(let url):
            let uploadRequest = sessionManager.upload(url, to: urlString, method: HTTPMethod, headers: headers)
            completion(.success(uploadRequest))
        case .uploadStream(let stream):
            let uploadRequest = sessionManager.upload(stream, to: urlString, method: HTTPMethod, headers: headers)
            completion(.success(uploadRequest))
        case .uploadMultipart(let parameters, let multipartParameters):
            multipartRequest(with: sessionManager, parameters, multipartParameters, completion)
        }
    }
    
    // MARK: - Private -
    
    private func multipartRequest(with sessionManager: SessionManager, _ parameters: [String: Any]?,
                                  _ multipartParameters: MultipartDataParameters, _ completion: @escaping RequestHandler<RequestType>) {
        sessionManager.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(with: parameters)
            multipartFormData.append(with: multipartParameters)
        }, to: urlString, method: HTTPMethod, headers: headers, encodingCompletion: { (result) in
            switch result {
            case .success(let uploadRequest, _, _):
                completion(.success(uploadRequest))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
}

public extension APIUploadRequesting where ResponseType == Any {
    
    public func execute(_ task: RequestType, completion: @escaping ResultHandler<ResponseType>) {
        task.responseJSON(completionHandler: { completion($0.result) })
    }
    
}

public extension APIUploadRequesting where ResponseType == Data {
    
    public func execute(_ task: RequestType, completion: @escaping ResultHandler<ResponseType>) {
        task.responseData(completionHandler: { completion($0.result) })
    }
    
}
