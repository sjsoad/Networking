//
//  ResponseProtocol.swift
//  MyWeather
//
//  Created by Mac on 05.12.16.
//  Copyright © 2016 Sergey Kostyan. All rights reserved.
//

import Foundation

public protocol APIResponsing {

    associatedtype Value
    
    var result: Value? { get }
    
    init(with value: Any)

}
