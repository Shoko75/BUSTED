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
    @IBOutlet weak var signInButton: UIButton!
    
    var loginViewModel = LoginViewModel()
    
    // MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Layout and keyboard setting
        signInButton.layer.cornerRadius = 12
        keyboardSetting()
        
        // Delegate
        loginViewModel.loginViewModelDelegate = self
    }
    
    deinit {
        // Stop listening for keyboard
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
        
    }
    
    func keyboardSetting() {
        self.hidesKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    // MARK: Button Functions
    @IBAction func pressedLogin(_ sender: Any) {
        
        let email = emailText.text
        let password = passwordText.text
        
        if email != "", password != "" {
            loginViewModel.logIn(email: email!, password: password!)
        } else {
            self.showAlert(title: "Sign In Error", message: "Please enter Email and Password")
        }
    }
    
    @IBAction func pressedBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}

// MARK: LoginViewModelDelegate
extension LoginViewController: LoginViewModelDelegate {
    
    func finishLogIn(errorMessage: String?) {
        
        if errorMessage == nil {
            self.performSegue(withIdentifier: "GoToMainMenu", sender: nil)
        } else {
            self.showAlert(title: "Sign In Error", message: errorMessage!)
        }
    }
}
