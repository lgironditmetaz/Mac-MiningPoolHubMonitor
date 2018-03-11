//
//  CryptonatorRate.swift
//  MiningPoolHub Monitor
//
//  Created by Loïc GIRON DIT METAZ on 02/03/2018.
//  Copyright © 2018 LgdLab. All rights reserved.
//

import Foundation

class Rate : CustomStringConvertible {
    
    let base: Coin
    let target: Coin
    
    let price: Double
    let volume: Double?
    let change: Double?
    
    init(base: Coin, target: Coin, price: Double, volume: Double?, change: Double?) {
        self.base = base
        self.target = target
        
        self.price = price
        self.volume = volume
        self.change = change
    }
    
    var description: String {
        let volume = self.volume ?? 0.0
        let change = self.change ?? 0.0
        
        return "Rate(base: \(base.symbol), target: \(target.symbol), price: \(price), volume: \(volume), change: \(change))"
    }
    
}
