//
//  LoginViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-19.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import Foundation

protocol LoginViewModelDelegate {
    func finishLogIn(errorMessage: String?)
}

class LoginViewModel {
    
    var loginViewModelDelegate: LoginViewModelDelegate?
    
    func logIn(email: String, password: String) {
        
        let loginManager = FirebaseAuthManager()
        var message: String?
        
        loginManager.logIn(email: email, password: password) { [weak self] (success, error) in
            guard self != nil else { return }
            if !success {
                message = error
            }
            self!.loginViewModelDelegate?.finishLogIn(errorMessage: message)
        }
    }
}
