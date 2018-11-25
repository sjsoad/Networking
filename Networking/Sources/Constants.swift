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

public typealias RequestMethod = Alamofire.HTTPMethod // Alamofire
public typealias DataResponseHandler = (DataResponse<Any>) -> Void // Alamofire
public typealias DownloadResponseHandler = (DownloadResponse<Data>) -> Void // Alamofire
public typealias DownloadFileDestination = DownloadRequest.DownloadFileDestination // Alamofire

// MARK: - Custom -

public typealias ErrorHandler = (_ error: Error) -> Void
public typealias RequestExecutingHandler = (_ executing: Bool) -> Void
public typealias TokenRefreshingHandler = (_ success: Bool) -> Void
public typealias ResponseResult<Value> = (_ result: Result<Value>, _ response: HTTPURLResponse?) -> Void

//public typealias RequestHandler<RequestClass> = (_ result: RequestResult<RequestClass>) -> Void

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

public enum RequestResult {
    case data(DataRequest)
    case upload(UploadRequest)
    case download(DownloadRequest)
    case failure(Error)

    public var alamofireRequest: AlamofireRequest? {
        switch self {
        case .data(let request):
            return request
        case .upload(let request):
            return request
        case .download(let request):
            return request
        case .failure:
            return nil
        }
    }
    
    public var hasValue: Bool {
        switch self {
        case .failure:
            return false
        default:
            return true
        }
    }
    
    public var error: Error? {
        switch self {
        case .failure(let error):
            return error
        default:
            return nil
        }
    }
    
}
