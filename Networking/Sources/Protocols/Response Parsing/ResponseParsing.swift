//
//  ResponseParsing.swift
//  SKNetworkingLib
//
//  Created by Sergey Kostyan on 12/3/18.
//

import Alamofire

public protocol ResponseParsing {
    
    associatedtype ResponseType: APIResponsing
    associatedtype ValueType = ResponseType.ResponseType
    
    func parse(_ value: ValueType, with errorParser: ErrorParsable, and handlers: NetworkHandlers<ResponseType>?)
    
}

public extension ResponseParsing where ValueType == Any {
    
    func parse<ResponseType>(_ value: ValueType, with errorParser: ErrorParsable, and handlers: NetworkHandlers<ResponseType>?)
        where ResponseType: APIResponsing {
        errorParser.parseError(from: value).map({ handlers?.errorHandler?($0) }) ??
            ResponseType(with: value as? ResponseType.ResponseType).result.map({ handlers?.successHandler?($0) })
    }
    
}

public extension ResponseParsing where ValueType == Data {
    
    func parse<ResponseType>(_ value: ValueType, with errorParser: ErrorParsable, and handlers: NetworkHandlers<ResponseType>?)
        where ResponseType: APIResponsing {
        ResponseType(with: value as? ResponseType.ResponseType).result.map({ handlers?.successHandler?($0) })
    }
    
}
