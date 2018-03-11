//
//  RefreshStatus.swift
//  MiningPoolHub Monitor
//
//  Created by Loïc GIRON DIT METAZ on 09/03/2018.
//  Copyright © 2018 LgdLab. All rights reserved.
//

import Foundation

class RefreshStatus {
    
    static let defaultRefreshStatus = "Every 15 minutes"
    
    static let status = [
        RefreshStatus(name: "Never", interval: nil),
        RefreshStatus(name: defaultRefreshStatus, interval: 15 * 60),
        RefreshStatus(name: "Every 30 minutes", interval: 30 * 60),
        RefreshStatus(name: "Every hour", interval: 60 * 60),
    ]
    
    let name: String
    let interval: TimeInterval?
    
    static func refreshStatus(fromInterval interval: TimeInterval?) -> RefreshStatus? {
        return status.filter({ status in status.interval == interval }).first
    }

    init(name: String, interval: TimeInterval?) {
        self.name = name
        self.interval = interval
    }
    
}
