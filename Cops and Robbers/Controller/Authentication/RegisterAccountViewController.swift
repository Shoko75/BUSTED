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
    @IBOutlet weak var customView: CustomUIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var registerAccountViewModel = RegisterAccountViewModel()
    
    // MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Layout and keyboard setting
        layoutSetting()
        keyboardSetting()
        
        // delegate
        registerAccountViewModel.registerAccountDelegate = self
    }
    
    override func viewDidLayoutSubviews() {
        customView.roundCorners(cornerRadius: 50.0)
    }
    
    deinit {
        // Stop listening for keyboard
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        print("keyboard will show: \(notification.name.rawValue)")
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
        
    }
    
    func layoutSetting() {
        
        // Buttons
        signUpButton.layer.cornerRadius = 12
        cancelButton.layer.cornerRadius = 12
        
        // ImageView
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2
        
        // Text Field
        userNameText.attributedPlaceholder = NSAttributedString(string: "Your username",  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        emailText.attributedPlaceholder = NSAttributedString(string: "Your email",  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordText.attributedPlaceholder = NSAttributedString(string: "Your password",  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func keyboardSetting() {
        
        self.hidesKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    // MARK: Button Functions
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

// MARK: UIImagePickerControllerDelegate (For Photo Library)
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
