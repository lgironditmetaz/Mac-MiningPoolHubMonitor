//
//  BalancesWindow.swift
//  MiningPoolHub Monitor
//
//  Created by Loïc GIRON DIT METAZ on 01/03/2018.
//  Copyright © 2018 LgdLab. All rights reserved.
//

import Cocoa

class BalancesWindowController : NSWindowController {
    
    class BalanceSummary {
        
        public let coinSymbol: String
        public let coinBalance: Double
        public let fiatSymbol: String
        public let fiatBalance: Double
        
        init(coinSymbol: String, coinBalance: Double, fiatSymbol: String, fiatBalance: Double) {
            self.coinSymbol = coinSymbol
            self.coinBalance = coinBalance
            self.fiatSymbol = fiatSymbol
            self.fiatBalance = fiatBalance
        }
    }
    
    @IBOutlet weak var refreshIndicator: NSProgressIndicator!
    @IBOutlet weak var refreshButton: NSButton!
    @IBOutlet weak var balanceLabel: NSTextField!
    
    private var refreshInProgress = false
    private var lastSuccessfulRefresh: Date?
    private let autoRefreshTimerInterval: TimeInterval = 60.0
    
    private var balanceSummary: BalanceSummary?
    
    private lazy var balancesViewController = {
       return self.contentViewController as! BalancesViewController
    }()
    
    // MARK: - Controller lifecycle
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        showRefreshIndicator(false)
        enableRefreshButton(true)
        showBalanceLabel(false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshBalances()
            self.startAutoRefreshTimer()
        }
    }
    
    // MARK: - UI handling
    
    private func showRefreshIndicator(_ show: Bool) {
        if show {
            refreshIndicator.startAnimation(self)
            refreshIndicator.isHidden = false
        } else {
            refreshIndicator.isHidden = true
        }
    }
    
    private func enableRefreshButton(_ enable: Bool) {
        refreshButton.isEnabled = enable
        self.touchBar = nil
    }
    
    private func showBalanceLabel(_ show: Bool) {
        balanceLabel.isHidden = !show
    }
    
    private func balanceLabelDescription() -> String {
        guard let balanceSummary = self.balanceSummary else {
            return ""
        }
        
        let coinBalanceString = BalanceFormatter.shared.string(balance: balanceSummary.coinBalance, currency: .coin)
        let fiatBalanceString = BalanceFormatter.shared.string(balance: balanceSummary.fiatBalance, currency: .fiat)
        
        return "\(balanceSummary.coinSymbol) \(coinBalanceString) • \(balanceSummary.fiatSymbol) \(fiatBalanceString)"
    }
    
    private func updateBalanceLabel(coinSymbol: String, coinBalance: Double, fiatSymbol: String, fiatBalance: Double) {
        self.balanceSummary = BalanceSummary(coinSymbol: coinSymbol, coinBalance: coinBalance, fiatSymbol: fiatSymbol, fiatBalance: fiatBalance)
        
        showBalanceLabel(true)
        balanceLabel.stringValue = balanceLabelDescription()
        
        self.touchBar = nil
    }
    
    // MARK: - Toolbar actions
    
    @IBAction func refreshButtonAction(_ sender: Any) {
        refreshBalances()
    }
    
    // MARK: - Auto refresh timer
    
    private func startAutoRefreshTimer() {
        Timer.scheduledTimer(withTimeInterval: autoRefreshTimerInterval, repeats: true) { _ in
            
            guard let autoRefreshInterval = SettingsHelper.shared.readAutoRefreshStatus()?.interval else {
                NSLog("[Auto Balance Refresh] NOT DONE - auto refresh not activated")
                return
            }
            
            guard self.refreshInProgress == false else {
                NSLog("[Auto Balance Refresh] NOT DONE - refresh already in progress")
                return
            }
            
            guard let lastSuccessfulRefresh = self.lastSuccessfulRefresh else {
                NSLog("[Auto Balance Refresh] NOT DONE - last refresh was less than \(autoRefreshInterval) seconds ago")
                return
            }
            
            guard Date().timeIntervalSince1970 - lastSuccessfulRefresh.timeIntervalSince1970 >= autoRefreshInterval else {
                NSLog("[Auto Balance Refresh] NOT DONE - last refresh was less than \(autoRefreshInterval) seconds ago")
                return
            }
            
            NSLog("[Auto Balance Refresh] DONE - auto refresh launched")
            self.refreshBalances()
        }
    }
    
    // MARK: - Webservices
    
    @objc func refreshBalances() {
        
        // Disabling refresh button
        enableRefreshButton(false)
        showRefreshIndicator(true)
        
        // Retrieve API Key from keychain
        guard let apiKey = KeychainHelper.shared.readKey(), apiKey.count > 0 else {
            
            // Display an error if no API Key defined
            let alert = NSAlert()
            alert.messageText = "API Key not defined"
            alert.informativeText = "Please set your API Key in the Settings. Click on the gear icon in the toolbar.\nThis app can't work without a valid API Key!"
            alert.addButton(withTitle: "Ok")
            alert.alertStyle = NSAlert.Style.critical
            alert.beginSheetModal(for: self.window!) { (response) in
                DispatchQueue.main.async {
                    
                    // Enabling refresh button back
                    self.enableRefreshButton(true)
                    self.showRefreshIndicator(false)
                    
                }
            }
            
            return
        }
        
        // The refresh starts now, it will be considered as done when the Cryptonator API returns a result (no
        // matter if its a success or a failure), when the balance is updated without a call to Cryptonator API
        // or when the balances retrieved from MiningPoolHub API are invalid.
        self.refreshInProgress = true
        
        MiningPoolHubAPI().balances(forAPIKey: apiKey) { (balances, error) in
            DispatchQueue.main.async {
                
                // Enabling refresh button back
                self.enableRefreshButton(true)
                self.showRefreshIndicator(false)
                
                // Checking result
                guard let balances = balances, error == nil else {
                    if let error = error {
                        NSLog("Error when fetching balances: \(error.localizedDescription)")
                    }
                    
                    self.refreshInProgress = false
                    
                    return
                }
                
                // Update the main balance label
                if let mainCoin = SettingsHelper.shared.readMainCoin(),
                    let mainFiat = SettingsHelper.shared.readMainFiat() {
                        
                    if let balance = balances.filter({ balance in balance.coinName == mainCoin.name}).first {
                        
                        // Using the API if we have a balance
                        CryptonatorAPI().rate(base: mainCoin, target: mainFiat) { rate, error in
                            
                            self.refreshInProgress = false
                            
                            guard let rate = rate, error == nil else {
                                if let error = error {
                                    NSLog("Error when fetching rate: \(error.localizedDescription)")
                                }
                                return
                            }
                            
                            self.lastSuccessfulRefresh = Date()
                            
                            DispatchQueue.main.async {
                                // Updating fiat value
                                let coinValue = balance.confirmedBalance
                                let fiatValue = coinValue * rate.price
                                
                                self.updateBalanceLabel(coinSymbol: mainCoin.symbol, coinBalance: coinValue, fiatSymbol: mainFiat.symbol, fiatBalance: fiatValue)
                            }
                            
                        }
                        
                    } else {
                        
                        self.refreshInProgress = false
                        self.lastSuccessfulRefresh = Date()
                        
                        DispatchQueue.main.async {
                            // No need to call the API if the balance is 0
                            self.updateBalanceLabel(coinSymbol: mainCoin.symbol, coinBalance: 0, fiatSymbol: mainFiat.symbol, fiatBalance: 0)
                        }
                        
                    }
                }
                
                // The result can be displayed to the user
                self.balancesViewController.balances = balances
            }
        }
    }
    
}

extension NSTouchBarItem.Identifier {
    static let balanceLabel = NSTouchBarItem.Identifier("org.lgdlab.macos.MiningPoolHub-Monitor.balanceLabel")
    static let refreshButton = NSTouchBarItem.Identifier("org.lgdlab.macos.MiningPoolHub-Monitor.refreshButton")
}

extension BalancesWindowController: NSTouchBarDelegate {
    
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.defaultItemIdentifiers = [.flexibleSpace, .balanceLabel, .flexibleSpace, .refreshButton]
        return touchBar
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        switch identifier {
        case NSTouchBarItem.Identifier.refreshButton:
            let item = NSCustomTouchBarItem(identifier: identifier)
            let button = NSButton(image: NSImage(named: .refreshTemplate)!, target: self, action: #selector(refreshBalances))
            button.isEnabled = refreshButton.isEnabled
            item.view = button
            return item
            
        case NSTouchBarItem.Identifier.balanceLabel:
            let item = NSCustomTouchBarItem(identifier: identifier)
            item.view = NSTextField(labelWithString: balanceLabelDescription())
            return item
            
        default:
            return nil
        }
    }
    
}
