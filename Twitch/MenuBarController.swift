//
//  MenuBarController.swift
//  Twitch
//
//  Created by Adam Holt on 18/03/2016.
//  Copyright © 2016 Adam Holt. All rights reserved.
//

import Cocoa
import ReactiveMoya
import SwiftyJSON

enum MenuItemType {
    case Browse
    case Header
    case Followed
}

struct MenuItem {
    var title: String
    var icon: NSImage?
    var type: MenuItemType
    var endpoint: TwitchAPI?
}

class BrowseTableRowView: NSTableRowView {
    override func drawSelectionInRect(dirtyRect: NSRect) {
        if self.selectionHighlightStyle != .None {
            let selectionRect = NSMakeRect(self.bounds.origin.x, self.bounds.origin.y, 5, self.bounds.height)
            NSColor(calibratedRed: (100+1)/256, green: (65+1)/256, blue: (165+1)/256, alpha: 1).setFill()
            let selectionPath = NSBezierPath(rect: selectionRect)
            selectionPath.fill()
        }
    }
}

class BrowseCellView: NSTableCellView {
    @IBOutlet weak var iconView: NSImageView?
}

class ChannelCellView: NSTableCellView {
    @IBOutlet weak var iconView: NSImageView?
}

class MenuBarController: NSViewController {
    @IBOutlet weak var tableView: NSTableView?
    var menuItems: Array<MenuItem> = []
    let twitchProvider = ReactiveCocoaMoyaProvider<TwitchAPI>()
    
    override func viewDidLoad() {
        setupMenu()
    }
    
    func setupMenu() {
        let games = MenuItem(title: "Games", icon: NSImage(named: "GamesIcon"), type: .Browse, endpoint: .TopGames)
        let channels = MenuItem(title: "Channels", icon: NSImage(named: "ChannelsIcon"), type: .Browse, endpoint: .Streams)
        let videos = MenuItem(title: "Videos", icon: NSImage(named: "VideosIcon"), type: .Browse, endpoint: .TopVideos)
        let followedHeader = MenuItem(title: "Followed Channels", icon: nil, type: .Header, endpoint: nil)
        let bulldogChannel = MenuItem(title: "AdmiralBulldog", icon: NSImage(named: "SubscriberIcon"), type: .Followed, endpoint: .Channel(channel: "admiralbulldog"))
        let singChannel = MenuItem(title: "Sing_sing", icon: NSImage(named: "FollowerIcon"), type: .Followed, endpoint: .Channel(channel: "sing_sing"))
        let dreamleagueChannel = MenuItem(title: "DreamLeague", icon: NSImage(named: "FollowerIcon"), type: .Followed, endpoint: .Channel(channel: "dreamleague"))
        
        self.menuItems = [games, channels, videos, followedHeader, bulldogChannel, singChannel, dreamleagueChannel]
        self.tableView?.reloadData()
    }
    
    override func awakeFromNib() {
        self.tableView?.selectRowIndexes(NSIndexSet(index: 0), byExtendingSelection: false)
    }
}

extension MenuBarController: NSTableViewDataSource {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return self.menuItems.count
    }
}

extension MenuBarController: NSTableViewDelegate {
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let item = self.menuItems[row]
        var cell: NSTableCellView?
        
        switch item.type {
        case .Browse:
            cell = tableView.makeViewWithIdentifier("SectionCell", owner: self) as! BrowseCellView
            (cell as! BrowseCellView).textField?.stringValue = item.title
            (cell as! BrowseCellView).iconView?.image = item.icon
        case .Header:
            cell = tableView.makeViewWithIdentifier("HeaderCell", owner: self) as? NSTableCellView
            cell!.textField?.stringValue = item.title
        case .Followed:
            cell = tableView.makeViewWithIdentifier("FollowedCell", owner: self) as! ChannelCellView
            (cell as! ChannelCellView).textField?.stringValue = item.title
            (cell as! ChannelCellView).iconView?.image = item.icon
        }
        
        return cell
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        let item = self.menuItems[row]
        
        switch item.type {
        case .Browse:
            return 32.0
        case .Header:
            return 20.0
        case .Followed:
            return 24.0
        }
    }
    
    func tableView(tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        var view: NSTableRowView?
        let item = self.menuItems[row]
        
        switch item.type {
        case .Browse, .Followed:
            view = tableView.makeViewWithIdentifier("BrowseRow", owner: self) as? BrowseTableRowView
        case .Header:
            view = tableView.makeViewWithIdentifier("DefaultRow", owner: self) as? NSTableRowView
        }
        
        if view == nil {
            switch item.type {
            case .Browse, .Followed:
                view = BrowseTableRowView()
                view?.identifier = "BrowseRow"
            case .Header:
                view = NSTableRowView()
                view?.identifier = "DefaultRow"
            }
        }
        
        return view
    }
    
    func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        let item = self.menuItems[row]
        
        switch item.type {
        case .Browse, .Followed:
            return true
        case .Header:
            return false
        }
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        let selectedItem: MenuItem = self.menuItems[self.tableView!.selectedRow]

        twitchProvider.request(selectedItem.endpoint!).start { (event) -> Void in
            switch event {
            case .Next(let response):
                let json = JSON(data: response.data)
                print(json)
            case .Failed(let error):
                print(error)
            default:
                break
            }
        }
    }
}
