//
//  APIBaseRequesting.swift
//  AERecord
//
//  Created by Sergey Kostyan on 30.04.2018.
//

import Foundation
import Alamofire

public typealias Method = Alamofire.HTTPMethod

public protocol APIBaseRequesting {

    associatedtype RequestType: APIResponsing
    
    var HTTPMethod: Method { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get set }
    var path: String { get }
    
}
