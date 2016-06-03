//
//  ViewController.swift
//  Twitch
//
//  Created by Adam Holt on 17/03/2016.
//  Copyright © 2016 Adam Holt. All rights reserved.
//

import Cocoa
import Alamofire
import Moya
import SwiftyJSON
import ObjectMapper

class GamesCollectionViewController: TwitchViewController {
    let provider = MoyaProvider<TwitchAPI>()
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var scrollView: NSScrollView!
    
    var collection: Array<Game> = []
    var gamesRequest: Cancellable?
    
    var limit = 20
    var nextOffset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.scrollHandler(_:)), name: NSScrollViewDidLiveScrollNotification
            , object: nil)
        
        let nib = NSNib(nibNamed: "GameViewItem", bundle: nil)
        self.collectionView.registerNib(nib, forItemWithIdentifier: "GameViewItem")
        
        fetchGames()
    }
    
    
    func scrollHandler(notification: NSNotification) {
        let aScrollView = notification.object as! NSScrollView
        let documentBounds = aScrollView.documentView?.bounds
        let documentVisibleRect = aScrollView.contentView.documentVisibleRect
        
        let bottomVisibleRect = (documentVisibleRect.origin.y + documentVisibleRect.size.height)
        
        if (bottomVisibleRect >= documentBounds?.size.height) {
            fetchGames()
        }
    }
    
    func fetchGames() {
        if self.gamesRequest == nil {
            let endpoint = TwitchAPI.TopGames(limit: self.limit, offset: self.nextOffset)
            
            self.gamesRequest = provider.request(endpoint) { result in
                switch result {
                case let .Success(moyaResponse):
                    let json = JSON(data: moyaResponse.data)
                    let collectionJSON = json.dictionary!["top"]!.array!
                    var indexPaths = Set<NSIndexPath>()
                    
                    for (_, recordJSON) in collectionJSON.enumerate() {
                        if let game = Mapper<Game>().map(recordJSON.rawValue) {
                            indexPaths.insert(NSIndexPath(forItem: self.collection.count, inSection: 0))
                            self.collection.append(game)
                        }
                    }
                    
                    if(self.nextOffset == 0) {
                        self.collectionView.reloadData()
                    } else {
                        self.collectionView.performBatchUpdates({
                            self.collectionView.insertItemsAtIndexPaths(indexPaths)
                        }, completionHandler: nil)
                    }
                    
                    self.nextOffset = self.limit + self.nextOffset
                    self.gamesRequest = nil
                case .Failure(_):
                    self.gamesRequest = nil
                }
            }
        }
    }
}

extension GamesCollectionViewController: NSCollectionViewDelegate {
    func collectionView(collectionView: NSCollectionView, didSelectItemsAtIndexPaths indexPaths: Set<NSIndexPath>) {
        let record = self.collection[indexPaths.first!.item] 
        let endpoint = TwitchAPI.GameStreams(game: record.name!, limit: 25, offset: 0)
        
        let vc = StreamsCollectionViewController(nibName: "StreamsCollectionView", bundle: nil)
        vc?.endpoint = endpoint
        
        self.navigationController.pushViewController(vc!, animated: true)
    }
}

extension GamesCollectionViewController: NSCollectionViewDataSource {
    func collectionView(collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collection.count;
    }
    
    func collectionView(collectionView: NSCollectionView, itemForRepresentedObjectAtIndexPath indexPath: NSIndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItemWithIdentifier(String(GameViewItem), forIndexPath: indexPath) as! GameViewItem
        let record = self.collection[indexPath.item]
        
        item.record = record
        item.setup()
        
        return item
    }
}