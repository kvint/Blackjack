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
    func focusChanged(to: inout BJHand) {
        print("didHandChange to \(to.id)")
        self.cardsDelegate?.didHandChange(&to)
    }
    
    func updated(hand: inout BJHand) {
        
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
        self.cardsDelegate?.betOnHand(handId: onHand.id)
    }
    
    func onDone(hand: inout BJUserHand) {
        self.cardsDelegate?.betOnHand(handId: hand.id)
        self.uiDelegate?.displayActions()
    }
    
    func onPayout(hand: inout BJUserHand) {
        self.cardsDelegate?.onPayout(hand: &hand)
    }
    
    func onBlackjack(atHand: inout BJUserHand) {
        
    }
    
    func onBust(atHand: inout BJUserHand) {
        self.cardsDelegate?.onBust(atHand: &atHand)
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
    
    func roundStarted() {
        print("round started")
    }
    
    func roundEnded() {
        print("==== round ended ====")
        self.cardsDelegate?.endGame();
        game.model.clear()
    }
    
}
