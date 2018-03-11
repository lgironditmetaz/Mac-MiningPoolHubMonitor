//
//  BaseAPI.swift
//  MiningPoolHub Monitor
//
//  Created by Loïc GIRON DIT METAZ on 02/03/2018.
//  Copyright © 2018 LgdLab. All rights reserved.
//

import Foundation

class BaseAPI {
    
    enum APIError : Error {
        case invalidURL(url: String)
        case requestFailed(error: Error?)
        case unableToParseResponse(description: String)
    }
    
    private let session: URLSession
    
    init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        config.urlCache = nil
        
        self.session = URLSession(configuration: config)
    }
    
    func request(url: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let requestUrl = URL(string: url) else {
            completionHandler(nil, nil, APIError.invalidURL(url: url))
            return
        }
        
        self.session.dataTask(with:requestUrl, completionHandler: completionHandler).resume()
    }
    
}
