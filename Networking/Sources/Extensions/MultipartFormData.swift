//
//  MultipartFormData.swift
//  SKNetworkingLib
//
//  Created by Sergey on 31.08.2018.
//

import Alamofire

extension MultipartFormData {
    
    func append(with parameters: [String: Any]?) {
        parameters?.forEach({ (key, value) in
            guard let data = "\(value)".data else { return }
            append(data, withName: key)
        })
    }
    
    func appen(with multipartDataParameters: MultipartDataParameters) {
        append(multipartDataParameters.multipartData, withName: multipartDataParameters.multipartKey,
               fileName: multipartDataParameters.fileName, mimeType: multipartDataParameters.mimeType)
    }
    
}
