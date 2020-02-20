//
//  UserSettingViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-02-14.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import Foundation
import Firebase

protocol UserSettingDelegate {
    func didFinishObserveUserInfo()
}

class UserSettingViewModel {
    
    let userInfoRef = Database.database().reference(withPath: "user_Info")
    let userID = Auth.auth().currentUser?.uid
    
    var userInfo: Friend?
    var userSettingDelegate: UserSettingDelegate?
    
    func observeUserInfo() {
        userInfoRef.child(userID!).observe(.value) { (snapshot) in
            if let userInfo = Friend(snapshot: snapshot) {
                self.userInfo = userInfo
                self.userSettingDelegate?.didFinishObserveUserInfo()
            }
        }
    }
    
    func changeUserImage(userImage: UIImage) {
        let randomID = UUID.init().uuidString
        let newStorageRef = Storage.storage().reference(withPath: "profileImages/\(randomID).png")
        let storageRef = Storage.storage().reference(forURL: (userInfo?.userImageURL)!)
        
        // Saving the userImage on the storage
        if let uploadData = userImage.pngData() {
            
            newStorageRef.putData(uploadData, metadata: nil, completion:
                { (metadata, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                
                    
                    newStorageRef.downloadURL { (url, error) in
                        guard let dowloadURL = url else {
                            print(error!)
                            return
                        }
                        // Move to create the userInfo
                        self.updateUserImage(userImageURL: dowloadURL.absoluteString)
                    }
                    
                    // delete old image
                    storageRef.delete(completion: nil)
                    
            })
        }
    }
    
    func updateUserImage(userImageURL: String) {
        
        let userImage = ["userImageURL": userImageURL]
        userInfoRef.child(userID!).updateChildValues(userImage)
    }
    
}
