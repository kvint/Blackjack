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
    
    @IBOutlet weak var cheatBtn: UIButton!
    
    @IBAction func btnHandler(_ sender: UIButton) {
        switch sender {
        case dealBtn:
            globals.ua.deal()
            break;
        case doubleBtn:
            globals.ua.double()
            break;
        case hitBtn:
            globals.ua.hit()
            break;
        case standBtn:
            globals.ua.stand()
            break;
        case splitBtn:
            globals.ua.split()
            break;
        case insuranceBtn:
            globals.ua.insurance()
            break;
        case cheatBtn:
            NotificationCenter.default.post(Notification(name: .openCheats))
            break;
        default:
            print("Unhandled button")
        }
        self.displayActions()
    }
    
    func displayActions() {
        let actions = globals.backend.getActions();
        
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

