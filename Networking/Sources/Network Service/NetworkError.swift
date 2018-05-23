//
//  NetworkError.swift
//  Networking
//
//  Created by Sergey on 22.05.2018.
//  Copyright © 2018 Sergey Kostyan. All rights reserved.
//

import UIKit

open class NetworkError: Error {
    
    public private(set) var error: Error
    public private(set) var statusCode: Int?
    
    public init(error: Error, statusCode: Int?) {
        self.error = error
        self.statusCode = statusCode
    }
    
}
