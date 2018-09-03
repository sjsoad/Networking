//
//  APIRequestProtocol.swift
//  MyWeather
//
//  Created by Mac on 05.12.16.
//  Copyright © 2016 Sergey Kostyan. All rights reserved.
//

import Foundation

public protocol APIRequesting {
    
    var requestType: RequestType { get }
    var HTTPMethod: Method { get }
    var headers: [String: String]? { get }
    var urlString: String { get }

}

public extension APIRequesting {
    
    var HTTPMethod: Method { return .get }
    var headers: [String: String]? { return nil }
    
}
