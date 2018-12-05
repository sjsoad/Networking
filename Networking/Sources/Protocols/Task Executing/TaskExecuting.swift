//
//  TaskExecuting.swift
//  AERecord
//
//  Created by Sergey Kostyan on 12/3/18.
//

import Foundation

public protocol TaskExecuting {

    func execute<RequestType: Request, ResponseType>(_ task: RequestType, with completion: @escaping ResultHandler<ResponseType>)
    
}
