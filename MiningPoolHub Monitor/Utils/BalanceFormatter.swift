//
//  BalanceFormatter.swift
//  MiningPoolHub Monitor
//
//  Created by Loïc GIRON DIT METAZ on 01/03/2018.
//  Copyright © 2018 LgdLab. All rights reserved.
//

import Foundation

class BalanceFormatter {
    
    enum Currency {
        case coin
        case fiat
    }
    
    static let shared = BalanceFormatter()
    
    func string(balance: Double, currency: Currency) -> String {
        return optionalString(balance: balance, currency: currency) ?? "---"
    }
    
    private func optionalString(balance: Double, currency: Currency) -> String? {
        switch currency {
        case .coin:
            return coinFormatter.string(from: NSNumber(value: balance))
        case .fiat:
            return fiatFormatter.string(from: NSNumber(value: balance))
        }
    }
    
    private init() {}
    
    private lazy var coinFormatter = {
        return self.numberFormatter(fractionDigits: 8)
    }()
    
    private lazy var fiatFormatter = {
        return self.numberFormatter(fractionDigits: 2)
    }()
    
    private func numberFormatter(fractionDigits: Int) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = "."
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter
    }
    
}
