//
//  TwitchWindow.swift
//  Twitch
//
//  Created by Adam Holt on 11.09.18.
//  Copyright © 2018 Adam Holt. All rights reserved.
//

import Foundation
import Cocoa

class TwitchWindowController: NSWindowController {
    override func windowDidLoad() {
        let customToolbar = NSToolbar()
        customToolbar.showsBaselineSeparator = false
        window?.titlebarAppearsTransparent = true
        window?.titleVisibility = .hidden
        window?.toolbar = customToolbar
    }
    
    override func awakeFromNib() {
        
    }
    
    func splitViewDidResizeSubviews(_ notification: Notification) {
        
    }
}
