//
//  LoginViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-19.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    var loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel.loginViewModelDelegate = self
    }
    
    
    @IBAction func pressedLogin(_ sender: Any) {
        
        let email = emailText.text
        let password = passwordText.text
        
        if email != "", password != "" {
            loginViewModel.logIn(email: email!, password: password!)
        } else {
            self.showAlert(title: "Login Error", message: "Please enter Email and Password")
        }
    }
    
    @IBAction func pressedBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

extension LoginViewController: LoginViewModelDelegate {
    
    func finishLogIn(errorMessage: String?) {
        
        if errorMessage == nil {
            self.performSegue(withIdentifier: "GoToMainMenu", sender: nil)
        } else {
            self.showAlert(title: "Login Error", message: errorMessage!)
        }
    }
    
    
}
