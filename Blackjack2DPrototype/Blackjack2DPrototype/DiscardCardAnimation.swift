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

class DiscardCardAnimation: AsyncOperation {
    
    var card: SKSpriteNode
    var deck: SKNode
    var topNode: SKNode
    
    required init(theCard: SKSpriteNode, to: SKNode, flyOn: SKNode) {
        self.card = theCard
        self.deck = to
        self.topNode = flyOn
        super.init()
    }
    
    override func execute() {
        
        let time = 0.3
        
        let fromPos = self.topNode.convert(self.card.position, from: self.card.parent!)
        let targetPos = self.topNode.convert(self.deck.position, from: self.topNode)
        card.xScale = card.parent!.xScale
        card.yScale = card.parent!.yScale
        card.position = fromPos
        
        card.removeFromParent()
        self.topNode.addChild(card)
        
        let moveToAction = SKAction.move(to: targetPos, duration: time)
        let rotate = SKAction.rotate(toAngle: self.deck.zRotation, duration: time)
        rotate.timingMode = .easeIn
        
        let scale = SKAction.scaleX(to: self.deck.xScale, y: self.deck.yScale, duration: time)
        
        moveToAction.timingMode = .easeInEaseOut
        
        var animationGroup = [rotate, scale, moveToAction]
        
        let waitAndSwap = SKAction.sequence([SKAction.wait(forDuration: time * 3/5), SKAction.run({
            self.card.texture = SKTexture(imageNamed: "shirt")
        })])
        animationGroup.append(waitAndSwap)
    
        card.run(SKAction.sequence([SKAction.group(animationGroup), SKAction.run {
            self.card.removeFromParent()
            self.deck.addChild(self.card)
            self.card.setScale(1)
            self.card.zRotation = 0
            self.card.position = CGPoint(x: 0, y:0)
            self.isFinished = true
        }]))
    }
}
