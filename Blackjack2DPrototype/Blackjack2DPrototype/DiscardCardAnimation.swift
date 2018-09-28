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
    
    var card: CardNode
    var deck: SKNode
    var time: Double!
    var actionTime: Double!
    
    required init(theCard: CardNode, time: Double = 0.3, completeAfter: Double? = nil) {
        self.card = theCard
        self.deck = globals.view.discardDeckNode
        self.time = time
        if completeAfter != nil {
            self.actionTime = completeAfter
        } else {
            self.actionTime = self.time
        }
        super.init()
    }
    func getScale(from: SKNode) -> (xScale: CGFloat, yScale: CGFloat){
        var tpl = (xScale: from.xScale, yScale: from.yScale)
        var p = from.parent
        while p != nil {
            tpl.xScale *= p!.xScale
            tpl.yScale *= p!.yScale
            p = p?.parent
        }
        return tpl
    }
    func getPosition() {
        
    }
    override func execute() {
        
        let targetPos = globals.view.topNode.convert(self.deck.position, from: globals.view.topNode)
        let dscale = self.getScale(from: card)
        card.xScale = dscale.xScale
        card.yScale = dscale.yScale
        
        card.move(toParent: globals.view.topNode)
        
        let moveToAction = SKAction.move(to: targetPos, duration: time)
        let rotate = SKAction.rotate(toAngle: self.deck.zRotation, duration: time)
        rotate.timingMode = .easeIn
        
        let scale = SKAction.scaleX(to: self.deck.xScale, y: self.deck.yScale, duration: time)
        
        moveToAction.timingMode = .easeInEaseOut
        
        var animationGroup = [rotate, scale, moveToAction]
        
        let waitAndSwap = SKAction.sequence([SKAction.wait(forDuration: time * 3/5), SKAction.run({
            self.card.flip()
        })])
        animationGroup.append(waitAndSwap)
        
        let completionAction = SKAction.run {
            self.isFinished = true
        }
        let anim = SKAction.sequence([SKAction.group(animationGroup), SKAction.run {
            self.card.removeFromParent()
        }])
        
        if self.time == self.actionTime {
            card.run(SKAction.sequence([anim, completionAction]))
        } else {
            card.run(SKAction.sequence([SKAction.wait(forDuration: self.actionTime), completionAction]))
            card.run(anim)
        }
    }
}
