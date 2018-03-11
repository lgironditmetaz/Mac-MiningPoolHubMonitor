//
//  CryptonatorAPI.swift
//  MiningPoolHub Monitor
//
//  Created by Loïc GIRON DIT METAZ on 02/03/2018.
//  Copyright © 2018 LgdLab. All rights reserved.
//

import Foundation

class CryptonatorAPI : BaseAPI {
    
    func rate(base: Coin, target: Coin, completionHandler: @escaping (Rate?, Error?) -> Void) {
        request(url: "https://api.cryptonator.com/api/ticker/\(base.symbol)-\(target.symbol)") { (data, response, error) in
            guard let data = data, error == nil else {
                completionHandler(nil, APIError.requestFailed(error: error))
                return
            }
            do {
                completionHandler(try self.rate(fromJSON: data, base: base, target: target), nil)
            } catch let error {
                completionHandler(nil, error)
            }
        }
    }
    
    private func rate(fromJSON jsonData: Data, base: Coin, target: Coin) throws -> Rate {
        
        // Basic JSON validation
        guard let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any],
            let success = json["success"] as? Bool,
            let error = json["error"] as? String
            else {
                throw APIError.unableToParseResponse(description: "Invalid JSON")
        }
        
        // Checking for API errors
        guard success else {
            throw APIError.unableToParseResponse(description: "API call with error: \(error)")
        }
        
        // Checking that response is valid and contains all necessary infos
        guard let ticker = json["ticker"] as? [String: Any],
            let priceString = ticker["price"] as? String,
            let volumeString = ticker["volume"] as? String,
            let changeString = ticker["change"] as? String
            else {
                throw APIError.unableToParseResponse(description: "Missing elements in response")
        }
        
        // The price is required, other infos are optional
        guard let price = Double(priceString) else {
            throw APIError.unableToParseResponse(description: "Invalid values in response")
        }
        
        let volume = Double(volumeString)
        let change = Double(changeString)
        
        return Rate(
            base: base,
            target: target,
            price: price,
            volume: volume,
            change: change
        )
    }
    
}
