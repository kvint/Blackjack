//
//  File.swift
//  Blackjack2DPrototype
//
//  Created by Александр Славщик on 11.09.2018.
//  Copyright © 2018 Александр Славщик. All rights reserved.
//

import Foundation
import CardsBase
import SpriteKit

class DiscardCardsAnimation: AsyncOperation {
    
    var handView: HandView
    var queue: OperationQueue = OperationQueue()
    
    required init(hand: HandView) {
        self.handView = hand
        self.queue.maxConcurrentOperationCount = 1
        super.init()
    }
    
    override func execute() {
        let cardNodes = self.handView.cards.cards.reversed()
        for cardNode in cardNodes {
            var op: DiscardCardAnimation!
            if cardNode != cardNodes.last {
                op = DiscardCardAnimation(theCard: cardNode, time: 0.3, completeAfter: 0.07)
            } else {
                op = DiscardCardAnimation(theCard: cardNode, time: 0.3)
            }
            self.queue.addOperation(op)
        }
        
        self.queue.addOperation {
            self.isFinished = true
        }
    }
}
