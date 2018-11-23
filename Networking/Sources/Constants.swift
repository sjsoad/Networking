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

public typealias UsedRequestClass = Request // Alamofire
public typealias RequestMethod = Alamofire.HTTPMethod // Alamofire
public typealias DataResponseHandler = (DataResponse<Any>) -> Void // Alamofire
public typealias DownloadResponseHandler = (DownloadResponse<Data>) -> Void // Alamofire
public typealias DownloadFileDestination = DownloadRequest.DownloadFileDestination // Alamofire

// MARK: - Custom -

public typealias ErrorHandler = (_ error: Error) -> Void
public typealias RequestExecutingHandler = (_ executing: Bool) -> Void
public typealias RequestHandler<RequestType> = (_ result: RequestResult<RequestType>) -> Void

public enum RequestType {
    case simple([String: Any]?) // regular API request
    case uploadData(Data)
    case uploadURL(URL)
    case uploadStream(InputStream)
    case uploadMultipart([String: Any]?, MultipartDataParameters)
    case downloadResuming(Data, DownloadFileDestination)
    case downloadTo([String: Any]?, DownloadFileDestination)
}

public enum StatusCode: Int {
    case unauthorized = 401
}

public enum RequestResult<RequestClass> {
    case success(RequestClass)
    case failure(Error)
    
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    public var value: RequestClass? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
}
