//
//  RegisterAccountViewController.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-17.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import UIKit

class RegisterAccountViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    var registerAccountViewModel = RegisterAccountViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerAccountViewModel.registerAccountDelegate = self
    }

    @IBAction func pressedSelectImage(_ sender: Any) {
        
        showImagePickerController()
    }
    @IBAction func pressedSingIn(_ sender: Any) {
        
        let userName = userNameText.text
        let email = emailText.text
        let password = passwordText.text
        
        if userName != "", email != "", password != "", let userImage = userImageView.image {
            registerAccountViewModel.createUser(userName: userName!, email: email!, password: password!, userImage: userImage)
        } else {
            self.showAlert(title: "SignIn Error", message: "please enter username, email and password")
        }
    }
    
    @IBAction func pressedBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
}

extension RegisterAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerController() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            userImageView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userImageView.image = originalImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
}

// MARK: RegisterAccountDelegate
extension RegisterAccountViewController: RegisterAccountDelegate {
    func finishSignIn(errorMessage: String?) {
        
        if errorMessage == nil {
            self.performSegue(withIdentifier: "GoToMainMenu", sender: nil)
        } else {
            self.showAlert(title: "SignIn Error", message: errorMessage!)
        }
    }
    
    
}
