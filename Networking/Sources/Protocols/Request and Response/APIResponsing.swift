//
//  ResponseProtocol.swift
//  MyWeather
//
//  Created by Mac on 05.12.16.
//  Copyright © 2016 Sergey Kostyan. All rights reserved.
//

import Foundation

public protocol APIResponsing {

    associatedtype InputValueType
    associatedtype ResultValueType
    
    var result: ResultValueType? { get }
    
    init(with value: InputValueType?)

}
