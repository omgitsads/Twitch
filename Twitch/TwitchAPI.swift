//
//  TwitchAPI.swift
//  Twitch
//
//  Created by Adam Holt on 17/03/2016.
//  Copyright © 2016 Adam Holt. All rights reserved.
//

import Foundation
import ReactiveMoya

enum TwitchAPI {
    case TopGames
    case Streams
    case Stream(stream: String)
    case Channel(channel: String)
    case GameStreams(game: String)
    case FeaturedStreams
    case FollowedStreams
    case TopVideos
}

extension TwitchAPI : TargetType {
    var path: String {
        switch self {
        case .TopGames:
            return "/games/top"
        case .GameStreams(_):
            return "/streams"
        case .Streams:
            return "/streams"
        case .Stream(let stream):
            return "/streams/\(stream)"
        case .Channel(let channel):
            return "/channels/\(channel)"
        case .FeaturedStreams:
            return "/streams/featured"
        case .FollowedStreams:
            return "/streams/followed"
        case .TopVideos:
            return "/videos/top"
        }
    }
    
    var base: String { return "https://api.twitch.tv/kraken" }
    var baseURL: NSURL { return NSURL(string: base)! }
    
    var parameters: [String: AnyObject]? {
        switch self {
        case .GameStreams(let game):
            return ["game": game]
        default:
            return nil
        }
    }
    
    var method: ReactiveMoya.Method {
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