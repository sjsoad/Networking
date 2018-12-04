//
//  DefaultTaskExecuter.swift
//  
//
//  Created by Sergey Kostyan on 12/3/18.
//

import Alamofire

public struct DefaultTaskExecuter: TaskExecuting {
    
    public func execute<TaskType, RequestType, ResponseType>(_ task: TaskType, for request: RequestType, with response: ResponseType.Type,
                                                             completion: @escaping (Result<ResponseType.ResponseType>) -> Void)
        where TaskType : Request, RequestType : APIRequesting, ResponseType : APIResponsing {
        print("Default implementation")
    }
}

public extension DefaultTaskExecuter {

    public func execute<TaskType, RequestType, ResponseType>(_ task: TaskType, for request: RequestType, with response: ResponseType.Type,
                                                             completion: @escaping (Result<ResponseType.ResponseType>) -> Void)
        where TaskType : DataRequest, RequestType : APIRequesting, ResponseType : APIResponsing, ResponseType.ResponseType == Any {
            task.responseJSON(completionHandler: { completion($0.result) })
    }

}

public extension DefaultTaskExecuter {

    public func execute<TaskType, RequestType, ResponseType>(_ task: TaskType, for request: RequestType, with response: ResponseType.Type,
                                                             completion: @escaping (Result<ResponseType.ResponseType>) -> Void)
        where TaskType : DataRequest, RequestType : APIRequesting, ResponseType : APIResponsing, ResponseType.ResponseType == Data {
            task.responseData(completionHandler: { completion($0.result) })
    }

}

public extension DefaultTaskExecuter {

    public func execute<TaskType, RequestType, ResponseType>(_ task: TaskType, for request: RequestType, with response: ResponseType.Type,
                                                             completion: @escaping (Result<ResponseType.ResponseType>) -> Void)
        where TaskType : DownloadRequest, RequestType : APIRequesting, ResponseType : APIResponsing, ResponseType.ResponseType == Any {
            task.responseJSON(completionHandler: { completion($0.result) })
    }

}

public extension DefaultTaskExecuter {

    public func execute<TaskType, RequestType, ResponseType>(_ task: TaskType, for request: RequestType, with response: ResponseType.Type,
                                                             completion: @escaping (Result<ResponseType.ResponseType>) -> Void)
        where TaskType : DownloadRequest, RequestType : APIRequesting, ResponseType : APIResponsing, ResponseType.ResponseType == Data {
            task.responseData(completionHandler: { completion($0.result) })
    }

}
