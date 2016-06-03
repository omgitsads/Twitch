//
//  StreamsCollectionViewController.swift
//  Twitch
//
//  Created by Adam Holt on 10/04/2016.
//  Copyright © 2016 Adam Holt. All rights reserved.
//

import Cocoa
import Alamofire
import Moya
import SwiftyJSON
import ObjectMapper

class StreamsCollectionViewController: TwitchViewController {
    let provider = MoyaProvider<TwitchAPI>()
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var scrollView: NSScrollView!
    
    var collection: Array<Stream> = []
    var streamsRequest: Cancellable?
    
    var endpoint: TwitchAPI! = TwitchAPI.Streams(limit: 25, offset: 0)
    
    var firstRequest: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.scrollHandler(_:)), name: NSScrollViewDidLiveScrollNotification
            , object: nil)
        
        let nib = NSNib(nibNamed: "StreamViewItem", bundle: nil)
        self.collectionView.registerNib(nib, forItemWithIdentifier: "StreamViewItem")
        
        fetchStreams()
    }
    
    override func viewDidAppear() {
        //
    }
    
    func scrollHandler(notification: NSNotification) {
        let aScrollView = notification.object as! NSScrollView
        let documentBounds = aScrollView.documentView?.bounds
        let documentVisibleRect = aScrollView.contentView.documentVisibleRect
        
        let bottomVisibleRect = (documentVisibleRect.origin.y + documentVisibleRect.size.height)
        
        if (bottomVisibleRect >= documentBounds?.size.height) {
            fetchStreams()
        }
    }
    
    func fetchStreams() {
        if self.streamsRequest == nil {
            self.streamsRequest = provider.request(self.endpoint) { result in
                switch result {
                case let .Success(moyaResponse):
                    let json = JSON(data: moyaResponse.data)
                    let collectionJSON = json.dictionary!["streams"]!.array!
                    var indexPaths = Set<NSIndexPath>()
                    for (_, recordJSON) in collectionJSON.enumerate() {
                        if let stream = Mapper<Stream>().map(recordJSON.rawValue) {
                            indexPaths.insert(NSIndexPath(forItem: self.collection.count, inSection: 0))
                            self.collection.append(stream)
                        }
                    }
                    
                    if(self.firstRequest) {
                        // Bug in nscollectionview?
                        self.collectionView.reloadData()
                        self.firstRequest = false
                    } else {
                        self.collectionView.performBatchUpdates({
                            self.collectionView.insertItemsAtIndexPaths(indexPaths)
                            }, completionHandler: nil)
                    }
                    
                    switch self.endpoint! {
                    case .Streams(let limit, let offset):
                        self.endpoint = TwitchAPI.Streams(limit: limit, offset: limit + offset)
                    case .GameStreams(let game, let limit, let offset):
                        self.endpoint = TwitchAPI.GameStreams(game: game, limit: limit, offset: limit + offset)
                    default:
                        break
                    }
                    self.streamsRequest = nil
                case .Failure(_):
                    self.streamsRequest = nil
                }
            }
        }
    }
}

extension StreamsCollectionViewController: NSCollectionViewDelegate {
    func collectionView(collectionView: NSCollectionView, didSelectItemsAtIndexPaths indexPaths: Set<NSIndexPath>) {
        let record = self.collection[indexPaths.first!.item]
        
        let vc = StreamViewController(nibName: "StreamViewController", bundle: nil)!
        vc.stream = record
        
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension StreamsCollectionViewController: NSCollectionViewDataSource {
    func collectionView(collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collection.count;
    }
    
    func collectionView(collectionView: NSCollectionView, itemForRepresentedObjectAtIndexPath indexPath: NSIndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItemWithIdentifier(String(StreamViewItem), forIndexPath: indexPath) as! StreamViewItem
        let record = self.collection[indexPath.item]
        
        item.record = record
        item.setup()
        
        return item
    }
}
