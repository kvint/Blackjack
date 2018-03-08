//
//  GameViewController.swift
//  Blackjack
//
//  Created by Alexander Slavschik on 2/20/18.
//  Copyright © 2018 Alexander Slavschik. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class UILayerViewController: UIViewController {
    
    @IBOutlet weak var uiLayerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func startButtonClicked(_ sender: UIButton) {
        let totalHands = 5
        var i = 0;
        repeat {
            game.bet(index: i, stake: 100)
            i += 1
        } while i < totalHands
        
        game.deal();
    }
}

