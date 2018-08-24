//
//  UIGameViewController
//  Blackjack2DPrototype
//
//  Created by Александр Славщик on 17.03.2018.
//  Copyright © 2018 Александр Славщик. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import CardsBase

class UIGameViewController: UIViewController {
    
    @IBOutlet weak var dealBtn: UIButton!
    @IBOutlet weak var insuranceBtn: UIButton!
    @IBOutlet weak var doubleBtn: UIButton!
    @IBOutlet weak var hitBtn: UIButton!
    @IBOutlet weak var standBtn: UIButton!
    @IBOutlet weak var splitBtn: UIButton!
    
    @IBAction func btnHandler(_ sender: UIButton) {
        switch sender {
        case dealBtn:
            gameActions.deal()
            break;
        case doubleBtn:
            gameActions.double()
            break;
        case hitBtn:
            gameActions.hit()
            break;
        case standBtn:
            gameActions.stand()
            break;
        case splitBtn:
            gameActions.split()
            break;
        case insuranceBtn:
            gameActions.insurance()
            break;
        default:
            print("Unhandled button")
        }
        self.displayActions()
    }
    
    func displayActions() {
        let actions = game.getActions();
        
        do {
            doubleBtn.isHidden = true
            dealBtn.isHidden = true
            hitBtn.isHidden = true
            standBtn.isHidden = true
            splitBtn.isHidden = true
            insuranceBtn.isHidden = true
        }
        
        for action in actions {
            switch (action) {
                case .Deal:
                    dealBtn.isHidden = false
                    break;
                case .Double:
                    doubleBtn.isHidden = false
                    break;
                case .Split:
                    splitBtn.isHidden = false
                    break;
                case .Hit:
                    hitBtn.isHidden = false
                    break;
                case .Stand:
                    standBtn.isHidden = false
                    break;
                case .Insurance:
                    insuranceBtn.isHidden = false
                    break;
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayActions()
        
    }
}

