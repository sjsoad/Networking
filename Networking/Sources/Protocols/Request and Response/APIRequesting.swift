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
    
    var HTTPMethod: Method { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
    var urlString: String { get }
    
    var multipartData: Data? { get }
    var multipartKey: String? { get }
    var mimeType: String? { get }
    var fileName: String? { get }

}

public extension APIRequesting {
    
    var HTTPMethod: Method { return .get }
    
    var parameters: [String: Any]? { return nil }
    var headers: [String: String]? { return nil }
    
    var multipartData: Data? { return nil }
    var multipartKey: String? { return nil }
    var mimeType: String? { return nil }
    var fileName: String? { return nil }
    
}

public protocol AuthentificatedAPIRequesting: class, APIRequesting {
    
    var accessToken: String? { get set }
    
    func update(accessToken: String?)
    
}

public extension AuthentificatedAPIRequesting {
    
    func update(accessToken: String?) {
        self.accessToken = accessToken
    }
    
}
