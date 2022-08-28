//
//  BetViewController.swift
//  FinalProject
//
//  Created by David Qian on 12/8/20.
//

import UIKit
import SwiftSoup
import FirebaseAuth
import FirebaseFirestore


class BetViewController: UITableViewController {
    
    // Bets data received from segue
    var bets: [String] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

    }
    
    // Display bets in tableview
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "BetCell", for: indexPath)
        cell.textLabel?.text = bets[indexPath.row]
        return cell
    }
    
}
