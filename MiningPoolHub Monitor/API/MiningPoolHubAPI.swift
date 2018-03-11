//
//  MiningPoolHubAPI.swift
//  MiningPoolHub Monitor
//
//  Created by Loïc GIRON DIT METAZ on 01/03/2018.
//  Copyright © 2018 LgdLab. All rights reserved.
//

import Foundation

class MiningPoolHubAPI : BaseAPI {
    
    func balances(forAPIKey key: String, completionHandler: @escaping ([Balance]?, Error?) -> Void) {
        request(url: "https://miningpoolhub.com/index.php?page=api&action=getuserallbalances&api_key=\(key)") { (data, response, error) in
            guard let data = data, error == nil else {
                completionHandler(nil, APIError.requestFailed(error: error))
                return
            }
            do {
                completionHandler(try self.balances(fromJSON: data), nil)
            } catch let error {
                completionHandler(nil, error)
            }
        }
    }
    
    private func balances(fromJSON jsonData: Data) throws -> [Balance] {
        
        // Basic JSON validation
        guard let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]  else {
            throw APIError.unableToParseResponse(description: "Invalid JSON")
        }
        
        guard let allBalances = json["getuserallbalances"] as? [String : Any],
            let allBalancesData = allBalances["data"] as? [[String : Any]] else {
                
            throw APIError.unableToParseResponse(description: "No balances data in response")
        }
        
        // Balance data parsing
        return try allBalancesData.map { balanceData in
            
            // Balance data validation
            guard let coinName = balanceData["coin"] as? String,
                let confirmedBalance = balanceData["confirmed"] as? Double,
                let unconfirmedBalance = balanceData["unconfirmed"] as? Double,
                let confirmedAutoExchangeBalance = balanceData["ae_confirmed"] as? Double,
                let unconfirmedAutoExchangeBalance = balanceData["ae_unconfirmed"] as? Double,
                let exchangeBalance = balanceData["exchange"] as? Double
                else {
                    throw APIError.unableToParseResponse(description: "Missing information in response")
            }
            
            return Balance(
                coinName: coinName,
                confirmedBalance: confirmedBalance,
                unconfirmedBalance: unconfirmedBalance,
                confirmedAutoExchangeBalance: confirmedAutoExchangeBalance,
                unconfirmedAutoExchangeBalance: unconfirmedAutoExchangeBalance,
                exchangeBalance: exchangeBalance
            )
        }
    }
    
}
