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
    var time: Double!
    var actionTime: Double!
    
    required init(theCard: Card, to: HandView, time: Double = 0.4, completeAfter: Double? = nil) {
        self.card = theCard
        self.deck = globals.view.deckNode
        self.hand = to
        self.time = time
        if completeAfter != nil {
           self.actionTime = completeAfter
        } else {
           self.actionTime = self.time
        }
        super.init()
    }
    
    override func execute() {
        let wasHiddenInitially = self.card.hidden
        self.card.hidden = true
        let cardNode = CardNode(card)
        
        globals.view.topNode.addChild(cardNode)
        
        self.hand.cards.stack.allocate()
        
        let targetPos = globals.view.topNode.convert(CGPoint(x: self.hand.cards.nextShift, y: 0), from: self.hand.cards)
        let targetScale = self.hand.cards.xScale
        
        cardNode.zRotation = self.deck.zRotation
        cardNode.position = self.deck.position
        cardNode.xScale = self.deck.xScale
        cardNode.yScale = self.deck.yScale
        
        let angle = CGFloat.pi / 180 * CGFloat(drand48() * 2)
        let moveToAction = SKAction.move(to: targetPos, duration: self.time)
        let rotate = SKAction.rotate(toAngle: angle, duration: self.time)
        rotate.timingMode = .easeOut
        
        moveToAction.timingMode = .easeInEaseOut
        
        var animationGroup = [rotate, moveToAction]
        
        if !wasHiddenInitially {
            let waitAndSwap = SKAction.sequence([SKAction.wait(forDuration: self.time * 2/3), SKAction.run({
                cardNode.flip()
            })])
            animationGroup.append(waitAndSwap)
        }
        
        let initialScale = cardNode.xScale
        let scaleUp = SKAction.scale(to: initialScale * 1.7, duration: self.time * 2/6)
        scaleUp.timingMode = .easeOut
        let scaleDown = SKAction.scale(to: targetScale, duration: self.time * 3/4)
        scaleDown.timingMode = .easeIn
        let scaleAction = SKAction.sequence([scaleUp, scaleDown])
        
        animationGroup.append(scaleAction)
        
        let anim = SKAction.sequence([SKAction.group(animationGroup), SKAction.run {
            cardNode.removeFromParent()
            self.hand.cards.addNode(cardNode)
            let pos = self.hand.cards.convert(cardNode.position, from: globals.view.topNode)
            cardNode.position = pos
        }])
    
        let completionAction = SKAction.run {
            self.isFinished = true
        }
        if self.time == self.actionTime {
            cardNode.run(SKAction.sequence([anim, completionAction]))
        } else {
            cardNode.run(SKAction.sequence([SKAction.wait(forDuration: self.actionTime), completionAction]))
            cardNode.run(anim)
        }
    }
}
