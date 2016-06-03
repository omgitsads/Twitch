//
//  TwitchWindowController.swift
//  Twitch
//
//  Created by Adam Holt on 18/03/2016.
//  Copyright © 2016 Adam Holt. All rights reserved.
//

import Cocoa

class TwitchWindowController: NSWindowController {

    @IBOutlet weak var spacerToolbar: JWToolbarAdaptiveSpaceItem!
    @IBOutlet weak var splitView: MDPSplitView!
    
    @IBOutlet weak var menuBarSplit: NSView!
    @IBOutlet weak var menuWidthConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var menuBarController: MenuBarController!
    @IBOutlet weak var navigationController: TwitchNavigationController!
    
    var lastMenuBarWidth: CGFloat = 110.0
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        if let aWindow = self.window {
            aWindow.titleVisibility = .Hidden
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TwitchWindowController.didLogin(_:)), name: Twitch.DidAuthenticate, object: nil)
        
        let gamesViewController = GamesCollectionViewController(nibName: "GamesCollectionView", bundle: nil)!
        self.navigationController.setRootViewController(gamesViewController)
    }
    
    func mainSplitViewWillResizeSubviewsHandler(notification: NSNotification) {
        if let menuWidth = self.menuBarSplit?.frame.size.width {
            self.lastMenuBarWidth = menuWidth
        }
    }
    
    @IBAction func toggleMenu(sender: AnyObject) {
        if let aSplitView = self.splitView {
            aSplitView.adjustSubviews()
            
            if aSplitView.isSubviewCollapsed(self.menuBarSplit) || self.menuBarSplit!.frame.size.width == 0 {
                var width: CGFloat
                
                if self.lastMenuBarWidth < 10 {
                    width = 250.0
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
        let scopes = "user_read+user_follows_edit+user_subscriptions+chat_login+channel_feed_read+channel_feed_edit"
        let url = NSURL(string: "https://api.twitch.tv/kraken/oauth2/authorize?response_type=token&client_id=\(clientId)&redirect_uri=\(redirectUri)&scopes=\(scopes)")!
        
        NSWorkspace.sharedWorkspace().openURL(url)
    }
    
    func didLogin(notification: NSNotification) {
        print("Logged In: \(notification.object as! String)")
    }
}