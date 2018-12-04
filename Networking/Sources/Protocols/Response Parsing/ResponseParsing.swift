//
//  ResponseParsing.swift
//  SKNetworkingLib
//
//  Created by Sergey Kostyan on 12/3/18.
//

import Alamofire

public protocol ResponseParsing {
    
    func parse<ResponseType: APIResponsing>(_ value: ResponseType.ResponseType, with errorParser: ErrorParsable,
                                            and handlers: NetworkHandlers<ResponseType>?)

}
