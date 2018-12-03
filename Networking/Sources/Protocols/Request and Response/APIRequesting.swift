//
//  APIRequestProtocol.swift
//  MyWeather
//
//  Created by Mac on 05.12.16.
//  Copyright © 2016 Sergey Kostyan. All rights reserved.
//

import Foundation

public protocol APIRequesting {
    
    associatedtype RequestType: Request
    
    var responseType: ResponseType { get }
    var HTTPMethod: RequestMethod { get }
    var headers: [String: String]? { get }
    var urlString: String { get }

}

public extension APIRequesting {
    
    var responseType: ResponseType { return .json }
    var HTTPMethod: RequestMethod { return .get }
    var headers: [String: String]? { return nil }
    
}

public protocol APIDataRequesting: APIRequesting where RequestType == DataRequest {
    var requestType: DataRequestType { get }
}

public protocol APIUploadRequesting: APIRequesting where RequestType == UploadRequest {
    var requestType: UploadRequestType { get }
}

public protocol APIDownloadRequesting: APIRequesting where RequestType == DownloadRequest {
    var requestType: DownloadRequestType { get }
}
