//
//  User.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-19.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import Foundation

class User {
    
    var userName: String
    var email: String
    var password: String
    
    init(userName: String, email: String, password: String){
        self.userName = userName
        self.email = email
        self.password = password
    }
}

var userInfo = User(userName: "", email: "", password: "")


