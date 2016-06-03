//
//  MenuBarController.swift
//  Twitch
//
//  Created by Adam Holt on 18/03/2016.
//  Copyright © 2016 Adam Holt. All rights reserved.
//

import Cocoa
import Moya
import SwiftyJSON
import ObjectMapper

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
    var record: Mappable?
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
    @IBOutlet weak var windowController: TwitchWindowController!
    @IBOutlet weak var tableView: NSTableView!
    var menuItems: Array<MenuItem> = []
    var followerItems: Array<MenuItem> = []
    let provider = MoyaProvider(endpointClosure: endpointClosure)
    var authorisedTimer: NSTimer?
    var authenticationIsRefreshing = false
    
    override func viewDidLoad() {
        setupMenu()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MenuBarController.didLogin(_:)), name: Twitch.DidAuthenticate, object: nil)
    }
    
    func setupMenu() {
        let games = MenuItem(title: "Games", icon: NSImage(named: "GamesIcon"), type: .Browse, endpoint: .TopGames(limit: 100, offset: 0), record: nil)
        let channels = MenuItem(title: "Channels", icon: NSImage(named: "ChannelsIcon"), type: .Browse, endpoint: .Streams(limit: 100, offset: 0), record: nil)
        let videos = MenuItem(title: "Videos", icon: NSImage(named: "VideosIcon"), type: .Browse, endpoint: .TopVideos, record: nil)
        
        self.menuItems = [games, channels, videos]
        self.tableView?.reloadData()
    }
    
    override func awakeFromNib() {
        if self.tableView.numberOfRows > 0 {
            self.tableView?.selectRowIndexes(NSIndexSet(index: 0), byExtendingSelection: false)
        }
    }
    
    func didLogin(notification: NSNotification) {
        self.getFollowedStreams()
        
        if (self.authorisedTimer == nil) {
            self.authorisedTimer = NSTimer(timeInterval: 60, target: self, selector: #selector(MenuBarController.getFollowedStreams), userInfo: nil, repeats: true)
            NSRunLoop.currentRunLoop().addTimer(self.authorisedTimer!, forMode: NSRunLoopCommonModes)
        }
    }
    
    func getFollowedStreams() {
        provider.request(TwitchAPI.FollowedStreams) { result in
            switch result {
            case let .Success(moyaResponse):
                // Reset the follower items
                self.followerItems = []
                
                let json = JSON(data: moyaResponse.data)
                let collectionJSON = json.dictionary!["streams"]!.array!
                
                if(collectionJSON.count > 0) {
                    let followedHeader = MenuItem(title: "Followed Channels", icon: nil, type: .Header, endpoint: nil, record: nil)
                    self.followerItems.append(followedHeader)
                }
                
                for (_, recordJSON) in collectionJSON.enumerate() {
                    if let stream = Mapper<Stream>().map(recordJSON.rawValue) {
                        let menuItem = MenuItem(title: stream.name!, icon: NSImage(named: "FollowerIcon"), type: .Followed, endpoint: nil, record: stream)
                        
                        self.followerItems.append(menuItem)
                    }
                }
                // Wrap this reload with authenticationIsRefreshing, so we don't trigger a change of view controller
                self.authenticationIsRefreshing = true
                self.tableView.reloadData()
            case let .Failure(_):
                print("Failed")
            }
        }
    }
}

extension MenuBarController: NSTableViewDataSource {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return (self.menuItems.count + self.followerItems.count)
    }
}

extension MenuBarController: NSTableViewDelegate {
    func menuItem(row: Int) -> MenuItem {
        var item: MenuItem!
        if row > (self.menuItems.count-1) {
            let followerRow = row - (self.menuItems.count)
            item = self.followerItems[followerRow]
        } else {
            item = self.menuItems[row]
        }
        
        return item
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let item = self.menuItem(row)
        
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
        let item = self.menuItem(row)
        
        switch item.type {
        case .Browse:
            return 32.0
        case .Header:
            return 30.0
        case .Followed:
            return 24.0
        }
    }
    
    func tableView(tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        var view: NSTableRowView?
        let item = self.menuItem(row)
        
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
        let item = self.menuItem(row)
        
        switch item.type {
        case .Browse, .Followed:
            return true
        case .Header:
            return false
        }
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        if(self.authenticationIsRefreshing) {
            self.authenticationIsRefreshing = false
            return
        }
        
        let index = self.tableView!.selectedRow
        if(index >= 0) {
            let selectedItem = self.menuItem(index)
            
            switch selectedItem.type {
            case .Browse:
                if selectedItem.title == "Games" {
                    let gamesViewController = GamesCollectionViewController(nibName: "GamesCollectionView", bundle: nil)!
                    self.windowController.navigationController.setRootViewController(gamesViewController)
                } else if selectedItem.title == "Channels" {
                    let streamsViewController = StreamsCollectionViewController(nibName: "StreamsCollectionView", bundle: nil)!
                    self.windowController.navigationController.setRootViewController(streamsViewController)
                }
            case .Followed:
                let streamViewController = StreamViewController(nibName: "StreamViewController", bundle: nil)!
                streamViewController.stream = selectedItem.record as! Stream
                
                self.windowController.navigationController.setRootViewController(streamViewController)
            default:
                break
            }
        }
    }
}
