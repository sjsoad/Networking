//
//  APIRequestProtocol.swift
//  MyWeather
//
//  Created by Mac on 05.12.16.
//  Copyright © 2016 Sergey Kostyan. All rights reserved.
//

import Foundation
import Alamofire

public protocol APIRequesting {
    
    associatedtype RequestType: Request
    
    var parameterEncoding: ParameterEncoding { get }
    var HTTPMethod: RequestMethod { get }
    var headers: [String: String]? { get }
    var urlString: String { get }
    
    func build(with sessionManager: SessionManager, handler: @escaping RequestHandler<RequestType>)
    func execute<ResponseType>(with executor: TaskExecuting, _ task: RequestType, handler: @escaping ResultHandler<ResponseType>)
}

public extension APIRequesting {
    
    var parameterEncoding: ParameterEncoding { return JSONEncoding.default }
    var HTTPMethod: RequestMethod { return .get }
    var headers: [String: String]? { return nil }
    
}
