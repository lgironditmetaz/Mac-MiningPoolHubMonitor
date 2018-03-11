//
//  MiningPoolHubBalance.swift
//  MiningPoolHub Monitor
//
//  Created by Loïc GIRON DIT METAZ on 01/03/2018.
//  Copyright © 2018 LgdLab. All rights reserved.
//

import Foundation

class Balance : CustomStringConvertible {
    
    let coinName: String
    
    let confirmedBalance: Double
    let unconfirmedBalance: Double
    
    let confirmedAutoExchangeBalance: Double
    let unconfirmedAutoExchangeBalance: Double
    
    let exchangeBalance: Double
    
    init(coinName: String, confirmedBalance: Double, unconfirmedBalance: Double, confirmedAutoExchangeBalance: Double, unconfirmedAutoExchangeBalance: Double, exchangeBalance: Double) {
        
        self.coinName = coinName
        
        self.confirmedBalance = confirmedBalance
        self.unconfirmedBalance = unconfirmedBalance
        
        self.confirmedAutoExchangeBalance = confirmedAutoExchangeBalance
        self.unconfirmedAutoExchangeBalance = unconfirmedAutoExchangeBalance
        
        self.exchangeBalance = exchangeBalance
        
    }
    
    var description: String {
        return "Balance(\(coinName), confirmed: \(confirmedBalance) , unconfirmed: \(unconfirmedBalance), ae_confirmed: \(confirmedAutoExchangeBalance), ae_unconfirmed: \(unconfirmedAutoExchangeBalance), exchange: \(exchangeBalance))"
    }
    
}
