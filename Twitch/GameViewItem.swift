//
//  GameViewItem.swift
//  Twitch
//
//  Created by Adam Holt on 04/04/2016.
//  Copyright © 2016 Adam Holt. All rights reserved.
//

import Cocoa
import Alamofire
import ObjectMapper

class GameViewItem: NSCollectionViewItem {
    @IBOutlet weak var gameNameLabel: NSTextField!
    @IBOutlet weak var viewersLabel: NSTextField!
    @IBOutlet weak var streamsLabel: NSTextField!
    
    var imageRequest: Request?
    var record: protocol<Mappable>!
    
    var game: Game! {
        get {
            return self.record as! Game
        }
    }
    
    override func viewDidDisappear() {
        self.imageRequest?.cancel()
    }
    
    func setup() {
        self.gameNameLabel.stringValue = ""
        self.imageView?.image = NSImage(named: "box-default")
        
        if let boxImage = self.game.boxImage {
            self.imageView?.image = boxImage
        } else {
            // Cancel the existing request if it's running
            self.imageRequest?.cancel()
            
            // Start a new request to fetch the box artwork
            self.imageRequest = Alamofire.request(.GET, self.game.box!.absoluteString)
            
            // Assign the box artwork if the request was successful.
            self.imageRequest!.responseData { response in
                if response.result.isSuccess {
                    // If the image was 404, we don't need to create a new one.
                    if (response.response?.URL?.path != "/ttv-static/404_boxart-272x380.jpg") {
                        self.game.boxImage = NSImage(data:  response.result.value!)
                        self.imageView?.image = self.game.boxImage
                    } else {
                        self.gameNameLabel.stringValue = self.game.name!
                    }
                }
            }
        }
        
        self.viewersLabel?.stringValue = "\(self.game.viewers!) viewers"
        self.streamsLabel?.stringValue = "\(self.game.channels!) streams"
    }
}
