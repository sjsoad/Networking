//
//  TaskExecuting.swift
//  AERecord
//
//  Created by Sergey Kostyan on 12/3/18.
//

import Alamofire

public protocol TaskExecuting {

    func execute<TaskType: Request, RequestType: APIRequesting, ResponseType: APIResponsing>(_ task: TaskType, for request: RequestType,
                                                                                             with response: ResponseType.Type,
                                                                                             completion: @escaping ResultHandler<ResponseType.ResponseType>)
    
}
