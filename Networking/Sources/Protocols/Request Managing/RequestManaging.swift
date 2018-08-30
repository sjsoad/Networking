//
//  RequestManaging.swift
//  Networking
//
//  Created by Sergey on 22.05.2018.
//  Copyright © 2018 Sergey Kostyan. All rights reserved.
//

import Foundation

public protocol RequestManaging {
    
    func pauseAllRequests(_ pause: Bool)
    func cancelAllRequests()
    func cancel(_ request: RequestClass)
    
}
