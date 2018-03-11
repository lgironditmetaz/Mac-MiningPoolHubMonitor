//
//  SettingsViewController.swift
//  MiningPoolHub Monitor
//
//  Created by Loïc GIRON DIT METAZ on 05/03/2018.
//  Copyright © 2018 LgdLab. All rights reserved.
//

import Cocoa

class SettingsViewController : NSViewController, NSComboBoxDataSource {
    
    @IBOutlet weak var apiKeyTextField: NSTextField!
    @IBOutlet weak var mainCoinComboBox: NSComboBox!
    @IBOutlet weak var mainFiatComboBox: NSComboBox!
    @IBOutlet weak var autoRefreshComboBox: NSComboBox!
    
    // MARK: - Controller lifecycle
    
    override func viewDidAppear() {
        restoreAPIKey()
        
        restoreMainCoin()
        restoreMainFiat()
        restoreRefresh()
    }
    
    override func viewDidDisappear() {
        saveAPIKey()
        
        saveMainCoin()
        saveMainFiat()
        saveRefresh()
    }
    
    // MARK: - API key loading & saving
    
    private func saveAPIKey() {
        KeychainHelper.shared.updateKey(key: apiKeyTextField.stringValue)
    }
    
    private func restoreAPIKey() {
        apiKeyTextField.stringValue = KeychainHelper.shared.readKey() ?? ""
    }
    
    // MARK: - Other settings loading & saving
    
    private func saveMainCoin() {
        let selectedCoin = Coin.coins[mainCoinComboBox.indexOfSelectedItem]
        SettingsHelper.shared.updateMainCoin(coin: selectedCoin)
    }
    
    private func restoreMainCoin() {
        mainCoinComboBox.removeAllItems()
        Coin.coins.forEach { coin in
            mainCoinComboBox.addItem(withObjectValue: coin.name)
        }
        
        let mainCoinSymbol = SettingsHelper.shared.readMainCoin()?.symbol ?? "ETH"
        let mainCoinIndex = Coin.coins.index(where: { $0.symbol == mainCoinSymbol }) ?? 0
        
        mainCoinComboBox.selectItem(at: mainCoinIndex)
    }
    
    private func saveMainFiat() {
        let selectedFiat = Coin.fiats[mainFiatComboBox.indexOfSelectedItem]
        SettingsHelper.shared.updateMainFiat(fiat: selectedFiat)
    }
    
    private func restoreMainFiat() {
        mainFiatComboBox.removeAllItems()
        Coin.fiats.forEach { coin in
            mainFiatComboBox.addItem(withObjectValue: coin.name)
        }
        
        let mainFiatSymbol = SettingsHelper.shared.readMainFiat()?.symbol ?? "USD"
        let mainFiatIndex = Coin.fiats.index(where: { $0.symbol == mainFiatSymbol }) ?? 0
        
        mainFiatComboBox.selectItem(at: mainFiatIndex)
    }
    
    private func saveRefresh() {
        let selectedStatus = RefreshStatus.status[autoRefreshComboBox.indexOfSelectedItem]
        SettingsHelper.shared.updateAutoRefreshStatus(status: selectedStatus)
    }
    
    private func restoreRefresh() {
        autoRefreshComboBox.removeAllItems()
        RefreshStatus.status.forEach { status in
            autoRefreshComboBox.addItem(withObjectValue: status.name)
        }
        let autoRefreshStatusName = SettingsHelper.shared.readAutoRefreshStatus()?.name ?? RefreshStatus.defaultRefreshStatus
        let autoRefreshStatusIndex = RefreshStatus.status.index(where: { $0.name == autoRefreshStatusName }) ?? 0
        
        autoRefreshComboBox.selectItem(at: autoRefreshStatusIndex)
    }
    
}
