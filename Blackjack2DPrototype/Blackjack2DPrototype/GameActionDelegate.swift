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
    func onFocusChanged(to: inout BJHand) {
        print("didHandChange to \(to.id)")
        self.cardsDelegate?.didHandChange(&to)
    }
    
    func onUpdate(hand: inout BJHand) {
        
    }
    
    func onDealCard(toHand: inout BJHand, card: Card) {
        print("deal \(card) to \(toHand.id)")
        
        if toHand is BJDealerHand {
            self.cardsDelegate?.dealCardToDealer(card: card)
        } else {
            self.cardsDelegate?.dealCard(toHand.id, card)
        }
    }
    
    func onDone(hand: inout BJUserHand) {
        if (hand.gotBusted()) {
            self.cardsDelegate?.onBust(atHand: &hand)
        }
        self.cardsDelegate?.onPayout(hand: &hand)
    }
    
    func onBet(onHand: inout BJUserHand) {
        self.cardsDelegate?.betOnHand(handId: onHand.id)
        self.uiDelegate?.displayActions()
    }
    

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
            
            let hand = globals.backend.model.getHand(id: String(_selectedHand))
            if hand != nil {
                cardsDelegate?.showHand(hand!.id)
            }
            print("Show hand \(_selectedHand)")
        }
    }
    
    func bet(stake: Double) {
        do {
            try globals.backend.bet(index: _selectedHand, stake: stake)
            print("bet \(String(describing: globals.backend.model.getHand(id: String(_selectedHand))?.stake)) to \(_selectedHand)")
        } catch {
            print("Failed to place a bet")
        }
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
        print("Split")
        do {
            try globals.backend.split()
        } catch {
            print("Split failed")
        }
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
    }
    
    func roundEnded() {
        print("==== round ended ====")
        self.cardsDelegate?.endGame();
        globals.backend.model.clear()
    }
    
}
