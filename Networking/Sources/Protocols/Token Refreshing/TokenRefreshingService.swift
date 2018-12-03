//
//  TokenRefreshingService.swift
//  SKNetworkingLib
//
//  Created by Sergey Kostyan on 11/24/18.
//

import Foundation

public protocol TokenRefreshingService {
    
    func refreshToken(with completion: @escaping TokenRefreshingHandler)
    
}
