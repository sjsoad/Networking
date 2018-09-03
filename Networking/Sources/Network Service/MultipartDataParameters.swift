//
//  MultipartDataParameters.swift
//  AERecord
//
//  Created by Sergey on 31.08.2018.
//

import Foundation

public struct MultipartDataParameters {
    
    var multipartData: Data
    var multipartKey: String
    var mimeType: String
    var fileName: String

    public init(with multipartData: Data, key multipartKey: String, mimeType: String, fileName: String) {
        self.multipartData = multipartData
        self.multipartKey = multipartKey
        self.mimeType = mimeType
        self.fileName = fileName
    }
    
}
