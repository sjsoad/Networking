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
    
    public func build(with sessionManager: SessionManager, handler: @escaping RequestHandler<RequestType>) {
        switch requestType {
        case .uploadData(let data):
            let uploadRequest = sessionManager.upload(data, to: urlString, method: HTTPMethod, headers: headers)
            handler(.success(uploadRequest))
        case .uploadURL(let url):
            let uploadRequest = sessionManager.upload(url, to: urlString, method: HTTPMethod, headers: headers)
            handler(.success(uploadRequest))
        case .uploadStream(let stream):
            let uploadRequest = sessionManager.upload(stream, to: urlString, method: HTTPMethod, headers: headers)
            handler(.success(uploadRequest))
        case .uploadMultipart(let parameters, let multipartParameters):
            multipartRequest(with: sessionManager, parameters, multipartParameters, handler)
        case .none:
            break
        }
    }
    
    public func execute<ResponseType>(_ task: RequestType, with response: ResponseType.Type,
                                      and completion: (Result<ResponseType.ResponseType>) -> Void)
        where ResponseType : APIResponsing {
//            task.responseJSON(completionHandler: { response in completion(response.result) })
//            task.responseData(completionHandler: { response in completion(response.result) })
    }
    
    // MARK: - Private -
    
    private func multipartRequest(with sessionManager: SessionManager, _ parameters: [String: Any]?,
                                  _ multipartParameters: MultipartDataParameters, _ handler: @escaping RequestHandler<RequestType>) {
        sessionManager.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(with: parameters)
            multipartFormData.append(with: multipartParameters)
        }, to: urlString, method: HTTPMethod, headers: headers, encodingCompletion: { (result) in
            switch result {
            case .success(let uploadRequest, _, _):
                handler(.success(uploadRequest))
            case .failure(let error):
                handler(.failure(error))
            }
        })
    }
    
}


