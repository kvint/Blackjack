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
        self.addUILayer()
        
        // create a new scene
        
        let scene = SCNScene(named: "art.scnassets/Scene3D.scn")!
        self.createGeometry(scene.rootNode);
        
//        let contentNode = scene.rootNode.childNode(withName: "tableCards", recursively: true)
//        contentNode?.childNodes.forEach({ (node) in
//            if (node.name == "dealer") {
//                //createDealer()
//            } else {
//                let someCard = Card(Rank.random(), Suit.random()).create3D()
//                node.enumerateChildNodes({ (handChildNode, _) in
//                    handChildNode.removeFromParentNode()
//                })
//                node.addChildNode(someCard)
//            }
//        })
        
        //tableNode?.removeFromParentNode()
        
        
        let zeroNode = SCNNode()
        scene.rootNode.addChildNode(zeroNode)
        
//        print("Start")
//        let moveUp = SCNAction.moveBy(x: 120, y: 60, z: 0, duration: 5)
//        cameraNode.runAction(moveUp)
//        print("Done")
        
        //let someCard = Card(Rank.random(), Suit.random())
        //scene.rootNode.addChildNode(someCard.create3D())
        
        //scene.rootNode.addChildNode(CardView())
        // retrieve the ship node
        //let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
        
        // animate the 3d object
        //ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
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
    func createGeometry(_ rootNode: SCNNode) {
        let card = Card(Rank.random(), Suit.random())
        let node = SCNNode(geometry: card.geometry)
        node.eulerAngles = SCNVector3Make(0, Float.pi/2, 0)
        rootNode.addChildNode(node)
    }
}
