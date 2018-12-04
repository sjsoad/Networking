//
//  ResponseProtocol.swift
//  MyWeather
//
//  Created by Mac on 05.12.16.
//  Copyright © 2016 Sergey Kostyan. All rights reserved.
//

import Alamofire

public protocol APIResponsing {
    
    associatedtype ResponseType
    associatedtype ResultValueType
    
    var result: ResultValueType? { get }
    
    init(with value: ResponseType?)
    
    func retrieveResponse<RequestType: APIRequesting>(from request: RequestType, _ task: RequestType.RequestType,
                                                      _ completion: @escaping (Result<ResponseType>) -> Void)
    
}

public protocol APIJSONResponsing: APIResponsing where ResponseType == Any {
    
}

extension APIJSONResponsing {
    
    public func retrieveResponse<RequestType>(from request: RequestType, _ task: DataRequest,
                                              _ completion: @escaping (Result<ResponseType>) -> Void)
        where RequestType : APIRequesting {
            task.responseJSON(completionHandler: { completion($0.result) })
    }
    
}

public protocol APIDataResponsing: APIResponsing where ResponseType == Data {
    
}

extension APIDataResponsing {
    
    public func retrieveResponse<RequestType>(from request: RequestType, _ task: DataRequest,
                                              _ completion: @escaping (Result<ResponseType>) -> Void)
        where RequestType : APIRequesting {
        task.responseData(completionHandler: { completion($0.result) })
    }
    
}
