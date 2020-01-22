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
    
    func createUser(userName: String, email: String, password: String, userImage: UIImage) {
        
        let singInManager = FirebaseAuthManager()
        singInManager.createUser(email: email, password: password) { [weak self] (success, error) in
            
            guard self != nil else { return }
            var errorMessage: String?
            
            if success {
                self!.saveUserImage(userImage: userImage, userName: userName)
                singInManager.logIn(email: email, password: password) { [weak self] (success, error) in
                    print("logined!")
                }
            } else {
                errorMessage = error
            }
            self!.signInDelegate?.finishSignIn(errorMessage: errorMessage)
        }
    }
    
    func saveUserImage(userImage: UIImage, userName: String){
        
        let randomID = UUID.init().uuidString
        let storageRef = Storage.storage().reference(withPath: "profileImages/\(randomID).png")
        
        // Saving the userImage on the storage
        if let uploadData = userImage.pngData() {
            storageRef.putData(uploadData, metadata: nil, completion:
                { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                
                    
                    storageRef.downloadURL { (url, error) in
                        guard let dowloadURL = url else {
                            print(error!)
                            return
                        }
                        // Move to create the userInfo
                        self.createUserInfo(userName: userName, userImageURL: dowloadURL.absoluteString)
                    }
            })
        }
    }
    
    func createUserInfo(userName: String, userImageURL: String) {
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            
            guard let user = user else { return }
            self.dbUser = DBUser(authData: user, userName: userName, userImageURL: userImageURL, token: UserDefaults.standard.string(forKey: "FCM_TOKEN")!)
            
            let currentUserRef = self.userInfoRef.child(self.dbUser.uid)
            currentUserRef.setValue(self.dbUser.toAnyObject())
        }
    }
}
