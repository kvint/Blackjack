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

extension Notification.Name {
    static let openCheats = Notification.Name("OpenCheats")
}

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
class UserBank: Bank {
    
    private var currentAmount: Double = 0
    
    func take(amount: Double) throws {
        currentAmount -= amount
    }
    func put(amount: Double) {
        currentAmount += amount
    }
    var total: Double {
        get {
            return self.currentAmount
        }
    }
}

var globals: (backend: Game, view: GameScene, ua: GameActionDelegate, cheats: Dictionary<String, [Cheat]>)!

class GameViewController: UIViewController {

    private var cheats: Dictionary<String, [Cheat]>!
    private var bank: UserBank = UserBank()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = Bundle.main.path(forResource: "combinations", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                self.cheats = try JSONDecoder().decode(Dictionary<String, [Cheat]>.self, from: data)
            } catch {
                fatalError("Failed to parse cheats")
            }
        }

        NotificationCenter.default.addObserver(self, selector: #selector(onCheatsOpenRequested(_:)), name: .openCheats, object: nil)
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                self.initTheGame(scene: scene as! GameScene)
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
    @objc func onCheatsOpenRequested(_ notification: Notification) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "cheats") {
            self.present(controller, animated: true) {
                
            }
        }
    }
    func initTheGame(scene: GameScene) {
        globals = (backend: Game(), view: scene, ua: GameActionDelegate(), cheats: self.cheats)
        globals.backend.bank = bank
        globals.backend.delegate = globals.ua
        globals.ua.cardsDelegate = scene
        self.addUIView();
    }
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    private func addUIView() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "uiLayer") as! UIGameViewController
        globals.ua.uiDelegate = controller;
        self.addChild(controller)
        let selfViewFrame = self.view.frame;
        let childViewHeight = CGFloat(160);
        controller.view.frame = CGRect(origin: CGPoint(x: 0, y: selfViewFrame.height - childViewHeight), size: CGSize(width: selfViewFrame.width, height: childViewHeight))
        self.view.frame = CGRect(origin: CGPoint(x: selfViewFrame.minX, y: selfViewFrame.minY), size: CGSize(width: selfViewFrame.width, height: selfViewFrame.height - childViewHeight));
        self.view.addSubview(controller.view)
        controller.didMove(toParent: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
