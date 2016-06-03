//
//  StreamViewController.swift
//  Twitch
//
//  Created by Adam Holt on 15/04/2016.
//  Copyright © 2016 Adam Holt. All rights reserved.
//

import Cocoa
import AVFoundation
import AVKit
import CocoaAsyncSocket

class StreamViewController: TwitchViewController {
    var collectionView: NSCollectionView!
    var stream: Stream!
    @IBOutlet weak var playerView: AVPlayerView!
    var socket: GCDAsyncSocket!
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.startStream()
        self.socket = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        
        do {
            try socket.connectToHost("irc.chat.twitch.tv", onPort: 6667)
            socket.readDataToData(GCDAsyncSocket.CRLFData(), withTimeout: -1, tag: 0)
        } catch {
            print("Failed to connect to host")
        }
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        if let player = self.playerView.player {
            player.pause()
        }
    }
    
    func startStream() {
        stream.playlist().observeNext { (playlist) in
            if let source = playlist.streamList.first {
                let player = AVPlayer(URL: source.url!)
                self.playerView.controlsStyle = AVPlayerViewControlsStyle.None
                self.playerView.showsFullScreenToggleButton = true
                self.playerView.player = player
                player.play()
            }
        }
    }
}

extension StreamViewController: NSCollectionViewDelegate {
    
}

extension StreamViewController: NSCollectionViewDataSource {
    func collectionView(collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6;
    }
    
    func collectionView(collectionView: NSCollectionView, itemForRepresentedObjectAtIndexPath indexPath: NSIndexPath) -> NSCollectionViewItem {
        let cell = collectionView.makeItemWithIdentifier("StreamPanelItem", forIndexPath: indexPath)
        
        return cell
    }
}

extension StreamViewController: GCDAsyncSocketDelegate {
    func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        // login
        let pass = "PASS oauth:zrchcmkt0h4zxp2sag7to3u9io96w0\r\n"
        self.socket.writeData(pass.dataUsingEncoding(NSUTF8StringEncoding), withTimeout: -1, tag: 1)
        let nick = "NICK omgitsads\r\n"
        self.socket.writeData(nick.dataUsingEncoding(NSUTF8StringEncoding), withTimeout: -1, tag: 2)
        let join = "JOIN #\(self.stream.name!)\r\n"
        self.socket.writeData(join.dataUsingEncoding(NSUTF8StringEncoding), withTimeout: -1, tag: 3)
        let commands = "CAP REQ :twitch.tv/commands\r\n"
        self.socket.writeData(commands.dataUsingEncoding(NSUTF8StringEncoding), withTimeout: -1, tag: 4)
        let memberships = "CAP REQ :twitch.tv/membership\r\n"
        self.socket.writeData(memberships.dataUsingEncoding(NSUTF8StringEncoding), withTimeout: -1, tag: 5)
        let tags = "CAP REQ :twitch.tv/tags\r\n"
        self.socket.writeData(tags.dataUsingEncoding(NSUTF8StringEncoding), withTimeout: -1, tag: 6)
    }
    
    func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        if let string = String(data: data, encoding: NSUTF8StringEncoding) {
            print(string)
            
            if let match = string.rangeOfString("^PING", options: .RegularExpressionSearch) {
                let ping = "PONG :tmi.twitch.tv"
                sock.writeData(ping.dataUsingEncoding(NSUTF8StringEncoding), withTimeout: -1, tag: 5)
            }
        }
        
        self.socket.readDataToData(GCDAsyncSocket.CRLFData(), withTimeout: -1, tag: 0)
    }
}