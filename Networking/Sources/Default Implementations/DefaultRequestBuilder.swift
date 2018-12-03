//
//  DefaultRequestBuilder.swift
//  AERecord
//
//  Created by Sergey Kostyan on 12/3/18.
//

import Alamofire

public struct DefaultRequestBuilder<IncomingRequestType: APIRequesting>: RequestBuilding {
    
    public typealias RequestType = IncomingRequestType
    
    public func build(with sessionManager: SessionManager, from requestInfo: IncomingRequestType,
                      handler: (Result<IncomingRequestType.RequestType>) -> Void) {
        fatalError("RequestType not implemented in library. Write extension to RequestBuilding protocol")
    }
}
