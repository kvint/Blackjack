//
//  CardsView.swift
//  Blackjack
//
//  Created by Alexander Slavschik on 3/7/18.
//  Copyright © 2018 Alexander Slavschik. All rights reserved.
//

import Foundation
import CardsBase
import SpriteKit

extension Card {
    
    var suitName: String {
        get {
            switch (self.suit) {
            case .Spades: return "spades"
            case .Hearts: return "hearts"
            case .Clubs: return "clubs"
            case .Diamonds: return "diamonds"
            }
        }
    }
    var rankName: String {
        switch (self.rank) {
        case .Ace: return "ace"
        case .King: return "king"
        case .Queen: return "queen"
        case .Jack: return "jack"
        case .c10: return "10"
        case .c9: return "9"
        case .c8: return "8"
        case .c7: return "7"
        case .c6: return "6"
        case .c5: return "5"
        case .c4: return "4"
        case .c3: return "3"
        case .c2: return "2"
        }
    }
    var imageNamed: String {
        get {
            return "\(self.suitName)_\(self.rankName)"
        }
    }
    func createNode() -> SKSpriteNode {
        return SKSpriteNode(imageNamed: self.imageNamed)
    }
}
