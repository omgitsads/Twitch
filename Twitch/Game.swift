//
//  Game.swift
//  Twitch
//
//  Created by Adam Holt on 04/04/2016.
//  Copyright © 2016 Adam Holt. All rights reserved.
//

import Cocoa
import ObjectMapper

class Game: Mappable {
    var name: String?
    var id: Int?
    var giantBombId: Int?
    var logo: NSURL?
    var box: NSURL?
    
    var logoImages: Dictionary<String, String>?
    var boxImages: Dictionary<String, String>?
    
    var viewers: Int?
    var channels: Int?
    
    static let gameCache = NSCache()

    var boxImage: NSImage? {
        get {
            if let image = Game.gameCache.objectForKey("game:box:\(self.id)") {
                return image as? NSImage
            } else {
                return Optional()
            }
        }
        set(newImage) {
            Game.gameCache.setObject(newImage!, forKey: "game:box:\(self.id)")
        }
    }
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["game.name"]
        id <- map["game._id"]
        giantBombId <- map["game.giantbomb_id"]
        logo <- (map["game.logo.large"], URLTransform())
        box <- (map["game.box.large"], URLTransform())
        
        logoImages <- map["game.logo"]
        boxImages <- map["game.box"]
        
        viewers <- map["viewers"]
        channels <- map["channels"]
    }
}
