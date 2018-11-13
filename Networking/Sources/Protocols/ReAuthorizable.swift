//
//  ReAuthorizable.swift
//  Pods
//
//  Created by Sergey on 29.08.2018.
//

import Foundation

public protocol ReAuthorizable {
    
    func shouldReAuthAndRepeat(after code: Int) -> Bool
    func reAuthAndRepeat<RequestType: APIRequesting>(_ request: RequestType, completion: @escaping (RequestType) -> Void)
    
}

public extension ReAuthorizable {
    
    func shouldReAuthAndRepeat(after code: Int) -> Bool {
        return code == StatusCode.unauthorized.rawValue
    }
    
}
