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
        
        if let email = emailText.text, let password = passwordText.text {
            singInViewModel.createUser(email: email, password: password)
        }
    }
    
    @IBAction func pressedBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}

extension SignInViewController: SignInDelegate {
    func finishSignIn(errorMessage: String?) {
        
        if errorMessage == nil {
            self.dismiss(animated: false, completion: nil)
        } else {
            let alertController = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
}
