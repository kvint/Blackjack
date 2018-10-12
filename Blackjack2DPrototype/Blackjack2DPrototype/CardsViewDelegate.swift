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
    
    func endGame() -> Void
    func startGame() -> Void
    func dealCard(_ id: String, _ card: Card) -> Void
    func dealCardToDealer(card: Card) -> Void
    func betOnHand(handId: String) -> Void
    func didHandChange(_ hand: inout BJHand) -> Void
    func revealDealerCard(_ card: Card) -> Void
    func onBust(atHand: inout BJUserHand) -> Void
    func onPayout(hand: inout BJUserHand) -> Void
    func updated(hand: inout BJHand) -> Void
}
