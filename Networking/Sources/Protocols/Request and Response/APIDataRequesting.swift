//
//  APIDataRequesting.swift
//  SKNetworkingLib
//
//  Created by Sergey Kostyan on 12/4/18.
//

import Foundation
import Alamofire

public protocol APIDataRequesting: APIRequesting where RequestType == DataRequest {
    var requestType: DataRequestType { get }
}

public extension APIDataRequesting {
    
    public func build(with sessionManager: SessionManager, completion: @escaping RequestHandler<RequestType>) {
        switch requestType {
        case .simple(let parameters):
            let dataRequest = sessionManager.request(urlString, method: HTTPMethod, parameters: parameters, encoding: parameterEncoding,
                                                     headers: headers)
            completion(.success(dataRequest))
        }
    }
    
}

public extension APIDataRequesting where ResponseType == Any {
    
    public func execute(_ task: RequestType, completion: @escaping ResultHandler<ResponseType>) {
        task.responseJSON(completionHandler: { completion($0.result) })
    }
    
}

public extension APIDataRequesting where ResponseType == Data {
    
    public func execute(_ task: RequestType, completion: @escaping ResultHandler<ResponseType>) {
        task.responseData(completionHandler: { completion($0.result) })
    }
    
}
