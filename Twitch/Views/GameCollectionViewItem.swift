//
//  GameCollectionViewItem.swift
//  Twitch
//
//  Created by Adam Holt on 13.09.18.
//  Copyright © 2018 Adam Holt. All rights reserved.
//

import Cocoa

class GameCollectionViewItem: NSCollectionViewItem {
    @IBOutlet weak var gameNameLabel: NSTextField?
    @IBOutlet weak var viewersLabel: NSTextField?
    @IBOutlet weak var streamsLabel: NSTextField?
    
    var _gameViewModel: GameViewModel!
    var gameViewModel: GameViewModel! {
        get {
            return _gameViewModel
        }
        set {
            self._gameViewModel = newValue
            self.setup()
        }
    }
    
    func setup() {
        self.gameNameLabel?.stringValue = self.gameViewModel.name
        self.imageView?.image = NSImage(named: NSImage.Name(rawValue: "box-default"))
        
        self.viewersLabel?.stringValue = "\(self.gameViewModel.viewersCount) viewers"
        self.streamsLabel?.stringValue = "\(self.gameViewModel.broadcastersCount) streams"
    }
}
