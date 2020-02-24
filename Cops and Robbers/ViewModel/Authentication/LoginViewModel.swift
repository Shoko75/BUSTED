//
//  LoginViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-19.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import Firebase

// MARK: Protocol
protocol LoginViewModelDelegate {
    func finishLogIn(errorMessage: String?)
}

// MARK: LoginViewModel
class LoginViewModel {
    
    private let userInfoRef = Database.database().reference(withPath: "user_Info")
    var loginViewModelDelegate: LoginViewModelDelegate?
    
    // MARK: LogIn
    func logIn(email: String, password: String) {
        
        let loginManager = FirebaseAuthManager()
        var message: String?
        
        loginManager.logIn(email: email, password: password) { [weak self] (success, error) in
            guard self != nil else { return }
            if !success {
                message = error
            }
            self?.updateToken()
            self!.loginViewModelDelegate?.finishLogIn(errorMessage: message)
        }
    }
    
    // MARK: Update
    func updateToken() {
        let userID = Auth.auth().currentUser?.uid
        
        if userID != "", userID != nil {
            let token = ["token": UserDefaults.standard.string(forKey: "FCM_TOKEN")!]
            userInfoRef.child(userID!).updateChildValues(token)
        }
    }
}
