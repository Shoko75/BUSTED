//
//  SignInViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-19.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import Foundation
import Firebase

protocol SignInDelegate {
    func finishSignIn(errorMessage: String?)
}

class SignInViewModel {
    
    var signInDelegate: SignInDelegate?
    var dbUser: DBUser!
    
    let userInfoRef = Database.database().reference(withPath: "user_Info")
    
    func createUser(userName: String, email: String, password: String) {
        
        let singInManager = FirebaseAuthManager()
        singInManager.createUser(email: email, password: password) { [weak self] (success, error) in
            
            guard self != nil else { return }
            var errorMessage: String?
            
            if success {
                self!.createUserInfo(userName: userName)
                singInManager.logIn(email: email, password: password) { [weak self] (success, error) in
                    print("logined!")
                }
            } else {
                errorMessage = error
            }
            self!.signInDelegate?.finishSignIn(errorMessage: errorMessage)
        }
    }
    
    func createUserInfo(userName: String) {
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            
            guard let user = user else { return }
            self.dbUser = DBUser(authData: user, userName: userName)
            
            let currentUserRef = self.userInfoRef.child(self.dbUser.uid)
            currentUserRef.setValue(self.dbUser.userName)
        }
        
    }
    
}
