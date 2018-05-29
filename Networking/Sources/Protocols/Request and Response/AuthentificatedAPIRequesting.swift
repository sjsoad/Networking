//
//  AuthentificatedAPIRequesting.swift
//  Networking
//
//  Created by Sergey on 29.05.2018.
//  Copyright © 2018 Sergey Kostyan. All rights reserved.
//

import UIKit
import Foundation

public protocol AuthentificatedAPIRequesting: class, APIRequesting {
    
    var accessToken: String? { get set }
    
    func update(accessToken: String?)
    
}

public extension AuthentificatedAPIRequesting {

    func update(accessToken: String?) {
        self.accessToken = accessToken
    }
    
}
