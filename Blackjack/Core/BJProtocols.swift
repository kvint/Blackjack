//
// Created by Alexander Slavschik on 2/16/18.
// Copyright (c) 2018 alexander.slavschik. All rights reserved.
//

import Foundation

enum BJAction {
    case Deal, Double, Split, Hit, Stand, Insurance
}
protocol UserModel {
    var balance: Double {get}
}
protocol BJGame {
    weak var delegate: GameDelegate? {get set}
    var live: Bool {get}

    func bet(index: Int, stake: Double)
    func pullCard() -> Card?

    func deal()
    func double()
    func split()
    func insurance()
    func hit()
    func stand()

    static func getCardScore(card: Card, soft: Bool) -> Int
}

protocol BJModel {
    var maxHands: Int {get}
    var dealer: BJDealerHand {get set}
    var activeHand: BJUserHand? {get set}
    var hands: [BJUserHand?] {get}

    func getHand(at:Int) -> BJUserHand?
    func getNextHand() -> BJUserHand?
}

protocol BJHand {
    var id: Int {get}
    var cards: [Card] {get set}

    func getScore() -> (hard: Int, soft: Int?)
}

protocol BJUserHand: BJHand {
    var stake: Double {get}
    var playing: Bool {get set}

    func bet(stake: Double)
    func getActions() -> [BJAction]
}

protocol BJDealerHand: BJHand {
    var insuranceAvailable: Bool {get}
}

protocol GameDelegate: class {
    func roundStarted()
    func roundEnded()

    func didDealCard(_ card: Card, _ hand: inout BJHand)

    func didHandDone(_ hand: inout BJUserHand)
}
