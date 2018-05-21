//
//  APIMultipartProtocol.swift
//  Place
//
//  Created by Sergey on 29.08.17.
//  Copyright © 2017 the appsolutions. All rights reserved.
//

import Foundation

public protocol APIMultipartRequesting: APIBaseRequesting {
    
    var multipartData: Data { get }
    var multipartKey: String { get }
    var mimeType: String { get }
    var fileName: String { get }

    init(withURL url: String,
         multipartData: Data,
         multipartKey: String,
         mimeType: String,
         fileName: String,
         parameters: [String: Any]?,
         headers: [String: String]?)
    
}

extension APIMultipartRequesting {

    public var HTTPMethod: Method { return .post }
    
}
