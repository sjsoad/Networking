//
//  ErrorParsing.swift
//  Place
//
//  Created by Sergey on 18.08.17.
//  Copyright © 2017 the appsolutions. All rights reserved.
//

import Foundation

public protocol ErrorParsable {
    
    func parseError(from value: Any, httpURLResponse: HTTPURLResponse?) -> Error?
    
}
