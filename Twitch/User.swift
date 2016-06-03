//
//  User.swift
//  Twitch
//
//  Created by Adam Holt on 04/04/2016.
//  Copyright © 2016 Adam Holt. All rights reserved.
//

import Cocoa
import ObjectMapper

class User: Mappable {
    var type: String?
    var name: String?
    var displayName: String?
    var bio: String?
    var id: Int?
    var logo: NSURL?
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        type <- map["type"]
        name <- map["name"]
        displayName <- map["display_name"]
        bio <- map["bio"]
        logo <- (map["bio"], URLTransform())
    }
}
