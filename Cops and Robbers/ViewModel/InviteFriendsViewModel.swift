//
//  InviteFriendsViewModel.swift
//  Cops and Robbers
//
//  Created by Shoko Hashimoto on 2019-12-26.
//  Copyright © 2019 Shoko Hashimoto. All rights reserved.
//

import Foundation
import Firebase

protocol InviteFriendsDelegate {
    func didFinishObserveUserInfo()
}

protocol ToCellInviteFriendsDelegate {
    func didSendFriendRequest()
}

class InviteFriendsViewModel {
    
    let userInfoRef = Database.database().reference(withPath: "user_Info")
    let friendReqRef = Database.database().reference(withPath: "friends_request")
    
    var friendsList: [Friend]?
    var dbFriendReq: DBFriendRequest!
    var inviteFriendsDelegate: InviteFriendsDelegate?
    var toCellInviteFriendsDelegate: ToCellInviteFriendsDelegate?
    
    func observeUserInfo() {
        userInfoRef.observe(.value, with: { snapshot in
            var friends: [Friend] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let friend = Friend(snapshot: snapshot) {
                    friends.append(friend)
                }
            }
            self.friendsList = friends
            self.inviteFriendsDelegate?.didFinishObserveUserInfo()
        })
    }
    
    func sendFrinedRequest(friend: Friend){
        
        let userID = Auth.auth().currentUser?.uid
        self.dbFriendReq = DBFriendRequest(fromUser: userID!, toUser: friend.uid, status: "request")
        
        let request = friendReqRef.childByAutoId()
        request.setValue(self.dbFriendReq.toAnyObject())
        toCellInviteFriendsDelegate?.didSendFriendRequest()
    }
}
