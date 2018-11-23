//
//  String.swift
//  SKNetworkingLib
//
//  Created by Sergey Kostyan on 21.08.2018.
//

import Foundation

public extension String {
    
    var data: Data? {
        return data(using: .utf8)
    }
    
}
