//
//  DefaultResponseParser.swift
//  SKNetworkingLib
//
//  Created by Sergey Kostyan on 12/3/18.
//

import Foundation

struct DefaultResponseParser<IncomingResponseType: APIResponsing>: ResponseParsing {
    
    typealias ResponseType = IncomingResponseType
    
    func parse(_ value: ValueType, with errorParser: ErrorParsable, and handlers: NetworkHandlers<ResponseType>?) {
        fatalError("IncomingResponseType not implemented in library. Write extension to DefaultResponseParser protocol")
    }
    
}
