//
//  TaskExecuting.swift
//  AERecord
//
//  Created by Sergey Kostyan on 12/3/18.
//

import Alamofire

public protocol TaskExecuting {

    associatedtype TaskType: Request
    associatedtype Value
    func execute<RequestType: APIRequesting>(_ task: TaskType, for request: RequestType, completion: @escaping ResultHandler<Value>)
    
}

public extension TaskExecuting where TaskType: DataRequest, Value == Any {
    
    func execute<RequestType: APIRequesting>(_ task: TaskType, for request: RequestType, completion: @escaping ResultHandler<Value>) {
        task.responseJSON(completionHandler: { response in
            completion(response.result)
        })
    }
    
}

public extension TaskExecuting where TaskType: DataRequest, Value == Data {
    
    func execute<RequestType: APIRequesting>(_ task: TaskType, for request: RequestType, completion: @escaping ResultHandler<Value>) {
        task.responseData(completionHandler: { response in
            completion(response.result)
        })
    }
    
}

public extension TaskExecuting where TaskType: DownloadRequest, Value == Any {
    
    func execute<RequestType: APIRequesting>(_ task: TaskType, for request: RequestType, completion: @escaping ResultHandler<Value>) {
        task.responseJSON(completionHandler: { response in
            completion(response.result)
        })
    }
    
}

public extension TaskExecuting where TaskType: DownloadRequest, Value == Data {
    
    func execute<RequestType: APIRequesting>(_ task: TaskType, for request: RequestType, completion: @escaping ResultHandler<Value>) {
        task.responseData(completionHandler: { response in
            completion(response.result)
        })
    }
    
}
