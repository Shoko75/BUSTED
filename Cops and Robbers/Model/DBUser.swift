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
    
    init(authData: Firebase.User, userName: String, userImageURL: String) {
        self.uid = authData.uid
        self.userName = userName
        self.userImageURL = userImageURL
    }
    
    init(uid: String, userName: String, userImageURL: String) {
        self.uid = uid
        self.userName = userName
        self.userImageURL = userImageURL
    }
    
    func toAnyObject() -> Any {
        return [
            "userName": userName,
            "userImageURL": userImageURL
        ]
    }
}
