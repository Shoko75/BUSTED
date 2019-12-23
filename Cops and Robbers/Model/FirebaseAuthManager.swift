//
//  FirebaseAuthManager.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-23.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import Firebase
import UIKit

class FirebaseAuthManager {
    
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let user = authResult?.user {
                print(user)
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
    }
    
    func logIn(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
    
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false)
            } else {
                completionBlock(true)
            }
        }
    }
    
}

