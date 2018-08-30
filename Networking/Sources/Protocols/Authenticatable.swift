//
//  Authenticatable.swift
//  Networking
//
//  Created by Sergey on 29.05.2018.
//  Copyright © 2018 Sergey Kostyan. All rights reserved.
//

import Foundation

public protocol Authenticatable {
    
    var accessToken: String? { get set }
    
    mutating func update(accessToken: String?)
    
}

public extension Authenticatable {

    mutating func update(accessToken: String?) {
        self.accessToken = accessToken
    }
    
}
