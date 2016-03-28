//
//  TwitchWindowController.swift
//  Twitch
//
//  Created by Adam Holt on 18/03/2016.
//  Copyright © 2016 Adam Holt. All rights reserved.
//

import Cocoa

class TwitchWindowController: NSWindowController {

    @IBOutlet weak var spacerToolbar: JWToolbarAdaptiveSpaceItem?
    
    var splitView: MDPSplitView? { return self.window?.contentView?.subviews.first as? MDPSplitView }
    
    var menuBarSplit: NSView? { return splitView?.subviews.first }
    
    @IBOutlet weak var menuWidthConstraint: NSLayoutConstraint?
    
    var lastMenuBarWidth: CGFloat = 110.0
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        if let aWindow = self.window {
            aWindow.titleVisibility = .Hidden
        }
        
        if let aSplitView = self.splitView {
            if let leftSplit = aSplitView.subviews.first {
                self.spacerToolbar?.linkedView = leftSplit
            }
        }
    }
    
    func mainSplitViewWillResizeSubviewsHandler(notification: NSNotification) {
        if let menuWidth = self.menuBarSplit?.frame.size.width {
            print(menuWidth)
            self.lastMenuBarWidth = menuWidth
        }
    }
    
    @IBAction func toggleMenu(sender: AnyObject) {
        if let aSplitView = self.splitView {
            aSplitView.adjustSubviews()
            
            if aSplitView.isSubviewCollapsed(self.menuBarSplit!) || self.menuBarSplit!.frame.size.width == 0 {
                var width: CGFloat
                
                if self.lastMenuBarWidth < 10 {
                    width = 110.0
                } else {
                    width = self.lastMenuBarWidth
                }
                
                aSplitView.setPosition(width, ofDividerAtIndex: 0, animated: true)
            } else {
                if let menuWidth = self.menuBarSplit?.frame.size.width { self.lastMenuBarWidth = menuWidth }
                aSplitView.setPosition(aSplitView.minPossiblePositionOfDividerAtIndex(0), ofDividerAtIndex: 0, animated: true)
            }
        }
    }
    
    @IBAction func login(sender: AnyObject) {
        let clientId = "qpc3uyx3odeip09jbgz4nweuef19r2g"
        let redirectUri = "twitchmac://login"
        let scopes = "user_read+user_subscriptions+chat_login"
        let url = NSURL(string: "https://api.twitch.tv/kraken/oauth2/authorize?response_type=token&client_id=\(clientId)&redirect_uri=\(redirectUri)&scopes=\(scopes)")!
        
        NSWorkspace.sharedWorkspace().openURL(url)
    }
}