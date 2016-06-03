//
//  Stream.swift
//  Twitch
//
//  Created by Adam Holt on 10/04/2016.
//  Copyright © 2016 Adam Holt. All rights reserved.
//

import Cocoa
import ObjectMapper
import ReactiveCocoa
import Alamofire
import SwiftyJSON

class Stream: Mappable {
    var name: String?
    var status: String?
    var id: Int?
    
    var game: String?
    
    var logo: NSURL?
    var banner: NSURL?
    var videoBanner: NSURL?
    var profileBanner: NSURL?
    
    var preview: NSURL?
    
    var previewImages: Dictionary<String, String>?
    
    var viewers: Int?
    var views: Int?
    var followers: Int?
    
    static let cache = NSCache()
    
    var previewImage: NSImage? {
        get {
            if let image = Stream.cache.objectForKey("stream:preview:\(self.id)") {
                return image as? NSImage
            } else {
                return Optional()
            }
        }
        set(newImage) {
            Stream.cache.setObject(newImage!, forKey: "stream:preview:\(self.id)")
        }
    }
    
    required init?(_ map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["channel.name"]
        status <- map["channel.status"]
        id <- map["_id"]
        
        logo <- (map["channel.logo"], URLTransform())
        banner <- (map["channel.banner"], URLTransform())
        videoBanner <- (map["channel.video_banner"], URLTransform())
        profileBanner <- (map["channel.profile_banner"], URLTransform())
        
        preview <- (map["preview.large"], URLTransform())
        previewImages <- map["preview"]
        
        viewers <- map["viewers"]
        views <- map["channel.views"]
        followers <- map["channel.followers"]
    }
    
    func playlist() -> Signal<M3U8MasterPlaylist, NSError> {
        let (signal, observer) = Signal<M3U8MasterPlaylist, NSError>.pipe()
        
        let tokenURL = "https://api.twitch.tv/api/channels/\(self.name!)/access_token"

        Alamofire.request(.GET, tokenURL).response { (req, res, data, error) -> Void in
            let tokenResponse = JSON(data: data!).dictionary!

            let random = Int(arc4random_uniform(999999))
            let usherURL = "http://usher.twitch.tv/api/channel/hls/\(self.name!).m3u8"
            let usherParams = [
                "player": "twitchweb",
                "token": tokenResponse["token"]!.string!,
                "sig": tokenResponse["sig"]!.string!,
                "allow_audio_only": "true",
                "allow_source": "true",
                "type": "any",
                "p": random
            ]
        
            Alamofire.request(.GET, usherURL, parameters: usherParams as! [String: AnyObject], encoding: .URL, headers: nil).responseString { (response) -> Void in
                if response.result.isSuccess {
                    let masterPlaylist = M3U8MasterPlaylist(playlist: response.result.value!)
                    do {
                        try masterPlaylist.parse()
                    } catch let error as NSError {
                        observer.sendFailed(error)
                    }
                    
                    observer.sendNext(masterPlaylist)
                    observer.sendCompleted()
                } else {
                    observer.sendFailed(response.result.error!)
                }
            }
        }
        
        return signal
    }
}