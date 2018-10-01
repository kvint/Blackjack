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

    var node: SKNode
    var toNode: SKNode
    var time: Double!
    var actionTime: Double!

    required init(node: SKNode, to: SKNode, time: Double = 0.3, completeAfter: Double? = nil) {
        self.node = node
        self.toNode = to
        self.time = time
        if completeAfter != nil {
            self.actionTime = completeAfter
        } else {
            self.actionTime = self.time
        }
        super.init()
    }

    override func execute() {

        if let nodeParent = self.node.parent {
            // convert
            self.node.position = globals.view.topNode.convert(self.node.position, from: nodeParent)
            self.node.removeFromParent();
        }
        globals.view.topNode.addChild(self.node)

        let targetPos = globals.view.topNode.convert(CGPoint(x: 0, y: 0), from: self.toNode)
        let moveToAction = SKAction.move(to: targetPos, duration: time)
        moveToAction.timingMode = .easeOut

        let rotateAction = SKAction.rotate(toAngle: CGFloat(drand48() * Double.pi), duration: time)
        rotateAction.timingMode = .easeInEaseOut

        let scaleUp = SKAction.scale(to: 1.5, duration: time / 2)
        scaleUp.timingMode = .easeOut
        let scaleDown = SKAction.scale(to: 1, duration: time / 2)
        scaleDown.timingMode = .easeIn
        let scaleAction = SKAction.sequence([scaleUp, scaleDown])
        
        let anim = SKAction.sequence([SKAction.group([moveToAction, rotateAction, scaleAction]), SKAction.run {
            self.node.move(toParent: self.toNode)
        }])

        let completionAction = SKAction.run {
            self.isFinished = true
        }
        if self.time == self.actionTime {
            self.node.run(SKAction.sequence([anim, completionAction]))
        } else {
            self.node.run(SKAction.sequence([SKAction.wait(forDuration: self.actionTime), completionAction]))
            self.node.run(anim)
        }
    }
}
