//
//  TCards.swift
//  BlackjackTests
//
//  Created by Alexander Slavschik on 2/20/18.
//  Copyright © 2018 Alexander Slavschik. All rights reserved.
//

import XCTest
@testable import Blackjack

class TCards: XCTestCase {

    func testUniq() {
        let card1 = Blackjack.Card(suit: Blackjack.Suit.Spades, rank: Blackjack.Rank.c2)
        let card2 = Blackjack.Card(suit: Blackjack.Suit.Hearts, rank: Blackjack.Rank.c2)

        XCTAssert(card1.suit != card2.suit)
        XCTAssert(card1.rank == card2.rank)
        XCTAssert(card1 != card2, "Cards with diff suits are equals")

        let card3 = Blackjack.Card(suit: Blackjack.Suit.Clubs, rank: Blackjack.Rank.c2)
        let card4 = Blackjack.Card(suit: Blackjack.Suit.Clubs, rank: Blackjack.Rank.c3)

        XCTAssert(card3.suit == card4.suit)
        XCTAssert(card3.rank != card4.rank)
        XCTAssert(card3 != card4, "Cards with diff ranks are equals")
    }

    func testDeck() {
        let deck = Blackjack.CardDeck.getDeck()
        XCTAssert(deck.count == 52, "Deck should be counts 52")
    }

    func testDeckShuffle() {
        let deck = Blackjack.CardDeck.getDeck().shuffled()
        XCTAssert(deck.count == 52, "Shuffled deck should be 52")
    }
    
}
