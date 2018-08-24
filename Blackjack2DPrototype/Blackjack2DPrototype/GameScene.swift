//
//  GameScene.swift
//  Blackjack2DPrototype
//
//  Created by Александр Славщик on 17.03.2018.
//  Copyright © 2018 Александр Славщик. All rights reserved.
//

import SpriteKit
import GameplayKit
import CardsBase


extension Card {
    
    var suitName: String {
        get {
            switch (self.suit) {
            case .Spades: return "spades"
            case .Hearts: return "hearts"
            case .Clubs: return "clubs"
            case .Diamonds: return "diamonds"
            }
        }
    }
    var rankName: String {
        switch (self.rank) {
        case .Ace: return "ace"
        case .King: return "king"
        case .Queen: return "queen"
        case .Jack: return "jack"
        case .c10: return "10"
        case .c9: return "9"
        case .c8: return "8"
        case .c7: return "7"
        case .c6: return "6"
        case .c5: return "5"
        case .c4: return "4"
        case .c3: return "3"
        case .c2: return "2"
        }
    }
    var imageNamed: String {
        get {
            return "\(self.suitName)_\(self.rankName)"
        }
    }
}

class CardStack: SKNode {
    
    var shiftX: CGFloat = 0.0
    var cards: [SKSpriteNode] = []
    
    func addCard(card: Card) {
        let cardNode = SKSpriteNode(imageNamed: card.imageNamed)
        self.addChild(cardNode)
        cardNode.position.x = shiftX
        self.shiftX += 50
    }
    func clear() {
        self.removeAllChildren()
        shiftX = 0.0
    }
}

class GameScene: SKScene, CardsDelegate {
    
    func endGame() {
        self.enumerateChildNodes(withName: ".//hand_*") { (node, _) in
            if let cardStack = node as? CardStack {
                cardStack.run(SKAction.fadeAlpha(by: 0, duration: 0.4), completion: {
                    cardStack.clear()
                })
            }
        }
        self.dealerNode?.run(SKAction.fadeAlpha(by: 0, duration: 0.4), completion: {
            self.dealerNode?.clear()
        })
    }
    
    
    func showHand(_ id: String) {
        print("Show hand \(id)")
    }
    
    func dealCard(_ id: String, _ card: Card) {
        print("Deal card to hand \(id) -> \(card)")
        
        guard let handNode = self.childNode(withName: "//hand_\(id)") else {
            fatalError("Hand node not found")
        }
        (handNode as? CardStack)?.addCard(card: card)
    }
    func dealCardToDealer(card: Card) -> Void {
        self.dealerNode?.addCard(card: card)
    }
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    var dealerNode: CardStack!;
    
    override func didMove(to view: SKView) {
        guard let dealerNode = self.childNode(withName: "//dealerNode") else {
            fatalError("Dealer node not found")
        }
        self.dealerNode = dealerNode as! CardStack
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
