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
    case uploadMultipart([String: Any]?, MultipartDataParameters)
    case downloadResuming(Data, DownloadFileDestination)
    case downloadTo([String: Any]?, DownloadFileDestination)
}

public enum StatusCode: Int {
    case unauthorized = 401
}
