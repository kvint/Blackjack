//
//  CheatsViewController.swift
//  Blackjack2DPrototype
//
//  Created by Александр Славщик on 9/28/18.
//  Copyright © 2018 Александр Славщик. All rights reserved.
//

import UIKit

class CheatsViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func onDoneHandler(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return globals.cheats.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = Array(globals.cheats.keys)[indexPath.item]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //selectedCheat = Array(globals.cheats.values)[indexPath.item]
        self.performSegue(withIdentifier: "showCell", sender: self)
    }
}
