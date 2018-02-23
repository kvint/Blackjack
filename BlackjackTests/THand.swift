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
        self.checkHardScore(Rank.c2, 2)
        self.checkHardScore(Rank.c3, 3)
        self.checkHardScore(Rank.c4, 4)
        self.checkHardScore(Rank.c5, 5)
        self.checkHardScore(Rank.c6, 6)
        self.checkHardScore(Rank.c7, 7)
        self.checkHardScore(Rank.c8, 8)
        self.checkHardScore(Rank.c9, 9)
        self.checkHardScore(Rank.c10, 10)
        self.checkHardScore(Rank.King, 10)
        self.checkHardScore(Rank.Jack, 10)
        self.checkHardScore(Rank.Queen, 10)
    }
    func checkHardScore(_ rank:Rank, _ value:Int) {
        let hand = Hand()
        hand.cards.append(Card(rank))
        let score = hand.getScore()
        XCTAssert(score.hard == value, "hard \(rank) should be equal \(value)")
        XCTAssert(score.soft == nil, "soft \(rank) should be nil")
    }
    func testScoreSum() {
        self.checkScoreSum([Rank.c2, Rank.c3], (hard: 5, soft: nil))
        self.checkScoreSum([Rank.c2, Rank.c3, Rank.c2, Rank.c3, Rank.c2, Rank.c3], (hard: 15, soft: nil))
        self.checkScoreSum([Rank.King, Rank.Jack], (hard: 20, soft: nil))
        self.checkScoreSum([Rank.King, Rank.Ace], (hard: 21, soft: 11))

        self.checkScoreSum([Rank.c2, Rank.c2, Rank.Ace], (hard: 15, soft: 5))
        self.checkScoreSum([Rank.Ace, Rank.Ace], (hard: 12, soft: 2))

        self.checkScoreSum([Rank.Ace, Rank.Ace, Rank.Ace], (hard: 13, soft: 3))
        self.checkScoreSum([Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace], (hard: 16, soft: 6))
        self.checkScoreSum([Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace], (hard: 19, soft: 9))
        self.checkScoreSum([Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace, Rank.Ace], (hard: 21, soft: 11))
//
        self.checkScoreSum([Rank.Ace, Rank.Ace, Rank.Jack], (hard: 22, soft: 12))
        self.checkScoreSum([Rank.Jack, Rank.c2, Rank.Ace], (hard: 13, soft: nil))
//
        self.checkScoreSum([Rank.c5, Rank.Ace], (hard: 16, soft: 6))
        self.checkScoreSum([Rank.c2, Rank.c2, Rank.c2, Rank.c2, Rank.Ace], (hard: 19, soft: 9))
        self.checkScoreSum([Rank.c2, Rank.c4, Rank.c2, Rank.c2, Rank.Ace], (hard: 21, soft: 11))
        self.checkScoreSum([Rank.c2, Rank.c5, Rank.c2, Rank.c2, Rank.Ace], (hard: 22, soft: 12))

        self.checkScoreSum([Rank.c2, Rank.c7, Rank.c3, Rank.Jack], (hard: 22, soft: nil))
    }
    func testActions() {
        // -- 2 ---------
        self.checkActions("Basic",
                [Rank.c5, Rank.c2],
                shouldBe: [BJAction.Double, BJAction.Hit, BJAction.Stand])

        self.checkActions("Split",
                [Rank.Jack, Rank.Jack],
                shouldBe: [BJAction.Double, BJAction.Hit, BJAction.Stand, BJAction.Split])

        self.checkActions("Blackjack",
                [Rank.Jack, Rank.Ace],
                shouldBe: [])

        // -- 3 ---------
        self.checkActions("Stand/Hit",
                [Rank.c2, Rank.c4, Rank.Ace],
                shouldBe: [BJAction.Hit, BJAction.Stand])

        // -- bust -------
        self.checkActions("Bust",
                [Rank.Jack, Rank.Jack, Rank.Jack],
                shouldBe: [])
    }
    func checkActions(_ msg: String, _ ranks: [Rank], shouldBe: Set<BJAction>) -> Void {
        print("Check actions \(msg)")
        let hand = Hand()
        for rank in ranks {
            hand.cards.append(Card(rank))
        }
        let actions = hand.getActions()
        XCTAssert(actions == shouldBe, "failed \(msg)")
    }
    func checkScoreSum(_ ranks:[Rank], _ value: (hard: Int, soft: Int?)) {
        let hand = Hand()
        for rank in ranks {
            hand.cards.append(Card(rank))
        }
        let score = hand.getScore()
        XCTAssert(score.hard == value.hard, "hard \(ranks) should be equal \(value.hard) but it is \(score.hard)")
        XCTAssert(score.soft == value.soft, "soft \(ranks) should be \(value.soft) but it is \(score.soft)")
    }
}
