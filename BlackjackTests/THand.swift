//
//  TCards.swift
//  BlackjackTests
//
//  Created by Alexander Slavschik on 2/20/18.
//  Copyright © 2018 Alexander Slavschik. All rights reserved.
//

import XCTest
@testable import Blackjack

class THand: XCTestCase {
    func testUniq() {
        let hand1 = Hand()
        let hand2 = Hand()

        XCTAssert(hand1 != hand2, "Hands should not be equal")
    }
    func testScoreInitial() {
        let hand = Hand()
        let score: (hard: Int, soft: Int?) = hand.getScore()

        XCTAssert(score.hard == 0, "Initial score should be zero")
        XCTAssert(score.soft == nil, "Initial soft score should be nil")
    }
    func testHardScore() {
        self.checkHardScore(rank: Rank.c2, value: 2)
        self.checkHardScore(rank: Rank.c3, value: 3)
        self.checkHardScore(rank: Rank.c4, value: 4)
        self.checkHardScore(rank: Rank.c5, value: 5)
        self.checkHardScore(rank: Rank.c6, value: 6)
        self.checkHardScore(rank: Rank.c7, value: 7)
        self.checkHardScore(rank: Rank.c8, value: 8)
        self.checkHardScore(rank: Rank.c9, value: 9)
        self.checkHardScore(rank: Rank.c10, value: 10)
        self.checkHardScore(rank: Rank.King, value: 10)
        self.checkHardScore(rank: Rank.Jack, value: 10)
        self.checkHardScore(rank: Rank.Queen, value: 10)
    }
    func checkHardScore(rank:Rank, value: Int) {
        let hand = Hand()
        hand.cards.append(Card(suit: Suit.Diamonds, rank:rank))
        let score = hand.getScore()
        XCTAssert(score.hard == value, "hard \(rank) should be equal \(value)")
        XCTAssert(score.soft == nil, "soft \(rank) should be nil")
    }
    func testScoreSum() {
        self.checkScoreSum(ranks: [Rank.c2, Rank.c3], value: (hard: 5, soft: nil))
        self.checkScoreSum(ranks: [Rank.c2, Rank.c3, Rank.c2, Rank.c3, Rank.c2, Rank.c3], value: (hard: 15, soft: nil))
        self.checkScoreSum(ranks: [Rank.King, Rank.Jack], value: (hard: 20, soft: nil))
        self.checkScoreSum(ranks: [Rank.King, Rank.Ace], value: (hard: 21, soft: 11))

        self.checkScoreSum(ranks: [Rank.c2, Rank.c2, Rank.Ace], value: (hard: 15, soft: 5))
        self.checkScoreSum(ranks: [Rank.Ace, Rank.Ace], value: (hard: 12, soft: 2))

        self.checkScoreSum(ranks: [Rank.Ace, Rank.Ace, Rank.Ace], value: (hard: 13, soft: 3))
        self.checkScoreSum(ranks: [Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace], value: (hard: 16, soft: 6))
        self.checkScoreSum(ranks: [Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace], value: (hard: 19, soft: 9))
        self.checkScoreSum(ranks: [Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace], value: (hard: 21, soft: 11))
//
        self.checkScoreSum(ranks: [Rank.Ace, Rank.Ace, Rank.Jack], value: (hard: 22, soft: 12))
        self.checkScoreSum(ranks: [Rank.Jack, Rank.c2, Rank.Ace], value: (hard: 13, soft: nil))
//
        self.checkScoreSum(ranks: [Rank.c5, Rank.Ace], value: (hard: 16, soft: 6))
        self.checkScoreSum(ranks: [Rank.c2, Rank.c2, Rank.c2, Rank.c2, Rank.Ace], value: (hard: 19, soft: 9))
        self.checkScoreSum(ranks: [Rank.c2, Rank.c4, Rank.c2, Rank.c2, Rank.Ace], value: (hard: 21, soft: 11))
        self.checkScoreSum(ranks: [Rank.c2, Rank.c5, Rank.c2, Rank.c2, Rank.Ace], value: (hard: 22, soft: 12))

        self.checkScoreSum(ranks: [Rank.c2, Rank.c7, Rank.c3, Rank.Jack], value: (hard: 22, soft: nil))
    }

    func checkScoreSum(ranks:[Rank], value: (hard: Int, soft: Int?)) {
        let hand = Hand()
        for r in ranks {
            hand.cards.append(Card(suit: Suit.Diamonds, rank:r))
        }
        let score = hand.getScore()
        XCTAssert(score.hard == value.hard, "hard \(ranks) should be equal \(value.hard) but it is \(score.hard)")
        XCTAssert(score.soft == value.soft, "soft \(ranks) should be \(value.soft) but it is \(score.soft)")
    }
}
