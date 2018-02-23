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
        let card1 = Blackjack.Card(Blackjack.Rank.c2, Blackjack.Suit.Spades)
        let card2 = Blackjack.Card(Blackjack.Rank.c2, Blackjack.Suit.Hearts)

        XCTAssert(card1.suit != card2.suit)
        XCTAssert(card1.rank == card2.rank)
        XCTAssert(card1 != card2, "Cards with diff suits are equals")

        let card3 = Blackjack.Card(Blackjack.Rank.c2, Blackjack.Suit.Clubs)
        let card4 = Blackjack.Card(Blackjack.Rank.c3, Blackjack.Suit.Clubs)

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
