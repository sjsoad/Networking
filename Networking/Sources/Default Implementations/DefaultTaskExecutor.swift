//
//  DefaultTaskExecutor.swift
//  SKNetworkingLib
//
//  Created by Sergey Kostyan on 12/5/18.
//

import Foundation

public struct DefaultTaskExecutor: TaskExecuting {
    
    public  init() {}
    
    public func execute<RequestType, ResponseType>(_ task: RequestType, with completion: @escaping ResultHandler<ResponseType>
        ) where RequestType : Request {
        print("Your pair of request and response is not supported. Extend TaskExecuting with function overload")
    }
    
}

extension TaskExecuting {
    
    func execute(_ task: DataRequest, with completion: @escaping ResultHandler<Any>) {
        print("DataRequest, Any")
        //        request.responseJSON(completionHandler: { completion($0.result) })
    }
    
    func execute(_ task: DataRequest, with completion: @escaping ResultHandler<Data>) {
        print("DataRequest, Data")
        //        request.responseJSON(completionHandler: { completion($0.result) })
    }
    
    func execute(_ task: UploadRequest, with completion: @escaping ResultHandler<Any>) {
        print("UploadRequest, Any")
        //        request.responseJSON(completionHandler: { completion($0.result) })
    }
    
    func execute(_ task: UploadRequest, with completion: @escaping ResultHandler<Data>) {
        print("UploadRequest, Data")
        //        request.responseJSON(completionHandler: { completion($0.result) })
    }
    
    func execute(_ task: DownloadRequest, with completion: @escaping ResultHandler<Any>) {
        print("DownloadRequest, Any")
        //        request.responseJSON(completionHandler: { completion($0.result) })
    }
    
    func execute(_ task: DownloadRequest, with completion: @escaping ResultHandler<Data>) {
        print("DownloadRequest, Data")
        //        request.responseJSON(completionHandler: { completion($0.result) })
    }
    
}
