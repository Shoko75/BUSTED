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
        loginViewModel.loginViewModelDelegate = self
    }
    
    
    @IBAction func pressedLogin(_ sender: Any) {
        
        guard let email = emailText.text, let password = password.text,
                email != "", password != "" else { return }
        
        loginViewModel.logIn(email: email, password: password)
        
        
        
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
            let alertController = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: false, completion: nil)
        }
    }
    
    
}
