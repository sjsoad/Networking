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
    
    public func build(with sessionManager: SessionManager, handler: @escaping RequestHandler<RequestType>) {
        switch requestType {
        case .simple(let parameters):
            let dataRequest = sessionManager.request(urlString, method: HTTPMethod, parameters: parameters, encoding: JSONEncoding.default,
                                                     headers: headers)
            handler(.success(dataRequest))
        }
    }

    public func execute<ResponseType>(with executor: TaskExecuting, _ task: RequestType, handler: @escaping ResultHandler<ResponseType>) {
        executor.execute(task, with: { (result: Result<Data>) in
            print("")
        })
    }
    
}
