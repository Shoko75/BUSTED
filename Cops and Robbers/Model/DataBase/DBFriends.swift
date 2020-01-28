//
//  DBFriends.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-11.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import Foundation

struct DBFriends {
    
    let uid: String
    let friendUID: String
    
    init(uid: String, friendUID: String) {
        self.uid = uid
        self.friendUID = friendUID
    }
    
    func toAnyObject() -> Any {
        return [
            "friendUID": friendUID
        ]
    }
}
