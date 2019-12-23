//
//  LoginViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-19.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import Foundation

class LoginViewModel {
    
    func loginCheck(userOrEmail: String, password: String) -> Bool {
        
        if ( userInfo.email == userOrEmail || userInfo.userName == userOrEmail ) && userInfo.password == password {
            
            return true
        }
        return false
    }
    
}
