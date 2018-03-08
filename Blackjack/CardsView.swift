//
//  CardsView.swift
//  Blackjack
//
//  Created by Alexander Slavschik on 3/7/18.
//  Copyright © 2018 Alexander Slavschik. All rights reserved.
//

import Foundation
import CardsBase
import SceneKit
import SpriteKit
import UIKit

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
    var geometry: SCNGeometry {
        get {
            let realSize = CGSize(width: 272, height: 388)
            let realRatio = realSize.height / realSize.width
            let gameSize = CGFloat(1)
            let geometry: SCNBox = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)

            let whiteMaterial = SCNMaterial()
            whiteMaterial.diffuse.contents = UIColor.white

            let faceMaterial = SCNMaterial()
            faceMaterial.diffuse.contents = UIImage(named: self.imageNamed)

            let shirtMaterial = SCNMaterial()
            faceMaterial.diffuse.contents = UIImage(named: "shirt")

            let materials = [
                shirtMaterial,
                whiteMaterial,
                whiteMaterial,
                faceMaterial,
                whiteMaterial,
                whiteMaterial,
            ]

            geometry.materials = materials
            return geometry
        }
    }
    var node: SCNNode {
        get {
            let n = SCNNode(geometry: self.geometry)
            return n
        }
    }
    var imageNamed: String {
        get {
            return "\(self.suitName)_\(self.rankName)"
        }
    }
    func createNode() -> SKSpriteNode {
        return SKSpriteNode(imageNamed: self.imageNamed)
    }
    
    func create3D() -> SCNNode {
        let node = Card.nodeTemplate.clone()
        node.geometry = Card.nodeTemplate!.geometry!.copy() as! SCNGeometry
        node.geometry!.materials = Card.nodeTemplate!.geometry!.materials
        node.geometry?.firstMaterial?.diffuse.contents = UIImage(named: self.imageNamed)
        print("create card", self.imageNamed)
        return node
    }
    static var nodeTemplate: SCNNode!
}
