//
//  ViewController.swift
//  Twitch
//
//  Created by Adam Holt on 06.09.18.
//  Copyright © 2018 Adam Holt. All rights reserved.
//

import Cocoa
import Apollo

class GamesViewController: NSViewController {
    @IBOutlet weak var collectionView: NSCollectionView!
    
    var collection: Array<GameViewModel> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = NSNib(nibNamed: NSNib.Name(rawValue: "GameCollectionViewItem"), bundle: nil)
        self.collectionView.register(nib, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "GameCollectionViewItem"))
        
        let apollo: ApolloClient = {
            let configuration = URLSessionConfiguration.default
            // Add additional headers as needed
            configuration.httpAdditionalHeaders = ["Client-ID": "qpc3uyx3odeip09jbgz4nweuef19r2g"]
            
            let url = URL(string: "https://gql.twitch.tv/gql")!
            
            return ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
        }()
        
        apollo.fetch(query: FetchGamesQuery()) { (result, error) in
            result?.data?.games?.edges?.forEach({ (edge) in
                if let gameNode = edge.node {
                    do {
                        let gameViewModel = try GameViewModel(game: gameNode)
                        self.collection.append(gameViewModel)
                    } catch {
                        // Do nothing
                    }
                }
            })
            
            self.collectionView.reloadData()
        }
    }
}

extension GamesViewController: NSCollectionViewDelegate {
}

extension GamesViewController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collection.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "GameCollectionViewItem"), for: indexPath)
        guard let collectionViewItem = item as? GameCollectionViewItem else { return item }
        
        let viewModel = self.collection[indexPath.item]
        collectionViewItem.gameViewModel = viewModel
        
        return item
    }
}
