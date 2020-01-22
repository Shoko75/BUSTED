//
//  DBUser.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-25.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import Foundation
import Firebase

struct DBUser {
    
    let uid: String
    let userName: String
    let userImageURL: String
    let token: String
    
    init(authData: Firebase.User, userName: String, userImageURL: String, token: String) {
        self.uid = authData.uid
        self.userName = userName
        self.userImageURL = userImageURL
        self.token = token
    }
    
    init(uid: String, userName: String, userImageURL: String, token: String) {
        self.uid = uid
        self.userName = userName
        self.userImageURL = userImageURL
        self.token = token
    }
    
    func toAnyObject() -> Any {
        return [
            "userName": userName,
            "userImageURL": userImageURL,
            "token": token
        ]
    }
}
