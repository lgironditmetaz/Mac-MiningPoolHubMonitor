//
//  AppDelegate.swift
//  MiningPoolHub Monitor
//
//  Created by Loïc GIRON DIT METAZ on 28/02/2018.
//  Copyright © 2018 LgdLab. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            sender.windows.first?.makeKeyAndOrderFront(self)
            return true
        } else {
            return false
        }
    }
    
}
