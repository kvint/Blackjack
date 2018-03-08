//
// Created by Alexander Slavschik on 2/23/18.
// Copyright (c) 2018 Alexander Slavschik. All rights reserved.
//

import Foundation

class GameModel: BJModel {

    var dealer: BJDealerHand = Dealer()
    var activeHand: BJUserHand?

    private(set) var hands: [BJUserHand?] = []

    func getHand(at: Int) -> BJUserHand? {
        guard self.hands.indices.contains(at) else {
            let newHand = Hand()
            self.hands.insert(newHand, at: at)
            return newHand
        }
        return self.hands[at]!
    }

    func getNextHand() -> BJUserHand? {
        guard let aHandId = self.activeHand?.id else {
            return nil
        }
        // TODO: refactor-refactor
        var n = false
        for hand in hands {
            if hand != nil && n {
                return hand
            }
            if let handId = hand?.id {
                if handId == aHandId {
                    n = true
                }
            }
        }
        return nil
    }
}

class Hand: BJUserHand, Equatable {

    private static var IDS: Int = 0

    var stake: Double = 0

    private(set) var id: Int = 0
    var cards: [Card] = []
    var playing: Bool = false

    init() {
        self.id = Hand.IDS
        Hand.IDS += 1;
    }

    func getFinalScore() -> Int {
        let score = self.getScore()

        guard let softScore = score.soft else {
            return score.hard
        }
        guard score.hard < BlackJackConstants.MAX_SCORE else {
            return softScore
        }

        return score.hard
    }

    func getScore() -> (hard: Int, soft: Int?) {
        var score = 0
        var aces = 0

        for card in self.cards {
            if card.rank == Rank.Ace {
                aces += 1
            } else {
                score += Game.getCardScore(card: card, soft: false)
            }
        }

        if aces > 0 {
            let soft = score + aces
            if score > 11 {
                return (hard: soft, soft: nil)
            } else {
                return (hard: score + 10 + aces, soft: soft)
            }
        }
        return (hard: score, soft: nil)
    }

    func bet(stake: Double) -> Void {
        self.stake += stake
    }

    func getActions() -> Set<BJAction> {
        guard self.cards.count > 1 else {
            return [] // TODO: throw exception?
        }

        let score = self.getScore().hard
        guard score < BlackJackConstants.MAX_SCORE else {
            return []
        }

        var actions: Set<BJAction> = [BJAction.Stand, BJAction.Hit];

        if self.cards.count == 2 {

            actions.insert(BJAction.Double)

            let card1 = self.cards.first!
            let card2 = self.cards.last!

            let score1 = Game.getCardScore(card: card1)
            let score2 = Game.getCardScore(card: card2)

            // check for split
            if score1 == score2 {
                actions.insert(BJAction.Split)
            } else {
                let hasTen = score1 == 10 || score2 == 10
                let hasAce = card1.rank == Rank.Ace || card2.rank == Rank.Ace
                if hasTen && hasAce {
                    return []
                }
            }
        }
        return actions;
    }

    static func ==(lhs: Hand, rhs: Hand) -> Bool {
        return lhs.id == rhs.id
    }
}

class Dealer: Hand, BJDealerHand {
    private(set) var insuranceAvailable: Bool = false
}
