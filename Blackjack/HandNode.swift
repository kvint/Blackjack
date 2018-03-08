//
// Created by Alexander Slavschik on 3/8/18.
// Copyright (c) 2018 Alexander Slavschik. All rights reserved.
//

import Foundation
import SpriteKit
import CardsBase

class HandNode: SKNode {
    var cards: [SKSpriteNode] = []
//    var hand: BJHand

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setScale(CGFloat(0.35))
    }
//    func bindHand(hand: inout BJHand) {
//
//    }
    func addCard(card: SKSpriteNode) -> Void {
        let shiftX = 40 * self.cards.count
        card.position = CGPoint(x: shiftX, y: 0)
        card.zPosition = CGFloat(self.cards.count)
//        card.zRotation = CGFloat(0.2)

        self.cards.append(card)
        self.addChild(card)

    }
}
