//
//  AppDelegate.swift
//  Twitch
//
//  Created by Adam Holt on 17/03/2016.
//  Copyright © 2016 Adam Holt. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        self.registerApplication()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    func registerApplication() {
//        [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(getUrl:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
        
        NSAppleEventManager.sharedAppleEventManager().setEventHandler(self, andSelector: #selector(AppDelegate.handleEvent(_:withReplyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }
    
    func handleEvent(event: NSAppleEventDescriptor!, withReplyEvent: NSAppleEventDescriptor) {
        let url = NSURL(string: event.paramDescriptorForKeyword(AEKeyword(keyDirectObject))!.stringValue!);
        
        let command = url?.host;
        let query = url?.fragment;
        
        if(command == "login") {
            let first_index = query!.rangeOfString("access_token=")?.endIndex;
            let last_index = query!.rangeOfString("&scope")?.startIndex;
            let accessToken = query!.substringWithRange(Range(first_index!..<last_index!));
            
            let notification = NSNotification(name: "TwitchDidAuthenticate", object: accessToken)
            NSNotificationCenter.defaultCenter().postNotification(notification)
        }
    }
}

