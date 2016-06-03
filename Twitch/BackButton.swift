//
//  BackButton.swift
//  Twitch
//
//  Created by Adam Holt on 21/09/15.
//  Copyright © 2015 OMGITSADS. All rights reserved.
//

import Cocoa

class BackButton: NSButton {
    override func drawRect(dirtyRect: NSRect) {
        TwitchStyleKit.drawBackIcon(frame: dirtyRect)
    }
}
