//
//  TaskExecuting.swift
//  AERecord
//
//  Created by Sergey Kostyan on 12/3/18.
//

import Alamofire

public protocol TaskExecuting {

    func execute<ResponseType: APIResponsing>(with response: ResponseType.Type, completion: @escaping ResultHandler<ResponseType.ResponseType>)
    
}

extension TaskExecuting {
    
    public func execute<ResponseType>(with response: ResponseType.Type, completion: @escaping (Result<ResponseType.ResponseType>) -> Void)
        where ResponseType : APIResponsing {
            print("Default")
    }
    
}

extension Request: TaskExecuting {}

extension TaskExecuting where Self: DownloadRequest {
    
    func execute<ResponseType>(with response: ResponseType.Type, completion: @escaping (Result<ResponseType.ResponseType>) -> Void)
        where ResponseType : APIResponsing {
            print("DownloadRequest")
    }
    
    func execute<ResponseType>(with response: ResponseType.Type, completion: @escaping (Result<ResponseType.ResponseType>) -> Void)
        where ResponseType : APIResponsing, ResponseType.ResponseType == Data {
            print("DownloadRequest")
    }
    
}

extension TaskExecuting where Self: DataRequest {
    
    public func execute<ResponseType>(with response: ResponseType.Type, completion: @escaping (Result<ResponseType.ResponseType>) -> Void)
        where ResponseType : APIResponsing {
        print("Request")
    }
    
    public func execute<ResponseType>(with response: ResponseType.Type, completion: @escaping (Result<ResponseType.ResponseType>) -> Void)
        where ResponseType : APIResponsing, ResponseType.ResponseType == Data {
            print("Request")
    }
    
}
