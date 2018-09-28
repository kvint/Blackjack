//
//  CheatsViewController.swift
//  Blackjack2DPrototype
//
//  Created by Александр Славщик on 9/28/18.
//  Copyright © 2018 Александр Славщик. All rights reserved.
//

import UIKit

class CheatsViewController: UITableViewController {
    
    var selectedCheat: [Cheat]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func onDoneHandler(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globals.cheats.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        cell.textLabel?.text = Array(globals.cheats.keys)[indexPath.item]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCheat = Array(globals.cheats.values)[indexPath.item]
        self.performSegue(withIdentifier: "showCheat", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCheat" {
            if let destination = segue.destination as? CheatDetailController {
                destination.selectedCheat = self.selectedCheat
            }
        }
    }
}
