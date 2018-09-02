//
//  DealCardAnimation.swift
//  Blackjack2DPrototype
//
//  Created by Александр Славщик on 02.09.2018.
//  Copyright © 2018 Александр Славщик. All rights reserved.
//

import Foundation
import CardsBase
import SpriteKit

class DealCardAnimation: AsyncOperation {
    
    var card: Card
    var deck: SKNode
    var hand: HandView
    var scene: SKScene
    
    required init(scene: SKScene, hand: HandView, theCard: Card, theDeck: SKNode) {
        self.card = theCard
        self.deck = theDeck
        self.hand = hand
        self.scene = scene
        super.init()
    }
    
    override func execute() {
        
        let cardNode = SKSpriteNode(imageNamed: "shirt")
        
        self.scene.addChild(cardNode)
        cardNode.isHidden = true
        
        cardNode.isHidden = false
        let time = 0.3
        
        self.hand.cards.stack.allocate()
        
        let targetPos = self.scene.convert(CGPoint(x: self.hand.cards.nextShift, y: 0), from: self.hand.cards)
        let targetScale = self.hand.cards.xScale
        
        cardNode.zRotation = self.deck.zRotation
        cardNode.position = self.deck.position
        cardNode.xScale = self.deck.xScale
        cardNode.yScale = self.deck.yScale
        
        let moveToAction = SKAction.move(to: targetPos, duration: time)
        let rotate = SKAction.rotate(toAngle: 0, duration: time)
        rotate.timingMode = .easeOut
        let scale = SKAction.scale(to: targetScale, duration: time)
        
        moveToAction.timingMode = .easeInEaseOut
        
        var animationGroup = [rotate, scale, moveToAction]
        if !self.card.hidden {
            let waitAndSwap = SKAction.sequence([SKAction.wait(forDuration: time * 2/3), SKAction.run({
                cardNode.texture = SKTexture(imageNamed: self.card.hidden ? "shirt" : self.card.imageNamed)
            })])
            animationGroup.append(waitAndSwap)
        }
        cardNode.run(SKAction.sequence([SKAction.group(animationGroup), SKAction.run {
            cardNode.removeFromParent()
            self.hand.cards.addNode(cardNode)
            let pos = self.hand.cards.convert(cardNode.position, from: self.scene)
            cardNode.position = pos
            self.isFinished = true
        }]))
    }
}
