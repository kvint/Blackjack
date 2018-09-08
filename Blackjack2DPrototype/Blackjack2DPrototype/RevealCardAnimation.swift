//
//  RevealDealerCardAnimation.swift
//  Blackjack2DPrototype
//
//  Created by Александр Славщик on 04.09.2018.
//  Copyright © 2018 Александр Славщик. All rights reserved.
//

import Foundation
import CardsBase
import SpriteKit

class RevealFirstCardAnimation: AsyncOperation {
    
    var hand: HandView
    var card: Card
    
    required init(theCard: Card, hand: HandView) {
        self.hand = hand
        self.card = theCard
        super.init()
    }
    
    override func execute() {
        let cardNode = self.hand.cards.cards[0]
        let time = 0.3
        let currentPos = cardNode.position
        let targetPos = CGPoint(x: cardNode.position.x - cardNode.size.width, y: cardNode.position.y)
        let moveToAction = SKAction.move(to: targetPos, duration: time)
        let moveBackAction = SKAction.move(to: currentPos, duration: time)
        moveToAction.timingMode = .easeOut
        moveBackAction.timingMode = .easeIn
        
        cardNode.run(SKAction.sequence([moveToAction, SKAction.run {
            cardNode.flip()
            }, SKAction.wait(forDuration: time * 1/2), moveBackAction, SKAction.run {
            self.isFinished = true
        }]))
    }
}
