//
//  NetworkError.swift
//  Networking
//
//  Created by Sergey on 22.05.2018.
//  Copyright © 2018 Sergey Kostyan. All rights reserved.
//

import Foundation

public struct NetworkError {
    
    public let error: Error
    public let statusCode: Int?
    
    public init(error: Error, statusCode: Int?) {
        self.error = error
        self.statusCode = statusCode
    }
    
}
