//
//  SignInViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-19.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import Foundation

protocol SignInDelegate {
    func finishSignIn(errorMessage: String?)
}

class SignInViewModel {
    
    var signInDelegate: SignInDelegate?
    
    func createUser(email: String, password: String) {
        
        let singInManager = FirebaseAuthManager()
        singInManager.createUser(email: email, password: password) { [weak self] (success, error) in
            
            guard self != nil else { return }
            var errorMessage: String?
            
            if !success {
                errorMessage = error
            }
            self!.signInDelegate?.finishSignIn(errorMessage: errorMessage)
        }
    }
    
}
