//
//  DefaultTaskExecuter.swift
//  AERecord
//
//  Created by Sergey Kostyan on 12/3/18.
//

import Foundation

public struct DefaultTaskExecuter<IncomingTaskType: Request, IncomingValue>: TaskExecuting {
    
    public typealias TaskType = IncomingTaskType
    public typealias Value = IncomingValue
    
    public func execute<RequestType: APIRequesting>(_ task: TaskType, for request: RequestType, completion: @escaping ResultHandler<Value>) {
        fatalError("TaskType not implemented in library. Write extension to TaskExecuting protocol")
    }
}
