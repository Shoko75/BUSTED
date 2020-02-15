//
//  ResetPasswordViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-02-14.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var customView: CustomUIView!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var resetPasswordViewModel: ResetPasswordViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hidesKeyboard()
        resetPasswordViewModel = ResetPasswordViewModel()
        
        resetPasswordButton.layer.cornerRadius = 12
        backButton.layer.cornerRadius = 12
        
        emailText.attributedPlaceholder = NSAttributedString(string: "Your email",  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    override func viewDidLayoutSubviews() {
        customView.roundCorners(cornerRadius: 50.0)
    }

    @IBAction func pressedBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func pressedReset(_ sender: Any) {
        guard let email = emailText.text, email != "" else {
            self.showAlert(title: "Format Error", message: "please email and password")
            return
        }
        
        resetPasswordViewModel?.resetPassword(email: email, onSuccuss: {
            self.showAlert(title: "Success", message: "We have just sent you a password reset email. Please check it!")
        }, onError: { (errorMessage) in
            print(errorMessage)
        })
        
    }
}
