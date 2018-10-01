//
//  HandView.swift
//  Blackjack2DPrototype
//
//  Created by Александр Славщик on 8/28/18.
//  Copyright © 2018 Александр Славщик. All rights reserved.
//

import UIKit
import SpriteKit
import CardsBase

class TextureCache {
    static private var cache: NSMutableDictionary = NSMutableDictionary()
    
    static func getTexture(_ name: String) -> SKTexture {
        if let texture = cache.value(forKey: name) as? SKTexture {
            return texture
        }
        let newTexture = SKTexture(imageNamed: name)
        cache.setValue(newTexture, forKey: name)
        return newTexture
    }
}

class CardNode: SKNode
{
    var cardVO: Card!
    var card: SKSpriteNode = SKSpriteNode()
    var faceTexture: SKTexture!
    var shirtTexture: SKTexture = TextureCache.getTexture("shirt")
    
    required init(_ card: Card) {
        super.init()
        self.cardVO = card
        self.faceTexture = TextureCache.getTexture(card.imageNamed)
        
        let cropNode = SKCropNode()
        let textureSize = self.faceTexture.size()
        let rect = CGRect(x: -textureSize.width/2, y: -textureSize.height/2, width: textureSize.width, height: textureSize.height)
        let mask = SKShapeNode(rect: rect, cornerRadius: 17)
        
        mask.isAntialiased = true
        mask.lineCap = .round
        mask.fillColor = .black
        cropNode.addChild(self.card)
        cropNode.maskNode = mask
        
        let shadowNode = SKShapeNode(rect: rect, cornerRadius: 17)
        shadowNode.fillColor = .black
        shadowNode.alpha = 0.2
        let effectNode = SKEffectNode()
        effectNode.addChild(shadowNode)
        effectNode.shouldRasterize = true
        effectNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": 30])
        self.insertChild(effectNode, at: 0)
    
        self.addChild(cropNode)
        self.updateTexture();
    }
    private func updateTexture() {
        self.card.texture = cardVO.hidden ? shirtTexture : faceTexture
        self.card.size = self.card.texture!.size()
    }
    func flip() {
        cardVO.hidden = !cardVO.hidden
        self.updateTexture()
    }
    var size: CGSize {
        get {
            return self.card.size;
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class Stack {
    private var allocated: Int = 0;
    var count: Int = 0;
    
    func add() {
//        if (self.allocated < 1) {
//            self.allocate();
//        }
        self.count += 1;
        self.allocated -= 1;
        self.update();
    }
    func allocate() {
        self.allocated += 1;
        self.update();
    }
    func pop() {
        self.count -= 1;
        self.update();
    }
    func reset() {
        self.allocated = 0;
        self.count = 0;
    }
    var length: Int {
        get {
            return self.count + self.allocated;
        }
    }
    func update() {
        
    }
}
class CardStack: SKNode {
    private let step: CGFloat = 45
    var cards: [CardNode] = []
    var stack: Stack = Stack()
    
    var nextShift: CGFloat {
        get {
            return CGFloat(self.stack.length - 1) * self.step
        }
    }
    var shiftX: CGFloat {
        get {
            return CGFloat(self.stack.count - 1) * self.step
        }
    }
    
    func addNode(_ card: CardNode) {
        self.addChild(card)
        card.setScale(1)
        self.stack.add()
        self.cards.append(card)
    }
    
    func clear() {
        self.cards = []
        self.stack.reset()
        self.removeAllChildren()
    }
}

class ChipStack: SKNode {
    var label: SKLabelNode = SKLabelNode()
    
    override init() {
        super.init();
        label.fontSize = 35
        self.addChild(label)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func clear() {
        self.label.text = ""
    }
}

class ScoreLabel: SKNode {
    
    var label: SKLabelNode = SKLabelNode(text: "")
    var shape: SKShapeNode = SKShapeNode()
    var path: CGPath!
    
    override init() {
        super.init()
        label.fontSize = 20
        label.fontName = "Monaco"
        //label.fontColor
        shape.path = self.path
        shape.fillColor = .darkGray
        shape.strokeColor = .white
        shape.lineWidth = 1
        self.addChild(shape)
        self.addChild(label)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func updateScore(hand: BJUserHand) {
        self.label.text = "?"
        if hand.isDone {
            self.label.text =  "\(hand.getFinalScore())"
        } else {
            let scr = hand.getScore()
            if let softScore = scr.soft {
                self.label.text = "\(scr.hard)/\(softScore)"
            } else {
                self.label.text = "\(scr.hard)"
            }
        }
        let rect = CGRect(x:label.frame.origin.x - 10, y: label.frame.origin.y - 10, width: label.frame.size.width + 20, height: label.frame.size.height + 20)
        self.path = UIBezierPath(roundedRect: rect, cornerRadius: 32).cgPath
        shape.path = self.path
    }
    func clear() {
        self.label.text = ""
    }
}

class HandView: SKNode {
    
    var score: ScoreLabel = ScoreLabel()
    var cards: CardStack = CardStack()
    var chips: ChipStack = ChipStack()
    var spotArea: SKShapeNode = SKShapeNode(circleOfRadius: 65)
    var model: BJUserHand?
    
    private var _selected: Bool = false
    
    var selected: Bool {
        get {
            return _selected
        }
        set(value) {
            self._selected = value
            self.score.shape.fillColor = value ? .blue : .darkGray
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        spotArea.strokeColor = .yellow
        spotArea.glowWidth = 20
        spotArea.alpha = 0.2
        
        self.chips.position.y = -125
        
        score.position.x = -90
        score.isHidden = true
        
        cards.setScale(0.7)
        self.addChild(spotArea)
        self.addChild(cards)
        self.addChild(score)
        self.addChild(chips)
        
        self.selected = false
    }
    func updateBet(hand: inout BJUserHand) {
        self.chips.label.text = "\(hand.stake)";
    }
    func updateScore() {
        guard let hand = self.model else {
            return
        }
        self.score.isHidden = false
        self.score.updateScore(hand: hand)
    }
    func clear() {
        self.score.isHidden = true
        self.cards.clear()
        self.chips.clear()
        self.score.clear();
    }
}
