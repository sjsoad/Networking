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
    
    var HTTPMethod: RequestMethod { get }
    var headers: [String: String]? { get }
    var urlString: String { get }

    func build(with sessionManager: SessionManager, handler: @escaping RequestHandler<RequestType>)
    func execute(with executor: TaskExecuting, _ task: RequestType)
}

public extension APIRequesting {
    
    var HTTPMethod: RequestMethod { return .get }
    var headers: [String: String]? { return nil }
    
}
