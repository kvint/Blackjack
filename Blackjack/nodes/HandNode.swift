//
// Created by Alexander Slavschik on 3/8/18.
// Copyright (c) 2018 Alexander Slavschik. All rights reserved.
//

import Foundation
import SceneKit
import CardsBase

class HandNode: SCNNode {
    
    var shiftX: Float = 0
    
    func addCard(card: Card) {
        let card = CardNode()
        card.scale = SCNVector3(x: 0.03, y: 0.03, z: 0.03)
        card.position = SCNVector3Make(shiftX, 0, 0)
        card.setRandom()
        card.renderingOrder = self.childNodes.count
        self.addChildNode(card)
        shiftX += 1
    }
    
}
