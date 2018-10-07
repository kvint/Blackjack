//
//  SelectHand.swift
//  Blackjack2DPrototype
//
//  Created by Александр Славщик on 07.10.2018.
//  Copyright © 2018 Александр Славщик. All rights reserved.
//

import UIKit
import CardsBase
import SpriteKit

class SelectHandAnimation: AsyncOperation {
    
    var hand: BJHand?
    
    required init(hand: BJHand?) {
        self.hand = hand
    }
    
    override func execute() {
        if let ah = globals.view.activeHandNode {
            ah.selected = false
            ah.updateScore()
        }
        if let hid = hand?.id {
            let nextHandNode: HandView? = globals.view.getHandView(hid)
            nextHandNode?.selected = true
            
            if let pos = nextHandNode?.position {
                let moveAction = SKAction.move(to: pos, duration: 0.2)
                moveAction.timingMode = .easeInEaseOut
                
                globals.view.spotGlow.run(SKAction.sequence([moveAction, SKAction.run {
                    self.isFinished = true
                }]))
            }
            
            globals.view.activeHandNode = nextHandNode
        } else {
            globals.view.activeHandNode = nil
            isFinished = true
        }
    }
}
