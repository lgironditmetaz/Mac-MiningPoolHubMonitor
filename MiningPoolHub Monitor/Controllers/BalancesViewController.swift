//
//  BalancesViewController.swift
//  MiningPoolHub Monitor
//
//  Created by Loïc GIRON DIT METAZ on 28/02/2018.
//  Copyright © 2018 LgdLab. All rights reserved.
//

import Cocoa

class BalancesViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.view.window?.titleVisibility = NSWindow.TitleVisibility.hidden
    }
    
    var balances: [Balance] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
}

extension BalancesViewController : NSTableViewDataSource, NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let CoinCell = "CoinCellID"
        static let WalletCell = "WalletCellID"
        static let AutoExchangeCell = "AutoExchangeCellID"
        static let OnExchangeCell = "OnExchangeCellID"
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return balances.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let balance = balances[row]
        
        let cellIdentifier: String = {
            if tableColumn == tableView.tableColumns[0] {
                return CellIdentifiers.CoinCell
            } else if tableColumn == tableView.tableColumns[1] {
                return CellIdentifiers.WalletCell
            } else if tableColumn == tableView.tableColumns[2] {
                return CellIdentifiers.AutoExchangeCell
            } else if tableColumn == tableView.tableColumns[3] {
                return CellIdentifiers.OnExchangeCell
            } else {
                return ""
            }
        }()
        
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(cellIdentifier), owner: nil) as? NSTableCellView else {
            return nil
        }
        
        cell.textField?.stringValue = {
            if tableColumn == tableView.tableColumns[0] {
                return balance.coinName
            } else if tableColumn == tableView.tableColumns[1] {
                return balanceString(confirmedBalance: balance.confirmedBalance, unconfirmedBalance: balance.unconfirmedBalance)
            } else if tableColumn == tableView.tableColumns[2] {
                return balanceString(confirmedBalance: balance.confirmedAutoExchangeBalance, unconfirmedBalance: balance.unconfirmedAutoExchangeBalance)
            } else if tableColumn == tableView.tableColumns[3] {
                return balanceString(confirmedBalance: balance.exchangeBalance, unconfirmedBalance: nil)
            } else {
                return ""
            }
        }()
        
        return cell
    }
    
    private func balanceString(confirmedBalance: Double, unconfirmedBalance: Double?) -> String {
        let confirmedString = balanceString(balance: confirmedBalance)
        if let unconfirmedBalance = unconfirmedBalance, unconfirmedBalance > 0 {
            return "\(confirmedString) (\(balanceString(balance: unconfirmedBalance)))"
        } else {
            return confirmedString
        }
    }
    
    private func balanceString(balance: Double) -> String {
        if balance == 0 {
            return "0"
        } else {
            return BalanceFormatter.shared.string(balance: balance, currency: .coin)
        }
    }
    
}
