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
    private let step: CGFloat = 45
    var shiftX: CGFloat = 0.0
    var cards: [SKSpriteNode] = []
    
    var nextShift: CGFloat {
        get {
            return self.shiftX + self.step
        }
    }
    
    func addNode(_ card: SKSpriteNode) {
        self.addChild(card)
        card.setScale(1)
        card.position.x = self.nextShift
        card.position.y = 0;
        self.shiftX = self.nextShift
    }
    
    func add(card: Card) {
        let cardNode = card.hidden ? SKSpriteNode(imageNamed: "shirt") : SKSpriteNode(imageNamed: card.imageNamed)

        self.addChild(cardNode)
        cardNode.position.x = self.nextShift
        self.shiftX = self.nextShift
    }
    func clear() {
        self.removeAllChildren()
        shiftX = 0.0
    }
}

class ChipStack: SKNode {
    var label: SKLabelNode = SKLabelNode()
    
    override init() {
        super.init();
        label.fontSize = 35
        self.addChild(label)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func clear() {
        self.label.text = ""
    }
}

class HandView: SKNode {
    
    var id: Int = 0
    var score: SKLabelNode = SKLabelNode(text: "")
    var cards: CardStack = CardStack()
    var chips: ChipStack = ChipStack()
    var spotArea: SKShapeNode = SKShapeNode(circleOfRadius: 65)
    var spotGlow: SKShapeNode = SKShapeNode(circleOfRadius: 88)
    
    private var _selected: Bool = false
    
    var selected: Bool {
        get {
            return _selected
        }
        set(value) {
            self._selected = value
            self.spotGlow.isHidden = !value
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        spotArea.strokeColor = .yellow
        spotArea.glowWidth = 20
        spotArea.alpha = 0.2
        spotGlow.fillColor = .yellow
        spotGlow.alpha = 0
        
        self.chips.position.y = -125
        score.fontSize = 25
        score.position.y = 90
        cards.setScale(0.7)
        self.addChild(spotArea)
        self.addChild(spotGlow)
        self.addChild(cards)
        self.addChild(score)
        self.addChild(chips)
        
        let fadeIn = SKAction.fadeAlpha(to: 0.3, duration: 0.5)
        fadeIn.timingMode = .easeOut
        let fadeOut = SKAction.fadeAlpha(to: 0, duration: 0.5)
        fadeOut.timingMode = .easeIn
        let pulse = SKAction.sequence([fadeIn, fadeOut])
        spotGlow.run(SKAction.repeatForever(pulse))
        self.selected = false
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
        self.score.text = ""
    }
}
