//
//  APIRequestProtocol.swift
//  MyWeather
//
//  Created by Mac on 05.12.16.
//  Copyright © 2016 Sergey Kostyan. All rights reserved.
//

import Foundation

public protocol APIRequesting: APIBaseRequesting {
    
    init(withURL url: String,
         parameters: [String: Any]?,
         headers: [String: String]?)
    
}

extension APIRequesting {
    
    var HTTPMethod: Method { return .get }
    
}
