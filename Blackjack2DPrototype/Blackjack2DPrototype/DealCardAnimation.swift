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
    var topNode: SKNode
    
    required init(theCard: Card, from: SKNode, to: HandView, flyOn: SKNode) {
        self.card = theCard
        self.deck = from
        self.hand = to
        self.topNode = flyOn
        super.init()
    }
    
    override func execute() {
        let wasHiddenInitially = self.card.hidden
        self.card.hidden = true
        let cardNode = CardNode(card)
        
        self.topNode.addChild(cardNode)
        let time = 0.3
        
        self.hand.cards.stack.allocate()
        
        let targetPos = self.topNode.convert(CGPoint(x: self.hand.cards.nextShift, y: 0), from: self.hand.cards)
        let targetScale = self.hand.cards.xScale
        
        cardNode.zRotation = self.deck.zRotation
        cardNode.position = self.deck.position
        cardNode.xScale = self.deck.xScale
        cardNode.yScale = self.deck.yScale
        
        let angle = CGFloat.pi / 180 * CGFloat(drand48() * 2)
        let moveToAction = SKAction.move(to: targetPos, duration: time)
        let rotate = SKAction.rotate(toAngle: angle, duration: time)
        rotate.timingMode = .easeOut
        let scale = SKAction.scale(to: targetScale, duration: time)
        
        moveToAction.timingMode = .easeInEaseOut
        
        var animationGroup = [rotate, scale, moveToAction]
        
        if !wasHiddenInitially {
            let waitAndSwap = SKAction.sequence([SKAction.wait(forDuration: time * 2/3), SKAction.run({
                cardNode.flip()
            })])
            animationGroup.append(waitAndSwap)
        }
        cardNode.run(SKAction.sequence([SKAction.group(animationGroup), SKAction.run {
            cardNode.removeFromParent()
            self.hand.cards.addNode(cardNode)
            let pos = self.hand.cards.convert(cardNode.position, from: self.topNode)
            cardNode.position = pos
            self.isFinished = true
        }]))
    }
}
