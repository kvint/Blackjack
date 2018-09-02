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

func getCardSprite(_ card: Card) -> SKSpriteNode {
    return card.hidden ? SKSpriteNode(imageNamed: "shirt") : SKSpriteNode(imageNamed: card.imageNamed)
}
class GameScene: SKScene, CardsDelegate {
    
    var dealingQueue = OperationQueue()
    var dealerNode: HandView!
    var activeHandNode: HandView?
    var deckNode: SKNode!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        var id = 0;
        self.dealingQueue.maxConcurrentOperationCount = 1
        self.enumerateChildNodes(withName: ".//hand_*") { (node, _) in
            (node as? HandView)?.id = id
            id = id + 1
        }
    }
    
    func endGame() {
        
        self.enumerateChildNodes(withName: ".//hand_*") { (node, _) in
            if let handView = node as? HandView {
                self.dealingQueue.addOperation {
                    handView.run(SKAction.fadeAlpha(by: 0, duration: 0.4)) {
                        handView.clear()
                    };
                }
            }
        }
        self.dealingQueue.addOperation {
            self.dealerNode.run(SKAction.sequence([SKAction.fadeAlpha(by: 0, duration: 0.4), SKAction.run {
                self.dealerNode.clear()
            }]));
        }
    }
    func didHandChange(_ hand: inout BJHand) {
        if let ah = self.activeHandNode {
            ah.selected = false
        }
        if let newHand = self.getHandView(hand.id) {
            self.activeHandNode = newHand;
            newHand.selected = true
        }
    }
    func showHand(_ id: String) {
        print("Show hand \(id)")
    }
    
    func dealCard(_ id: String, _ card: Card) {
        print("Deal card to hand \(id) -> \(card)")
        
        guard let handNode = self.getHandView(id) else {
            fatalError("Hand node not found")
        }
        
        let op = DealCardAnimation(scene: self, hand: handNode, theCard: card, theDeck: self.deckNode)
        
        self.dealingQueue.addOperation(op)
        self.dealingQueue.addOperation {
            guard let handModel = game.model.getHand(id: id) else {
                return
            }
            var hModel = handModel
            handNode.updateScore(hand: &hModel)
        }
        
    }
    func dealCardToDealer(card: Card) -> Void {
        // let cardNode = card.hidden ? SKSpriteNode(imageNamed: "shirt.png") : SKSpriteNode(imageNamed: card.imageNamed)
//        self.dealCardAnimation(node: self.dealerNode, from: "shirt", to: card.hidden ? "shirt" : card.imageNamed)
        let op = DealCardAnimation(scene: self, hand: self.dealerNode, theCard: card, theDeck: self.deckNode)
        self.dealingQueue.addOperation(op)
    }
    
    override func didMove(to view: SKView) {
        guard let dealerNode = self.childNode(withName: "//dealerNode") else {
            fatalError("Dealer node not found")
        }
        guard let deckNode = self.childNode(withName: "//deckNode") else {
            fatalError("Deck node not found")
        }
        self.dealerNode = dealerNode as! HandView
        self.deckNode = deckNode;
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
        let touchedNodes = self.nodes(at: pos)
        touchedNodes.forEach { (node) in
            if let handView = node as? HandView {
                NSLog("node \(handView.id)")
                if game.live {
                    NSLog("The game is playing")
                } else {
                    try? game.bet(handId: "\(handView.id)", stake: 10)
                }
            }
        }
        
    }
    func getHandView(_ id: String) -> HandView? {
        return self.childNode(withName: "//hand_\(id)") as? HandView
    }
    func betOnHand(handId: String) {
        guard let handView = self.getHandView(handId) else {
            return;
        }
        var handModel = game.model.getHand(id: handId)!
        handView.updateBet(hand: &handModel)
    }

    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {        
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
