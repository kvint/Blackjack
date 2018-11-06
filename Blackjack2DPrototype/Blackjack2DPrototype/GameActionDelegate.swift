//
//  GameActionDelegate.swift
//  Blackjack2DPrototype
//
//  Created by Александр Славщик on 17.03.2018.
//  Copyright © 2018 Александр Славщик. All rights reserved.
//

import Foundation
import CardsBase

class GameActionDelegate: GameDelegate {
    
    public weak var cardsDelegate: CardsDelegate? = nil
    public weak var uiDelegate: UIGameViewController? = nil
    
    func focusChanged(to: inout BJHand) {
        print("didHandChange to \(to.id)")
        self.cardsDelegate?.didHandChange(&to)
    }
    
    func updated(hand: inout BJHand) {
        self.cardsDelegate?.updated(hand: &hand)
    }
    
    func cardDealt(toHand: inout BJHand, card: Card) {
        print("deal \(card) to \(toHand.id)")
        
        if toHand is BJDealerHand {
            self.cardsDelegate?.dealCardToDealer(card: card)
        } else {
            self.cardsDelegate?.dealCard(toHand.id, card)
        }
    }
    
    func onBet(onHand: inout BJUserHand, regularBet: Bool) {
        self.cardsDelegate?.betOnHand(handId: onHand.id, regularBet: regularBet)
        self.uiDelegate?.displayActions()
    }
    
    func onDone(hand: inout BJUserHand) {
        if (hand.gotBusted()) {
            self.cardsDelegate?.onBust(atHand: &hand)
        }
        if hand.payedOut {
            self.cardsDelegate?.onPayout(hand: &hand)
        }
        self.uiDelegate?.displayActions()
    }

    func deal() {
        print("Deal")
        try! globals.backend.deal()
    }
    func double() {
        print("Double")
        do {
            try globals.backend.double();
        } catch {
            print("Double failed")
        }
    }
    func hit() {
        print("Hit")
        do {
            try globals.backend.hit()
        } catch {
            print("Hit failed")
        }
    }
    func stand() {
        print("Stand")
        do {
            try globals.backend.stand()
        } catch {
            print("Stand failed")
        }
    }
    func split() {
//        print("Split")
//        do {
//            try globals.backend.split()
//        } catch {
//            print("Split failed")
//        }
    }
    func insurance() {
        do {
            try globals.backend.insurance()
        } catch {
            print("Insurance failed")
        }
    }
    func revealDealerCard(_ card: Card) {
        self.cardsDelegate?.revealDealerCard(card);
    }
    
    func roundStarted() {
        print("round started")
        self.cardsDelegate?.startGame()
    }
    
    func roundEnded() {
        print("==== round ended ====")
        self.cardsDelegate?.endGame()
    }
    
}
