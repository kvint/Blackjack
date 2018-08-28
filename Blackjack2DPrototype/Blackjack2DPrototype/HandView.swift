//
//  HandView.swift
//  Blackjack2DPrototype
//
//  Created by Александр Славщик on 8/28/18.
//  Copyright © 2018 Александр Славщик. All rights reserved.
//

import UIKit
import SpriteKit
import CardsBase

class CardStack: SKNode {
    
    var shiftX: CGFloat = 0.0
    var cards: [SKSpriteNode] = []
    
    func add(card: Card) {
        let cardNode = SKSpriteNode(imageNamed: card.imageNamed)
        self.addChild(cardNode)
        cardNode.position.x = shiftX
        self.shiftX += 50
    }
    func clear() {
        self.removeAllChildren()
        shiftX = 0.0
    }
}

class ChipStack: SKNode {
    var label: SKLabelNode = SKLabelNode(text: "0")
    
    override init() {
        super.init();
        label.fontSize = 70
        self.addChild(label)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func clear() {
        self.label.text = "0"
    }
}

class HandView: SKNode {
    
    var id: Int = 0
    var score: SKLabelNode = SKLabelNode(text: "")
    var cards: CardStack = CardStack()
    var chips: ChipStack = ChipStack()
    var spotArea: SKShapeNode = SKShapeNode(circleOfRadius: 88)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        spotArea.glowWidth = 2.0
        spotArea.fillColor = .white
        spotArea.alpha = 0.3
        self.chips.position.y = -250
        score.fontSize = 50
        score.position.y = 180
        self.addChild(spotArea)
        self.addChild(cards)
        self.addChild(score)
        self.addChild(chips)
    }
    func updateBet(hand: inout BJUserHand) {
        self.chips.label.text = "\(hand.stake)";
    }
    func updateScore(hand: inout BJUserHand) {
        let scr = hand.getScore()
        if let softScore = scr.soft {
            self.score.text = "\(scr.hard)/\(softScore)"
        } else {
            self.score.text = "\(scr.hard)"
        }
    }
    func clear() {
        self.cards.clear()
        self.chips.clear()
    }
}
