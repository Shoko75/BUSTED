//
//  Friend.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-26.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import Foundation
import Firebase

struct Friend {
    
    let uid: String
    let userName: String
    let userImageURL: String?
    
    init(uid: String, userName: String, userImageURL: String) {
        self.uid = uid
        self.userName = userName
        self.userImageURL = userImageURL
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let userName = value["userName"] as? String,
            let userImageURL = value["userImageURL"] as? String
            else { return nil }
        
        self.uid = snapshot.key
        self.userName = userName
        self.userImageURL = userImageURL
    }
}
