//
//  RequestBuilding.swift
//  SKNetworkingLib
//
//  Created by Sergey Kostyan on 11/25/18.
//

import Alamofire

public protocol RequestBuilding {
    
    func build<RequestType: APIRequesting>(with sessionManager: SessionManager, from requestInfo: RequestType,
                                           handler: RequestHandler<RequestType.RequestType>)
    
}
