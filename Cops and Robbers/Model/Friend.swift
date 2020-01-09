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
    
    init(uid: String, userName: String) {
        self.uid = uid
        self.userName = userName
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let userName = value["userName"] as? String
            else { return nil }
        
        self.uid = snapshot.key
        self.userName = userName
    }
}
