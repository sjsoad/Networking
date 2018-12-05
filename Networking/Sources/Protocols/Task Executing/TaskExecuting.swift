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

extension Request: TaskExecuting {
    
    public func execute<ResponseType>(with response: ResponseType.Type, completion: @escaping ResultHandler<ResponseType.ResponseType>)
        where ResponseType : APIResponsing {
        print("Default")
    }
    
}

//extension DataRequest: DataTaskExecuting {}
//extension DownloadRequest: DownloadTaskExecuting {}

//    public func execute<ResponseType>(with response: ResponseType.Type, completion: @escaping ResultHandler<ResponseType.ResponseType>)
//        where ResponseType : APIResponsing, ResponseType.ResponseType == Any {
//            print("Default")
//    }
//
//    public func execute<ResponseType>(with response: ResponseType.Type, completion: @escaping ResultHandler<ResponseType.ResponseType>)
//        where ResponseType : APIResponsing, ResponseType.ResponseType == Data {
//            print("Default")
//    }

//extension DataRequest {
//
//    public func execute<ResponseType>(with response: ResponseType.Type, completion: @escaping ResultHandler<ResponseType.ResponseType>)
//        where ResponseType : APIResponsing {
//            print("DownloadRequest")
//    }
//
//    public func execute<ResponseType>(with response: ResponseType.Type, completion: @escaping ResultHandler<ResponseType.ResponseType>)
//        where ResponseType : APIResponsing, ResponseType.ResponseType == Data {
//            print("DownloadRequest")
//    }
//
//}

//extension DownloadRequest {
//
//    public func execute<ResponseType>(with response: ResponseType.Type, completion: @escaping ResultHandler<ResponseType.ResponseType>)
//        where ResponseType : APIResponsing {
//        print("Request")
//    }
//
//    public func execute<ResponseType>(with response: ResponseType.Type, completion: @escaping ResultHandler<ResponseType.ResponseType>)
//        where ResponseType : APIResponsing, ResponseType.ResponseType == Data {
//            print("Request")
//    }
//
//}
