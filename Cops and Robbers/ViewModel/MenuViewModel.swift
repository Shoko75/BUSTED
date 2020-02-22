//
//  MenuViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-31.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import Foundation
import Firebase

protocol MenuDelegate {
    func didFinishcheckInvitationStatus()
}

class MenuViewModel {
    
    let userInfoRef = Database.database().reference(withPath: "user_Info")
    let userID = Auth.auth().currentUser?.uid
    
    var flgJoinField = false
    var menuDelegate: MenuDelegate?
    var invitationID: String?
    var userInfo: Friend?
    
    func checkInvitationStatus() {
        
        userInfoRef.child(userID!).observe(.value) { (snapshot) in
            if let value = snapshot.value as? [String: AnyObject],
                let playTeam = value["playTeam"] as? String {
           
                if playTeam != "" {
                    self.flgJoinField = true
                    self.invitationID = playTeam
                } else {
                    self.flgJoinField = false
                }
                self.menuDelegate?.didFinishcheckInvitationStatus()
            }
        }
    }
}
