//
//  TwitchStyleKit.swift
//  Twitch
//
//  Created by Adam Holt on 28/09/15.
//  Copyright (c) 2015 OMGITSADS. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//



import Cocoa

public class TwitchStyleKit : NSObject {

    //// Drawing Methods

    public class func drawBackIcon(frame frame: NSRect = NSMakeRect(0, 0, 44, 44)) {
        //// Color Declarations
        let white = NSColor(calibratedRed: 1, green: 1, blue: 1, alpha: 1)


        //// Subframes
        let back: NSRect = NSMakeRect(frame.minX + floor(frame.width * 0.37500) + 0.5, frame.minY + floor(frame.height * 0.23864) + 0.5, floor(frame.width * 0.64773) - floor(frame.width * 0.37500), floor(frame.height * 0.76136) - floor(frame.height * 0.23864))


        //// Back
        //// Icon Drawing
        let iconPath = NSBezierPath()
        iconPath.moveToPoint(NSMakePoint(back.minX + 1.00000 * back.width, back.minY + 1.00000 * back.height))
        iconPath.lineToPoint(NSMakePoint(back.minX + 0.00000 * back.width, back.minY + 0.50000 * back.height))
        iconPath.lineToPoint(NSMakePoint(back.minX + 1.00000 * back.width, back.minY + 0.00000 * back.height))
        iconPath.miterLimit = 4
        iconPath.lineCapStyle = NSLineCapStyle.RoundLineCapStyle
        iconPath.lineJoinStyle = NSLineJoinStyle.RoundLineJoinStyle
        iconPath.windingRule = NSWindingRule.EvenOddWindingRule
        white.setStroke()
        iconPath.lineWidth = 2
        iconPath.stroke()
    }

    public class func drawChannelsIcon(frame frame: NSRect = NSMakeRect(0, 0, 50, 50)) {
        //// Color Declarations
        let strokeColor = NSColor(calibratedRed: 1, green: 1, blue: 1, alpha: 1)


        //// Subframes
        let channel: NSRect = NSMakeRect(frame.minX + 9.89, frame.minY + 17, 30.11, 16.04)


        //// Channel
        //// Bezier Drawing
        let bezierPath = NSBezierPath()
        bezierPath.moveToPoint(NSMakePoint(channel.minX, channel.minY + 1.22))
        bezierPath.curveToPoint(NSMakePoint(channel.minX + 1.31, channel.minY), controlPoint1: NSMakePoint(channel.minX, channel.minY + 0.55), controlPoint2: NSMakePoint(channel.minX + 0.59, channel.minY))
        bezierPath.lineToPoint(NSMakePoint(channel.minX + 18.33, channel.minY))
        bezierPath.curveToPoint(NSMakePoint(channel.minX + 19.64, channel.minY + 1.22), controlPoint1: NSMakePoint(channel.minX + 19.05, channel.minY), controlPoint2: NSMakePoint(channel.minX + 19.64, channel.minY + 0.55))
        bezierPath.lineToPoint(NSMakePoint(channel.minX + 19.64, channel.minY + 14.81))
        bezierPath.curveToPoint(NSMakePoint(channel.minX + 18.33, channel.minY + 16.04), controlPoint1: NSMakePoint(channel.minX + 19.64, channel.minY + 15.49), controlPoint2: NSMakePoint(channel.minX + 19.05, channel.minY + 16.04))
        bezierPath.lineToPoint(NSMakePoint(channel.minX + 1.31, channel.minY + 16.04))
        bezierPath.curveToPoint(NSMakePoint(channel.minX, channel.minY + 14.81), controlPoint1: NSMakePoint(channel.minX + 0.59, channel.minY + 16.04), controlPoint2: NSMakePoint(channel.minX, channel.minY + 15.49))
        bezierPath.lineToPoint(NSMakePoint(channel.minX, channel.minY + 1.22))
        bezierPath.closePath()
        bezierPath.moveToPoint(NSMakePoint(channel.minX + 30.11, channel.minY + 1.23))
        bezierPath.lineToPoint(NSMakePoint(channel.minX + 22.26, channel.minY + 4.93))
        bezierPath.lineToPoint(NSMakePoint(channel.minX + 22.26, channel.minY + 11.11))
        bezierPath.lineToPoint(NSMakePoint(channel.minX + 30.11, channel.minY + 14.81))
        bezierPath.lineToPoint(NSMakePoint(channel.minX + 30.11, channel.minY + 1.23))
        bezierPath.lineToPoint(NSMakePoint(channel.minX + 30.11, channel.minY + 1.23))
        bezierPath.closePath()
        strokeColor.setStroke()
        bezierPath.lineWidth = 0.5
        bezierPath.stroke()
    }

    public class func drawChatIcon(frame frame: NSRect = NSMakeRect(0, 0, 44, 44)) {
        //// Color Declarations
        let white = NSColor(calibratedRed: 1, green: 1, blue: 1, alpha: 1)


        //// Subframes
        let chat: NSRect = NSMakeRect(frame.minX + 10.5, frame.minY + 11.5, frame.width - 21, frame.height - 24)


        //// Chat
        //// Bezier Drawing
        let bezierPath = NSBezierPath()
        bezierPath.moveToPoint(NSMakePoint(chat.minX + 1.00000 * chat.width, chat.minY + 0.80000 * chat.height))
        bezierPath.lineToPoint(NSMakePoint(chat.minX + 0.47826 * chat.width, chat.minY + 0.80000 * chat.height))
        bezierPath.lineToPoint(NSMakePoint(chat.minX + 0.30435 * chat.width, chat.minY + 1.00000 * chat.height))
        bezierPath.lineToPoint(NSMakePoint(chat.minX + 0.30435 * chat.width, chat.minY + 0.80000 * chat.height))
        bezierPath.lineToPoint(NSMakePoint(chat.minX + 0.00000 * chat.width, chat.minY + 0.80000 * chat.height))
        bezierPath.lineToPoint(NSMakePoint(chat.minX + 0.00000 * chat.width, chat.minY + 0.00000 * chat.height))
        bezierPath.lineToPoint(NSMakePoint(chat.minX + 1.00000 * chat.width, chat.minY + 0.00000 * chat.height))
        bezierPath.lineToPoint(NSMakePoint(chat.minX + 1.00000 * chat.width, chat.minY + 0.80000 * chat.height))
        bezierPath.lineToPoint(NSMakePoint(chat.minX + 1.00000 * chat.width, chat.minY + 0.80000 * chat.height))
        bezierPath.closePath()
        bezierPath.moveToPoint(NSMakePoint(chat.minX + 0.21739 * chat.width, chat.minY + 0.25005 * chat.height))
        bezierPath.lineToPoint(NSMakePoint(chat.minX + 0.60870 * chat.width, chat.minY + 0.25005 * chat.height))
        bezierPath.moveToPoint(NSMakePoint(chat.minX + 0.21739 * chat.width, chat.minY + 0.40005 * chat.height))
        bezierPath.lineToPoint(NSMakePoint(chat.minX + 0.78261 * chat.width, chat.minY + 0.40005 * chat.height))
        bezierPath.moveToPoint(NSMakePoint(chat.minX + 0.21739 * chat.width, chat.minY + 0.55005 * chat.height))
        bezierPath.lineToPoint(NSMakePoint(chat.minX + 0.78261 * chat.width, chat.minY + 0.55005 * chat.height))
        white.setStroke()
        bezierPath.lineWidth = 1
        bezierPath.stroke()
    }

    public class func drawGamesIcon(frame frame: NSRect = NSMakeRect(0, 0, 50, 50)) {
        //// Color Declarations
        let strokeColor = NSColor(calibratedRed: 1, green: 1, blue: 1, alpha: 1)


        //// Subframes
        let games: NSRect = NSMakeRect(frame.minX + 10.5, frame.minY + 10.5, 29, 29)


        //// Games
        //// Bezier Drawing
        let bezierPath = NSBezierPath()
        bezierPath.moveToPoint(NSMakePoint(games.minX + 17.65, games.minY + 29))
        bezierPath.lineToPoint(NSMakePoint(games.minX + 11.35, games.minY + 29))
        bezierPath.lineToPoint(NSMakePoint(games.minX + 11.35, games.minY + 20.17))
        bezierPath.lineToPoint(NSMakePoint(games.minX + 14.5, games.minY + 17.02))
        bezierPath.lineToPoint(NSMakePoint(games.minX + 17.65, games.minY + 20.17))
        bezierPath.lineToPoint(NSMakePoint(games.minX + 17.65, games.minY + 29))
        bezierPath.lineToPoint(NSMakePoint(games.minX + 17.65, games.minY + 29))
        bezierPath.closePath()
        bezierPath.moveToPoint(NSMakePoint(games.minX + 29, games.minY + 11.35))
        bezierPath.lineToPoint(NSMakePoint(games.minX + 29, games.minY + 17.65))
        bezierPath.lineToPoint(NSMakePoint(games.minX + 20.17, games.minY + 17.65))
        bezierPath.lineToPoint(NSMakePoint(games.minX + 17.02, games.minY + 14.5))
        bezierPath.lineToPoint(NSMakePoint(games.minX + 20.17, games.minY + 11.35))
        bezierPath.lineToPoint(NSMakePoint(games.minX + 29, games.minY + 11.35))
        bezierPath.lineToPoint(NSMakePoint(games.minX + 29, games.minY + 11.35))
        bezierPath.closePath()
        bezierPath.moveToPoint(NSMakePoint(games.minX + 11.35, games.minY))
        bezierPath.lineToPoint(NSMakePoint(games.minX + 17.65, games.minY))
        bezierPath.lineToPoint(NSMakePoint(games.minX + 17.65, games.minY + 8.83))
        bezierPath.lineToPoint(NSMakePoint(games.minX + 14.5, games.minY + 11.98))
        bezierPath.lineToPoint(NSMakePoint(games.minX + 11.35, games.minY + 8.83))
        bezierPath.lineToPoint(NSMakePoint(games.minX + 11.35, games.minY))
        bezierPath.lineToPoint(NSMakePoint(games.minX + 11.35, games.minY))
        bezierPath.closePath()
        bezierPath.moveToPoint(NSMakePoint(games.minX, games.minY + 17.65))
        bezierPath.lineToPoint(NSMakePoint(games.minX, games.minY + 11.35))
        bezierPath.lineToPoint(NSMakePoint(games.minX + 9.53, games.minY + 11.35))
        bezierPath.lineToPoint(NSMakePoint(games.minX + 11.98, games.minY + 14.5))
        bezierPath.lineToPoint(NSMakePoint(games.minX + 8.83, games.minY + 17.65))
        bezierPath.lineToPoint(NSMakePoint(games.minX, games.minY + 17.65))
        bezierPath.lineToPoint(NSMakePoint(games.minX, games.minY + 17.65))
        bezierPath.closePath()
        strokeColor.setStroke()
        bezierPath.lineWidth = 0.5
        bezierPath.stroke()
    }

    public class func drawVideosIcon(frame frame: NSRect = NSMakeRect(0, 0, 50, 50)) {
        //// Color Declarations
        let strokeColor = NSColor(calibratedRed: 1, green: 1, blue: 1, alpha: 1)


        //// Subframes
        let videos: NSRect = NSMakeRect(frame.minX + 10.5, frame.minY + 13.32, 29, 24.35)


        //// Videos
        //// Bezier Drawing
        let bezierPath = NSBezierPath()
        bezierPath.moveToPoint(NSMakePoint(videos.minX, videos.minY + 4.32))
        bezierPath.lineToPoint(NSMakePoint(videos.minX + 29, videos.minY + 4.32))
        bezierPath.lineToPoint(NSMakePoint(videos.minX + 29, videos.minY + 20.03))
        bezierPath.lineToPoint(NSMakePoint(videos.minX, videos.minY + 20.03))
        bezierPath.lineToPoint(NSMakePoint(videos.minX, videos.minY + 4.32))
        bezierPath.closePath()
        bezierPath.moveToPoint(NSMakePoint(videos.minX, videos.minY + 20.07))
        bezierPath.lineToPoint(NSMakePoint(videos.minX + 29, videos.minY + 20.07))
        bezierPath.lineToPoint(NSMakePoint(videos.minX + 29, videos.minY + 24.35))
        bezierPath.lineToPoint(NSMakePoint(videos.minX, videos.minY + 24.35))
        bezierPath.lineToPoint(NSMakePoint(videos.minX, videos.minY + 20.07))
        bezierPath.closePath()
        bezierPath.moveToPoint(NSMakePoint(videos.minX, videos.minY))
        bezierPath.lineToPoint(NSMakePoint(videos.minX + 29, videos.minY))
        bezierPath.lineToPoint(NSMakePoint(videos.minX + 29, videos.minY + 4.28))
        bezierPath.lineToPoint(NSMakePoint(videos.minX, videos.minY + 4.28))
        bezierPath.lineToPoint(NSMakePoint(videos.minX, videos.minY))
        bezierPath.closePath()
        bezierPath.moveToPoint(NSMakePoint(videos.minX + 20.17, videos.minY + 24.34))
        bezierPath.lineToPoint(NSMakePoint(videos.minX + 20.17, videos.minY + 20.05))
        bezierPath.moveToPoint(NSMakePoint(videos.minX + 8.83, videos.minY + 24.34))
        bezierPath.lineToPoint(NSMakePoint(videos.minX + 8.83, videos.minY + 20.05))
        bezierPath.moveToPoint(NSMakePoint(videos.minX + 20.17, videos.minY + 4.3))
        bezierPath.lineToPoint(NSMakePoint(videos.minX + 20.17, videos.minY + 0.01))
        bezierPath.moveToPoint(NSMakePoint(videos.minX + 8.83, videos.minY + 4.3))
        bezierPath.lineToPoint(NSMakePoint(videos.minX + 8.83, videos.minY + 0.01))
        strokeColor.setStroke()
        bezierPath.lineWidth = 0.5
        bezierPath.stroke()


        //// Play Drawing
        let playPath = NSBezierPath()
        playPath.moveToPoint(NSMakePoint(videos.minX + 11.35, videos.minY + 8.6))
        playPath.lineToPoint(NSMakePoint(videos.minX + 11.35, videos.minY + 15.75))
        playPath.lineToPoint(NSMakePoint(videos.minX + 18.28, videos.minY + 12.18))
        playPath.lineToPoint(NSMakePoint(videos.minX + 11.35, videos.minY + 8.6))
        playPath.lineToPoint(NSMakePoint(videos.minX + 11.35, videos.minY + 8.6))
        playPath.closePath()
        playPath.miterLimit = 4
        playPath.lineCapStyle = NSLineCapStyle.RoundLineCapStyle
        playPath.lineJoinStyle = NSLineJoinStyle.RoundLineJoinStyle
        playPath.windingRule = NSWindingRule.EvenOddWindingRule
        strokeColor.setStroke()
        playPath.lineWidth = 0.5
        playPath.stroke()
    }

}
