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
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var createAccountLabel: UIButton!
    @IBOutlet var errorLabel: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginActionButton(_ sender: UIButton) {
    }
    
    @IBAction func createAccountActionButton(_ sender: UIButton) {
    }
    

}

