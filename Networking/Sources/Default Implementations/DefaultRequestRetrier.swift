//
//  DefaultRequestRetrier.swift
//  SKUtils
//
//  Created by Sergey Kostyan on 11/23/18.
//  Copyright © 2018 Sergey Kostyan. All rights reserved.
//

import Alamofire

open class DefaultRequestRetrier: RequestRetrier {
    
    private var tokenRefreshingService: TokenRefreshingService
    private var failedRequests: [Request]
    private var isRefreshing: Bool
    
    public init(with tokenRefreshingService: TokenRefreshingService) {
        self.tokenRefreshingService = tokenRefreshingService
        self.failedRequests = []
        self.isRefreshing = false
    }
    
    open func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        request.response.map({
            guard $0.statusCode == StatusCode.unauthorized.rawValue else { return }
            failedRequests.append(request)
            guard !isRefreshing else { return }
            refreshToken(with: completion)
        }) ?? completion(false, 0)
    }
    
    // MARK: - Private -
    
    private func refreshToken(with completion: @escaping RequestRetryCompletion) {
        isRefreshing.toggle()
        tokenRefreshingService.refreshToken(with: { [weak self] success in
            self?.isRefreshing.toggle()
            self?.failedRequests.forEach({ _ in completion(success, 0) })
            self?.failedRequests.removeAll()
        })
    }
    
}
