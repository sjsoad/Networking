//
//  RequestExecutor.swift
//  SKNetworkingLib
//
//  Created by Sergey on 28.08.2018.
//

import Alamofire

public protocol RequestExecutor: RequestManaging {
    
    init(sessionManager: SessionManager)
    func dataRequest<RequestType: APIRequesting>(from request: RequestType, _ requestHandler: RequestHandler?,
                                                 with completion: @escaping DataResponseHandler)
    func downloadRequest<RequestType: APIRequesting>(from request: RequestType, _ requestHandler: RequestHandler?,
                                                     with completion: @escaping DownloadResponseHandler)
    
}
