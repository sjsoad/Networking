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

public typealias DataRequest = Alamofire.DataRequest // Alamofire
public typealias UploadRequest = Alamofire.UploadRequest // Alamofire
public typealias DownloadRequest = Alamofire.DownloadRequest // Alamofire

public typealias RequestMethod = Alamofire.HTTPMethod // Alamofire
public typealias DataResponseHandler = (DataResponse<Any>) -> Void // Alamofire
public typealias DownloadResponseHandler = (DownloadResponse<Data>) -> Void // Alamofire
public typealias DownloadFileDestination = DownloadRequest.DownloadFileDestination // Alamofire

// MARK: - Custom -

public typealias ErrorHandler = (_ error: Error) -> Void
public typealias RequestExecutingHandler = (_ executing: Bool) -> Void
public typealias TokenRefreshingHandler = (_ success: Bool) -> Void
public typealias ResponseResult<Value> = (_ result: Result<Value>, _ response: HTTPURLResponse?) -> Void

public enum DataRequestType {
    case simple([String: Any]?)
}

public enum UploadRequestType {
    case uploadData(Data)
    case uploadURL(URL)
    case uploadStream(InputStream)
    case uploadMultipart([String: Any]?, MultipartDataParameters)
}

public enum DownloadRequestType {
    case downloadResuming(Data, DownloadFileDestination)
    case downloadTo([String: Any]?, DownloadFileDestination)
}

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
