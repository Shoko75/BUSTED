//
//  EndGameViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-02-21.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import Foundation
import Firebase

class EndGameViewModel {
    let userInfoRef = Database.database().reference(withPath: "user_Info")
    let userID = Auth.auth().currentUser?.uid
    
    func updateUserInfo() {
        let playTeamValue = ["playTeam": ""]
        
        userInfoRef.child(userID!).updateChildValues(playTeamValue)
    }
    
    func stopObserveUserInfo() {
        userInfoRef.child(userID!).removeAllObservers()
    }
}
