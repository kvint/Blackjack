//
//  GameViewController.swift
//  Blackjack2DPrototype
//
//  Created by Александр Славщик on 17.03.2018.
//  Copyright © 2018 Александр Славщик. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import CardsBase

var game = Game()
var gameActions = GameActionDelegate()

class GameViewController: UIViewController {

    @IBAction func swipeLeft(_ sender: Any) {
        gameActions.selectedHand = gameActions.selectedHand - 1
    }
    @IBAction func swipeRight(_ sender: Any) {
        gameActions.selectedHand = gameActions.selectedHand + 1
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        game.delegate = gameActions;
        
        self.addUIView();
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                gameActions.cardsDelegate = scene as! GameScene
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = false
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    private func addUIView() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "uiLayer") as! UIGameViewController
        self.addChildViewController(controller)
        let selfViewFrame = self.view.frame;
        let childViewHeight = CGFloat(250);
        controller.view.frame = CGRect(origin: CGPoint(x: 0, y: selfViewFrame.height - childViewHeight), size: CGSize(width: selfViewFrame.width, height: childViewHeight))
        self.view.frame = CGRect(origin: CGPoint(x: selfViewFrame.minX, y: selfViewFrame.minY), size: CGSize(width: selfViewFrame.width, height: selfViewFrame.height - childViewHeight));
        self.view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
