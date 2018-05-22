//
//  APIRequestProtocol.swift
//  MyWeather
//
//  Created by Mac on 05.12.16.
//  Copyright © 2016 Sergey Kostyan. All rights reserved.
//

import Foundation
import Alamofire

public typealias Method = Alamofire.HTTPMethod

public protocol APIRequesting {
    
    associatedtype ResponseType: APIResponsing
    
    var HTTPMethod: Method { get set }
    var parameters: [String: Any]? { get set }
    var headers: [String: String]? { get set }
    var urlString: String { get set }
    
    var multipartData: Data? { get set }
    var multipartKey: String? { get set }
    var mimeType: String? { get set }
    var fileName: String? { get set }
    
    init(withURL urlString: String, parameters: [String: Any]?, headers: [String: String]?)
    
    init(withURL urlString: String, multipartData: Data?, multipartKey: String?, mimeType: String?, fileName: String?, parameters: [String: Any]?,
         headers: [String: String]?)
}

public extension APIRequesting {
    
    var HTTPMethod: Method { return .get }
    
    init(withURL urlString: String, parameters: [String: Any]?, headers: [String: String]?) {
        self.urlString = urlString
        self.parameters = parameters
        self.headers = headers
    }
    
    init(withURL urlString: String, multipartData: Data?, multipartKey: String?, mimeType: String?, fileName: String?, parameters: [String: Any]?,
         headers: [String: String]?) {
        self.urlString = urlString
        self.multipartData = multipartData
        self.multipartKey = multipartKey
        self.mimeType = mimeType
        self.fileName = fileName
        self.parameters = parameters
        self.headers = headers
    }
    
}
