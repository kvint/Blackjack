import Foundation

class Game: BJGame {
    var delegate: GameDelegate? = nil

    var model: GameModel = GameModel()
    private(set) var live: Bool = false

    private func startRound() {
        self.live = true

        self.model.activeHand = {() -> BJUserHand? in
            for hand in self.model.hands {
                if hand != nil {
                    return hand
                }
            }
            return nil
        }()

        self.delegate?.roundStarted()
        self.nextStep()
    }

    private func endRound() {
        self.model.activeHand = nil
        for var hand in self.model.hands {
            hand?.playing = false
            hand?.cards = []
        }
        self.delegate?.roundEnded()
    }
    private func dealCardToUser(hand: inout BJUserHand) {
        guard var uhnd = hand as BJHand? else {
            return
        }
        self.dealCardTo(hand: &uhnd)
    }
    private func dealCardTo(hand: inout BJHand) {
        guard let card = self.pullCard() else {
            return
        }
        hand.cards.append(card)
        self.delegate?.didDealCard(card, &hand)
    }

    private func nextStep() -> Void {
        guard var hand = self.model.activeHand else {
            return self.endRound()
        }
        if hand.getScore().hard >= BlackJackConstants.MAX_SCORE {
            hand.playing = false
        }
        if !hand.playing {
            self.delegate?.didHandDone(&hand)
            guard let nextHand = self.model.getNextHand() else {
                return self.endRound()
            }
            self.model.activeHand = nextHand
            guard nextHand.getActions().count > 0 else {
                return self.nextStep()
            }
        }
    }
    func bet(index: Int, stake: Double) {
        guard var hand = self.model.getHand(at: index, create: true) else {
            return
        }
        hand.stake = stake
    }

    func pullCard() -> Card? {
        return self.model.deck.popLast()
    }

    func deal() {
        // create deck
        self.model.createDeck()

        //deal the cards
        var dealer = self.model.dealer as BJHand
        for _ in 1...2 {
            self.dealCardTo(hand: &dealer)
            for var (_, hand) in self.model.hands.enumerated() {
                guard hand != nil else {
                    continue
                }

                hand!.playing = true
                self.dealCardToUser(hand: &hand!)
            }
        }
        self.startRound()
    }

    func double() {
        guard var hand = self.model.activeHand else {
            return;
        }
        hand.stake += hand.stake
        self.dealCardToUser(hand: &hand)
        hand.playing = false
        self.nextStep()
    }

    func split() {
        fatalError("split() has not been implemented")
    }

    func insurance() {
        fatalError("insurance() has not been implemented")
    }

    func hit() {
        guard var hand = self.model.activeHand else {
            return;
        }
        self.dealCardToUser(hand: &hand)
        self.nextStep()
    }

    func stand() {
        guard var hand = self.model.activeHand else {
            return;
        }
        hand.playing = false;
        self.nextStep()
    }

    static func getCardScore(card: Card, soft: Bool = false) -> Int {
        switch (card.rank) {
        case Rank.c2: return 2
        case Rank.c3: return 3
        case Rank.c4: return 4
        case Rank.c5: return 5
        case Rank.c6: return 6
        case Rank.c7: return 7
        case Rank.c8: return 8
        case Rank.c9: return 9
        case Rank.c10: return 10
        case Rank.Jack: return 10
        case Rank.Queen: return 10
        case Rank.King: return 10
        case Rank.Ace: return (soft ? 1 : 11)
        }
    }
}

class GameModel: BJModel {

    var deck: [Card] = []
    var dealer: BJDealerHand = Dealer()
    var activeHand: BJUserHand?

    private var handsDict: [Int: BJUserHand] = [:]
    private(set) var hands: [BJUserHand?] = []

    func createDeck() {
        self.deck = []
        for _ in 1...4 {
            self.deck += CardDeck.getDeck()
        }
        self.deck.shuffle()
    }

    func getHand(at: Int, create: Bool = false) -> BJUserHand? {
        guard let hand = self.handsDict[at] else {
            if create {
                return self.createHand(at)
            }
            return nil
        }
        return hand
    }

    func createHand(_ at: Int) -> BJUserHand {
        let newHand = Hand()
        self.handsDict[at] = newHand;
        return newHand
    }

    func getNextHand() -> BJUserHand? {
        guard let aHandId = self.activeHand?.id else {
            return nil
        }
        // TODO: refactor-refactor
        var n = false;
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
    func clear() {
        self.deck = []
        self.handsDict = [:]
        self.dealer.clear()
    }
}

class Hand: BJUserHand, Equatable {

    private static var IDS: Int = 0

    var stake: Double = 0
    var cards: [Card] = []
    var playing: Bool = false

    private(set) var id: Int = 0

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

    func clear() {
        self.cards = []
        self.stake = 0
        self.playing = false
    }

    static func ==(lhs: Hand, rhs: Hand) -> Bool {
        return lhs.id == rhs.id
    }
}

class Dealer: Hand, BJDealerHand {
    private(set) var insuranceAvailable: Bool = false
}
