//
//  GameScene.swift
//  Blackjack2DPrototype
//
//  Created by Александр Славщик on 17.03.2018.
//  Copyright © 2018 Александр Славщик. All rights reserved.
//

import Darwin
import SpriteKit
import GameplayKit
import CardsBase

func getCardSprite(_ card: Card) -> SKNode {
    return CardNode(card)
}
class GameScene: SKScene, CardsDelegate {
    
    var animationQueue = OperationQueue()
    var dealerNode: HandView!
    var activeHandNode: HandView?
    var deckNode: SKNode!
    var discardDeckNode: SKNode!
    var chipsNode: SKNode!
    var dealerChipsNode: SKNode!
    var topNode: SKNode!
    var handNodes: NSMutableDictionary = NSMutableDictionary()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.animationQueue.maxConcurrentOperationCount = 1
        self.enumerateChildNodes(withName: ".//hand") { (node, _) in
            if let handId = node.userData?["hand_id"] {
                let handStr = "\(handId)"
                var model: BJUserHand? = game.model.getHand(id: handStr)
                if model == nil {
                    model = game.model.createHand(id: handStr)
                }
                if let handView = node as? HandView {
                    handView.model = model
                    self.handNodes.setObject(handView, forKey: handStr as NSCopying)
                }
            }
        }
        
    }
    
    func endGame() {
        self.enumerateChildNodes(withName: ".//hand") { (node, _) in
            if let handView = node as? HandView {
//                if let win = handView.model?.win {
//                    if win > 0 {
//                        if handView.chips.children.count > 0 {
//                            // TODO: refactor, remove conditional
//                            let chip = handView.chips.children[0]
//                            self.animationQueue.addOperation(FlyAnimation(node: chip, to: self.dealerChipsNode, flyOn: self.topNode))
//                        }
//                    }
//                }
                self.discard(hand: handView)
            }
        }
        self.discard(hand: self.dealerNode)
        
    }
    func onPayout(hand: inout BJUserHand) {
        guard let handView = self.getHandView(hand.id) else {
            fatalError("handView not found")
        }
        if hand.win > 0 {
            handView.chips.children.forEach { (chip) in
                self.animationQueue.addOperation(FlyAnimation(node: chip, to: self.chipsNode, flyOn: self.topNode))
            }
        } else {
            handView.chips.children.forEach { (chip) in
                self.animationQueue.addOperation(FlyAnimation(node: chip, to: self.dealerChipsNode, flyOn: self.topNode))
            }
        }
    }
    func onBust(atHand: inout BJUserHand) {
        if let handView = self.getHandView(atHand.id) {
            discard(hand: handView)
        }
    }
    func discard(hand: HandView) {
        let op = DiscardCardsAnimation(hand: hand, deck: self.discardDeckNode, topNode: self.topNode)
        self.animationQueue.addOperation(op)
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
    func revealDealerCard(_ card: Card) {
        let op = RevealFirstCardAnimation(theCard: card, hand: self.dealerNode)
        self.animationQueue.addOperation(op)
    }
    func showHand(_ id: String) {
        print("Show hand \(id)")
    }
    
    func dealCard(_ id: String, _ card: Card) {
        print("Deal card to hand \(id) -> \(card)")
        
        guard let handNode = self.getHandView(id) else {
            fatalError("Hand node not found")
        }
        
        let deal = DealCardAnimation(theCard: card, from: self.deckNode, to: handNode, flyOn: self.topNode)
        
        let completion = BlockOperation {
            guard let handModel = game.model.getHand(id: id) else {
                return
            }
            var hModel = handModel
            handNode.updateScore(hand: &hModel)
        }
        completion.addDependency(deal)
        self.animationQueue.addOperation(deal)
    }
    func dealCardToDealer(card: Card) -> Void {
        // let cardNode = card.hidden ? SKSpriteNode(imageNamed: "shirt.png") : SKSpriteNode(imageNamed: card.imageNamed)
//        self.dealCardAnimation(node: self.dealerNode, from: "shirt", to: card.hidden ? "shirt" : card.imageNamed)
        
        let op = DealCardAnimation(theCard: card, from: self.deckNode, to: self.dealerNode, flyOn: self.topNode)
        self.animationQueue.addOperation(op)
    }
    
    override func didMove(to view: SKView) {
        guard let dealerNode = self.childNode(withName: "//dealer") else {
            fatalError("Dealer node not found")
        }
        guard let deckNode = self.childNode(withName: "//dealingDeck") else {
            fatalError("Deck node not found")
        }
        guard let discardNode = self.childNode(withName: "//discardedDeck") else {
            fatalError("Deck node not found")
        }
        guard let topNode = self.childNode(withName: "//topNode") else {
            fatalError("Top node not found")
        }
        guard let chipsNode = self.childNode(withName: "//chipsNode") else {
            fatalError("Chips node not found")
        }
        guard let dealerChipsNode = self.childNode(withName: "//dealerChipsNode") else {
            fatalError("dealerChipsNode node not found")
        }
        
        self.topNode = topNode
        self.discardDeckNode = discardNode
        self.dealerNode = dealerNode as! HandView
        self.deckNode = deckNode
        self.chipsNode = chipsNode
        self.dealerChipsNode = dealerChipsNode
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
        let touchedNodes = self.nodes(at: pos)
        touchedNodes.forEach { (node) in
            if let handModelID = (node as? HandView)?.model?.id {
                
                print("bet on hand -> \(handModelID)")
                if game.live {
                    print("The game is playing")
                } else {
                    try? game.bet(handId: "\(handModelID)", stake: 10)
                }
            }
        }
        
    }
    func getHandView(_ id: String) -> HandView? {
        return self.handNodes.value(forKey: id) as? HandView
//        print("enumerate hands")
//        return self.childNode(withName: "//hand\(id)") as? HandView
    }
    func betOnHand(handId: String) {
        guard let handView = self.getHandView(handId) else {
            return;
        }

        let chip = SKSpriteNode(imageNamed: "chip")

        chip.setScale(0.8)
        chipsNode.addChild(chip)

        let animation = FlyAnimation(node: chip, to: handView.chips, flyOn: topNode)
        animation.execute()
//        self.animationQueue.addOperation(animation)
//        self.animationQueue.addOperation {
//            handView.updateBet(hand: &handModel)
//        }
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
