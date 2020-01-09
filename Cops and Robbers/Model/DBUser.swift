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
    
    init(authData: Firebase.User, userName: String) {
        self.uid = authData.uid
        self.userName = userName
    }
    
    init(uid: String, userName: String) {
        self.uid = uid
        self.userName = userName
    }
    
    func toAnyObject() -> Any {
        return [
            "userName": userName
        ]
    }
}
