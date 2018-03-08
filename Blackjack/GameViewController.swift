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
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        let camera = SCNCamera()
        cameraNode.camera = camera
        scene.rootNode.addChildNode(cameraNode)

        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)


        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        

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
}
