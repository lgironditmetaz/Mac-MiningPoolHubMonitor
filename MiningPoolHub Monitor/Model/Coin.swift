//
//  Coin.swift
//  MiningPoolHub Monitor
//
//  Created by Loïc GIRON DIT METAZ on 02/03/2018.
//  Copyright © 2018 LgdLab. All rights reserved.
//

import Foundation

class Coin : CustomStringConvertible {
    
    static let coins = [
        Coin(name: "adzcoin", symbol: "ADZ"),
        Coin(name: "auroracoin", symbol: "AUR"),
        Coin(name: "bitcoin", symbol: "BTC"),
        Coin(name: "bitcoin-cash", symbol: "BCH"),
        Coin(name: "bitcoin-gold", symbol: "BTG"),
        Coin(name: "dash", symbol: "DSH"),
        Coin(name: "digibyte", symbol: "DGB"),
        Coin(name: "digibyte-groestl", symbol: "DGB"),
        Coin(name: "digibyte-skein", symbol: "DGB"),
        Coin(name: "digibyte-qubit", symbol: "DGB"),
        Coin(name: "ethereum", symbol: "ETH"),
        Coin(name: "ethereum-classic", symbol: "ETC"),
        Coin(name: "expanse", symbol: "EXP"),
        Coin(name: "feathercoin", symbol: "FTC"),
        Coin(name: "gamecredits", symbol: "GAME"),
        Coin(name: "geocoin", symbol: "GEO"),
        Coin(name: "globalboosty", symbol: "BSTY"),
        Coin(name: "groestlcoin", symbol: "GRS"),
        Coin(name: "litecoin", symbol: "LTC"),
        Coin(name: "maxcoin", symbol: "MAX"),
        Coin(name: "monacoin", symbol: "MONA"),
        Coin(name: "musicoin", symbol: "MUSIC"),
        Coin(name: "myriadcoin", symbol: "XMY"),
        Coin(name: "myriadcoin-skein", symbol: "XMY"),
        Coin(name: "myriadcoin-groestl", symbol: "XMY"),
        Coin(name: "myriadcoin-yescrypt", symbol: "XMY"),
        Coin(name: "sexcoin", symbol: "SXC"),
        Coin(name: "siacoin", symbol: "SC"),
        Coin(name: "startcoin", symbol: "START"),
        Coin(name: "verge", symbol: "XVG"),
        Coin(name: "vertcoin", symbol: "VTC"),
        Coin(name: "zcash", symbol: "ZEC"),
        Coin(name: "zclassic", symbol: "ZCL"),
        Coin(name: "zcoin", symbol: "XZC"),
        Coin(name: "zencash", symbol: "ZEN")
    ]
    
    static let fiats = [
        Coin(name: "Euro", symbol: "EUR"),
        Coin(name: "US Dollar", symbol: "USD")
    ]
    
    static func coin(fromSymbol symbol: String) -> Coin? {
        return coin(fromSymbol: symbol, coins: coins)
    }
    
    static func coin(fromName name: String) -> Coin? {
        return coin(fromName: name, coins: coins)
    }
    
    static func fiat(fromSymbol symbol: String) -> Coin? {
        return coin(fromSymbol: symbol, coins: fiats)
    }
    
    static func fiat(fromName name: String) -> Coin? {
        return coin(fromName: name, coins: fiats)
    }
    
    static func coin(fromSymbol symbol: String, coins: [Coin]) -> Coin? {
        return coins.filter({ coin in coin.symbol == symbol }).first
    }
    
    static func coin(fromName name: String, coins: [Coin]) -> Coin? {
        return coins.filter({ coin in coin.name == name }).first
    }
    
    let name: String
    let symbol: String
    
    private init(name: String, symbol: String) {
        self.name = name
        self.symbol = symbol
    }
    
    var description: String {
        return "Coin(\(name))"
    }
    
}
