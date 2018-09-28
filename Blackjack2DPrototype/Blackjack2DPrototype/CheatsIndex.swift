//
//  CheatsIndex.swift
//  Blackjack2DPrototype
//
//  Created by Александр Славщик on 9/28/18.
//  Copyright © 2018 Александр Славщик. All rights reserved.
//

import Foundation
import CardsBase

struct Cheat: Decodable {
    enum CodingKeys: String, CodingKey {
        case label
        case cheatingCards
        case dealerCheatCards
    }
    
    let label: String
    let cheatingCards: [CheatCard]?
    let dealerCheatCards: [CheatCard]?
}
struct CheatCard: Decodable {
    let rank: String
    let suit: String
    
    enum CodingKeys: String, CodingKey {
        case rank
        case suit
    }
}

extension Card {
    init(fromCheat: CheatCard) {
        var rank: Rank!
        var suit: Suit!
        switch (fromCheat.rank) {
        case "A":
            rank = .Ace
            break
        case "K":
            rank = .King
            break
        case "Q":
            rank = .Queen
            break
        case "J":
            rank = .Jack
            break
        case "10":
            rank = .c10
            break
        case "9":
            rank = .c9
            break
        case "8":
            rank = .c8
            break
        case "7":
            rank = .c7
            break
        case "6":
            rank = .c6
            break
        case "5":
            rank = .c5
            break
        case "4":
            rank = .c4
            break
        case "3":
            rank = .c3
            break
        case "2":
            rank = .c2
            break
        default:
            fatalError("Cheat card creation failed")
        }
        switch fromCheat.suit {
        case "C":
            suit = .Clubs
            break
        case "H":
            suit = .Hearts
            break
        case "S":
            suit = .Spades
            break
        case "D":
            suit = .Diamonds
            break
        default:
            fatalError("Cheat card creation failed")
        }
        self.init(rank, suit)
    }
}
