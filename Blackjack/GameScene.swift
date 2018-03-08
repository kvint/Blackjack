//
//  GameScene.swift
//  Blackjack
//
//  Created by Alexander Slavschik on 2/20/18.
//  Copyright © 2018 Alexander Slavschik. All rights reserved.
//

import SpriteKit
import GameplayKit
import CardsBase

class GameScene: SKScene, GameDelegate {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var root: SKNode!

    private var lastUpdateTime : TimeInterval = 0
    
    override func sceneDidLoad() {
        
        game.delegate = self
        self.lastUpdateTime = 0
        self.root = self.childNode(withName: "//mainNode")!
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }

    func didHandChange(_ hand: inout BJHand) {

    }

    func roundStarted() {
    }

    func roundEnded() {
    }

    func didHandUpdate(_ hand: inout BJHand) {

    }

    func didDealCard(_ card: Card, _ hand: inout BJHand) {
        print("deal card to ", hand.id)
        guard let hand = self.childNode(withName: "//mainNode/hand_\(hand.id)") else {
            fatalError("Unable to get hand node")
        }
        (hand as? HandNode)?.addCard(card: card.createNode())
    }

    func didHandDone(_ hand: inout BJUserHand) {
    }
}
