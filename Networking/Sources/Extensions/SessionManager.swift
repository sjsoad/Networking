//
//  SessionManager.swift
//  SKNetworkingLib
//
//  Created by Sergey Kostyan on 11/25/18.
//

import Alamofire

extension SessionManager {
    
    func build(from requestInfo: APIDataRequesting, with handler: DataRequestHandler) {
        switch requestInfo.requestType {
        case .simple(let parameters):
            let dataRequest = request(requestInfo.urlString, method: requestInfo.HTTPMethod, parameters: parameters, encoding: JSONEncoding.default,
                                      headers: requestInfo.headers)
            handler(.success(dataRequest))
        }
    }
    
    func build(from requestInfo: APIUploadRequesting, with handler: @escaping UploadRequestHandler) {
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
            upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(with: parameters)
                multipartFormData.appen(with: multipartParameters)
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
    
    func build(from requestInfo: APIDownloadRequesting, with handler: DownloadRequestHandler) {
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
