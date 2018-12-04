//
//  DefaultResponseParser.swift
//  SKNetworkingLib
//
//  Created by Sergey Kostyan on 12/3/18.
//

import Foundation

public struct DefaultResponseParser: ResponseParsing {
    
    public func parse<ResponseType>(_ value: ResponseType.ResponseType, with errorParser: ErrorParsable, and handlers: NetworkHandlers<ResponseType>?)
        where ResponseType : APIResponsing {
        print("Default implementation")
    }
    
}

public extension DefaultResponseParser {
    
    public func parse<ResponseType>(_ value: ResponseType.ResponseType, with errorParser: ErrorParsable, and handlers: NetworkHandlers<ResponseType>?)
        where ResponseType : APIResponsing, ResponseType.ResponseType == Any {
            errorParser.parseError(from: value).map({ handlers?.errorHandler?($0) }) ??
                ResponseType(with: value).result.map({ handlers?.successHandler?($0) })
    }
    
}

public extension DefaultResponseParser {
    
    public func parse<ResponseType>(_ value: ResponseType.ResponseType, with errorParser: ErrorParsable, and handlers: NetworkHandlers<ResponseType>?)
        where ResponseType: APIResponsing, ResponseType.ResponseType == Data {
            ResponseType(with: value).result.map({ handlers?.successHandler?($0) })
    }
    
}
