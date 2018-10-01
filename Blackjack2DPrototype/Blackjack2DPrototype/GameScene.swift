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
    var spotGlow: SKSpriteNode = SKSpriteNode(texture: TextureCache.getTexture("spot"))
    var handNodes: NSMutableDictionary = NSMutableDictionary()
    
    override func didMove(to view: SKView) {
        
        self.animationQueue.maxConcurrentOperationCount = 1
        
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
        
        spotGlow.isHidden = true
        spotGlow.alpha = 0.6
        insertChild(spotGlow, at: 0)
        
        self.topNode = topNode
        self.discardDeckNode = discardNode
        self.dealerNode = dealerNode as? HandView
        self.deckNode = deckNode
        self.chipsNode = chipsNode
        self.dealerChipsNode = dealerChipsNode
        
        self.enumerateChildNodes(withName: ".//hand") { (node, _) in
            if let handId = node.userData?["hand_id"] {
                let handStr = "\(handId)"
                var model: BJUserHand? = globals.backend.model.getHand(id: handStr)
                if model == nil {
                    model = globals.backend.model.createHand(id: handStr)
                }
                if let handView = node as? HandView {
                    handView.model = model
                    self.handNodes.setObject(handView, forKey: handStr as NSCopying)
                }
            }
        }
    }
    func eachHand(_ closure :(_: HandView) -> Void) {
        globals.backend.model.hands.forEach {
            if let handId = $0?.id {
                if let handView = self.handNodes[handId] as? HandView {
                    closure(handView)
                }
            }
        }
    }
    func startGame() {
        self.isUserInteractionEnabled = false
        spotGlow.isHidden = false
    }
    func endGame() {
        self.eachHand { self.discard(hand: $0) }
        self.discard(hand: self.dealerNode)
        self.isUserInteractionEnabled = true
        spotGlow.isHidden = true
    }
    
    func updated(hand: inout BJHand) {
        self.getHandView(hand.id).updateScore()
    }
    
    func onPayout(hand: inout BJUserHand) {
        let handView = self.getHandView(hand.id)
        if hand.win > 0 {
            let chip = SKSpriteNode(texture: TextureCache.getTexture("chip"))
            self.dealerChipsNode.addChild(chip)
            self.animationQueue.addOperation(FlyAnimation(node: chip, to: handView.chips))
            var winningChipNodes = handView.chips.children
            winningChipNodes.append(chip)
            winningChipNodes.forEach { (chip) in
                self.animationQueue.addOperation(FlyAnimation(node: chip, to: self.chipsNode))
            }
        } else if hand.win == hand.stake {
            // push
            handView.chips.children.forEach { (chip) in
                self.animationQueue.addOperation(FlyAnimation(node: chip, to: self.chipsNode))
            }
        } else {
            handView.chips.children.forEach { (chip) in
                self.animationQueue.addOperation(FlyAnimation(node: chip, to: self.dealerChipsNode))
            }
        }
        if hand.gotBusted() {
            discard(hand: handView)
        }
    }
    func onBust(atHand: inout BJUserHand) {
        //
    }
    func discard(hand: HandView) {
        let op = DiscardCardsAnimation(hand: hand)
        self.animationQueue.addOperation(op)
    }
    func didHandChange(_ hand: inout BJHand) {
        if let ah = self.activeHandNode {
            ah.selected = false
        }
        
        self.activeHandNode = self.getHandView(hand.id)
        self.activeHandNode?.selected = true
        
        if let pos = self.activeHandNode?.position {
            spotGlow.run(SKAction.move(to: pos, duration: 0.1))
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
        
        let handNode = self.getHandView(id)
        var completeTime: Double? = nil
        if globals.backend.state == .Betting  {
            completeTime = 0.1
        }
        
        let deal = DealCardAnimation(theCard: card, to: handNode, time: 0.4, completeAfter: completeTime)
        
        self.animationQueue.addOperation(deal)
        self.animationQueue.addOperation(BlockOperation {
            handNode.updateScore()
        })
    }
    func dealCardToDealer(card: Card) -> Void {
        let completeTime = globals.backend.state == .Betting ? 0.2 : nil
        let op = DealCardAnimation(theCard: card, to: self.dealerNode, time: 0.4, completeAfter: completeTime)
        self.animationQueue.addOperation(op)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
        let touchedNodes = self.nodes(at: pos)
        touchedNodes.forEach { (node) in
            if let handModelID = (node as? HandView)?.model?.id {
                
                print("bet on hand -> \(handModelID)")
                if globals.backend.state != .Betting {
                    print("The game is playing")
                } else {
                    try? globals.backend.bet(handId: "\(handModelID)", stake: 10)
                }
            }
        }
        
    }
    func getHandView(_ id: String) -> HandView {
        if id == "dealer" {
            return self.dealerNode
        }
        guard let hand = self.handNodes.value(forKey: id) as? HandView else {
            fatalError("Hand node not found")
        }
        return hand
    }
    func betOnHand(handId: String) {
        let handView = self.getHandView(handId)
        let chip = SKSpriteNode(texture: TextureCache.getTexture("chip"))
        chip.setScale(0.8)
        chipsNode.addChild(chip)

        let animation = FlyAnimation(node: chip, to: handView.chips)
        animation.execute()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
