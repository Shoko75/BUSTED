//
//  RegisterAccountViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-19.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import Firebase

// MARK: Protocol
protocol RegisterAccountDelegate {
    func finishSignIn(errorMessage: String?)
}

// MARK: RegisterAccountViewModel
class RegisterAccountViewModel {
    
    private let userInfoRef = Database.database().reference(withPath: "user_Info")
    let DEFALT_IMG = "4084DD65-935E-4473-8A52-105251E4A6DF.png"
    
    var registerAccountDelegate: RegisterAccountDelegate?
    var dbUser: DBUser!
    
    // MARK: Registration
    func createUser(userName: String, email: String, password: String, userImage: UIImage?) {
        
        let singInManager = FirebaseAuthManager()
        singInManager.createUser(email: email, password: password) { [weak self] (success, error) in
            
            guard self != nil else { return }
            var errorMessage: String?
            
            if success {
                if let userImage = userImage {
                    self!.saveUserImage(userImage: userImage, userName: userName)
                } else {
                    self?.getDefaltImgURL(userName: userName)
                }
                singInManager.logIn(email: email, password: password) { (success, error) in
                    print("logined!")
                }
            } else {
                errorMessage = error
            }
            self!.registerAccountDelegate?.finishSignIn(errorMessage: errorMessage)
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
        
        let userID = Auth.auth().currentUser?.uid
        self.dbUser = DBUser(authData: userID!, userName: userName, userImageURL: userImageURL, token: UserDefaults.standard.string(forKey: "FCM_TOKEN")!, playTeam: "")
        
        let currentUserRef = self.userInfoRef.child(self.dbUser.uid)
        currentUserRef.setValue(self.dbUser.toAnyObject())
        
    }
    
    func getDefaltImgURL(userName: String) {
        let storageRef = Storage.storage().reference(withPath: "profileImages/\(DEFALT_IMG)")
        
        storageRef.downloadURL { (url, error) in
            guard let imageURL = url else {
                print(error!)
                return
            }
            self.createUserInfo(userName: userName, userImageURL: imageURL.absoluteString)
        }
    }
}
