//
//  DBFriendRequest.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-10.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//
import Firebase

struct DBFriendRequest {
    
    let fromUser: String
    let toUser: String
    let status: String
    
    init(fromUser: String, toUser: String, status: String) {
        
        self.fromUser = fromUser
        self.toUser = toUser
        self.status = status
    }
    
    func toAnyObject() -> Any {
        return [
            "fromUser": fromUser,
            "toUser": toUser,
            "status": status
        ]
    }
    
}
