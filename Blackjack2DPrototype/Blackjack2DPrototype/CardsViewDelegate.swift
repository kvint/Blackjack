//
//  CardsViewDelegate.swift
//  Blackjack2DPrototype
//
//  Created by Александр Славщик on 17.03.2018.
//  Copyright © 2018 Александр Славщик. All rights reserved.
//

import Foundation
import CardsBase

protocol CardsDelegate: class {
    
    func showHand(_ id: String) -> Void
    func endGame() -> Void
    func dealCard(_ id: String, _ card: Card) -> Void
    func dealCardToDealer(card: Card) -> Void
    
}
