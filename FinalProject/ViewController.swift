//
//  ViewController.swift
//  FinalProject
//
//  Created by David Qian on 12/1/20.
//

import UIKit
import SwiftSoup
import FirebaseAuth
import FirebaseFirestore
import Firebase

class ViewController: UITableViewController {
    var odds: [[String]] = []
    var money: [[String]] = []
    var games: [String] = []
    var score: [String:String] = [:]
    var bal: Int = 0
    var bets: [String] = []
    
    @IBOutlet var betButton: UIButton!
    @IBOutlet var balLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBalance()
        loadBets()
        
        // Get HTML
        var contents: String = ""
        if let url = URL(string: "https://sportsbook.draftkings.com/leagues/football/3?category=game-lines&subcategory=game") {
            do {
                contents = try String(contentsOf: url)
            } catch {
                print("Contents could not be loaded")
            }
        } else {
                print("URL was bad")
            }
        
        var contents2: String = ""
        if let url = URL(string: "https://www.footballdb.com/scores/index.html") {
            do {
                contents2 = try String(contentsOf: url)
            } catch {
                print("Contents could not be loaded")
            }
        } else {
                print("URL was bad")
            }
            
       
        // Parse HTML
        do {
            let doc: Document = try SwiftSoup.parse(contents)
            let betLines: Elements = try doc.select("span.sportsbook-outcome-cell__line")
            let teams: Elements = try doc.select("span.event-cell__name")
            let moneyLines: Elements = try doc.select("span.sportsbook-odds.american.default-color")
            
            let doc2: Document = try SwiftSoup.parse(contents2)
            let teams2: Elements = try doc2.select("td.left")
            let scores: Elements = try doc2.select("td.center")
            
            // Webscrape games and final score and store in dict
            for i in 0..<scores.count/2 {
                let team1 = try teams2[2*i].text().components(separatedBy: " ").first
                let team2 = try teams2[2*i+1].text().components(separatedBy: " ").first
                let score1 = try Int(scores[2*i].text())
                let score2 = try Int(scores[2*i + 1].text())
                score[team1!+" vs "+team2!] = String(score1! - score2!)
            }
            
            // Webscrape the betting odds
            for i in 0..<betLines.count/2 {
                let text1 = try betLines[2*i].text()
                let text2 = try betLines[2*i+1].text()
                if text1.contains("+") || text1.contains("-") {
                    odds.append([text1, text2])
                }
            }
            
            // Webscrape the game matchups
            for i in 0..<teams.count/2 {
                let text1 = try teams[2*i].text()
                let text2 = try teams[2*i+1].text()
                games.append(text1+" vs "+text2)
            }
            
            // Webscrape the bet values
            for i in 0..<moneyLines.count/2 {
                let text1 = try moneyLines[2*i].text()
                let text2 = try moneyLines[2*i+1].text()
                let tmp = text1.dropFirst()
                let tmp2 = text2.dropFirst()
                if Int(tmp)! <  130 && Int(tmp2)! < 130{
                    money.append([text1, text2])
                }
            }
            
        } catch Exception.Error(message: let message){
            print(message)
        } catch {
            print("error")
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath)
        cell.textLabel?.text = games[indexPath.row]
        return cell
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GameInfoSegue" {
            let destination = segue.destination as? GameViewController
            destination?.odds = odds[tableView.indexPathForSelectedRow!.row]
            destination?.money = money[tableView.indexPathForSelectedRow!.row]
            destination?.game = games[tableView.indexPathForSelectedRow!.row]
            destination?.bal = bal
        }
        if segue.identifier == "BetsSegue" {
            let destination1 = segue.destination as? BetViewController
            destination1?.bets = bets
        }
        
    }
    
    //viewBets
    func loadBets() {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid
        let user = db.collection("users").whereField("uid", isEqualTo: userID!)
        
        //query documents
        user.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("\(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    let docID = document.documentID
                    db.collection("users").document(docID).collection("bets").getDocuments { (query, error) in
                        if let error = error {
                            print("\(error)")
                        } else {
                            // Get game info for purchased bets and which team user bet for
                            var tmp: [String] = []
                            for doc in query!.documents {
                                let str1 = doc.get("game") as! String
                                let str2 = doc.get("team") as! String
                                tmp.append(str1 + " for " + str2)
                                
                            }
                            //save bets
                            self.bets = tmp
                        }
                    }
                }
            }
        }
        
    }
    
    //logout
    @IBAction func logoutTapped(_ sender: Any) {
        self.transitionToLogin()
    }
    
    func transitionToLogin() {
        let loginViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginViewController) as? LoginViewController
        
        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
    }
    
    //update user balance
    func getBalance() {
        
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid
        let balance = db.collection("users").whereField("uid", isEqualTo: userID!)
        balance.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("\(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    let docID = document.documentID
                        
                    self.bal = document.get("balance") as! Int
                    //display balance in app
                    self.balLabel.text = "Balance: $" + String(self.bal)
                    
                    
                    
                    // Query Bets to find winnings and update balance- needs checking
                    db.collection("users").document(docID).collection("bets").getDocuments { (query, error) in
                        if let error = error {
                            print("\(error)")
                        } else {
                            //score contains team playing in game as key and point diff as value
                            let keys = Array(self.score.keys)
                            
                            for document in query!.documents {
                                
                                let game = document.get("game") as! String
                                let firstTeam = game.components(separatedBy: " ").first!
                                let secondTeam = game.components(separatedBy: " ")[3]
                                let odds = document.get("bet") as! String
                                let team = document.get("team") as! String
                                
                                for key in keys {
                                    // check if a user has a bet on a game
                                    if key.contains(firstTeam[firstTeam.startIndex]) && key.contains(secondTeam[secondTeam.startIndex]) {
                                        // If bet is for favorited team
                                        if odds.contains("-") {
                                            let tmp = odds.dropFirst()
                                            // check if user made correct bet
                                            if team == firstTeam && Int(self.score[key]!)! > Int(tmp)!{
                                                // add to balance if true
                                                self.bal += 100
                                            }
                                            if team == secondTeam && Int(self.score[key]!)! < -1*Int(tmp)! {
                                                self.bal += 100
                                            }
                                        
                                        // If bet for underdog win
                                        } else {
                                            let tmp = odds.dropFirst()
                                            // check if user made correct bet
                                            if team == firstTeam && Int(self.score[key]!)! < Int(tmp)!{
                                                // add to balance if true
                                                self.bal += 100
                                            }
                                            if team == secondTeam && Int(self.score[key]!)! > -1*Int(tmp)! {
                                                self.bal += 100
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

}
