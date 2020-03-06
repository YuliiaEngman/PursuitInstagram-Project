//
//  ViewController.swift
//  PursuitInstagram-Project
//
//  Created by Yuliia Engman on 3/3/20.
//  Copyright © 2020 Yuliia Engman. All rights reserved.
//

import UIKit

enum AccountState {
    case existingUser
    case newUser
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var pursuitStagramLabel: UILabel!
    @IBOutlet weak var pursuitStagramImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel! // accountStateMessageLabel
    @IBOutlet weak var createAccountLabel: UIButton! // accountStateButton
    @IBOutlet weak var errorLabel: UILabel!
    
    private var accountState: AccountState = .existingUser
    
    private var authSession = AuthentificationSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearErrorLabel()
    }
    
    private func clearErrorLabel() {
        errorLabel.text = ""
    }
    
    @IBAction func loginActionButton(_ sender: UIButton) {
        print("login button pressed")
        
        guard let email = emailTextField.text,
            !email.isEmpty,
            let password = passwordTextField.text,
            !password.isEmpty else {
                print("Missing Fields")
                return
        }
        continueLoginFlow(email: email, password: password)
    }
    
        private func continueLoginFlow(email: String, password: String) {
            if accountState == .existingUser {
                authSession.signExistingUser(email: email, password: password) {[weak self](result) in
                    switch result {
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.errorLabel.text =
                                // localizedDescription - gives human redable description of the error
                            "\(error.localizedDescription)"
                            self?.errorLabel.textColor = .systemRed
                        }
                    case .success(let authDataResult):
                        // TODO: comment line above and uncomment line below
                       // case .success:
                        DispatchQueue.main.async {
                            self?.errorLabel.text = "Welcome back user with email: \(authDataResult.user.email ?? "")"
                            self?.errorLabel.textColor = .systemGreen
                            //TODO: navigate to the main view
                           // self?.navigateToMainView()
                        }
                    }
                }
            } else {
                authSession.createNewuser(email: email, password: password) { [weak self] (result) in
                    switch result {
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.errorLabel.text =
                                // localizedDescription - gives human redable description of the error
                            "\(error.localizedDescription)"
                            self?.errorLabel.textColor = .systemRed
                        }
                    case .success(let authDataResult):
                        // TODO: comment line above and uncomment line below
                      //  case .success:

                        DispatchQueue.main.async {
                            self?.errorLabel.text = "Hope ypu enjoy our app experience. Email used: \(authDataResult.user.email ?? "")"
                            self?.errorLabel.textColor = .systemGreen

                            //TODO: navigate to the main view
                            //self?.navigateToMainView()
                        }
                        
                    }
                }
            }
            resignFirstResponder()
        }
    
    //FIXME: uncomment it out
//    private func navigateToMainView() {
//        UIViewController.showViewController(storyboardName: "MainView", viewControllerId: "MainTabBarController")
//    }
    
    @IBAction func createAccountActionButton(_ sender: UIButton) {
        // change the account login state
        accountState = accountState == .existingUser ? .newUser : .existingUser
        
        // animation duration
        let duration: TimeInterval = 1.0
        
        if accountState == .existingUser {
            UIView.transition(with: view, duration: duration, options: [.transitionCrossDissolve], animations: {
                self.loginButton.setTitle("Login", for: .normal)
                self.statusLabel.text = "Don't have an account ? Click"
                self.createAccountLabel.setTitle("SIGNUP", for: .normal)
                
            }, completion: nil)
//            UIView.transition(with: containerView, duration: duration, options: [.transitionCrossDissolve], animations: {
//                self.loginButton.setTitle("Login", for: .normal)
//                self.accountStateMessageLabel.text = "Don't have an account ? Click"
//                self.accountStateButton.setTitle("SIGNUP", for: .normal)
//            }, completion: nil)
        } else {
            UIView.transition(with: view, duration: duration, options: [.transitionCrossDissolve], animations: {
                self.loginButton.setTitle("Sign Up", for: .normal)
                self.statusLabel.text = "Already have an account ?"
                self.createAccountLabel.setTitle("LOGIN", for: .normal)
            }, completion: nil)
//            UIView.transition(with: containerView, duration: duration, options: [.transitionCrossDissolve], animations: {
//                self.loginButton.setTitle("Sign Up", for: .normal)
//                self.accountStateMessageLabel.text = "Already have an account ?"
//                self.accountStateButton.setTitle("LOGIN", for: .normal)
//            }, completion: nil)
        }
    }
}

