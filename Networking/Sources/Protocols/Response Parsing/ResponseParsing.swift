//
//  ResponseParsing.swift
//  SKNetworkingLib
//
//  Created by Sergey Kostyan on 12/3/18.
//

import Alamofire

public protocol ResponseParsing {
    
    associatedtype IncomingResponseType
    
    func parse<ResponseType: APIResponsing>(_ response: IncomingResponseType, with handlers: NetworkHandlers<ResponseType>?)
    
}

public extension ResponseParsing where IncomingResponseType == Any {
    
    func parse<ResponseType>(_ value: IncomingResponseType, with handlers: NetworkHandlers<ResponseType>?) where ResponseType: APIResponsing {
//        errorParser.parseError(from: value).map({ handlers?.errorHandler?($0) }) ??
            ResponseType(with: value as? ResponseType.InputValueType).result.map({ handlers?.successHandler?($0) })
    }
    
}

public extension ResponseParsing where IncomingResponseType == Data {
    
    func parse<ResponseType>(_ value: IncomingResponseType, with handlers: NetworkHandlers<ResponseType>?) where ResponseType: APIResponsing {
        ResponseType(with: value as? ResponseType.InputValueType).result.map({ handlers?.successHandler?($0) })
    }
    
}
