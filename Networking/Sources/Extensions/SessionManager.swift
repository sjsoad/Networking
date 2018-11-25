//
//  SessionManager.swift
//  SKNetworkingLib
//
//  Created by Sergey Kostyan on 11/25/18.
//

import Alamofire

extension SessionManager {
    
    func buildRequest<RequestType: APIRequesting>(from requestInfo: RequestType,
                                                  with requestHandler: @escaping (RequestResult) -> Void) {
        switch requestInfo.requestType {
        case .simple(let parameters):
            let dataRequest = request(requestInfo.urlString, method: requestInfo.HTTPMethod, parameters: parameters, encoding: JSONEncoding.default,
                                      headers: requestInfo.headers)
            requestHandler(.data(dataRequest))
        case .uploadData(let data):
            let dataRequest = upload(data, to: requestInfo.urlString, method: requestInfo.HTTPMethod, headers: requestInfo.headers)
            requestHandler(.upload(dataRequest))
        case .uploadURL(let url):
            let dataRequest = upload(url, to: requestInfo.urlString, method: requestInfo.HTTPMethod, headers: requestInfo.headers)
            requestHandler(.upload(dataRequest))
        case .uploadStream(let stream):
            let dataRequest = upload(stream, to: requestInfo.urlString, method: requestInfo.HTTPMethod, headers: requestInfo.headers)
            requestHandler(.upload(dataRequest))
        case .uploadMultipart(let parameters, let multipartParameters):
            upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(with: parameters)
                multipartFormData.appen(with: multipartParameters)
            }, to: requestInfo.urlString, method: requestInfo.HTTPMethod, headers: requestInfo.headers, encodingCompletion: { (result) in
                switch result {
                case .success(let request, _, _):
                    requestHandler(.upload(request))
                case .failure(let error):
                    requestHandler(.failure(error))
                }
            })
        case .downloadResuming(let data, let destination):
            let downloadRequest = download(resumingWith: data, to: destination)
            requestHandler(.download(downloadRequest))
        case .downloadTo(let parameters, let destination):
            let downloadRequest = download(requestInfo.urlString, method: requestInfo.HTTPMethod, parameters: parameters,
                                           headers: requestInfo.headers, to: destination)
            requestHandler(.download(downloadRequest))
        }
    }
    
}
