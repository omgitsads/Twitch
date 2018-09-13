//
//  MenuControllers.swift
//  Twitch
//
//  Created by Adam Holt on 13.09.18.
//  Copyright © 2018 Adam Holt. All rights reserved.
//

import Cocoa

enum MenuItemType {
    case browse
    case header
    case followed
}

struct MenuItem {
    var title: String
    var type: MenuItemType
}

class MenuViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    
    var menuItems: Array<MenuItem> = []
    
    override func viewDidLoad() {
        self.tableView.backgroundColor = NSColor.clear
        
        let games = MenuItem(title: "Games", type: .browse)
        let channels = MenuItem(title: "Channels", type: .browse)
        
        self.menuItems = [games, channels]
    }
}

extension MenuViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let item = self.menuItems[row]
        var cell: NSTableCellView?
        
        cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "BrowseCell"), owner: self) as? NSTableCellView
        cell?.textField?.stringValue = item.title
        
        return cell
    }
}

extension MenuViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.menuItems.count
    }
}
