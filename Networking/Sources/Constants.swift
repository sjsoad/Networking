//
//  Constants.swift
//  Networking
//
//  Created by Sergey on 22.05.2018.
//  Copyright © 2018 Sergey Kostyan. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Alamofire -

public typealias RequestClass = Request // Alamofire
public typealias Method = Alamofire.HTTPMethod // Alamofire
public typealias DataResponseHandler = (DataResponse<Any>) -> Void // Alamofire
public typealias DownloadResponseHandler = (DownloadResponse<Any>) -> Void // Alamofire
public typealias DownloadFileDestination = DownloadRequest.DownloadFileDestination // Alamofire

// MARK: - Custom -

public typealias NetworkError = (error: Error, code: Int?)
public typealias ErrorHandler = (_ error: NetworkError) -> Void
public typealias RequestExecutingHandler = (_ executing: Bool) -> Void
public typealias RequestHandler = (_ request: RequestClass?, _ error: Error?) -> Void

public enum RequestType {
    case simple([String: Any]?)
    case uploadData(Data)
    case uploadURL(URL)
    case uploadStream(InputStream)
    case uploadMultipart
    case downloadResuming(Data, DownloadFileDestination)
    case downloadTo([String: Any]?, DownloadFileDestination)
}

public enum StatusCode: Int {
    case unauthorized = 401
}

public struct NetworkHandlers<ResponseType: APIResponsing> {
    
    let successHandler: ((_ response: ResponseType) -> Void)?
    let executingHandler: RequestExecutingHandler?
    let errorHandler: ErrorHandler?
    let requestHandler: RequestHandler?
    
    public init(successHandler: ((_ response: ResponseType) -> Void)? = nil, executingHandler: RequestExecutingHandler? = nil,
                errorHandler: ErrorHandler? = nil, requestHandler: RequestHandler? = nil) {
        self.successHandler = successHandler
        self.executingHandler = executingHandler
        self.errorHandler = errorHandler
        self.requestHandler = requestHandler
    }
}
