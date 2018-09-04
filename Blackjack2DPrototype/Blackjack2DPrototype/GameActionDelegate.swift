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

    private var _selectedHand: Int = 0;
    
    var selectedHand: Int {
        get {
            return _selectedHand;
        }
        set (index) {
            guard index >= 0 && index < 5 else {
                return;
            }
            _selectedHand = index
            
            let hand = game.model.getHand(id: String(_selectedHand))
            if hand != nil {
                cardsDelegate?.showHand(hand!.id)
            }
            print("Show hand \(_selectedHand)")
        }
    }
    
    func bet(stake: Double) {
        do {
            try game.bet(index: _selectedHand, stake: stake)
            print("bet \(String(describing: game.model.getHand(id: String(_selectedHand))?.stake)) to \(_selectedHand)")
        } catch {
            print("Failed to place a bet")
        }
    }

    func deal() {
        print("Deal")
        try! game.deal()
    }
    func double() {
        print("Double")
        do {
            try game.double();
        } catch {
            print("Double failed")
        }
    }
    func hit() {
        print("Hit")
        do {
            try game.hit()
        } catch {
            print("Hit failed")
        }
    }
    func stand() {
        print("Stand")
        do {
            try game.stand()
        } catch {
            print("Stand failed")
        }
    }
    func split() {
        print("Split")
        do {
            try game.split()
        } catch {
            print("Split failed")
        }
    }
    func insurance() {
        do {
            try game.insurance()
        } catch {
            print("Insurance failed")
        }
    }
    func revealDealerCard(_ card: Card) {
        self.cardsDelegate?.revealDealerCard(card);
    }
    func didHandChange(_ hand: inout BJHand) {
        print("didHandChange to \(hand.id)")
        self.cardsDelegate?.didHandChange(&hand)
    }
    
    func roundStarted() {
        print("round started")
    }
    
    func roundEnded() {
        print("==== round ended ====")
        self.cardsDelegate?.endGame();
        game.model.clear()
    }
    
    func didHandUpdate(_ hand: inout BJHand) {
        
    }
    
    func didDealCard(_ card: Card, _ hand: inout BJHand) {
        print("deal \(card) to \(hand.id)")
        
        if hand is BJDealerHand {
            self.cardsDelegate?.dealCardToDealer(card: card)
        } else {
            self.cardsDelegate?.dealCard(hand.id, card)
        }
    }
    
    func didHandDone(_ hand: inout BJUserHand) {
        
    }
    func betOnHand(handId: String) -> Void {
        self.cardsDelegate?.betOnHand(handId: handId)
        self.uiDelegate?.displayActions()
    }
}
