//
//  BetChipOperation.swift
//  Blackjack2DPrototype
//
//  Created by Александр Славщик on 04.09.2018.
//  Copyright © 2018 Александр Славщик. All rights reserved.
//

import Foundation
import SpriteKit

class FlyAnimation: AsyncOperation {

    var topNode: SKNode
    var node: SKNode
    var toNode: SKNode

    required init(node: SKNode, to: SKNode, flyOn: SKNode) {
        self.topNode = flyOn
        self.node = node
        self.toNode = to
        super.init()
    }

    override func execute() {
        let time = 0.3

        if let nodeParent = self.node.parent {
            // convert
            self.node.position = self.topNode.convert(self.node.position, from: nodeParent)
            self.node.removeFromParent();
        }
        self.topNode.addChild(self.node)

        let targetPos = self.topNode.convert(CGPoint(x: 0, y: 0), from: self.toNode)
        let moveToAction = SKAction.move(to: targetPos, duration: time)
        moveToAction.timingMode = .easeOut

        let rotateAction = SKAction.rotate(toAngle: CGFloat(drand48() * Double.pi), duration: time)
        rotateAction.timingMode = .easeInEaseOut

        let scaleUp = SKAction.scale(to: 1.5, duration: time / 2)
        scaleUp.timingMode = .easeOut
        let scaleDown = SKAction.scale(to: 1, duration: time / 2)
        scaleDown.timingMode = .easeIn
        let scaleAction = SKAction.sequence([scaleUp, scaleDown])
        
        self.node.run(SKAction.group([moveToAction, rotateAction, scaleAction])) {
            self.node.move(toParent: self.toNode)
            self.isFinished = true
        }
    }
}
