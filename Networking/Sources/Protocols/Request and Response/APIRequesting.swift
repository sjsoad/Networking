//
//  APIRequestProtocol.swift
//  MyWeather
//
//  Created by Mac on 05.12.16.
//  Copyright © 2016 Sergey Kostyan. All rights reserved.
//

import Foundation

public protocol APIRequesting {
    
//    static var type: RequestType { get }
    var responseType: ResponseType { get }
    var HTTPMethod: RequestMethod { get }
    var headers: [String: String]? { get }
    var urlString: String { get }

}

public extension APIRequesting {
    
//    static var type: RequestType { return .upload }
    var responseType: ResponseType { return .json }
    var HTTPMethod: RequestMethod { return .get }
    var headers: [String: String]? { return nil }
    
}

public protocol APIDataRequesting: APIRequesting {
    var requestType: DataRequestType { get }
}

public protocol APIUploadRequesting: APIRequesting {
    var requestType: UploadRequestType { get }
}

public protocol APIDownloadRequesting: APIRequesting {
    var requestType: DownloadRequestType { get }
}
