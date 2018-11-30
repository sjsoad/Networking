//
//  Requests.swift
//  AERecord
//
//  Created by Sergey Kostyan on 11/25/18.
//

import Alamofire

public protocol AlamofireRequest {
    
    
    
}

extension DataRequest: AlamofireRequest {
    
//    public func response<Value>(with completion: @escaping (Result<Value>) -> Void) -> Self {
//        return responseJSON(completionHandler: { response in
//            switch response.result {
//            case .success(let value):
//                completion(.success(value))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        })
//    }
    
}

//extension DownloadRequest: AlamofireRequest {
//
//    public func response<Value>(with completion: @escaping (Result<Value>) -> Void) -> Self {
//        return response(responseSerializer: <#T##DownloadResponseSerializerProtocol#>, completionHandler: <#T##(DownloadResponse<DownloadResponseSerializerProtocol.SerializedObject>) -> Void#>)
//    }
//
//}
