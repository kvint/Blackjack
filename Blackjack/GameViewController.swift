//
//  GameViewController.swift
//  3DTest
//
//  Created by Alexander Slavschik on 3/8/18.
//  Copyright © 2018 Alexander Slavschik. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import CardsBase

let game = Game()

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.addUILayer()
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/Scene3D.scn")!
        
        let contentNode = scene.rootNode.childNode(withName: "tableCards", recursively: true)
        var a = 1
        contentNode?.childNodes.forEach({ (node) in
            a += 100
            let handNode = HandNode()
            if (node.name == "dealer") {
                node.replaceChildNode(node.childNodes[0], with: handNode)
                handNode.addCard(card: Card(Rank.random(), Suit.random()))
                handNode.addCard(card: Card(Rank.random(), Suit.random()))
                handNode.addCard(card: Card(Rank.random(), Suit.random()))
            } else {
                node.replaceChildNode(node.childNodes[0], with: handNode)
                handNode.addCard(card: Card(Rank.random(), Suit.random()))
                handNode.addCard(card: Card(Rank.random(), Suit.random()))
                handNode.addCard(card: Card(Rank.random(), Suit.random()))
                handNode.addCard(card: Card(Rank.random(), Suit.random()))
            }
            handNode.renderingOrder = a
        })        
        
        let zeroNode = SCNNode()
        scene.rootNode.addChildNode(zeroNode)
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        scnView.scene = scene
        scnView.showsStatistics = true
        //scnView.allowsCameraControl = true
        scnView.backgroundColor = UIColor.black
        
    }
    
    func addUILayer() {
        let controller = storyboard!.instantiateViewController(withIdentifier: "uiLayer")
        addChildViewController(controller)
        let parentViewFrame: CGRect = self.view.frame
        let viewHeight = CGFloat(100)
        let x = CGFloat(0)
        let y = parentViewFrame.height - viewHeight
        
        controller.view.frame = CGRect(x: x, y: y, width: parentViewFrame.width, height:viewHeight)
        view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
    }
}
