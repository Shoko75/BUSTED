//
//  EndGameViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-02-21.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import Firebase

class EndGameViewModel {
    private let userInfoRef = Database.database().reference(withPath: "user_Info")
    private let userID = Auth.auth().currentUser?.uid
    
    // MARK: Observing
    func stopObserveUserInfo() {
        userInfoRef.child(userID!).removeAllObservers()
    }
    
    // MARK: Update
    func updateUserInfo() {
        let playTeamValue = ["playTeam": ""]
        userInfoRef.child(userID!).updateChildValues(playTeamValue)
    }
}
