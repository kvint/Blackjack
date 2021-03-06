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
    var imageNamed: String {
        get {
            return "\(self.suitName)_\(self.rankName)"
        }
    }
}

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
        gameActions.uiDelegate = controller;
        self.addChildViewController(controller)
        let selfViewFrame = self.view.frame;
        let childViewHeight = CGFloat(160);
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
