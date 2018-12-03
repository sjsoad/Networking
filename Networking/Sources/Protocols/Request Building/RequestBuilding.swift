//
//  RequestBuilding.swift
//  SKNetworkingLib
//
//  Created by Sergey Kostyan on 11/25/18.
//

import Alamofire

public protocol RequestBuilding {
    
    associatedtype RequestType: APIRequesting
    
    func build(with sessionManager: SessionManager, from requestInfo: RequestType, handler: RequestHandler<RequestType.RequestType>)
    
}

// MARK: - APIDataRequesting -

public extension RequestBuilding where RequestType: APIDataRequesting {
    
    func build(with sessionManager: SessionManager, from requestInfo: RequestType, handler: RequestHandler<RequestType.RequestType>) {
        switch requestInfo.requestType {
        case .simple(let parameters):
            let dataRequest = request(requestInfo.urlString, method: requestInfo.HTTPMethod, parameters: parameters, encoding: JSONEncoding.default,
                                      headers: requestInfo.headers)
            handler(.success(dataRequest))
        }
    }
    
}

// MARK: - APIUploadRequesting -

public extension RequestBuilding where RequestType: APIUploadRequesting {
    
    func build(with sessionManager: SessionManager, from requestInfo: RequestType, handler: @escaping RequestHandler<RequestType.RequestType>) {
        switch requestInfo.requestType {
        case .uploadData(let data):
            let uploadRequest = upload(data, to: requestInfo.urlString, method: requestInfo.HTTPMethod, headers: requestInfo.headers)
            handler(.success(uploadRequest))
        case .uploadURL(let url):
            let uploadRequest = upload(url, to: requestInfo.urlString, method: requestInfo.HTTPMethod, headers: requestInfo.headers)
            handler(.success(uploadRequest))
        case .uploadStream(let stream):
            let uploadRequest = upload(stream, to: requestInfo.urlString, method: requestInfo.HTTPMethod, headers: requestInfo.headers)
            handler(.success(uploadRequest))
        case .uploadMultipart(let parameters, let multipartParameters):
            multipartRequest(from: requestInfo, with: parameters, multipartParameters, handler)
        }
    }
    
    // MARK: - Private -
    
    private func multipartRequest(from requestInfo: RequestType, with parameters: [String: Any]?, _ multipartParameters: MultipartDataParameters,
                                  _ handler: @escaping RequestHandler<RequestType.RequestType>) {
        upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(with: parameters)
            multipartFormData.append(with: multipartParameters)
        }, to: requestInfo.urlString, method: requestInfo.HTTPMethod, headers: requestInfo.headers, encodingCompletion: { (result) in
            switch result {
            case .success(let uploadRequest, _, _):
                handler(.success(uploadRequest))
            case .failure(let error):
                handler(.failure(error))
            }
        })
    }
    
}

// MARK: - APIDownloadRequesting -

public extension RequestBuilding where RequestType: APIDownloadRequesting {
    
    func build(with sessionManager: SessionManager, from requestInfo: RequestType, handler: RequestHandler<RequestType.RequestType>) {
        switch requestInfo.requestType {
        case .downloadResuming(let data, let destination):
            let downloadRequest = download(resumingWith: data, to: destination)
            handler(.success(downloadRequest))
        case .downloadTo(let parameters, let destination):
            let downloadRequest = download(requestInfo.urlString, method: requestInfo.HTTPMethod, parameters: parameters,
                                           headers: requestInfo.headers, to: destination)
            handler(.success(downloadRequest))
        }
    }
    
}
