//
//  LoginViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-19.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import Foundation
import Firebase

protocol LoginViewModelDelegate {
    func finishLogIn(errorMessage: String?)
}

class LoginViewModel {
    
    var loginViewModelDelegate: LoginViewModelDelegate?
    let userInfoRef = Database.database().reference(withPath: "user_Info")
    
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
    
    func updateToken() {
        let userID = Auth.auth().currentUser?.uid
        let token = ["token": UserDefaults.standard.string(forKey: "FCM_TOKEN")!]
        userInfoRef.child(userID!).updateChildValues(token)
    }
}
