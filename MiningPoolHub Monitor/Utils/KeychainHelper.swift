//
//  KeychainHelper.swift
//  MiningPoolHub Monitor
//
//  Created by Loïc GIRON DIT METAZ on 05/03/2018.
//  Copyright © 2018 LgdLab. All rights reserved.
//

import Foundation

class KeychainHelper {
    
    static let shared = KeychainHelper(account: "monitor")
    
    // Every access to the keychain will trigger a login popup if the user does not
    // want to give us permanent keychain access.
    // To reduce these login popups, the key is retrieved from the Keychain only
    // once, then stored in memory.
    private var key: String? = nil
    
    func readKey() -> String? {
        do {
            
            if self.key != nil {
                return self.key
            } else {
                self.key = try keychainPasswordItem().readPassword()
                return self.key
            }
            
        } catch let error {
            NSLog("Unable to read key: \(error)")
            return nil
        }
    }
    
    func updateKey(key: String) {
        do {
            
            guard key != self.key else {
                // No key update if not necessary to avoid displaying the login popup
                return
            }
            
            self.key = key
            try keychainPasswordItem().savePassword(key)
            
        } catch let error {
            NSLog("Unable to update key: \(error)")
        }
    }
    
    private let account: String
    
    private func keychainPasswordItem() -> KeychainPasswordItem {
        return KeychainPasswordItem(
            service: KeychainConfiguration.serviceName,
            account: self.account,
            accessGroup: KeychainConfiguration.accessGroup
        )
    }
    
    private init(account: String) {
        self.account = account
    }
    
}
