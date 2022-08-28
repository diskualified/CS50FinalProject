//
//  GameViewController.swift
//  FinalProject
//
//  Created by David Qian on 12/6/20.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class GameViewController: UIViewController {
    
    @IBOutlet var negativeLine: UILabel!
    @IBOutlet var positiveLine: UILabel!
    @IBOutlet var negativeMoney: UILabel!
    @IBOutlet var positiveMoney: UILabel!
    @IBOutlet var negativeButton: UIButton!
    @IBOutlet var positiveButton: UIButton!
    @IBOutlet var successLabel: UILabel!
    @IBOutlet var negativeTeam: UILabel!
    @IBOutlet var positiveTeam: UILabel!
    
    var bal: Int = 0
    var odds: [String] = []
    var money: [String] = []
    var game: String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        negativeLine.text = odds[0]
        positiveLine.text = odds[1]
        negativeMoney.text = money[0]
        positiveMoney.text = money[1]
        successLabel.alpha = 0
        let team1 = game.components(separatedBy: " ").first
        let team2 = game.components(separatedBy: " ")[3]
        negativeTeam.text = team1
        positiveTeam.text = team2
    }
    
    @IBAction func topBetTapped(_ sender: Any) {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid
        // Get user
        let document = db.collection("users").whereField("uid", isEqualTo: userID!)
        document.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("\(err)")
            } else {
                for document in querySnapshot!.documents {
                    let docID = document.documentID
                    let team1 = self.game.components(separatedBy: " ").first
                    
                    // Create collection within user documents with betting info
                    db.collection("users").document(docID).collection("bets").addDocument(data: [
                        "game": self.game,
                        "team": team1!,
                        "bet": self.odds[0],
                        "money": self.money[0]
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            self.successLabel.alpha = 1
                            
                            // Update balance after purchasing bet
                            if self.money[0].contains("+") {
                                self.bal = (self.bal - 100)
                            } else {
                                let str = self.money[0].dropFirst()
                                self.bal = self.bal - Int(str)!
                                
                                // Update one field, creating the document if it does not exist.
                                db.collection("users").document(docID).setData([ "balance": self.bal ], merge: true)
                            }
                        }
                    }
                }
            }
        }
       
    }

            
    @IBAction func bottomBetTapped(_ sender: Any) {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser?.uid
        
        let document = db.collection("users").whereField("uid", isEqualTo: userID!)
        document.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("\(err)")
            } else {
                for document in querySnapshot!.documents {
                    let docID = document.documentID
                    let team2 = self.game.components(separatedBy: " ")[3]
                    
                    // Create collection within user documents with betting info
                    db.collection("users").document(docID).collection("bets").addDocument(data: [
                        "game": self.game,
                        "team": team2,
                        "bet": self.odds[1],
                        "money": self.money[1]
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            self.successLabel.alpha = 1

                            // Update balance after purchasing bet
                            if self.money[1].contains("+") {
                                self.bal = (self.bal - 100)
                            } else {
                                let str = self.money[1].dropFirst()
                                self.bal = self.bal - Int(str)!
                                
                                // Update one field, creating the document if it does not exist.
                                db.collection("users").document(docID).setData([ "balance": self.bal ], merge: true)
                                
                            }
                        }
                    }
                }
            }
        }
       
    }
    

}
    

