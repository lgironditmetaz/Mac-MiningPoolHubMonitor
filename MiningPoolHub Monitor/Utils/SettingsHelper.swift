//
//  SettingsHelper.swift
//  MiningPoolHub Monitor
//
//  Created by Loïc GIRON DIT METAZ on 06/03/2018.
//  Copyright © 2018 LgdLab. All rights reserved.
//

import Foundation

class SettingsHelper {
    
    static let shared = SettingsHelper()
    
    func updateMainCoin(coin: Coin) {
        userDefaults.set(coin.symbol, forKey: mainCoinKey)
    }
    
    func readMainCoin() -> Coin? {
        if let symbolName = userDefaults.string(forKey: mainCoinKey) {
            return Coin.coin(fromSymbol: symbolName)
        } else {
            return nil
        }
    }
    
    func updateMainFiat(fiat: Coin) {
        userDefaults.set(fiat.symbol, forKey: mainFiatKey)
    }
    
    func readMainFiat() -> Coin? {
        if let symbolName = userDefaults.string(forKey: mainFiatKey) {
            return Coin.fiat(fromSymbol: symbolName)
        } else {
            return nil
        }
    }
    
    func updateAutoRefreshStatus(status: RefreshStatus) {
        if status.interval != nil {
            userDefaults.set(status.interval, forKey: autoRefreshStatusKey)
        } else {
            userDefaults.set(-1.0, forKey: autoRefreshStatusKey)
        }
    }
    
    func readAutoRefreshStatus() -> RefreshStatus? {
        let statusInterval = userDefaults.double(forKey: autoRefreshStatusKey)
        if statusInterval > 0 {
            return RefreshStatus.refreshStatus(fromInterval: statusInterval)
        } else if statusInterval == -1.0 {
            return RefreshStatus.refreshStatus(fromInterval: nil)
        } else {
            return nil
        }
    }
    
    private let mainCoinKey = "org.lgdlab.macos.MiningPoolHub-Monitor.mainCoin"
    private let mainFiatKey = "org.lgdlab.macos.MiningPoolHub-Monitor.mainFiat"
    private let autoRefreshStatusKey = "org.lgdlab.macos.MiningPoolHub-Monitor.autoRefreshStatus"
    
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
}
