//
//  MenuViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2020-01-31.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import Firebase

// MARK: protocol
protocol MenuDelegate {
    func didFinishCheckInvitationStatus()
    func didFinishCheckFriendReq()
}

// MARK: MenuViewModel
class MenuViewModel {
    
    private let userInfoRef = Database.database().reference(withPath: "user_Info")
    private let friendReqRef = Database.database().reference(withPath: "friends_request")
    private let userID = Auth.auth().currentUser?.uid
    
    var flgJoinField = false
    var flgFriendReq = false
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
                self.menuDelegate?.didFinishCheckInvitationStatus()
            }
        }
    }
    
    func checkFriendReq() {
        
        // Get the data which toUser is myself
        friendReqRef.queryOrdered(byChild: "toUser").queryEqual(toValue: userID).observe(.value) { (snapshot) in
            if snapshot.childrenCount != 0 {
                self.flgFriendReq = true
            }
            self.menuDelegate?.didFinishCheckFriendReq()
        }
    }
}
