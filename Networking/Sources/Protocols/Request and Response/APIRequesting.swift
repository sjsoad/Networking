//
//  APIRequestProtocol.swift
//  MyWeather
//
//  Created by Mac on 05.12.16.
//  Copyright © 2016 Sergey Kostyan. All rights reserved.
//

import Foundation
import Alamofire

public protocol APIRequesting {
    
    associatedtype RequestType: Request
    associatedtype ResponseType
    
    var parameterEncoding: ParameterEncoding { get }
    var HTTPMethod: RequestMethod { get }
    var headers: [String: String]? { get }
    var urlString: String { get }
    
    func build(with sessionManager: SessionManager, completion: @escaping RequestHandler<RequestType>)
    func execute(_ task: RequestType, completion: @escaping ResultHandler<ResponseType>)
    func check<Response: APIResponsing>(_ response: ResponseType, with errorParser: ErrorParsable, handlers: NetworkHandlers<Response>?)
        where ResponseType == Response.ResponseType
}

public extension APIRequesting {
    
    var parameterEncoding: ParameterEncoding { return JSONEncoding.default }
    var HTTPMethod: RequestMethod { return .get }
    var headers: [String: String]? { return nil }
    
}

public extension APIRequesting where ResponseType == Any {
    
    public func check<Response>(_ response: ResponseType, with errorParser: ErrorParsable, handlers: NetworkHandlers<Response>?)
        where Response : APIResponsing, ResponseType == Response.ResponseType {
            errorParser.parseError(from: response).map({ handlers?.errorHandler?($0) }) ??
                Response(with: response).result.map({ handlers?.successHandler?($0) })
    }
    
}

public extension APIRequesting where ResponseType == Data {
    
    public func check<Response>(_ response: ResponseType, with errorParser: ErrorParsable, handlers: NetworkHandlers<Response>?)
        where Response : APIResponsing, ResponseType == Response.ResponseType {
            Response(with: response).result.map({ handlers?.successHandler?($0) })
    }
    
}
