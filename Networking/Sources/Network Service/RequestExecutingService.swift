//
//  APIClient.swift
//  MyWeather
//
//  Created by Mac on 05.12.16.
//  Copyright © 2016 Sergey Kostyan. All rights reserved.
//
import Foundation
import Alamofire

public protocol RequestExecutingService {
    
    var sessionManager: SessionManager { get }
    init(sessionManager: SessionManager)
    func execute<RequestType: APIRequesting>(request: RequestType, responseHandler: @escaping (DataResponse<Any>) -> Void,
                                             requestHandler: RequestHandler?)
    
}

open class DefaultRequestExecutingService: RequestExecutingService {
    
    public private(set) var sessionManager: SessionManager
    
    // MARK: - Public -
    
    public required init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
    
    open func execute<RequestType: APIRequesting>(request: RequestType, responseHandler: @escaping (DataResponse<Any>) -> Void,
                                                  requestHandler: RequestHandler?) {
        sessionManager.upload(multipartFormData: { [weak self] (multipartFormData) in
            self?.append(multipartFormData: multipartFormData, with: request)
        }, to: request.path, method: request.HTTPMethod, headers: request.headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                requestHandler?(upload)
                upload.responseJSON(completionHandler: responseHandler)
            case .failure(_):
                requestHandler?(nil)
            }
        }
    }

    // MARK: - Private -
    
    private func append<RequestType: APIRequesting>(multipartFormData: MultipartFormData, with request: RequestType) {
        if let parameters = request.parameters {
            for (key, value) in parameters {
                if let data = "\(value)".data(using: String.Encoding.utf8) {
                    multipartFormData.append(data, withName: key as String)
                }
            }
        }
        multipartFormData.append(request.multipartData, withName: request.multipartKey, fileName: request.fileName, mimeType: request.mimeType)
    }
    
}
