//
//  TwitchAPI.swift
//  Twitch
//
//  Created by Adam Holt on 17/03/2016.
//  Copyright © 2016 Adam Holt. All rights reserved.
//

import Foundation
import Moya

enum TwitchAPI {
    case TopGames(limit: Int, offset: Int)
    case Streams(limit: Int, offset: Int)
    case Stream(stream: String)
    case Channel(channel: String)
    case GameStreams(game: String, limit: Int, offset: Int)
    case FeaturedStreams
    case TopVideos
    case User
    case FollowedStreams
    case FollowedVideos
}

public func url(route: TargetType) -> String {
    return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString
}

let endpointClosure = { (target: TwitchAPI) -> Endpoint<TwitchAPI> in
    var endpoint: Endpoint<TwitchAPI> = Endpoint<TwitchAPI>(URL: url(target), sampleResponseClosure: {.NetworkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
    
    if let accessToken = NSUserDefaults.standardUserDefaults().objectForKey("TwitchAccessToken") {
        
        switch target {
        case .FollowedStreams, .FollowedVideos, .User:
            endpoint = endpoint.endpointByAddingHTTPHeaderFields(["Authorization": "OAuth \(accessToken as! String)"])
        default:
            break
        }
    }
    
    return endpoint
}

extension TwitchAPI : TargetType {
    var path: String {
        switch self {
        case .TopGames(_,_):
            return "/games/top"
        case .GameStreams(_,_,_):
            return "/streams"
        case .Streams(_,_):
            return "/streams"
        case .Stream(let stream):
            return "/streams/\(stream)"
        case .Channel(let channel):
            return "/channels/\(channel)"
        case .FeaturedStreams:
            return "/streams/featured"
        case .TopVideos:
            return "/videos/top"
        case .User:
            return "/user"
        case .FollowedStreams:
            return "/streams/followed"
        case .FollowedVideos:
            return "/videos/followed"
        }
    }
    
    var base: String { return "https://api.twitch.tv/kraken" }
    var baseURL: NSURL { return NSURL(string: base)! }
    
    var parameters: [String: AnyObject]? {
        switch self {
        case .TopGames(let limit, let offset):
            return ["limit": limit, "offset": offset]
        case .Streams(let limit, let offset):
            return ["limit": limit, "offset": offset]
        case .GameStreams(let game, let limit, let offset):
            return ["game": game, "limit": limit, "offset": offset]
        default:
            return nil
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .GET
        }
    }
    
    var sampleData: NSData {
        switch self {
        default:
            return NSData()
        }
    }
}