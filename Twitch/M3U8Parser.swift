//
//  M3U8Parser.swift
//  Twitch
//
//  Created by Adam Holt on 15/07/2015.
//  Copyright © 2015 OMGITSADS. All rights reserved.
//

import Foundation

enum M3U8Error: ErrorType {
    case InvalidM3U8File
}

struct M3U8Constants {
    static let Identifier = "#EXTM3U"
    static let Version = "#EXT-X-VERSION:"
    static let TwitchInfo = "#EXT-X-TWITCH-INFO:"
    static let Media = "#EXT-X-MEDIA:"
    static let StreamInfo = "#EXT-X-STREAM-INF:"
}

//#EXT-X-MEDIA:TYPE=VIDEO,GROUP-ID="audio_only",NAME="Audio Only",AUTOSELECT=NO,DEFAULT=NO
//#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=128000,CODECS="mp4a.40.2",VIDEO="audio_only"

struct MediaItem {
    // Media
    let name: String
    let type: String
    let groupId: String
    let autoSelect: Bool
    let isDefault: Bool
    
    var streamInfo: StreamInfo?
    var url: NSURL?
}

struct StreamInfo {
    // Stream Info
    let programId: Int
    let bandwidth: Int
    let codec: String
    let video: String
}

struct TwitchInfo {
    let node: String
    let manifestNode: String
    let serverTime: String
    let cluster: String
    let manifestCluster: String
}

class M3U8MasterPlaylist: NSObject {
    let playlist: String!
    var streamList = [MediaItem]()
    var twitchInfo: TwitchInfo?
    
    init(playlist: String) {
        self.playlist = playlist
    }
    
    func parse() throws {
        var lines = self.playlist.componentsSeparatedByString("\n")
        
        let m3ufile = lines.removeAtIndex(0)
        
        if(m3ufile != M3U8Constants.Identifier) {
            throw M3U8Error.InvalidM3U8File
        }
        
        var currentMediaItem: MediaItem?
        
        for line in lines {
            if line.hasPrefix(M3U8Constants.TwitchInfo) {
                let attributes = self.attributesFromLine(M3U8Constants.TwitchInfo, line: line)
                self.twitchInfo = TwitchInfo(node: attributes["NODE"]!, manifestNode: attributes["MANIFEST-NODE"]!, serverTime: attributes["SERVER-TIME"]!, cluster: attributes["CLUSTER"]!, manifestCluster: attributes["MANIFEST-CLUSTER"]!)
            } else if line.hasPrefix(M3U8Constants.Media) {
                let attributes = self.attributesFromLine(M3U8Constants.Media, line: line)
                
                var autoSelect: Bool
                if attributes["AUTOSELECT"] == "YES" {
                    autoSelect = true
                } else {
                    autoSelect = false
                }
                
                var isDefault: Bool
                if attributes["DEFAULT"] == "YES" {
                    isDefault = true
                } else {
                    isDefault = false
                }
                
                
                currentMediaItem = MediaItem(name: attributes["NAME"]!, type: attributes["TYPE"]!, groupId: attributes["GROUP-ID"]!, autoSelect: autoSelect, isDefault: isDefault, streamInfo: nil, url: nil)
            } else if line.hasPrefix(M3U8Constants.StreamInfo) {
                let attributes = self.attributesFromLine(M3U8Constants.StreamInfo, line: line)
                let programId = Int(attributes["PROGRAM-ID"]!)
                let bandwidth = Int(attributes["BANDWIDTH"]!)
                
                let streamInfo = StreamInfo(programId: programId!, bandwidth: bandwidth!, codec: attributes["CODECS"]!, video: attributes["VIDEO"]!)
                currentMediaItem!.streamInfo = streamInfo
            } else if line.hasPrefix("http") {
                currentMediaItem!.url = NSURL(string: line)
                self.streamList.append(currentMediaItem!)
            }
        }
    }
    
    func attributesFromLine(prefix: String, line: String) -> [String: String] {
        let prefixRange = line.rangeOfString(prefix)
        let attributeRange = Range<String.Index>(start: (prefixRange?.endIndex)!, end: line.endIndex)
        let attributeString = line.substringWithRange(attributeRange)
        
        var attributes = [String: String]()
        
        var stringBuffer = [String]()
        var key = ""
        var value = ""
        var quotesOpen = false
        
        for character in attributeString.characters {
            if character == "=" {
                key = stringBuffer.joinWithSeparator("")
                stringBuffer = [String]()
            } else if character == "\"" {
                if quotesOpen {
                    quotesOpen = false
                } else {
                    quotesOpen = true
                }
            } else if character == "," {
                if quotesOpen {
                    stringBuffer.append(String(character))
                } else {
                    value = stringBuffer.joinWithSeparator("")
                    
                    attributes[key] = value
                    
                    stringBuffer = [String]()
                    key = ""
                    value = ""
                }
            } else {
                stringBuffer.append(String(character))
            }
        }
        
        // empty the buffer to the value, nothing left to parse
        value = stringBuffer.joinWithSeparator("")
        attributes[key] = value
        
        return attributes
    }
}