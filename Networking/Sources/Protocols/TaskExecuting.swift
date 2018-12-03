//
//  TaskExecuting.swift
//  AERecord
//
//  Created by Sergey Kostyan on 12/3/18.
//

import Foundation

public protocol TaskExecuting {

    associatedtype TaskType
    
    func execute<RequestType: APIRequesting>(_ task: TaskType, for request: RequestType)
    
}

struct DefaultTaskExecuter<IncomingTaskType: Request>: TaskExecuting {
    
    typealias TaskType = IncomingTaskType
    
    func execute<RequestType: APIRequesting>(_ task: TaskType, for request: RequestType) {
        fatalError("TaskType not implemented in library. Write extension to TaskExecuting protocol")
    }
}

extension TaskExecuting where TaskType: DataRequest {
    
    func execute<RequestType: APIRequesting>(_ task: TaskType, for request: RequestType) {
        switch request.responseType {
        case .data:
            task.responseData(completionHandler: { response in })
        case .json:
            task.responseJSON(completionHandler: { response in })
        }
    }
    
}

extension TaskExecuting where TaskType: DownloadRequest {
    
    func execute<RequestType: APIRequesting>(_ task: TaskType, for request: RequestType) {
        switch request.responseType {
        case .data:
            task.responseData(completionHandler: { response in })
        case .json:
            task.responseJSON(completionHandler: { response in })
        }
    }
    
}
