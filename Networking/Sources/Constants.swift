//
//  Constants.swift
//  Networking
//
//  Created by Sergey on 22.05.2018.
//  Copyright © 2018 Sergey Kostyan. All rights reserved.
//

import Foundation

public enum NetworkError: Int {
    case unauthorized = 401
}

public typealias RequestHandler = (_ request: Request?) -> Void
public typealias ErrorHandler = (_ error: NetworkError) -> Void
