//
//  GameViewModel.swift
//  Twitch
//
//  Created by Adam Holt on 10.09.18.
//  Copyright © 2018 Adam Holt. All rights reserved.
//

import Foundation
import Apollo
import URITemplate

struct GameViewModel {
    let id: String
    let name: String
    let coverURITemplate: URITemplate?
    let viewersCount: Int
    let broadcastersCount: Int
}

extension GameViewModel {
    init(game: FetchGamesQuery.Data.Game.Edge.Node) throws {
        var coverURITemplate: URITemplate?
        
        if let coverURLString = game.fragments.gameDetails.coverUrl {
            coverURITemplate = try URITemplate(string: coverURLString)
            
        }
        
        let viewersCount = game.fragments.gameDetails.viewersCount ?? 0
        let broadcastersCount = game.fragments.gameDetails.broadcastersCount ?? 0
        
        self.init(id: game.fragments.gameDetails.id,
                name: game.fragments.gameDetails.displayName,
    coverURITemplate: coverURITemplate,
        viewersCount: viewersCount,
   broadcastersCount: broadcastersCount)
    }
}
