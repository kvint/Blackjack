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

struct ActionItem: Hashable {
    var node: SKNode
    var action: SKAction
    
    var hashValue: Int {
        return action.hashValue
    }
    
    static func == (lhs: ActionItem, rhs: ActionItem) -> Bool {
        return lhs.hashValue == rhs.hashValue// && lhs.petName == rhs.petName
    }
}

class ActionChain {
    let serialQueue = DispatchQueue(label: "serialQueue")
    
    var actions: [ActionItem] = []
    
    func add(node: SKNode, action: SKAction) {
        let item = ActionItem(node: node, action: action)
        self.actions.append(item)
        if self.actions.count == 1 {
            self.runNext(item: item)
        }
    }
    private func runNext(item: ActionItem) {
        
        item.node.run(item.action) {
            if let itemIndex = self.actions.index(of: item) {
                self.actions.remove(at: itemIndex)
            }
            self.onChainCompleted()
        }
    }
    func onChainCompleted() {
        if let nextItem = self.actions.first {
            self.runNext(item: nextItem)
        }
    }
}

func getCardSprite(_ card: Card) -> SKSpriteNode {
    return card.hidden ? SKSpriteNode(imageNamed: "shirt") : SKSpriteNode(imageNamed: card.imageNamed)
}
class GameScene: SKScene, CardsDelegate {
    
    var actionChain: ActionChain = ActionChain()
    var dealerNode: HandView!
    var activeHandNode: HandView?
    var deckNode: SKNode!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        var id = 0;
        self.enumerateChildNodes(withName: ".//hand_*") { (node, _) in
            (node as? HandView)?.id = id
            id = id + 1
        }
    }
    
    func endGame() {
        self.enumerateChildNodes(withName: ".//hand_*") { (node, _) in
            if let handView = node as? HandView {
                handView.run(SKAction.fadeAlpha(by: 0, duration: 0.4)) {
                    handView.clear()
                };
            }
        }
        self.dealerNode?.run(SKAction.fadeAlpha(by: 0, duration: 0.4), completion: {
            self.dealerNode?.clear()
        })
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
        var handModel = game.model.getHand(id: id)!
        let cardNode = SKSpriteNode(imageNamed: "shirt")
        
        self.addChild(cardNode)
        cardNode.isHidden = true
        
        self.actionChain.add(node: cardNode, action: SKAction.run {
            cardNode.isHidden = false
            let time = 5.0
            
            handNode.cards.stack.allocate()
            print("cardnode_start: \(card) \(handNode.cards.nextShift) \(handNode.id)")
            let targetPos = self.convert(CGPoint(x: handNode.cards.nextShift, y: 0), from: handNode.cards)
            
            let targetScale = handNode.cards.xScale
            
            cardNode.zRotation = self.deckNode.zRotation
            cardNode.position = self.deckNode.position
            cardNode.xScale = self.deckNode.xScale
            cardNode.yScale = self.deckNode.yScale
            
            let moveToAction = SKAction.move(to: targetPos, duration: time)
            let rotate = SKAction.rotate(toAngle: 0, duration: time)
            let scale = SKAction.scale(to: targetScale, duration: time)
            
            moveToAction.timingMode = .easeInEaseOut
            
            let waitAndSwap = SKAction.sequence([SKAction.wait(forDuration: time * 2/3), SKAction.run({
                cardNode.texture = SKTexture(imageNamed: card.imageNamed)
            })])
            
            let dealCardAction = SKAction.sequence([SKAction.group([rotate, scale, moveToAction, waitAndSwap]), SKAction.run {
                cardNode.removeFromParent()
                handNode.cards.addNode(cardNode)
                let pos = handNode.cards.convert(cardNode.position, from: self)
                cardNode.position = pos;
                print("cardnode_end: \(card) \(handNode.cards.shiftX)  \(handNode.id)")
                handNode.updateScore(hand: &handModel)
            }])
            
            self.actionChain.add(node: cardNode, action: dealCardAction)
        })
    }
    func dealCardToDealer(card: Card) -> Void {
        // let cardNode = card.hidden ? SKSpriteNode(imageNamed: "shirt.png") : SKSpriteNode(imageNamed: card.imageNamed)
        self.dealerNode?.cards.add(card: card)
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
