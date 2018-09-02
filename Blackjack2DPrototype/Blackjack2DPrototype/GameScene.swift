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

class DealCardOperation: Operation {
    
    var card: Card
    var deck: SKNode
    var hand: HandView
    var scene: SKScene
    var _finished = false // Our read-write mirror of the super's read-only finished property
    var _executing = false
    
    required init(scene: SKScene, hand: HandView, theCard: Card, theDeck: SKNode) {
        self.card = theCard
        self.deck = theDeck
        self.hand = hand
        self.scene = scene
        super.init()
    }
    override var isAsynchronous: Bool {
        return true
    }
    override var isConcurrent: Bool {
        return true
    }
    /// Override read-only superclass property as read-write.
    override var isExecuting: Bool {
        get { return _executing }
        set {
            willChangeValue(forKey: "isExecuting")
            _executing = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    /// Override read-only superclass property as read-write.
    override var isFinished: Bool {
        get { return _finished }
        set {
            willChangeValue(forKey: "isFinished")
            _finished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    override func start() {
        if isCancelled {
            isFinished = true
            return
        }
        isFinished = false
        isExecuting = true
        
        self.main()
    }
    override func main() {
        
        let cardNode = SKSpriteNode(imageNamed: "shirt")
        self.scene.addChild(cardNode)
        cardNode.isHidden = true

        cardNode.isHidden = false
        let time = 0.3

        self.hand.cards.stack.allocate()

        let targetPos = self.scene.convert(CGPoint(x: self.hand.cards.nextShift, y: 0), from: self.hand.cards)
        let targetScale = self.hand.cards.xScale

        cardNode.zRotation = self.deck.zRotation
        cardNode.position = self.deck.position
        cardNode.xScale = self.deck.xScale
        cardNode.yScale = self.deck.yScale

        let moveToAction = SKAction.move(to: targetPos, duration: time)
        let rotate = SKAction.rotate(toAngle: 0, duration: time)
        rotate.timingMode = .easeOut
        let scale = SKAction.scale(to: targetScale, duration: time)

        moveToAction.timingMode = .easeInEaseOut
        
//        if self.card.hidden {
            let waitAndSwap = SKAction.sequence([SKAction.wait(forDuration: time * 2/3), SKAction.run({
                cardNode.texture = SKTexture(imageNamed: self.card.hidden ? "shirt" : self.card.imageNamed)
            })])
//        }
        cardNode.run(SKAction.sequence([SKAction.group([rotate, scale, moveToAction, waitAndSwap]), SKAction.run {
            cardNode.removeFromParent()
            self.hand.cards.addNode(cardNode)
            let pos = self.hand.cards.convert(cardNode.position, from: self.scene)
            cardNode.position = pos
            self.isFinished = true
        }]))
    }
}

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
        
        self.dealingQueue.addOperation {
            self.enumerateChildNodes(withName: ".//hand_*") { (node, _) in
                if let handView = node as? HandView {
                    handView.run(SKAction.fadeAlpha(by: 0, duration: 0.4)) {
                        handView.clear()
                    };
                }
            }
            
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
        
        let op = DealCardOperation(scene: self, hand: handNode, theCard: card, theDeck: self.deckNode)
        
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
        let op = DealCardOperation(scene: self, hand: self.dealerNode, theCard: card, theDeck: self.deckNode)
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
