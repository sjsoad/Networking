//
//  ReAuthorizable.swift
//  Pods
//
//  Created by Sergey on 29.08.2018.
//

import Foundation

public protocol ReAuthorizable {
    
    func shouldReAuthAndRepeat(after error: NetworkError) -> Bool
    func reAuthAndRepeat<RequestType: APIRequesting>(_ request: RequestType, completion: (RequestType?) -> Void)
    
}

public extension ReAuthorizable {
    
    func shouldReAuthAndRepeat(after error: NetworkError) -> Bool {
        return error.code == StatusCode.unauthorized.rawValue
    }
    
}
