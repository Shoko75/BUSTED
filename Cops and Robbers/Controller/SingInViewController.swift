//
//  SignInViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-17.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    var singInViewModel = SignInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        singInViewModel.signInDelegate = self
    }

    @IBAction func pressedSingIn(_ sender: Any) {
        
        let userName = userNameText.text
        let email = emailText.text
        let password = passwordText.text
        
        if userName != "", email != "", password != "" {
            singInViewModel.createUser(userName: userName!, email: email!, password: password!)
        } else {
            self.showAlert(title: "SignIn Error", message: "please enter username, email and password")
        }
    }
    
    @IBAction func pressedBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}

extension SignInViewController: SignInDelegate {
    func finishSignIn(errorMessage: String?) {
        
        if errorMessage == nil {
            self.performSegue(withIdentifier: "GoToMainMenu", sender: nil)
        } else {
            self.showAlert(title: "SignIn Error", message: errorMessage!)
        }
    }
    
    
}
