//
//  TaskExecuting.swift
//  AERecord
//
//  Created by Sergey Kostyan on 12/3/18.
//

import Foundation

public protocol TaskExecuting {

    associatedtype TaskType: Request
    func execute<RequestType: APIRequesting>(_ task: TaskType, for request: RequestType)
    
}

public extension TaskExecuting where TaskType: DataRequest {
    
    func execute<RequestType: APIRequesting>(_ task: TaskType, for request: RequestType) {
//        switch request.responseType {
//        case .data:
//            task.responseData(completionHandler: { response in
//                switch response.result {
//                case .failure(let error): break
//                case .success(let value): break
//                }
//            })
//        case .json:
//            task.responseJSON(completionHandler: { response in
//                switch response.result {
//                case .failure(let error): break
//                case .success(let value): break
//                }
//            })
//        }
    }
    
}

public extension TaskExecuting where TaskType: DownloadRequest {
    
    func execute<RequestType: APIRequesting>(_ task: TaskType, for request: RequestType) {
//        switch request.responseType {
//        case .data:
//            task.responseData(completionHandler: { response in
//                switch response.result {
//                case .failure(let error): break
//                case .success(let value): break
//                }
//            })
//        case .json:
//            task.responseJSON(completionHandler: { response in
//                switch response.result {
//                case .failure(let error): break
//                case .success(let value): break
//                }
//            })
//        }
    }
    
}
