//
//  RegisterViewController.swift
//  FinalProject
//
//  Created by David Qian on 12/6/20.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class RegisterViewController: UIViewController {
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpElements()
    }
    
    func setUpElements() {
        // Hide the error label
        errorLabel.alpha = 0
        
        // Style elements
        Utilities.styleTextField(usernameTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(confirmPasswordTextField)
        Utilities.styleFilledButton(registerButton)
        Utilities.styleFilledButton(loginButton)
        
    }
    // Returns error message, if no error, returns nil
    func validateFields() -> String? {
        // Check all fields filled in
        if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        // Check if email is valid
        if Utilities.isEmailValid(usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) == false {
            return "Please provide valid email."
        }
        
        // Check if password is valid
        if Utilities.isPasswordValid(passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) == false {
            return "Password must contain 8 characters, a special character, and a number."
        }
        
        // Check if passwords match
        if passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) != confirmPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) {
            return "Passwords must match."
        }
        return nil
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        
        // Validate fields
        let error = validateFields()
        if error != nil {
            showError(error!)
        }
        else {
            
            let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create user
            Auth.auth().createUser(withEmail: username, password: password) { (result, err) in
                // Check for errors
                if err != nil {
                    self.showError("Error creating user")
                }
                else {
                    // Store user info
                    let db = Firestore.firestore()
                    let balance: Int = 10000
                    db.collection("users").addDocument(data: ["username":username, "balance": balance, "uid":result!.user.uid]) { (error) in
                        
                        if error != nil {
                            self.showError("Error saving user data.")
                        }
                    }
                    
                    // Transition to home screen
                    self.transitionToHome()
                }
            }
        }
    }
    
    func showError(_ message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? UINavigationController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
