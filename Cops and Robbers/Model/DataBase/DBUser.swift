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
    let playTeam: String?
    
    init(authData: Firebase.User, userName: String, userImageURL: String, token: String, playTeam: String? ) {
        self.uid = authData.uid
        self.userName = userName
        self.userImageURL = userImageURL
        self.token = token
        self.playTeam = playTeam
    }
    
    init(uid: String, userName: String, userImageURL: String, token: String, playTeam: String? ) {
        self.uid = uid
        self.userName = userName
        self.userImageURL = userImageURL
        self.token = token
        self.playTeam = playTeam
    }
    
    func toAnyObject() -> Any {
        return [
            "userName": userName,
            "userImageURL": userImageURL,
            "token": token,
            "playTeam": playTeam
        ]
    }
}
