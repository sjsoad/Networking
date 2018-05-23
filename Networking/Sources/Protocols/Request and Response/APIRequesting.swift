//
//  APIRequestProtocol.swift
//  MyWeather
//
//  Created by Mac on 05.12.16.
//  Copyright © 2016 Sergey Kostyan. All rights reserved.
//

import Foundation

public protocol APIRequesting {
    
    associatedtype ResponseType: APIResponsing
    
    var HTTPMethod: Method { get set }
    var parameters: [String: Any]? { get set }
    var headers: [String: String]? { get set }
    var urlString: String { get set }
    
//    var multipartData: Data? { get set }
//    var multipartKey: String? { get set }
//    var mimeType: String? { get set }
//    var fileName: String? { get set }
    
}

public extension APIRequesting {
    
    var HTTPMethod: Method { return .get }
    
}
