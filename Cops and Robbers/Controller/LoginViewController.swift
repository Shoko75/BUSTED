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
    @IBOutlet weak var password: UITextField!
    
    var loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func pressedLogin(_ sender: Any) {
        
        let loginManager = FirebaseAuthManager()
        guard let email = emailText.text, let password = password.text else { return }
        
        loginManager.logIn(email: email, password: password) { [weak self] (success) in
            guard let self = self else { return }
            var message: String = ""
            if success {
                message = "User was sucessfully logged in."
            } else {
                message = "There was an error."
            }
            
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: false, completion: nil)
        }
        
    }
    
    @IBAction func pressedBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
