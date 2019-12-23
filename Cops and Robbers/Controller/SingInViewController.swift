//
//  SingInViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-17.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import UIKit

class SingInViewController: UIViewController {

    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    var singInViewModel = SingInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func pressedSingIn(_ sender: Any) {
        
        let singInManager = FirebaseAuthManager()
        if let email = emailText.text, let password = passwordText.text {
            
            singInManager.createUser(email: email, password: password) { [weak self] (success) in
                
                guard let self = self else { return }
                var message: String = ""
                
                if success {
                    self.dismiss(animated: false, completion: nil)
                } else {
                    message = "There was an error."
                    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func pressedBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}
