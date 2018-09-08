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
    var topNode: SKNode
    
    required init(theCard: CardNode, to: SKNode, flyOn: SKNode) {
        self.card = theCard
        self.deck = to
        self.topNode = flyOn
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
        
        let time = 0.3
        
        let targetPos = self.topNode.convert(self.deck.position, from: self.topNode)
        let dscale = self.getScale(from: card)
        card.xScale = dscale.xScale
        card.yScale = dscale.yScale
        
        card.move(toParent: self.topNode)
        
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
    
        card.run(SKAction.sequence([SKAction.group(animationGroup), SKAction.run {
            self.card.move(toParent: self.deck)
            self.card.setScale(1)
            self.card.zRotation = 0
            self.card.position = CGPoint(x: 0, y:0)
            self.isFinished = true
        }]))
    }
}
